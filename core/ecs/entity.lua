local object = require("core.ecs.object")
local transform = require("core.components.c_transform")

local entity = {}
entity.new = function()
    local self = object.new()
    self.world = nil
    self.components = {}

    function self:add_component(component_type)
        assert(Type_registry.is_valid_component(component_type))
        local _comp = component_type.new()
        self.components[#self.components+1] = _comp
        _comp.owner = self
        return _comp
    end

    self.transform = self:add_component(transform)

    function self:has_component(component_type)
        for k, c in pairs(self.components) do
            if c.type_id == component_type.type_id then
                return true
            end
        end
        return false
    end

    function self:get_component(component_type)
        for k, c in pairs(self.components) do
            if c.type_id == component_type.type_id then
                return c
            end
        end
    end

    function self:load()
        print("loaded entity")
        for k, c in pairs(self.components) do
            c:load()
        end
    end

    function self:update(dt)
        for k, c in pairs(self.components) do
            c:update(dt)
        end
    end

    return self
end