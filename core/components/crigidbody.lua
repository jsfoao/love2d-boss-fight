require "core.ecs"
local collision = require("core.collision.collision")
local component = require("core.ecs.component")
local vector2 = require("core.vector2")

local crigidbody = Type_registry.create_component_type("CRigidBody")
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
    end

    function self:dynamic_behaviour(dt)
        self.box_x = self.collider:offset_box(vector2.new(self.velocity.x * dt, 0), vector2.new(1, 0.8))
        self.box_y = self.collider:offset_box(vector2.new(0, self.velocity.y * dt), vector2.new(0.8, 1))

        local col_x = false
        local col_y = false

        local penetration_x = 0
        local penetration_y = 0

        for key, col in pairs(self.collider.other_colliders) do
            if collision.intersect_aabb(col.box, self.box_x) then
                col_x = true
                if col.box.x.min <= self.box_x.x.max and col.box.x.max >= self.box_x.x.min then
                    penetration_x = col.owner.transform.position.x - self.owner.transform.position.x
                end
            end
            if collision.intersect_aabb(col.box, self.box_y) then
                col_y = true
                if col.box.y.min <= self.box_y.y.max and col.box.y.max >= self.box_y.y.min then
                    penetration_y = col.owner.transform.position.y - self.owner.transform.position.y
                    -- print(penetration_y)
                end
            end
        end

        if col_x == true then
            -- depenetrate on x axis by a factor of 2
            self.owner.transform.position = vector2.new(
                self.owner.transform.position.x - penetration_x * 0.01,
                self.owner.transform.position.y
            )

            self.velocity = vector2.new(0, self.velocity.y)
        end

        if col_y == true then
            -- depenetrate on y axis by a factor of 2
            self.owner.transform.position = vector2.new(
                self.owner.transform.position.x,
                self.owner.transform.position.y - penetration_y * 0.01
            )

            -- count in friction
            self.velocity = vector2.new(self.velocity.x - self.velocity.x * self.friction * dt, 0)
        else
            -- gravity accel
            self.velocity = vector2.new(self.velocity.x, self.velocity.y + self.gravity * self.mass * dt)
        end

        self.owner.transform.position = self.owner.transform.position + self.velocity * dt
    end

    local super_update = self.update
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