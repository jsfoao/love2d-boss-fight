local renderer = require("core.renderer.renderer")
local world = require("core.ecs.world")
local main_mode = require("game.scripts.gmmain_mode")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")

function love.load()
    Renderer = renderer.new()
    World = world.new()
    World:init_game_mode(main_mode)
    World:load()
end

function love.update(dt)
    World:update(dt)
end

function love.draw()
    local _pos = matrix:new({0, 0, 1})
    local _scl = matrix:new({1, 1, 1})

    local _pixelPos = matrix.mul(Camera.view_mtx, _pos)
    local _pixelScale = matrix.mul(Camera.zoom_mtx, _scl)

    love.graphics.rectangle("fill", _pixelPos[1][1], _pixelPos[2][1], _pixelScale[1][1], _pixelScale[2][1])
end