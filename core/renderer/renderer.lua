local renderer = {}
renderer.new = function ()
    local self = {}
    self.world_queue = {}
    self.world_layer_count = {}
    self.screen_queue = {}
    self.layers = 5

    function self:load()
        love.graphics.setBackgroundColor({0.1,0.1,0.1})

        -- initiate render z depth layers
        for i = 1, self.layers+1, 1 do
            self.world_queue[i] = {}
            self.world_layer_count[i] = 0
        end

        for i = 1, self.layers+1, 1 do
            self.screen_queue[i] = {}
        end
    end
    
    function self:submit(rend)
        if rend.space == WORLD_SPACE then
            table.insert(self.world_queue[rend.z+1], rend)
        elseif rend.space == SCREEN_SPACE then
            table.insert(self.screen_queue[rend.z+1], rend)
        end
    end

    function self:flush()
        if #self.world_queue == 0 and #self.screen_queue == 0 then
            return
        end
        
        -- draw world renderables
        for i = 1, self.layers+1, 1 do
            for j = #self.world_queue[i], 1, -1 do
                self.world_queue[i][j]:render()
                table.remove(self.world_queue[i], j)
            end
        end

        -- draw screen renderables
        for i = 1, self.layers+1, 1 do
            for j = #self.screen_queue[i], 1, -1 do
                self.world_queue[i][j]:render()
                table.remove(self.screen_queue[i], j)
            end
        end
    end
    return self
end

return renderer