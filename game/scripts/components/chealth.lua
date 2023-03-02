require "core.ecs"
local mesh = require("core.renderer.mesh")
local component = require("core.ecs.component")
local vector2 = require("core.vector2")

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

    -- UI
    self.draw_health = true
    self.bar_scale = vector2.new(1.2, 0.2)
    self.bar_relative_position = vector2.new(0, -0.8)
    self.bar_color = {1,0,0}

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

    function self:heal_to_max()
        local to_max = self.health_max - self.health
        self.health = self.health + to_max
    end
    

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
        if self.draw_health then
            local outline = 0.04
            local position = self.owner.transform.position + self.bar_relative_position
            local posl = vector2.new(position.x - self.bar_scale.x / 2, position.y) + vector2.new(1,0) * outline
            local inner_max_scale = vector2.new(self.bar_scale.x - outline * 2, self.bar_scale.y - outline * 2)
            local inner_current_scale = vector2.new(self.health * (inner_max_scale.x / self.health_max), inner_max_scale.y)
            debug.quad("fill", position, self.bar_scale, 0, {0.6,0.6,0.6})
            debug.mesh("fill", posl, inner_current_scale, 0, mesh.quadr, self.bar_color)
        end

    end
    return self
end
return chealth