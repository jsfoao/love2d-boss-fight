require "core.ecs"
local entity = require("core.ecs.entity")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")
local collision = require("core.collision.collision")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local chealth = require("game.scripts.components.chealth")

local eenemy = Type_registry.create_entity_type("EEnemy")
eenemy.new = function()
    local self = entity.new()
    self.type_id = eenemy.type_id
    self.name = "Enemy"

    -- component
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.health_comp = self:add_component(chealth)

    -- movement
    self.velocity = vector2.zero
    self.friction = 1
    self.speed = 0.1
    self.target_pos = vector2.zero
    self.is_moving = false
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self.mesh_comp.filter = mesh.quad
        self.mesh_comp.color = {0.5,0.5,0.5}

        self.box_comp:set_layer_enable(CollisionLayer.world, false)
        self.is_moving = true
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.transform.position = self.transform.position + self.velocity

        -- Apply friction
        self.velocity = self.velocity - self.velocity * self.friction * dt

        -- Apply movement
        local dir = self.target_pos - self.transform.position
        local dist = dir:len()
        self.velocity = self.velocity + dir * (dist / 10) * self.speed * dt
    end

    local super_fixed_update = self.fixed_update
    function self:fixed_update(dt)
        super_fixed_update(self, dt)
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)

        debug.line(self.transform.position, self.target_pos, {1,1,1})
        debug.circle("fill", self.target_pos, 10, 10, {1,0,0})
    end

    function self:on_hit(dir, damage)
        self.health_comp:damage(damage)

        self.velocity = dir * 0.01
        if self.health_comp.dead then
            World:destroy_entity(self)
        end
    end

    return self
end

return eenemy