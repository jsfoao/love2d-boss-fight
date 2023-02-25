require "core.ecs"
local object = require("core.ecs.object")

local world = {}
world.new = function ()
    local self = object.new()
    self.entities = {}
    self.game_mode = nil
    
    function self:create_entity(entity_type, position)
        assert(Type_registry.is_valid_entity(entity_type))
        local _entity = entity_type.new()
        self.entities[#self.entities+1] = _entity
        _entity.world = self
        _entity.transform.position = position
        return _entity
    end

    function self:init_game_mode(game_mode_type)
        local _gm = game_mode_type.new()
        _gm.world = self
        self.game_mode = _gm
        return self.game_mode
    end

    function self:load()
        self.game_mode:load()
        for k, e in pairs(self.entities) do
            e:load()
        end
    end

    function self:update(dt)
        self.game_mode:update(dt)
        for k, e in pairs(self.entities) do
            e:update(dt)
        end
    end

    function self:draw()
        self.game_mode:draw()
        for k, e in pairs(self.entities) do
            e:draw()
        end
    end

    function self:log()
        for k, e in pairs(self.entities) do
            print(e.name)
        end
    end

    return self
end

return world