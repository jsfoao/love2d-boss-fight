local vector2 = require("vector2")
COMPONENT_ID = 0

-- OBJECT
local object = {}
object.new = function ()
    local self = {}
    self.id = 0
    self.name = "default"
    self.enabled = true
    return self
end

-- COMPONENT
local component = {}
component.new = function ()
    local self = object.new()
    self.owner = nil
    return self
end

-- COMPONENT - TRANSFORM
COMPONENT = COMPONENT_ID + 1
TRANSFORM = COMPONENT_ID
local transform_comp = {}
transform_comp.new = function ()
    local self = component.new()
    self.id = TRANSFORM
    self.name = "transform"
    self.position = vector2.new(0, 0)
    return self
end

-- ENTITY
local entity = {}
entity.new = function()
    local self = object.new()
    self.world = nil
    self.components = {}

    function self:add_component(comp)
        self.components[comp.id] = comp
        comp.owner = self
    
        print(string.format("added component %s", comp.name))
        return comp
    end

    self.transform = self:add_component(transform_comp.new())

    function self:has_component(id)
        for key, value in pairs(self.components) do
            if value.id == id then
                return true
            end
        end
        return false
    end

    function self:get_component(id)
        for key, value in pairs(self.components) do
            if value.id == id then
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

    function self:log()
        for key, value in pairs(self.entities) do
            print(value.name)
        end
    end

    return self
end

local function main()
    local world_instance = world.new()

    local player = entity.new()
    player.name = "player"

    print(player.components[TRANSFORM].id)

    player.transform.position.x = 10
    print(player:has_component(TRANSFORM))
end

main()