require "core.ecs"
local entity = require("core.ecs.entity")
local mesh = require("core.renderer.mesh")
local vector2 = require("core.vector2")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local crigidbody = require("core.components.crigidbody")

local eprimitive = Type_registry.create_entity_type("EPrimitive")
eprimitive.new = function()
    local self = entity.new()
    self.type_id = eprimitive
    self.name = "Primitive"

    self.mesh = mesh.quad

    -- components
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.rb_comp = self:add_component(crigidbody)



    local super_load = self.load
    function self:load()
        super_load(self)
        self:log()
        self.rb_comp:init(self.box_comp)

        self.box_comp.on_collision_enter_callback = self.on_collision_enter

        self.mesh_comp.z = 2
        self.mesh_comp.filter = mesh.quad
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
    end

    function self:on_collision_enter(self, other)
    end

    return self
end

return eprimitive