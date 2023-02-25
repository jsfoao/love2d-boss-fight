require "core.ecs"
local entity = require("core.ecs.entity")
local cmesh = require("core.components.cmesh")

local eplayer = Type_registry.create_entity_type("EPlayer")
eplayer.new = function()
    local self = entity.new()
    self.type_id = eplayer
    self.name = "Player"

    -- components
    self.mesh_comp = self:add_component(cmesh)

    local super_load = self.load
    function self:load()
        super_load(self)
        self:log()
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        if love.keyboard.isDown('up') then
            self.transform.position.y = self.transform.position.y - 2 * dt
        end
        if love.keyboard.isDown('down') then
            self.transform.position.y = self.transform.position.y + 2 * dt
        end
        if love.keyboard.isDown('left') then
            self.transform.position.x = self.transform.position.x - 2 * dt
        end
        if love.keyboard.isDown('right') then
            self.transform.position.x = self.transform.position.x + 2 * dt
        end
        
        self.transform.rotation = self.transform.rotation + 45 * dt
    end
    return self
end

return eplayer