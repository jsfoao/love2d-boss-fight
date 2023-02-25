require "core.ecs"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")

local ctransform = Type_registry.create_component_type("CTransform")
ctransform.new = function ()
    -- setup
    local self = component.new()
    self.name = "CTransform"
    self.type_id = ctransform.type_id

    -- position in world space
    self.position = vector2.new(0,0)
    -- scale in world space
    self.scale = vector2.new(1,1)
    -- rotation in degrees (around z axis)
    self.rotation = 0
    -- local space right direction
    self.right = vector2.new(0,0)
    -- local space forward direction
    self.forward = vector2.new(0,0)

    -- debug
    self.debug = true

    local super_update = self.update
    function self:update(dt)
        local pos = self.position
        local scl = self.scale
        local rot = self.rotation

        local model = matrix:new(3, "I")
        model = matrix.mul(model, matrix.translate(pos.x, pos.y))
        model = matrix.mul(model, matrix.scale(scl.x, scl.y))
        model = matrix.mul(model, matrix.rotate(math.rad(rot)))

        self.right = matrix.to_vec(matrix.mul(model, matrix:new({1,0,0}))):normalized()
        self.forward = matrix.to_vec(matrix.mul(model, matrix:new({0,1,0}))):normalized()

    end

    function self:draw()
        debug.handles(self.position, self.right, 0.5)
    end
    return self
end

return ctransform