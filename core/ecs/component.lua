require "core.ecs"
local object = require("core.ecs.object")

local component = {}
component.new = function ()
    local self = object.new()
    self.owner = nil
    self.enabled = true

    function self:load() end

    function self:update(dt) end

    function self:draw() end

    return self
end

return component