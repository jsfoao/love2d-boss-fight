require "core.ecs"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")
local renderable = require("core.renderer.renderable")
local mesh = require("core.renderer.mesh")


local crenderable = Type_registry.create_component_type("CRenderable")
crenderable.new = function ()
    local self = component.new()
    self.type_id = crenderable.type_id
    self.mesh = mesh.quad

    local super_update = self.update
    function self:update(dt)
        if self.enabled == false then
            return
        end

        self.position = self.owner.transform.position
        self.scale = self.owner.transform.scale
        self.rotation = self.owner.transform.rotation
        Renderer:submit(self)
    end

    return self
end
return crenderable