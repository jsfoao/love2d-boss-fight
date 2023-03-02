require "core.ecs"

local object = {}
object.new = function ()
    local self = {}
    self.type_id = -1
    self.id = Type_registry.generate_uuid()
    self.name = "default"
    self.enabled = true

    function self:load() end
    function self:update(dt) end
    function self:fixed_update(dt) end
    function self:draw() end
    function self:on_destroy() end
    function self:set_enable() 
        self.enabled = true
    end
    function self:set_disable()
        self.enabled = false
    end

    function self:is_type(type)
        return self.type_id == type.type_id
    end
    return self
end

return object