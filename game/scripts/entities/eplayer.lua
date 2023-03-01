require "core.ecs"
local entity = require("core.ecs.entity")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")
local collision = require("core.collision.collision")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local crigidbody = require("core.components.crigidbody")

local eprimitive = require("core.entities.eprimitive")

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
        shoot = false,
        dash = false
    }

    self.wall_friction = 2
    self.speed = 40

    self.collision_normal = vector2.zero

    -- MOVEMENT
    self.dash_speed = 1500
    self.can_dash = true
    
    -- JUMP
    self.can_jump = false
    self.jump_speed = 80000
    self.do_jump = false
    -- wall collision
    self.wall_jump_y = 1
    self.jump_normal = vector2.zero
    -- coyote time
    self.coyote_goal = 0.1
    self.coyote_timer = 0
    -- buffer and impulse for "analogue" jump
    self.jump_reset = true
    self.can_buffer = true
    self.jump_buffer = 0
    self.jump_buffer_speed = 10
    self.cached_buffer = 0
    self.cached_velocity = vector2.zero
    self.jump_impulse_goal = 0.01
    self.jump_impulse_timer = 0

    self.in_air = false

    -- SHOOTING
    self.hand_pos = vector2.zero
    self.crosshair_pos = vector2.zero
    self.aim_dir = vector2.zero
    self.recoil = 1200
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self.rb_comp:init(self.box_comp)
        self.mesh_comp.filter = mesh.quad
        self.mesh_comp.color = {0.5,0.5,0.5}

        self.box_comp:set_layer_enable(CollisionLayer.world, false)
        self.box_comp:log_layers()

        self.rb_comp.gravity = 30
        self.rb_comp.friction = self.wall_friction
        self.can_dash = true
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

        if self.in_air == false then
            self.can_dash = true
        end
        print(self.can_dash)
        if self.input.dash then
            self:dash()
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
        -- coyote buffer
        if self.is_grounded() == true then
            self.coyote_timer = self.coyote_goal
        else
            self.coyote_timer = self.coyote_timer - dt
        end

        if self.coyote_timer > 0 then
            self.in_air = false
        else
            self.in_air = true
        end

        -- jump buffer for "analogue" jump. Hold key to jump higher
        if self.input.jump_hold == true and self.jump_reset == true then
            self.jump_buffer = self.jump_buffer + dt * self.jump_buffer_speed
        end
        
        -- conditions to perform jump
        self.do_jump =
            self.in_air == false and self.input.jump_up or
            self.in_air == false and self.jump_buffer >= 1

            
        if self.do_jump and self.jump_reset == true then
            self.cached_buffer = self.jump_buffer + 0.5
            self.jump_buffer = 0
            self.jump_impulse_timer = self.jump_impulse_goal
            self.jump_reset = false
            print("jump")
            self.cached_velocity = self.rb_comp.velocity
            print(self.cached_velocity)
            print(self.cached_buffer)
        end

        -- add jump impulse
        if self.jump_impulse_timer > 0 then
            self.rb_comp:add_velocity(self.jump_normal * self.jump_speed * self.cached_buffer * dt)
            self.jump_impulse_timer = self.jump_impulse_timer - dt
        end

        -- resets so can jump again when key is released
        if self.input.jump_up == true then
            self.jump_reset = true
        end
    end

    function self:jump()

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

        -- World:create_entity(eprimitive, self.)

        if hit.blocking then
        end
    end

    function self:dash()
        if self.can_dash == false then
            return
        end
        self.can_dash = false
        self.rb_comp:add_velocity(self.aim_dir * self.dash_speed)
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
        self.input.dash = Input.get_mouse_down(Mouse.Right)
    end

    function self.get_collision_normal()
        local forward = vector2.zero
        local right = vector2.zero
        if self.rb_comp.sweep_y == true and self.rb_comp.penetration_y > 0 then
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
            false
        )

        local right_hit = {}
        collision.raycast(
            self.transform.position + self.transform.right * 0.5,
            self.transform.right,
            0.2,
            right_hit,
            RayLayer.world,
            false
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