require "core.ecs"
local collision = require("core.collision.collision")
local ccollider = require("core.components.ccollider")
local vector2 = require("core.vector2")

local cbox_collider = Type_registry.create_component_type("CBoxCollider")
cbox_collider.new = function ()
    local self = ccollider.new()
    self.type_id = cbox_collider.type_id
    self.name = "CBoxCollider"

    self.box = {
        x = { min = 0, max = 0},
        y = { min = 0, max = 0}
    }
    self.position = vector2.zero
    self.rotation = 0
    self.scale = vector2.new(1,1)
    self.lock = { pos = true, scale = false, rotation = false}

    self.debug_color = {1,1,1}

    local super_update = self.update
    function self:update(dt)
        super_update(self,dt)
        if self.lock.pos == true then
            self.position = self.owner.transform.position
        end
        if self.lock.scale == true then
            self.scale = self.owner.transform.scale
        end
        if self.lock.rotation == true then
            self.rotation = self.owner.transform.rotation
        end

        local hscale = self.scale / 2
        self.box = {
            x = { min = self.position.x - hscale.x, max = self.position.x + hscale.x },
            y = { min = self.position.y - hscale.y, max = self.position.y + hscale.y }
        }

        if collision.point_inside_aabb(vector2.zero, self.box) then
            self.debug_color = {0,1,0}
        else
            self.debug_color = {1,0,0}
        end
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
        debug.quad("line", self.position, self.scale, self.rotation, self.debug_color)
    end
    return self
end
return cbox_collider