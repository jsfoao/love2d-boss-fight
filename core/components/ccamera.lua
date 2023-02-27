require "core.ecs"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")

local ccamera = Type_registry.create_component_type("CCamera")
ccamera.new = function ()
    local self = component.new()
    self.type_id = ccamera.type_id
    
    self.position = vector2.new(0, 0)
    self.z = 0
    self.view_mtx = nil
    self.ratio_x = 2
    self.ratio_y = 2

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        local h_width = love.graphics.getWidth() / 2
        local h_height = love.graphics.getHeight() / 2
        local model = matrix:new(3, "I")
        model = matrix.mul(model, matrix.translate(-self.position.x + h_width, self.position.y + h_height))
        model = matrix.mul(model, matrix.scale(self.z + 1, self.z + 1))
        model = matrix.mul(model, matrix.scale(love.graphics.getWidth() / (self.ratio_x * 5), love.graphics.getHeight() / (self.ratio_y * 5)))
        self.view_mtx = model
    end

    function self:world_to_screen(world_pos)
        local p = matrix:new({world_pos.x, world_pos.y, 1})
        local m = matrix:new(3, "I")
        m = matrix.mul(m, matrix.translate(p[1][1], p[2][1]))
        m = matrix.mul(m, matrix.scale(0, 0))
        m = matrix.mul(m, matrix.rotate(0))
        local f = matrix.mul(self.view_mtx, m)
        local screen_pos_mtx = matrix.mul(f, p)
        return vector2.new(screen_pos_mtx[1][1], screen_pos_mtx[2][1])
    end

    function self:screen_to_world(screen_pos)
        local p = matrix:new({screen_pos.x, screen_pos.y, 1})
        local m = matrix:new(3, "I")
        m = matrix.mul(m, matrix.translate(-self.position.x, self.position.y))
        m = matrix.mul(m, matrix.scale(self.z + 1, self.z + 1))
        m = matrix.mul(m, matrix.scale(love.graphics.getWidth() / (self.ratio_x * 5), love.graphics.getHeight() / (self.ratio_y * 5)))
        local inverted = matrix.invert(m)
        local world_pos_mtx = matrix.mul(inverted, p)
        return vector2.new(world_pos_mtx[1][1], world_pos_mtx[2][1])
    end

    return self
end
return ccamera