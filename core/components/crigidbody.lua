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
    self.gravity = 8

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
        for key, col in pairs(self.collider.other_colliders) do
            if collision.intersect_aabb(col.box, self.box_x) then
                col_x = true
            end
            if collision.intersect_aabb(col.box, self.box_y) then
                col_y = true
            end
        end

        if col_x == true then
            self.velocity = vector2.new(0, self.velocity.x)
        end

        if col_y == true then
            self.velocity = vector2.new(self.velocity.x - self.velocity.x * self.friction * dt, self.velocity.y * 0.4 - self.gravity * self.mass * dt)
        else
            -- gravity accel
            self.velocity = vector2.new(self.velocity.x, self.velocity.y + self.gravity * self.mass * dt)
        end

        self.owner.transform.position = self.owner.transform.position + self.velocity * dt
    end

    local super_update = self.update
    function self:update(dt)
        if self.type == "dynamic" then
            self:dynamic_behaviour(dt)
        end
    end

    function self:draw()
    end
    return self
end

return crigidbody