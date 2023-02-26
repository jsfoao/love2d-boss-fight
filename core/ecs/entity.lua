require "core.ecs"
local object = require("core.ecs.object")
local transform = require("core.components.ctransform")

local entity = {}
entity.new = function()
    local self = object.new()
    self.world = nil
    self.components = {}
    self.enabled = true

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
        for k, c in pairs(self.components) do
            c:load()
        end
    end

    function self:update(dt)
        for k, c in pairs(self.components) do
            if c.enabled == true then
                c:update(dt)
            end
        end
    end

    function self:draw()
        for k, c in pairs(self.components) do
            if c.enabled then
                c:draw()
            end
        end
    end

    function self:log()
        print("- ENTITY -")
        print(self.id)
        print(self.name)
        print("- COMPONENTS -")
        for k, c in pairs(self.components) do
            print(c.name)
        end
        print()
    end

    return self
end

return entity