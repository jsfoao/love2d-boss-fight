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
end


function love.update(dt)
    World:update(dt)
end

function love.draw()
    local origin = vector2.new(0,0)
    debug.line(origin, origin + vector2.new(1,0) * 0.5, {1,0,0})
    debug.line(origin, origin + vector2.new(0,1) * 0.5, {0,1,0})
    debug.circle("fill", origin, 5, 10, {1,1,1})

    Renderer:flush()
end


    -- -- Renderer:flush()
    -- local pos = Position
    -- local scl = vector2.new(1,1)
    -- local rot = Rotation
    -- local model = matrix:new(3, "I")
    -- model = matrix.mul(model, matrix.translate(pos.x, pos.y))
    -- model = matrix.mul(model, matrix.scale(scl.x, scl.y))
    -- model = matrix.mul(model, matrix.rotate(math.rad(rot)))
    -- local mtx = matrix.mul(Camera.view_mtx, model)

    -- local verts = {}
    -- local msh = mesh.quad
    -- for i = 1, #msh, 2 do
    --     local point = matrix:new({msh[i], msh[i+1], 1})
    --     local final = matrix.mul(mtx, point)
    --     verts[i] = final[1][1]
    --     verts[i+1] = final[2][1]
    --     love.graphics.circle("fill", final[1][1], final[2][1], 4)
    -- end

    -- local right = matrix.to_vec(matrix.mul(model, matrix:new({1,0,0}))):normalized()
    -- local forward = matrix.to_vec(matrix.mul(model, matrix:new({0,1,0}))):normalized()

    -- local origin = vector2.new(0,0)
    -- debug.line(origin, origin + vector2.new(1,0) * 0.5, {1,0,0})
    -- debug.line(origin, origin + vector2.new(0,1) * 0.5, {0,1,0})
    -- debug.circle("fill", origin, 5, 10, {1,1,1})

    -- debug.line(pos, pos + right * 1, {1,0,0})
    -- debug.line(pos, pos + forward * 1, {0,1,0})
    -- debug.circle("fill", Position, 5, 10, {1,1,1})

    -- -- love.graphics.setColor(1, 1, 1)
    -- love.graphics.setColor({1,1,1})
    -- love.graphics.polygon("line", verts)