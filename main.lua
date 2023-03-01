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

    love.physics.newWorld()
    
    Renderer = renderer.new()
    Renderer:load()

    Input.init()
end

local fixed_dt = 0.0018
local fixed_dt_timer = 0

function love.update(dt)
    -- PHYSICS
    fixed_dt_timer = fixed_dt_timer + dt
    if fixed_dt_timer >= fixed_dt then
        World:fixed_update(fixed_dt)
        fixed_dt_timer = 0
    end
    -- INPUT
    Input.update()
    -- GAME LOGIC
    World:update(dt)
end

function love.draw()
    Renderer:flush()
    World:draw()
end