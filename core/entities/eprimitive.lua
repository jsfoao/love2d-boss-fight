require "core.ecs"
local entity = require("core.ecs.entity")
local cmesh = require("core.components.cmesh")
local mesh = require("core.renderer.mesh")
local vector2 = require("core.vector2")

local eprimitive = Type_registry.create_entity_type("EPrimitive")
eprimitive.new = function()
    local self = entity.new()
    self.type_id = eprimitive
    self.name = "Primitive"

    self.mesh = mesh.quad

    -- rigidbody
    self.physics = {}
    self.velocity = vector2.zero

    -- components
    self.mesh_comp = self:add_component(cmesh)

    local super_load = self.load
    function self:load()
        super_load(self)
        self:log()

        self.mesh_comp.z = 2
        self.mesh_comp.filter = mesh.quad
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.transform.position = self.transform.position + self.velocity * dt
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
    end
    return self
end

return eprimitive