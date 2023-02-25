local renderer = {}
renderer.new = function ()
    local self = {}
    self.world_queue = {}
    self.screen_queue = {}
    self.layers = 5

    function self:load()
        love.graphics.setBackgroundColor({0.1,0.1,0.1})

        -- initiate render z depth layers
        for i = 1, self.layers, 1 do
            self.world_queue[i] = {}
        end

        for i = 1, self.layers, 1 do
            self.screen_queue[i] = {}
        end
    end
    
    function self:submit(rend)
        if rend.space == WORLD_SPACE then
            self.world_queue[rend.z+1][#self.world_queue+1] = rend
        elseif rend.space == SCREEN_SPACE then
            self.screen_queue[rend.z+1][#self.screen_queue+1] = rend
        end
    end

    function self:flush()
        if #self.world_queue == 0 and #self.screen_queue == 0 then
            return
        end
        
        -- draw world renderables
        for i = 1, self.layers, 1 do
            for k, r in pairs(self.world_queue[i]) do
                r:draw()
                table.remove(self.world_queue[i], k)
            end
        end

        -- draw screen renderables on top
        for i = 1, self.layers, 1 do
            for k, r in pairs(self.screen_queue[i]) do
                r:draw()
                table.remove(self.screen_queue[i], k)
            end
        end
    end
    return self
end

return renderer