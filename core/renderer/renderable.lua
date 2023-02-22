local renderable = {}
renderable.new = function ()
    local self = {}
    function self:draw() end
    return self
end

return renderable