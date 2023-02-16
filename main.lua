local function log(msg)
    local message = msg or "default"
    print(message)
end

local function sum(v1, v2)
    local temp = v1 + v2
    return temp
end

function love.load()
    print("Init LoveSandbox")
    local value = sum(1, 2)
    log(value)
end

function love.update(dt)

end

function love.draw()
end