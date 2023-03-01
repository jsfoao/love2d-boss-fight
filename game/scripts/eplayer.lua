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

    self.input = {
        movement = 0,
        jump_hold = false,
        jump_up = false,
        shoot = false
    }

    self.wall_friction = 0.2
    self.speed = 40

    self.collision_normal = vector2.zero
    
    -- JUMP
    self.can_jump = false
    self.jump_speed = 50000
    self.do_jump = false
    self.jump_count = 0
    -- wall collision
    self.wall_jump_y = 1
    self.jump_normal = vector2.zero
    -- coyote time
    self.coyote_goal = 0.1
    self.coyote_timer = 0
    -- buffer and impulse for "analogue" jump
    self.can_buffer = true
    self.jump_buffer = 0
    self.jump_buffer_speed = 8
    self.cached_buffer = 0
    self.jump_impulse_goal = 0.01
    self.jump_impulse_timer = 0

    -- SHOOTING
    self.hand_pos = vector2.zero
    self.crosshair_pos = vector2.zero
    self.aim_dir = vector2.zero
    self.recoil = 800
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self.rb_comp:init(self.box_comp)
        self.mesh_comp.filter = mesh.quad
        self.mesh_comp.color = {0.5,0.5,0.5}

        self.box_comp:log_layers()
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self:handle_input()
        self:handle_jump(dt)
        
        self.collision_normal = self.get_collision_normal()

        self:handle_aim()
        if self.input.shoot then
            self:shoot()
        end
    end

    local super_fixed_update = self.fixed_update
    function self:fixed_update(dt)
        super_fixed_update(self, dt)

        -- movement
        self.rb_comp:add_velocity(vector2.new(self.input.movement, 0) * self.speed)

        -- wall movement
        if self.collision_normal.x ~= 0 then
            self.rb_comp:add_velocity(vector2.new(0,-1) * self.wall_friction)
        end

        -- jump
        self.jump_normal = self.collision_normal - vector2.new(0,1) * self.wall_jump_y
        self.jump_normal = self.jump_normal:normalized()
    end

    function self:handle_jump(dt)
        -- reset coyote
        if self.is_grounded() then
            self.coyote_timer = self.coyote_goal
            self.can_buffer = true
        -- coyote buffer
        else
            self.coyote_timer = self.coyote_timer - dt
            self.can_buffer = false
        end
        local in_coyote = self.coyote_timer > 0

        if self.input.jump_hold and in_coyote and self.can_buffer then
            self.jump_buffer = self.jump_buffer + dt * self.jump_buffer_speed
        end

        self.do_jump = in_coyote and self.input.jump_up or
        in_coyote and self.jump_buffer >= 1

        if self.do_jump then
            self.cached_buffer = self.jump_buffer
            self.jump_buffer = 0
            self.jump_impulse_timer = self.jump_impulse_goal
            self.jump_count = self.jump_count + 1
            print("jump")
        end

        -- add jump impulse
        if self.jump_impulse_timer > 0 then
            self.rb_comp:add_velocity(self.jump_normal * self.jump_speed * self.cached_buffer * dt)
            self.jump_impulse_timer = self.jump_impulse_timer - dt
        end
    end

    function self:handle_aim()
        -- aiming
        self.crosshair_pos = Input.get_mouse_world()
        self.aim_dir = self.crosshair_pos - self.transform.position
        self.aim_dir = self.aim_dir:normalized()
        self.hand_pos = self.transform.position + self.aim_dir * 1
    end

    function self:shoot()
        -- recoil
        self.rb_comp:add_velocity(-self.aim_dir * self.recoil)
        local hit = {}
        collision.raycast(
            self.hand_pos,
            self.aim_dir,
            20,
            hit,
            RayLayer.world,
            false
        )

        if hit.blocking then
            print(hit.object.name)
        end
    end

    function self:handle_input()
        self.input.movement = 0
        if Input.get_key_hold(Key.A) then
            self.input.movement = -1
        end
        if Input.get_key_hold(Key.D) then
            self.input.movement = 1
        end
        self.input.jump_hold = Input.get_key_hold(Key.Space)
        self.input.jump_up = Input.get_key_up(Key.Space)
        self.input.shoot = Input.get_mouse_down(Mouse.Left)
    end

    function self.get_collision_normal()
        local forward = vector2.zero
        local right = vector2.zero
        if self.rb_comp.contact_y == true and self.rb_comp.penetration_y > 0 then
            forward = vector2.new(0, -1)
        end

        -- wall movement
        local left_hit = {}
        collision.raycast(
            self.transform.position - self.transform.right * 0.5,
            -self.transform.right,
            0.2,
            left_hit,
            RayLayer.world,
            true
        )

        local right_hit = {}
        collision.raycast(
            self.transform.position + self.transform.right * 0.5,
            self.transform.right,
            0.2,
            right_hit,
            RayLayer.world,
            true
        )

        if left_hit.blocking == true then
            right = vector2.new(1, 0)
        elseif right_hit.blocking == true then
            right = vector2.new(-1, 0)
        end

        local normal = right + forward
        return normal:normalized()
    end

    function self.is_grounded()
        return not (self.get_collision_normal() == vector2.zero)
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
    

        -- aiming
        debug.circle("fill", self.transform.position + self.aim_dir * 1, 10,10,{1,1,1})
        debug.quad("fill", self.crosshair_pos, vector2.new(0.2,0.2), 0, {1,1,1})
        debug.line(self.hand_pos, self.crosshair_pos, {1,0,0})

        -- jump
        if self.is_grounded() then
            debug.line(self.transform.position, self.transform.position + self.jump_normal * 1, {0,0,1})
        end
    end

    return self
end

return eplayer