require "core.ecs"
local entity = require("core.ecs.entity")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")
local collision = require("core.collision.collision")

local crigidbody = require("core.components.crigidbody")
local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")

local epickup = Type_registry.create_entity_type("EPickup")
epickup.new = function()
    local self = entity.new()
    self.type_id = epickup.type_id
    self.name = "Pickup"
    self.transform.scale = vector2.new(0.25,0.25)

    -- component
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.rb_comp = self:add_component(crigidbody)

    self.box_overlap_comp = self:add_component(cbox_collider)

    self.rotation_rate = 0
    self.rotation_friction = 1
    self.is_grounded = false
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self.rotation_rate = 10
        self.box_comp.on_collision_enter_callback = self.on_collision_enter
        self.box_overlap_comp.on_collision_enter_callback = self.on_overlap_enter

        self.box_overlap_comp.lock.scale = false
        self.box_overlap_comp.scale = vector2.new(1,1)
        self.box_overlap_comp.debug = true
        self.box_overlap_comp:log_layers()
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        if self.is_grounded == true then
            return
        end
        self.transform.rotation = self.transform.rotation + self.rotation_rate
        self.rotation_rate = self.rotation_rate - self.rotation_rate * self.rotation_friction * dt
    end

    function self:on_overlap_enter(other)
        print("here")
    end

    function self:on_collision_enter(other)
        self.owner.is_grounded = true
        self.owner.transform.rotation = 0

        -- disable physics, not necessary anymore since object is on ground to be picked up
        self.owner.rb_comp:set_disable()
        self.owner.box_comp:set_disable()
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
    end

    return self
end

return epickup