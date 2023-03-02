require "core.ecs"
local entity = require("core.ecs.entity")
local vector2 = require("core.vector2")
local mesh = require("core.renderer.mesh")
local collision = require("core.collision.collision")

local cmesh = require("core.components.cmesh")
local cbox_collider = require("core.components.cbox_collider")
local crigidbody = require("core.components.crigidbody")
local chealth = require("game.scripts.components.chealth")

local eprimitive = require("core.entities.eprimitive")
local eenemy = require("game.scripts.entities.eenemy")
local epickup = require("game.scripts.entities.epickup")

local eplayer = Type_registry.create_entity_type("EPlayer")
eplayer.new = function()
    local self = entity.new()
    self.type_id = eplayer
    self.name = "Player"

    -- components
    self.mesh_comp = self:add_component(cmesh)
    self.box_comp = self:add_component(cbox_collider)
    self.rb_comp = self:add_component(crigidbody)
    self.health_comp = self:add_component(chealth)

    self.input = {
        movement = 0,
        jump_hold = false,
        jump_up = false,
        shoot = false,
        dash = false
    }

    self.collision_normal = vector2.zero

    -- MOVEMENT
    self.speed = 50
    self.dash_speed = 15
    self.can_dash = true
    -- 0 to 1 where 1 is max control
    self.air_control = 0.9
    self.wall_friction = 2

    -- COLLISIONS
    self.sweep_offset = 0.3
    self.is_grounded = false
    -- wall collision
    self.wall_jump_y = 1
    self.jump_normal = vector2.zero
    
    -- JUMP
    self.jump_speed = 12
    self.do_jump = false
    self.jumped = false
    -- coyote time
    self.coyote_goal = 0.1
    self.coyote_timer = 0
    self.in_air = false

    -- COMBAT
    -- gun
    self.damage = 10
    self.ammo_max = 5
    self.ammo = 5
    self.hand_pos = vector2.zero
    self.crosshair_pos = vector2.zero
    self.aim_dir = vector2.zero
    self.recoil = 12
    self.hit = {}
    -- enemy
    self.knockback_multiplier = 0.8

    self.delta_position = vector2.zero
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self.mesh_comp.filter = mesh.quad
        self.mesh_comp.color = {0.5,0.5,0.5}

        self.box_comp:log_layers()

        self.rb_comp.gravity = 30
        self.rb_comp.friction = self.wall_friction
        self.can_dash = true
        self.jumps = self.jumps_max

        self.delta_position = self.transform.position
        self.ammo = self.ammo_max

        self.health_comp.bar_color = {0,1,0}
        -- self.box_comp.layer = CollisionLayer.player
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.is_grounded = self:ground_check()
        self:handle_input()
        self:handle_jump(dt)
        
        self.collision_normal = self.get_collision_normal()

        self:handle_aim()
        if self.input.shoot then
            self:shoot()
        end

        if self.is_grounded == false then
            self.can_dash = true
        end
        if self.input.dash then
            self:dash()
        end

        -- self.delta_position = self.delta_position - self.transform.position
        -- self.delta_position = self.transform.position
        -- -- print(self.delta_position)

        -- jump
        self.jump_normal = self.collision_normal - vector2.new(0,1) * self.wall_jump_y
        self.jump_normal = self.jump_normal:normalized()
    end

    local super_fixed_update = self.fixed_update
    function self:fixed_update(dt)
        super_fixed_update(self, dt)
        self:handle_movement()
    end

    function self:handle_movement()
        -- movement
        if self.is_grounded then
            self.rb_comp:add_velocity(vector2.new(self.input.movement, 0) * self.speed)
            self.jumps = self.jumps_max
        else
            self.rb_comp:add_velocity(vector2.new(self.input.movement, 0) * self.air_control * self.speed)
        end

        -- wall sliding
        if self.collision_normal.x ~= 0 then
            self.rb_comp:add_velocity(vector2.new(0,-1) * self.wall_friction)
        end
    end

    function self:handle_jump(dt)
        -- coyote buffer
        if self.is_grounded == true then
            self.coyote_timer = self.coyote_goal
        else
            self.coyote_timer = self.coyote_timer - dt
        end

        self.in_air = self.coyote_timer <= 0

        if Input.get_key_down(Key.Space) and self.in_air == false then
            self:jump()
        end
    end

    function self:jump()
        local jump_velocity = self.jump_normal * self.jump_speed
        self.rb_comp.velocity = vector2.new(
            self.rb_comp.velocity.x + jump_velocity.x,
            jump_velocity.y
        )
    end

    function self:handle_aim()
        -- aiming
        self.crosshair_pos = Input.get_mouse_world()
        self.aim_dir = self.crosshair_pos - self.transform.position
        self.aim_dir = self.aim_dir:normalized()
        self.hand_pos = self.transform.position + self.aim_dir * 1
    end

    function self:shoot()
        if self.ammo <= 0 then
            print("no ammo")
            return
        end
        self.ammo = self.ammo - 1
        -- recoil
        local bullet = World:create_entity(epickup, self.hand_pos + self.aim_dir * 0.2)
        -- sketch aka rotate 90 deg aim direction. Add aim direction to angle the bullet direction forward
        -- sketch counter clockwise
        if self.aim_dir.x >= 0 then
            bullet.rb_comp.velocity = vector2.new(self.aim_dir.y, -self.aim_dir.x) * 5 + self.aim_dir * 2
        -- sketch clockwise
        else
            bullet.rb_comp.velocity = vector2.new(-self.aim_dir.y, self.aim_dir.x) * 5 + self.aim_dir * 2
        end

        local recoil_velocity = -self.aim_dir * self.recoil
        if self.is_grounded == true and recoil_velocity.y > 0 then
            self.rb_comp.velocity = vector2.new(self.rb_comp.velocity.x * 0.2 + recoil_velocity.x, 0)
        else
            self.rb_comp.velocity = self.rb_comp.velocity * 0.2 + recoil_velocity
        end

        collision.raycast(
            self.hand_pos,
            self.aim_dir,
            20,
            self.hit,
            RayLayer.world,
            false
        )

        if self.hit.blocking then
            if self.hit.object:is_type(eenemy) then
                self.hit.object:on_hit(self.aim_dir, self.damage)
            end
        end
    end

    function self:dash()
        if self.can_dash == false then
            return
        end

        self.can_dash = false
        local dash_velocity = vector2.zero
        if self.input.movement == 0 then
            local velocity = 0
            if self.rb_comp.velocity.x >= 0 then
                velocity = 1
            else
                velocity = -1
            end
            dash_velocity = vector2.new(velocity , 0) * self.dash_speed
            self.rb_comp.velocity = self.rb_comp.velocity * 0.5 + dash_velocity
        else
            print("dash2")
            local dash_velocity = vector2.new(self.input.movement, 0) * self.dash_speed
            self.rb_comp.velocity = self.rb_comp.velocity * 0.5 + dash_velocity
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
        self.input.dash = Input.get_key_down(Key.LShift)
    end

    function self.get_collision_normal()
        local normal = vector2.zero


        local box_x_min = self.rb_comp.collider:offset_box(vector2.new(-1,0) * self.sweep_offset, vector2.new(1,1))
        local box_x_max = self.rb_comp.collider:offset_box(vector2.new(1,0) * self.sweep_offset, vector2.new(1,1))
        local box_y_min = self.rb_comp.collider:offset_box(vector2.new(0,-1) * self.sweep_offset, vector2.new(1,1))
        local box_y_max = self.rb_comp.collider:offset_box(vector2.new(0,1) * self.sweep_offset, vector2.new(1,1))

        for key, rb in pairs(World.physics_bodies) do
            if rb.id == self.rb_comp.id then
                goto continue
            end
            if collision.intersect_aabb(rb.collider.box, box_x_min) then
                normal = vector2.new(1 + normal.x,0 + normal.y)
            end
            if collision.intersect_aabb(rb.collider.box, box_x_max) then
                normal = vector2.new(-1 + normal.x,0 + normal.y)
            end
            if collision.intersect_aabb(rb.collider.box, box_y_min) then
                normal = vector2.new(0 + normal.x,1 + normal.y)
            end
            if collision.intersect_aabb(rb.collider.box, box_y_max) then
                normal = vector2.new(0 + normal.x,-1 + normal.y)
            end
            ::continue::
        end
        return normal:normalized()
    end

    function self.ground_check()
        return not (self.get_collision_normal() == vector2.zero)
    end

    function self:on_pickup(pickup)
        self.ammo = self.ammo + 1
    end

    function self:on_attacked(enemy)
        self.health_comp:damage(enemy.damage)

        local dir = self.transform.position - enemy.transform.position
        self.rb_comp.velocity = dir * enemy.damage * self.knockback_multiplier
    end

    local super_draw = self.draw
    function self:draw()
        super_draw(self)
    
        -- grounding
        -- debug.quad("line", self.transform.position + vector2.new(1,0) * self.sweep_offset, vector2.new(1, 1), 0, {1,0,0})
        -- debug.quad("line", self.transform.position - vector2.new(1,0) * self.sweep_offset, vector2.new(1, 1), 0, {1,0,0})
        -- debug.quad("line", self.transform.position + vector2.new(0,1) * self.sweep_offset, vector2.new(1, 1), 0, {1,0,0})
        -- debug.quad("line", self.transform.position - vector2.new(0,1) * self.sweep_offset, vector2.new(1, 1), 0, {1,0,0})

        -- aiming
        debug.circle("fill", self.transform.position + self.aim_dir * 1, 10,10,{1,1,1})
        debug.quad("fill", self.crosshair_pos, vector2.new(0.2,0.2), 0, {1,1,1})
        debug.line(self.hand_pos, self.crosshair_pos, {1,0,0})

        -- jump
        if self.ground_check() then
            debug.line(self.transform.position, self.transform.position + self.jump_normal * 1, {0,0,1})
        end

        collision.raycast(
            self.hand_pos,
            self.aim_dir,
            20,
            self.hit,
            RayLayer.world,
            true
        )
    end

    return self
end

return eplayer