require "core.ecs"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")

local ctransform = Type_registry.create_component_type("CTransform")
ctransform.new = function ()
    local self = component.new()
    self.type_id = ctransform.type_id

    self.position = vector2.new(0, 0)
    return self
end

return ctransform