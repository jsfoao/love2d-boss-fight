require "core.ecs"
local entity = require("core.ecs.entity")
local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local vector2 = require("core.vector2")

local eplayer = Type_registry.create_entity_type("EPlayer")
eplayer.new = function()
    local self = entity.new()
    self.type_id = eplayer
    self.name = "Player"

    -- components
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)

    local super_load = self.load
    function self:load()
        super_load(self)
        self.box_comp.scale = vector2.new(2,2)
        self:log()
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        if Input.get_key_down(Key.H) then
            print("down")
        end
        if Input.get_key_hold(Key.H) then
            print("hold")
        end
        if Input.get_key_up(Key.H) then
            print("up")
        end

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

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
        debug.handles(self.transform.position, self.transform.right, 1)
    end
    return self
end

return eplayer