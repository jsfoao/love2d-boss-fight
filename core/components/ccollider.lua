require "core.ecs"
local component = require("core.ecs.component")

local ccollider = Type_registry.create_component_type("CCollider")
ccollider.new = function ()
    local self = component.new()
    self.type_id = ccollider.type_id
    self.name = "CCollider"
    self.layer = 0
    self.ray_layer = 0

    return self
end
return ccollider