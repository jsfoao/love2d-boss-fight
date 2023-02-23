local vector2 = require("core.vector2")

SCREEN_SPACE = 0
WORLD_SPACE = 1

local renderable = {}
renderable.new = function ()
    local self = {}
    self.space = nil
    self.position = vector2.new()
    self.scale = vector2.new()
    self.rotation = vector2.new()

    function self:draw() end
    return self
end

return renderable