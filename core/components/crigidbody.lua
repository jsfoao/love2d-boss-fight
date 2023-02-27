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
    self.col_x = false
    self.col_y = false

    -- requires collider
    self.collider = nil

    -- physics material
    self.friction = 1.5
    self.mass = 1
    self.gravity = 15

    function self:set_linear_velocity(vec)
        self.velocity = vec
    end

    function self:add_velocity(vec)
        self.velocity = self.velocity + vec
    end

    function self:init(col)
        self.collider = col
        World:add_physics_body(self)
    end

    function self:dynamic_behaviour(dt)
        if self.col_x == true then
            
        end
        if self.col_y == true then
            -- count in friction
            self.velocity = vector2.new(self.velocity.x - self.velocity.x * self.friction * dt, 0)
        else
            -- gravity accel
            self.velocity = vector2.new(self.velocity.x, self.velocity.y + self.gravity * self.mass * dt)
        end

        self.owner.transform.position = self.owner.transform.position + self.velocity * dt
    end

    local super_load = self.load
    function self:load()
        super_load(self)
    end


    local super_update = self.update
    function self:update(dt)
        if self.type == "static" then
            return
        end
        self.col_x = false
        self.col_y = false

        self.box_x = self.collider:offset_box(vector2.new(self.velocity.x * dt, 0), vector2.new(1, 0.7))
        self.box_y = self.collider:offset_box(vector2.new(0, self.velocity.y * dt), vector2.new(0.7, 1))

        for key, rb in pairs(World.physics_bodies) do
            if rb.id == self.id or not (rb.collider.layer == self.collider.layer) then
                goto continue
            end
            if collision.intersect_aabb(rb.collider.box, self.box_x) then
                self.col_x = true
                if rb.collider.box.x.min <= self.box_x.x.max and rb.collider.box.x.max >= self.box_x.x.min then
                    local penetration_x = rb.collider.owner.transform.position.x - self.owner.transform.position.x

                    -- depenetrate on x axis by a factor of 2
                    self.owner.transform.position = vector2.new(
                        self.owner.transform.position.x - penetration_x * 0.01,
                        self.owner.transform.position.y
                    )
                    
                    if rb.type == "static" then
                        self.velocity = vector2.new(0, self.velocity.y)
                    elseif rb.type == "dynamic" and self.col_x == false then
                        self.velocity = vector2.new(rb.velocity.x, self.velocity.y)
                    end
                end
            end
            if collision.intersect_aabb(rb.collider.box, self.box_y) then
                self.col_y = true
                if rb.collider.box.y.min <= self.box_y.y.max and rb.collider.box.y.max >= self.box_y.y.min then
                    local penetration_y = rb.collider.owner.transform.position.y - self.owner.transform.position.y
                    
                    -- depenetrate on x axis by a factor of 2
                    self.owner.transform.position = vector2.new(
                        self.owner.transform.position.x,
                        self.owner.transform.position.y - penetration_y * 0.01
                    )

                    if rb.type == "static" then
                        self.velocity = vector2.new(self.velocity.x, 0)
                    elseif rb.type == "dynamic" and self.col_y == false then
                        self.velocity = vector2.new(self.velocity.x, rb.velocity.y)
                    end
                end
            end
            ::continue::
        end
    end

    function self:fixed_update(dt)
        if self.type == "dynamic" then
            self:dynamic_behaviour(dt)
        end
    end

    function self:draw()
    end
    return self
end

return crigidbody