require "core.ecs"
local object = require("core.ecs.object")

local world = {}
world.new = function ()
    local self = object.new()
    self.entities = {}
    self.game_mode = nil
    self.fixed_dt = 0.01
    self.curr_fixed_dt = 0

    -- entity queues
    self.to_destroy = {}
    self.to_load = {}
    
    function self:create_entity(entity_type, position)
        assert(Type_registry.is_valid_entity(entity_type))
        local ent = entity_type.new()
        ent.world = self
        ent.transform.position = position
        table.insert(self.to_load, ent)
        return ent
    end

    function self:destroy_entity(ent)
        for i = 1, #self.entities, 1 do
            if ent.id == self.entities[i].id then
                table.insert(self.to_destroy, ent)
            end
        end
    end

    function self:init_game_mode(game_mode_type)
        local _gm = game_mode_type.new()
        _gm.world = self
        self.game_mode = _gm
        return self.game_mode
    end

    function self:load()
        -- entities only get loaded once, either on world load or on their creation
        self.game_mode:load()
    end

    function self:update(dt)
        -- INITIALIZATION
        -- destroy queue
        for i = #self.to_destroy, 1, -1 do
            for j = 1, #self.entities, 1 do
                if self.to_destroy[i].id == self.entities[j].id then
                    table.remove(self.entities, j)
                    goto continue
                end
            end
            ::continue::
            table.remove(self.to_destroy, i)
        end

        -- load queue
        for i = #self.to_load, 1, -1 do
            if self.to_load[i].is_loaded == false then
                table.insert(self.entities, self.to_load[i])
                self.to_load[i]:load()
            end
            table.remove(self.to_load, i)
        end

        -- PHYSICS
        self.curr_fixed_dt = self.curr_fixed_dt + dt
        if self.curr_fixed_dt >= self.fixed_dt then
            self:fixed_update(self.fixed_dt)
            self.curr_fixed_dt = 0
        end

        -- GAME LOGIC
        self.game_mode:update(dt)
        for k, e in pairs(self.entities) do
            if e.enabled == true then
                e:update(dt)
            end
        end
    end

    function self:fixed_update(dt)
        for k, e in pairs(self.entities) do
            if e.enabled == true then
                e:fixed_update(dt)
            end
        end
    end

    function self:draw()
        self.game_mode:draw()
        for k, e in pairs(self.entities) do
            if e.enabled == true then
                e:draw()
            end
        end
    end

    function self:log()
        for k, e in pairs(self.entities) do
            print(e.name)
        end
    end

    return self
end

return world