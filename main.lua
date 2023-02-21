local vector2 = require("core.vector2")
local world = require("core.ecs.world")
local player = require("game.scripts.player")

local function main()
    local _world = world.new()
    -- local _player = _world.create_entity(player, vector2.new(10,10))
    -- print(_player.transform.postition)
end

main()
-- function love.load()
-- end

-- function love.update(dt)
-- end

-- function love.draw()
-- end