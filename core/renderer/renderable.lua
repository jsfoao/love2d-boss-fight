local vector2 = require("core.vector2")

SCREEN_SPACE = 0
WORLD_SPACE = 1

local renderable = {}
renderable.new = function ()
    local self = {}
    self.space = WORLD_SPACE
    self.position = vector2.new()
    self.scale = vector2.new()
    self.rotation = 0
    self.z = 0

    function self:draw()
    end
    return self
end

return renderable