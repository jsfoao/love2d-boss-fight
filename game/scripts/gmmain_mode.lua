local game_mode = require("core.ecs.game_mode")
local vector2 = require("core.vector2")
local eplayer = require("game.scripts.eplayer")
local ecamera = require("core.entities.ecamera")
local eprimitive = require("core.entities.eprimitive")
local mesh = require("core.renderer.mesh")

local gmmain_mode = {}
gmmain_mode.new = function ()
    local self = game_mode.new()

    -- entities
    self.camera = nil
    -- self.cube = nil

    function self:load()
        self.camera = World:create_entity(ecamera, vector2.new(0,0))
        Camera = self.camera.camera_comp
        
        -- cube
        self.cube = World:create_entity(eprimitive, vector2.new(0,2))
        self.cube.mesh = mesh.quad
        self.cube.mesh_comp.color = {0.5,0.5,0.5}
        self.cube.name = "Cube"
        self.cube.rb_comp:set_linear_velocity(vector2.new(0,2))
        self.cube.box_comp.debug = true

        -- platform
        self.platform = World:create_entity(eprimitive, vector2.new(0,5))
        self.platform.transform.scale = vector2.new(20,1)
        self.platform.mesh = mesh.quad
        self.platform.mesh_comp.color = {1,1,1}
        self.platform.name = "Platform"
        
        -- Player = World:create_entity(eplayer, vector2.new(0,0))
        -- Player.enabled = false
    end

    function self:update(dt)
        if love.keyboard.isDown('a') then
            self.camera.transform.position.x = self.camera.transform.position.x - 1
        end
        if love.keyboard.isDown('d') then
            self.camera.transform.position.x = self.camera.transform.position.x + 1
        end
        if love.keyboard.isDown('w') then
            self.camera.transform.position.y = self.camera.transform.position.y + 1
        end
        if love.keyboard.isDown('s') then
            self.camera.transform.position.y = self.camera.transform.position.y - 1
        end

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