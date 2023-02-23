local matrix = require("core.matrix")
local vector2 = require("core.vector2")

function debug.line(from, to, rgba)
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