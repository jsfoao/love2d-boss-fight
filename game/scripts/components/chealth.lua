require "core.ecs"
local component = require("core.ecs.component")

local chealth = Type_registry.create_component_type("CHealth")
chealth.new = function ()
    local self = component.new()
    self.type_id = chealth.type_id

    self.health_max = 100
    self.health = 0
    self.dead = false

    self.on_heal = nil
    self.on_damage = nil
    self.on_dead = nil

    local super_load = self.load
    function self:load()
        super_load(self)
        self.health = self.health_max
    end

    function self:damage(value)
        self.health = self.health - value
        if self.on_damage ~= nil then
            self:on_damage(value)
        end
        if self.health <= 0 then
            self.health = 0
            self.dead = true
            if self.on_dead ~= nil then
                self:on_dead()
            end
        end
    end

    function self:heal(value)
        self.health = self.health + value
        if self.on_heal ~= nil then
            self:on_heal(value)
        end
        if self.health >= self.health then
            self.health = self.health
        end
    end
    return self
end
return chealth