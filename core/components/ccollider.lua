require "core.ecs"
local component = require("core.ecs.component")

local ccollider = Type_registry.create_component_type("CBoxCollider")
ccollider.new = function ()
    local self = component.new()
    self.type_id = ccollider.type_id
    self.name = "CCollider"

    return self
end
return ccollider