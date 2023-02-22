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
    self.zoom_mtx = nil

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.view_mtx = matrix.trans(-self.position.x, self.position.y)
        self.zoom_mtx = matrix.mulnum(matrix.scale(self.z + 1, self.z + 1), 50)
    end

    return self
end
return ccamera