require "core.ecs.type_registry"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")

local transform = Type_registry.create_component_type("Transform")
transform.new = function ()
    local self = component.new()
    self.type_id = transform.type_id

    self.position = vector2.new(0, 0)
    return self
end

return transform