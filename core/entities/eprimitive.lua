require "core.ecs"
local entity = require("core.ecs.entity")
local cmesh = require("core.components.cmesh")
local mesh = require("core.renderer.mesh")
local vector2 = require("core.vector2")

local eprimitive = Type_registry.create_entity_type("EPrimitive")
eprimitive.new = function()
    local self = entity.new()
    self.type_id = eprimitive
    self.name = "Primitive"

    self.mesh = mesh.quad

    -- rigidbody
    self.physics = {}
    self.velocity = vector2.zero

    -- components
    self.mesh_comp = self:add_component(cmesh)

    local super_load = self.load
    function self:load()
        super_load(self)
        self:log()
        self.transform.scale = vector2.new(5,5)
        self.mesh_comp.filter = mesh.quad

        self.physics.type = "dynamic"
        self.physics.body = love.physics.newBody(
            World.physics,
            self.transform.position.x,
            self.transform.position.y,
            self.physics.type
        )
        self.physics.shape = love.physics.newRectangleShape(
            self.transform.scale.x,
            self.transform.scale.y
        )
        self.physics.fixture = love.physics.newFixture(
            self.physics.body,
            self.physics.shape
        )
        self.mesh_comp.z = 4
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        self.transform.position.x = self.physics.body:getX()
        self.transform.position.y = self.physics.body:getY()
    end
    return self
end

return eprimitive