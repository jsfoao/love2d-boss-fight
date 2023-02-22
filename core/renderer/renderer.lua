local renderer = {}
renderer.new = function ()
    local self = {}
    self.queue = {}

    function self:submit(renderable)
        self.queue[#self.queue+1] = renderable
    end

    function self:flush()
        if #self.queue == 0 then
            return
        end
        for k, r in pairs(self.queue) do
            r:draw()
            table.remove(self.queue, k)
        end
    end
    return self
end

return renderer