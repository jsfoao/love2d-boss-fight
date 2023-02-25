require "core.ecs"

local object = {}
object.new = function ()
    local self = {}
    self.type_id = -1
    self.id = -1
    self.name = "default"
    self.enabled = true

    function self:load() end
    function self:update(dt) end
    function self:draw() end

    return self
end

return object