require "core.ecs"
local entity = require("core.ecs.entity")
local ccamera = require("core.components.ccamera")

local ecamera = Type_registry.create_entity_type("ECamera")
ecamera.new = function ()
    local self = entity.new()
    self.type_id = ecamera.type_id
    
    self.camera_comp = self:add_component(ccamera)
    self.z = 0

    local super_load = self.load
    function self:load()
        super_load(self)
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.camera_comp.position = self.transform.position
        self.camera_comp.z = self.z
    end
    return self
end

return ecamera