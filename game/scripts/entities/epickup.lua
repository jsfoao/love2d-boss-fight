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
        self.box_overlap_comp.scale = vector2.new(0.5,0.5)
        self.box_overlap_comp.debug = true
        self.box_overlap_comp.init_layers_true = false
        self.box_overlap_comp.layer = CollisionLayer.dynamic
        

        self.box_comp:set_ray_layer_all_disable()
        self.box_overlap_comp:set_ray_layer_all_disable()

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
        if other.owner == Player then
            Player:on_pickup(self.owner)
            World:destroy_entity(self.owner)
        end
    end

    function self:on_collision_enter(other)
        if self.owner.is_grounded == true then
            return
        end

        if other.owner:is_type(epickup) then
            return
        end

        -- ensures components get disabled only in contact with ground floor and not with side or top platforms
        if self.owner.rb_comp.contact_y == true and self.owner.rb_comp.penetration_y >= 0 then
            self.owner.is_grounded = true
            self.owner.transform.rotation = 0
    
            -- disable physics, not necessary anymore since object is on ground to be picked up
            self.owner.rb_comp:set_disable()
            self.owner.box_comp:set_disable()
        end
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
    end

    return self
end

return epickup