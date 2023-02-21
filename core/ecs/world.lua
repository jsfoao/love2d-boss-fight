local object = require("core.ecs.object")

local world = {}
world.new = function ()
    local self = object.new()
    self.entities = {}
    
    function self:create_entity(entity_type, position)
        assert(Type_registry.is_valid_entity(entity_type))
        local _entity = entity_type.new()
        self.entities[#self.entities+1] = _entity
        _entity.world = self
        _entity.transform.position = position
        return _entity
    end

    function self:load()
        print("loaded world")
        for k, e in pairs(self.entities) do
            e:load()
        end
    end

    function self:update(dt)
        for k, e in pairs(self.entities) do
            e:update()
        end
    end

    return self
end