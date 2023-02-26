require "core.ecs"
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

    -- requires collider
    self.collider = nil

    function self:set_linear_velocity(vec)
        self.velocity = vec
    end

    function self:init(col)
        self.collider = col
    end

    local super_update = self.update
    function self:update(dt)
        self.collider:sweep(self.velocity * dt)
        if self.collider:is_colliding() == true then
            self.velocity = vector2.zero
        end
        if self.type == "dynamic" then
            self.owner.transform.position = self.owner.transform.position + self.velocity * dt
        end
    end

    function self:draw()
    end
    return self
end

return crigidbody