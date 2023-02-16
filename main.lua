local function log(msg)
    local message = msg or "default"
    print(message)
end

local function sum(v1, v2)
    local temp = v1 + v2
    return temp
end

local function Pet(name)
    -- private
    local age = 10

    -- public
    return 
    {
        name = name or "default",
        sum = function (v1, v2)
            sum(v1, v2)
        end,
        get_age = function ()
            return age
        end,
        try = function (self)
            log("Hello!")
            local val = self.get_age()
            log(val)
        end
    }
end

function love.load()
    print("Init LoveSandbox")
    local value = sum(1, 2)
    log(value)
    local dog = Pet("Miso")
    log(dog.get_age())
    dog:try()
end

function love.update(dt)
end

function love.draw()
end