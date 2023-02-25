local matrix = require("core.matrix")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")

function debug.line(from, to, rgba)
    if Camera.view_mtx == nil then
        return
    end

    local f = matrix:new({from.x, from.y, 1})
    local t = matrix:new({to.x, to.y, 1})

    local m = matrix:new(3, "I")
    m = matrix.mul(m, matrix.translate(f[1][1], f[2][1]))
    m = matrix.mul(m, matrix.scale(0, 0))
    m = matrix.mul(m, matrix.rotate(0))
    local tf = matrix.mul(Camera.view_mtx, m)

    m = matrix:new(3, "I")
    m = matrix.mul(m, matrix.translate(t[1][1], t[2][1]))
    m = matrix.mul(m, matrix.scale(0, 0))
    m = matrix.mul(m, matrix.rotate(0))
    local tt = matrix.mul(Camera.view_mtx, m)

    local f_vec = matrix.mul(tf, f)
    local t_vec = matrix.mul(tt, t)

    love.graphics.setColor(rgba)
    love.graphics.line({f_vec[1][1], f_vec[2][1], t_vec[1][1], t_vec[2][1]})
end

function debug.mesh(mode, pos, scale, rot, mesh, rgba)
    local model = matrix:new(3, "I")
    model = matrix.mul(model, matrix.translate(pos.x, pos.y))
    model = matrix.mul(model, matrix.scale(scale.x, scale.y))
    model = matrix.mul(model, matrix.rotate(math.rad(rot)))
    local mtx = matrix.mul(Camera.view_mtx, model)

    local verts = {}
    local msh = mesh
    for i = 1, #msh, 2 do
        local point = matrix:new({msh[i], msh[i+1], 1})
        local final = matrix.mul(mtx, point)
        verts[i] = final[1][1]
        verts[i+1] = final[2][1]
    end

    love.graphics.setColor(rgba)
    love.graphics.polygon(mode, verts)
end

function debug.quad(mode, pos, scale, rot, rgba)
    debug.mesh(mode, pos, scale, rot, mesh.quad, rgba)
end

function debug.circle(mode, pos, radius, segments, rgba)
    local p = matrix:new({pos.x, pos.y, 1})
    local m = matrix:new(3, "I")
    m = matrix.mul(m, matrix.translate(p[1][1], p[2][1]))
    m = matrix.mul(m, matrix.scale(0, 0))
    m = matrix.mul(m, matrix.rotate(0))
    local f = matrix.mul(Camera.view_mtx, m)
    local center = matrix.mul(f, p)

    love.graphics.setColor(rgba)
    love.graphics.circle(mode, center[1][1], center[2][1], radius, segments)
end

function debug.handles(pos, right, size)
    if Camera.view_mtx == nil then
        return
    end
    local forward = vector2.new(-right.y, right.x)
    debug.line(pos, pos + right * size, {1,0,0})
    debug.line(pos, pos + forward * size, {0,1,0})
    debug.circle("fill", pos, 5, 10, {1,1,1})
end