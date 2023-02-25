require "core.ecs"
local object = require("core.ecs.object")

local game_mode = {}
game_mode.new = function ()
    local self = object.new()
    self.world = nil
    function self:load() end

    function self:update(dt) end
    
    function self:draw(dt) end
    return self
end

return game_mode