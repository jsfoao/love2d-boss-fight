require "core.ecs"
local entity = require("core.ecs.entity")

local eplayer = Type_registry.create_entity_type("EPlayer")
eplayer.new = function()
    local self = entity.new()
    self.type_id = eplayer

    local super_load = self.load
    function self:load()
        super_load(self)
        print("loaded player")
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
    end
    return self
end

return eplayer