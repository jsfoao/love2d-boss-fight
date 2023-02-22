require "core.ecs.type_registry"
local entity = require("core.ecs.entity")

local player = Type_registry.create_entity_type("Player")
player.new = function()
    local self = entity.new()
    self.name = "Player"

    local super_load = self.load
    function self:load()
        super_load(self)
        print("loaded player")
    end

    local super_update = self.update
    function self:update(dt)
        super_update(dt)
    end
    return self
end

return player