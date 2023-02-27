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
        y = { min = 0, max = 0},
    }
    self.position = vector2.zero
    self.rotation = 0
    self.scale = vector2.new(1,1)
    self.lock = { pos = true, scale = true, rotation = false}
    self.other_colliders = {}

    -- callbacks
    self.on_collision_enter_callback = nil
    self.on_collision_stay_callback = nil
    self.on_collision_exit_callback = nil

    -- debug
    self.debug_color = {1,0,0}
    self.debug = false

    function self:on_collision_enter(other)
        if not (self.on_collision_enter_callback == nil) then
            self.on_collision_enter_callback(self, other)
        end
    end

    function self:on_collision_stay(other)
        if not (self.on_collision_stay_callback == nil) then
            self.on_collision_stay_callback(self, other)
        end
    end

    function self:on_collision_exit(other)
        if not (self.on_collision_exit_callback == nil) then
            self.on_collision_exit_callback(self, other)
        end
    end

    function self:add_collider(other)
        for key, col in pairs(self.other_colliders) do
            -- collider is already in table
            if col.id == other.id then
                self:on_collision_stay(other)
                return
            end
        end
        table.insert(self.other_colliders, other)
        self:on_collision_enter(other)
    end

    function self:remove_collider(other)
        for i = 1, #self.other_colliders, 1 do
            -- exit when sucessfully removed existing collider
            if self.other_colliders[i].id == other.id then
                table.remove(self.other_colliders, i)
                self:on_collision_exit(other)
                return
            end
        end
    end

    function self:offset_box(direction, scale)
        local tscale = vector2.new(self.scale.x * scale.x, self.scale.y * scale.y)
        local hscale = tscale / 2
        local box = {
            x = { min = self.position.x - hscale.x, max = self.position.x + hscale.x },
            y = { min = self.position.y - hscale.y, max = self.position.y + hscale.y }
        }
        return box
    end

    function self:is_colliding()
        return not (#self.other_colliders == 0)
    end

    local super_load = self.load
    function self:load()
        World:add_collider(self)
    end

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

        local colliders = {}
        for key, e in pairs(World.entities) do
            if e.enabled == true and not (e.id == self.owner.id) then
                if e:has_component(cbox_collider)then
                    local col = e:get_component(cbox_collider)
                    if col.layer == self.layer then
                        table.insert(colliders, col)
                    end
                end
            end
        end

        for key, col in pairs(colliders) do
            if collision.intersect_aabb(col.box, self.box) then
                self:add_collider(col)
                self.debug_color = {0,1,0}
            else
                self:remove_collider(col)
                self.debug_color = {1,0,0}
            end
        end
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
        if self.debug then
            debug.quad("line", self.position, self.scale, self.rotation, self.debug_color)
        end
    end

    local super_on_destroy = self.on_destroy
    function self:on_destroy()
        super_on_destroy(self)
        World:remove_collider(self)
    end
    return self
end
return cbox_collider