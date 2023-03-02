require "core.ecs"
local entity = require("core.ecs.entity")
local mesh = require("core.renderer.mesh")
local vector2 = require("core.vector2")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local crigidbody = require("core.components.crigidbody")

local eprimitive = Type_registry.create_entity_type("EPrimitive")
eprimitive.new = function()
    local self = entity.new()
    self.type_id = eprimitive
    self.name = "Primitive"

    self.mesh = mesh.quad

    -- components
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.rb_comp = self:add_component(crigidbody)


    local super_load = self.load
    function self:load()
        super_load(self)
        self.mesh_comp.filter = mesh.quad
    end

    return self
end

return eprimitive