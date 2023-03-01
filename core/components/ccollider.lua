require "core.ecs"
require "core.core"
local component = require("core.ecs.component")

local ccollider = Type_registry.create_component_type("CCollider")
ccollider.new = function ()
    local self = component.new()
    self.type_id = ccollider.type_id
    self.name = "CCollider"
    self.layer = CollisionLayer.world
    self.layer_matrix = {}
    self.ray_layer_matrix = {}
    
    local super_load = self.load
    function self:load()
        super_load(self)
        self:init_layers()
    end

    function self:init_layers()
        for k, v in pairs(CollisionLayer) do
            local col_table = {id = v.id, enable = true, name = v.name}
            table.insert(self.layer_matrix, col_table)
        end
        for k, v in pairs(RayLayer) do
            local ray_table = {id = v.id, enable = true, name = v.name}
            table.insert(self.ray_layer_matrix, ray_table)
        end
    end

    function self:set_layer_enable(layer, enable)
        for k, v in pairs(self.layer_matrix) do
            if v.id == layer.id then
                v.enable = enable
                return
            end
        end
    end

    function self:set_ray_layer_enable(layer, enable)
        for k, v in pairs(self.ray_layer_matrix) do
            if v.id == layer.id then
                v.enable = enable
                return
            end
        end
    end

    function self:has_layer(layer)
        for k, v in pairs(self.layer_matrix) do
            if v.id == layer.id and v.enable == true then
                return true
            end
        end
        return false
    end

    function self:has_ray_layer(layer)
        for k, v in pairs(self.ray_layer_matrix) do
            if v.id == layer.id and v.enable == true then
                return true
            end
        end
        return false
    end

    function self:log_layers()
        print("RayLayer")
        for k, v in pairs(self.ray_layer_matrix) do
            print(string.format("%s (%s): %s", v.name, v.id, v.enable))
        end
    end
    return self
end
return ccollider