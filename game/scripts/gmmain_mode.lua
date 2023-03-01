local game_mode = require("core.ecs.game_mode")
local vector2 = require("core.vector2")
local eplayer = require("game.scripts.eplayer")
local ecamera = require("core.entities.ecamera")
local eprimitive = require("core.entities.eprimitive")
local mesh = require("core.renderer.mesh")

local matrix = require("core.matrix")

local gmmain_mode = {}
gmmain_mode.new = function ()
    local self = game_mode.new()

    -- entities
    self.camera = nil
    -- self.cube = nil

    function self:load()
        self.camera = World:create_entity(ecamera, vector2.new(0,0))
        Camera = self.camera.camera_comp

        -- platform
        self.platform_b = World:create_entity(eprimitive, vector2.new(0,5))
        self.platform_b.transform.scale = vector2.new(20,1)
        self.platform_b.mesh = mesh.quad
        self.platform_b.mesh_comp.color = {1,1,1}
        self.platform_b.name = "Platform"
        self.platform_b.rb_comp.type = "static"

        self.platform_u = World:create_entity(eprimitive, vector2.new(0,-5))
        self.platform_u.transform.scale = vector2.new(20,1)
        self.platform_u.mesh = mesh.quad
        self.platform_u.mesh_comp.color = {1,1,1}
        self.platform_u.name = "Platform"
        self.platform_u.rb_comp.type = "static"

        self.platform_l = World:create_entity(eprimitive, vector2.new(-5,0))
        self.platform_l.transform.scale = vector2.new(1,20)
        self.platform_l.mesh = mesh.quad
        self.platform_l.mesh_comp.color = {1,1,1}
        self.platform_l.name = "Platform"
        self.platform_l.rb_comp.type = "static"

        self.platform_r = World:create_entity(eprimitive, vector2.new(5,0))
        self.platform_r.transform.scale = vector2.new(1,20)
        self.platform_r.mesh = mesh.quad
        self.platform_r.mesh_comp.color = {1,1,1}
        self.platform_r.name = "Platform"
        self.platform_r.rb_comp.type = "static"

        Player = World:create_entity(eplayer, vector2.new(0,0))

    end

    function self:update(dt)
        -- camera movement
        if Input.get_key_hold(Key.Left) then
            self.camera.transform.position.x = self.camera.transform.position.x - 1
        end
        if Input.get_key_hold(Key.Right) then
            self.camera.transform.position.x = self.camera.transform.position.x + 1
        end
        if Input.get_key_hold(Key.Up) then
            self.camera.transform.position.y = self.camera.transform.position.y + 1
        end
        if Input.get_key_hold(Key.Down) then
            self.camera.transform.position.y = self.camera.transform.position.y - 1
        end

        -- camera zoom
        if love.keyboard.isDown('o') then
            self.camera.z = self.camera.z + (1 * dt)
        end
        if love.keyboard.isDown('l') then
            self.camera.z = self.camera.z - (1 * dt)
        end
    end

    function self:draw()
        debug.handles(vector2.zero, vector2.new(1,0), 1)
    end

    return self
end

return gmmain_mode