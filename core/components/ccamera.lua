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

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        local h_width = love.graphics.getWidth() / 2
        local h_height = love.graphics.getHeight() / 2
        local model = matrix:new(3, "I")
        model = matrix.mul(model, matrix.translate(-self.position.x + h_width, self.position.y + h_height))
        model = matrix.mul(model, matrix.scale(self.z + 1, self.z + 1))
        model = matrix.mul(model, matrix.scale(love.graphics.getWidth() / 10, love.graphics.getHeight() / 10))
        self.view_mtx = model
    end

    return self
end
return ccamera