local vector2 = require("vector2")

-- OBJECT
local object = {}
object.new = function ()
    local self = {}
    self.id = 0
    self.name = "default"
    self.enabled = true
    return self
end

Component_registry = {}
Component_registry.comp_id = 0
function Component_registry.register(type)
    Component_registry[#Component_registry+1] = type
    type.id = Component_registry.comp_id
    Component_registry.comp_id = Component_registry.comp_id + 1
end

-- COMPONENT
local component = {}
component.new = function ()
    local self = object.new()
    self.owner = nil
    return self
end

-- COMPONENT - TRANSFORM
local transform = {id = nil, name = "Transform"}
transform.new = function ()
    local self = component.new()
    self.name = transform.name
    self.position = vector2.new(0, 0)
    return self
end
Component_registry.register(transform)

-- ENTITY
local entity = {}
entity.new = function()
    local self = object.new()
    self.world = nil
    self.components = {}

    function self:add_component(comp)
        self.components[comp.id] = comp
        comp.owner = self
        return comp
    end

    self.transform = self:add_component(transform.new())

    function self:load()
        print("loaded entity")
    end

    function self:has_component(id)
        for key, value in pairs(self.components) do
            if value.id == id then
                return true
            end
        end
        return false
    end

    function self:get_component(type)
        for key, value in pairs(self.components) do
            if value.id == type.id then
                return self.components[key]
            end
        end
    end

    return self
end

-- WORLD
local world = {}
world.new = function ()
    local self = {}
    self.entities = {}
    
    function self:add_entity(entity)
        self.entities[#self.entities+1] = entity
    end

    return self
end

local player = {}
player.new = function()
    local self = entity.new()

    local base_load = self.load
    function self:load()
        base_load(self)
        print("loaded player")
    end
    return self
end

local function main()
    local _world = world.new()

    local _player = player.new()
    _world.add_entity(_player)
    _player:load()
end

main()