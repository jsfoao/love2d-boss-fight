require "core.ecs"
local component = require("core.ecs.component")
local vector2 = require("core.vector2")
local matrix = require("core.matrix")
local renderable = require("core.renderer.renderable")
local mesh = require("core.renderer.mesh")


local cmesh = Type_registry.create_component_type("CMesh")
cmesh.new = function ()
    local self = component.new()
    self.name = "CMesh"
    self.type_id = cmesh.type_id

    self.filter = mesh.quad
    self.space = WORLD_SPACE
    self.position = vector2.new()
    self.scale = vector2.new()
    self.rotation = 0
    self.z = 0

    local super_load = self.load
    function self:load()
        super_load(self)
    end

    local super_update = self.update
    function self:update(dt)
        super_update(self, dt)
        if self.enabled == false then
            return
        end
        
        self.position = self.owner.transform.position
        self.scale = self.owner.transform.scale
        self.rotation = self.owner.transform.rotation
        
        Renderer:submit(self)
    end

    function self:draw()
        local pos = self.position
        local scl = self.scale
        local rot = self.rotation
        local model = matrix:new(3, "I")
        model = matrix.mul(model, matrix.translate(pos.x, pos.y))
        model = matrix.mul(model, matrix.scale(scl.x, scl.y))
        model = matrix.mul(model, matrix.rotate(math.rad(rot)))
        local mtx = matrix.mul(Camera.view_mtx, model)
    
        love.graphics.setColor({1,0,0})
        local verts = {}
        local msh = self.filter
        for i = 1, #msh, 2 do
            local point = matrix:new({msh[i], msh[i+1], 1})
            local final = matrix.mul(mtx, point)
            verts[i] = final[1][1]
            verts[i+1] = final[2][1]
            love.graphics.circle("fill", final[1][1], final[2][1], 4)
        end

        love.graphics.setColor({1,1,1})
        love.graphics.polygon("line", verts)
    end

    return self
end
return cmesh