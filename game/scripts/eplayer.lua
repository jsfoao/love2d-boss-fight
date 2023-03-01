require "core.ecs"
local entity = require("core.ecs.entity")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")
local collision = require("core.collision.collision")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local crigidbody = require("core.components.crigidbody")

local eplayer = Type_registry.create_entity_type("EPlayer")
eplayer.new = function()
    local self = entity.new()
    self.type_id = eplayer
    self.name = "Player"

    -- components
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.rb_comp = self:add_component(crigidbody)

    local super_load = self.load
    function self:load()
        super_load(self)
        self.rb_comp:init(self.box_comp)
        self.mesh_comp.filter = mesh.quad
        self.mesh_comp.color = {0,1,0}
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        local speed = 10
        if Input.get_key_hold(Key.A) then
            self.rb_comp:add_velocity(vector2.new(-speed * dt), 0)
        end
        if Input.get_key_hold(Key.D) then
            self.rb_comp:add_velocity(vector2.new(speed * dt), 0)
        end
        if Input.get_key_hold(Key.Space) then
            self.rb_comp:add_velocity(vector2.new(0, -20 * dt))
        end
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
        
        local is_grounded = self.rb_comp.contact_y
        local world_mouse_pos = Input.get_mouse_world()
        local dir = world_mouse_pos - self.transform.position
        local hit = {}
        debug.line(self.transform.position + dir:normalized() * 1, self.transform.position + dir:normalized() * 20, {1,0,0})
        debug.circle("fill", self.transform.position + dir:normalized() * 1, 10,10,{1,1,1})
        debug.circle("fill", world_mouse_pos, 10, 10, {1,1,1})

        if collision.raycast(self.transform.position + dir:normalized() * 1, dir, 20, hit, 0) then
            debug.circle("fill", hit.position, 5, 10, {0,1,0})
        end
    end

    return self
end

return eplayer