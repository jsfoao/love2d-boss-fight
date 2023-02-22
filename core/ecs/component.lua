require "core.ecs"
local object = require("core.ecs.object")

local component = {}
component.new = function ()
    local self = object.new()
    self.owner = nil

    function self:load()
        print("loaded component")
    end

    function self:update(dt)
    end

    return self
end

return component