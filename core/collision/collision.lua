local vector2 = require("core.vector2")
require "core.collision.collision_layers"

local collision = {}
function collision.point_inside_aabb(point, aabb)
    return
        point.x >= aabb.x.min and
        point.x <= aabb.x.max and
        point.y >= aabb.y.min and
        point.y <= aabb.y.max
end

function collision.point_inside_circle(point, circle)
    local dir = point - circle.pos
    local dist = math.sqrt(dir.x * dir.x + dir.y * dir.y)
    return dist < circle.radius
end

function collision.intersect_aabb(a, b)
    return
        a.x.min <= b.x.max and
        a.x.max >= b.x.min and
        a.y.min <= b.y.max and
        a.y.max >= b.y.min
end

function collision.intersect_circle(a, b)
    local dir = a.pos - b.pos
    local dist = math.sqrt(dir.x * dir.x + dir.y * dir.y)
    return dist < a.radius * 2 + b.radius * 2
end

function collision.intersect_aabb_circle(aabb, circle)
    local x = math.max(aabb.x.min, math.min(circle.pos.x, aabb.x.max))
    local y = math.max(aabb.y.min, math.min(circle.pos.y, aabb.y.max))
    local dir = vector2.new(x, y) - circle.pos
    local dist = math.sqrt(dir.x * dir.x + dir.y * dir.y)
    return dist < circle.radius
end

function collision.raycast(from, dir, length, out_hit, layer, debugging)
    local norm_dir = dir:normalized()
    -- ray segments
    local gap = 0.1
    local temp = norm_dir * length
    local dist = temp:len()
    local segments = dist / gap

    if debugging == true then
        debug.line(from, from + norm_dir * length, {1,0,0})
    end

    for i = 1, segments, 1 do
        local point = from + (norm_dir * i * gap)
        for key, col in pairs(World.colliders) do
            if collision.point_inside_aabb(point, col.box) and col:has_ray_layer(layer) then
                out_hit.blocking = true
                out_hit.position = point
                out_hit.object = col.owner

                if debugging == true then
                    debug.circle("fill", out_hit.position, 5, 10, {0,1,0})
                end
                return true
            end
        end
    end
    return false
end

return collision