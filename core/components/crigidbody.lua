require "core.ecs"
local collision = require("core.collision.collision")
local component = require("core.ecs.component")
local vector2 = require("core.vector2")

local crigidbody = Type_registry.create_component_type("CRigidbody")
crigidbody.new = function ()
    -- setup
    local self = component.new()
    self.name = "CRigidBody"
    self.type_id = crigidbody.type_id

    -- can be static or dynamic
    self.type = "dynamic"
    self.velocity = vector2.zero
    self.box_x = {}
    self.box_y = {}

    self.penetration_x = 0
    self.penetration_y = 0
    self.sweep_x = false
    self.sweep_y = false
    self.contact_x = false
    self.contact_y = false
    self.sweep_buffer_time = 0.25
    self.sweep_buffer_x = 0
    self.sweep_buffer_y = 0

    self.updating = false
    self.update_timer = 0.2

    -- requires collider
    self.collider = nil

    -- physics material
    self.air_friction = 2
    self.friction = 2
    self.mass = 1
    self.gravity = 9.8

    function self:set_linear_velocity(vec)
        self.velocity = vec
    end

    function self:add_velocity(vec)
        self.velocity = self.velocity + vec * 0.01
    end

    function self:init(col)
        self.collider = col
        World:add_physics_body(self)
    end

    function self:dynamic_behaviour(dt)
        if self.sweep_x == true then
            
        end

        if self.sweep_y == true then
            -- count in friction
            self.velocity = vector2.new(
                self.velocity.x - self.velocity.x * self.friction * 0.01,
                0
            )
        else
            -- gravity accel
            self.velocity = vector2.new(
                self.velocity.x - self.velocity.x * self.air_friction * 0.01,
                self.velocity.y + self.gravity * self.mass * 0.01
            )
        end

        self.owner.transform.position = self.owner.transform.position + self.velocity * 0.01
    end

    local super_load = self.load
    function self:load()
        super_load(self)
        self.contact_x = false
        self.contact_y = false
        self.sweep_buffer_x = 0
        self.sweep_buffer_y = 0
    end


    local super_update = self.update
    function self:update(dt)
        if self.updating == false then
            self.update_timer = self.update_timer - dt
            if self.update_timer > 0 then
                return
            end
            self.updating = true
        end

        if self.type == "static" then
            return
        end

        if self.sweep_buffer_x <= 0 then
            self.contact_x = false
        end
        if self.sweep_buffer_y <= 0 then
            self.contact_y = false
        end

        self.box_x = self.collider:offset_box(vector2.new(self.velocity.x * dt, 0), vector2.new(1, 0.7))
        self.box_y = self.collider:offset_box(vector2.new(0, self.velocity.y * dt), vector2.new(0.7, 1))

        for key, rb in pairs(World.physics_bodies) do
            if rb.id == self.id or not (rb.collider.layer == self.collider.layer) then
                goto continue
            end
            if collision.intersect_aabb(rb.collider.box, self.box_x) then
                -- reset sweep buffer x
                self.sweep_x = true
                self.contact_x = true
                self.sweep_buffer_x = self.sweep_buffer_time
                
                if rb.collider.box.x.min <= self.box_x.x.max and rb.collider.box.x.max >= self.box_x.x.min then
                    self.penetration_x = rb.collider.owner.transform.position.x - self.owner.transform.position.x

                    -- depenetrate on x axis by a factor of 2
                    self.owner.transform.position = vector2.new(
                        self.owner.transform.position.x - self.penetration_x * 0.01,
                        self.owner.transform.position.y
                    )

                    if rb.type == "static" then
                        self.velocity = vector2.new(0, self.velocity.y)
                    elseif rb.type == "dynamic" and self.sweep_x == false then
                        self.velocity = vector2.new(rb.velocity.x, self.velocity.y)
                    end
                end
            else
                self.sweep_x = false
                self.sweep_buffer_x = self.sweep_buffer_x - dt
            end
            
            if collision.intersect_aabb(rb.collider.box, self.box_y) then
                -- reset sweep buffer y
                self.sweep_y = true
                self.contact_y = true
                self.sweep_buffer_y = self.sweep_buffer_time

                if rb.collider.box.y.min <= self.box_y.y.max and rb.collider.box.y.max >= self.box_y.y.min then
                    self.penetration_y = rb.collider.owner.transform.position.y - self.owner.transform.position.y
                    
                    -- depenetrate on x axis by a factor of 2
                    self.owner.transform.position = vector2.new(
                        self.owner.transform.position.x,
                        self.owner.transform.position.y - self.penetration_y * 0.008
                    )

                    if rb.type == "static" then
                        self.velocity = vector2.new(self.velocity.x, 0)
                    elseif rb.type == "dynamic" and self.sweep_y == false then
                        self.velocity = vector2.new(self.velocity.x, rb.velocity.y)
                    end
                end
            else
                self.sweep_y = false
                self.sweep_buffer_y = self.sweep_buffer_y - dt
            end
            ::continue::
        end
    end

    local super_fixed_update = self.fixed_update
    function self:fixed_update(dt)
        super_fixed_update(self, dt)
        if self.type == "dynamic" then
            self:dynamic_behaviour(dt)
        end
    end

    local super_on_destroy = self.on_destroy
    function self:on_destroy()
        super_on_destroy(self)
        World:remove_physics_body(self)
    end

    return self
end

return crigidbody