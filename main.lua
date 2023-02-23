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
    Rotation = 0
    Position = vector2.new(0,0)

    Renderer = renderer.new()
    Renderer:load()
end


function love.update(dt)
    World:update(dt)

    Renderable = renderable.new()
    Rotation = Rotation + 25 * dt
    if love.keyboard.isDown('up') then
        Position.y = Position.y - 2 * dt
    end
    if love.keyboard.isDown('down') then
        Position.y = Position.y + 2 * dt
    end
    if love.keyboard.isDown('left') then
        Position.x = Position.x - 2 * dt
    end
    if love.keyboard.isDown('right') then
        Position.x = Position.x + 2 * dt
    end
end

function love.draw()
    -- Renderer:flush()
    local pos = Position
    local scl = vector2.new(1,1)
    local rot = Rotation
    local model = matrix:new(3, "I")
    model = matrix.mul(model, matrix.translate(pos.x, pos.y))
    model = matrix.mul(model, matrix.scale(scl.x, scl.y))
    model = matrix.mul(model, matrix.rotate(math.rad(rot)))
    local mtx = matrix.mul(Camera.view_mtx, model)

    local verts = {}
    local msh = mesh.quad
    for i = 1, #msh, 2 do
        local point = matrix:new({msh[i], msh[i+1], 1})
        local final = matrix.mul(mtx, point)
        verts[i] = final[1][1]
        verts[i+1] = final[2][1]
        love.graphics.circle("fill", final[1][1], final[2][1], 4)
    end

    local right = matrix.to(matrix.mul(model, matrix:new({1,0,0}))):normalized()
    local forward = matrix.to(matrix.mul(model, matrix:new({0,1,0}))):normalized()

    debug.circle("fill", vector2.new(0,0), 5, 10, {1,1,1})
    debug.line(pos, pos + right * 1, {1,0,0})
    debug.line(pos, pos + forward * 1, {0,1,0})
    debug.circle("fill", Position, 5, 10, {1,1,1})

    -- love.graphics.setColor(1, 1, 1)
    love.graphics.setColor({1,1,1})
    love.graphics.polygon("line", verts)
end