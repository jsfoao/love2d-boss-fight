local game_mode = require("core.ecs.game_mode")
local vector2 = require("core.vector2")
local eplayer = require("game.scripts.entities.eplayer")
local ecamera = require("core.entities.ecamera")
local eprimitive = require("core.entities.eprimitive")
local mesh = require("core.renderer.mesh")

local matrix = require("core.matrix")

local gmmain_mode = {}
gmmain_mode.new = function ()
    local self = game_mode.new()

    -- entities
    self.camera = nil

    function self:load()
        self.camera = World:create_entity(ecamera, vector2.new(0,0))
        Camera = self.camera.camera_comp

        -- platform
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

        Player = World:create_entity(eplayer, vector2.new(0,0))

    end

    function self:update(dt)
        -- camera movement
        if Input.get_key_hold(Key.Left) then
            Camera.owner.transform.position.x = self.camera.transform.position.x - 1
        end
        if Input.get_key_hold(Key.Right) then
            Camera.owner.transform.position.x = self.camera.transform.position.x + 1
        end
        if Input.get_key_hold(Key.Up) then
            Camera.owner.transform.position.y = self.camera.transform.position.y + 1
        end
        if Input.get_key_hold(Key.Down) then
            Camera.owner.transform.position.y = self.camera.transform.position.y - 1
        end

        -- camera zoom
        if love.keyboard.isDown('o') then
            Camera.owner.z = self.camera.z + (1 * dt)
        end
        if love.keyboard.isDown('l') then
            Camera.owner.z = self.camera.z - (1 * dt)
        end
    end

    function self:draw()
        debug.handles(vector2.zero, vector2.new(1,0), 1)
    end

    return self
end

return gmmain_mode