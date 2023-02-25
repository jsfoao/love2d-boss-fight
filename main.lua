local renderer = require("core.renderer.renderer")
local world = require("core.ecs.world")
local main_mode = require("game.scripts.gmmain_mode")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")
local renderable = require("core.renderer.renderable")
local mesh = require("core.renderer.mesh")
require "core.debug"

function love.load()
    World = world.new()
    World:init_game_mode(main_mode)
    World:load()
    
    Renderer = renderer.new()
    Renderer:load()

    Input.init()
end


function love.update(dt)
    World:update(dt)
end

function love.draw()
    Renderer:flush()
    World:draw()
end