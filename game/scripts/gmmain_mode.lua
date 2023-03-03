local game_mode = require("core.ecs.game_mode")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")
local mesh = require("core.renderer.mesh")

local eprimitive = require("core.entities.eprimitive")
local ecamera = require("core.entities.ecamera")
local eplayer = require("game.scripts.entities.eplayer")
local eenemy = require("game.scripts.entities.eenemy")
local epickup = require("game.scripts.entities.epickup")

local gmmain_mode = {}
gmmain_mode.new = function ()
    local self = game_mode.new()

    -- entities
    self.camera = nil

    self.stage = 0
    self.enemies = {}
    self.enemy_spawn_positions = {
        vector2.new(0,-2),
        vector2.new(2,-2),
        vector2.new(-2,-2)
    }

    self.countdown_timer = 3
    self.countdown = 3

    -- VISUALS
    self.font = love.graphics.newFont(64)
    self.stage_font = love.graphics.newFont(24)
    self.countdown_text = love.graphics.newText(self.font, string.format("%d", self.countdown_timer))

    self.camera_default_z = -0.3
    function self:load()
        love.mouse.setVisible(false)

        self.camera = World:create_entity(ecamera, vector2.new(0,0))
        Camera = self.camera.camera_comp
        self.camera.z = self.camera_default_z

        -- PLATFORMS
        self.platform_b = World:create_entity(eprimitive, vector2.new(0,5))
        self.platform_b.transform.scale = vector2.new(20,1)
        self.platform_b.mesh = mesh.quad
        self.platform_b.mesh_comp.color = {0.2,0.2,0.2}
        self.platform_b.name = "PlatformB"
        self.platform_b.rb_comp.type = "static"

        self.platform_u = World:create_entity(eprimitive, vector2.new(0,-5))
        self.platform_u.transform.scale = vector2.new(20,1)
        self.platform_u.mesh = mesh.quad
        self.platform_u.mesh_comp.color = {0.2,0.2,0.2}
        self.platform_u.name = "PlatformU"
        self.platform_u.rb_comp.type = "static"

        self.platform_l = World:create_entity(eprimitive, vector2.new(-5,0))
        self.platform_l.transform.scale = vector2.new(1,20)
        self.platform_l.mesh = mesh.quad
        self.platform_l.mesh_comp.color = {0.2,0.2,0.2}
        self.platform_l.name = "PlatformL"
        self.platform_l.rb_comp.type = "static"

        self.platform_r = World:create_entity(eprimitive, vector2.new(5,0))
        self.platform_r.transform.scale = vector2.new(1,20)
        self.platform_r.mesh = mesh.quad
        self.platform_r.mesh_comp.color = {0.2,0.2,0.2}
        self.platform_r.name = "PlatformR"
        self.platform_r.rb_comp.type = "static"

        -- PLAYER
        Player = World:create_entity(eplayer, vector2.new(0,0))

        -- ENEMY
        self.countdown_timer = 3
        self.countdown = 3

        self.camera_speed = 30
    end

    function self:update(dt)
        if self.countdown_timer > 0 and self.countdown_timer <= 3 then
            self.countdown_timer = self.countdown_timer - dt
            self.camera.z = self.camera_default_z + self.countdown / 25
            local cached_countdown = self.countdown
            self.countdown = math.floor(self.countdown_timer + 1)
            if self.countdown ~= cached_countdown then
                self.countdown_text = love.graphics.newText(self.font, string.format("%d", self.countdown))
            end
        end

        if self.countdown_timer <= 0 then
            self:load_new_stage()
            self.countdown_timer = 4
        end

        -- lerp camera
        if Player ~= nil then
            Camera.owner.transform.position = math.lerp(Camera.owner.transform.position, vector2.new(Player.transform.position.x * 5, Player.transform.position.y * -5), self.camera_speed * dt)
        end

        print(#self.enemies)
    end

    function self:restart_stages()
        self.stage = 0
        self:load_new_stage()
    end

    function self:load_new_stage()
        self.stage = self.stage + 1

        Player.health_comp:heal_to_max()
        local enemy_count = 0
        if self.stage >= 3 then
            enemy_count = 3
        else
            enemy_count = self.stage
        end
            
        self.stage_cleared_text = love.graphics.newText(self.stage_font, string.format("Stage: %d", self.stage))
        -- reset enemies in spawn positions
        self:destroy_all_enemies()
        for i = 1, enemy_count, 1 do
            local enemy = World:create_entity(eenemy, self.enemy_spawn_positions[i])
            table.insert(self.enemies, enemy)
        end
    end

    function self:destroy_all_enemies()
        for key, value in pairs(self.enemies) do
            self:destroy_enemy(value)
        end
    end

    function self:destroy_enemy(enemy)
        if enemy == nil then
            return
        end
        for i = 1, #self.enemies, 1 do
            if enemy.id == self.enemies[i].id then
                table.remove(self.enemies, i)
                World:destroy_entity(enemy)

                if #self.enemies == 0 then
                    self:on_stage_cleared()
                end
                return
            end
        end
    end

    function self:on_stage_cleared()
        self.countdown_timer = 3
    end

    function self:draw()
        -- debug.handles(vector2.zero, vector2.new(1,0), 1)
    end

    function self:late_draw()
        local screen_center = Camera.get_screen_center()
        love.graphics.setColor({1,1,1})
        if self.countdown > 0 then
            love.graphics.draw(
                self.countdown_text,
                screen_center.x - self.countdown_text:getWidth() / 2,
                screen_center.y - self.countdown_text:getHeight() / 2
            )
        end

        love.graphics.setColor({1,1,1})
        if self.stage ~= 0 then
            love.graphics.draw(
                self.stage_cleared_text,
                love.graphics.getWidth() - self.stage_cleared_text:getWidth() - 25,
                love.graphics.getHeight() - self.stage_cleared_text:getHeight() - 25
            )
        end


        if Player == nil then
            return
        end
        debug.circle("line", Player.crosshair_pos, 10,15, {1,1,1})
    end

    return self
end

return gmmain_mode