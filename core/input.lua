local vector2 = require("core.vector2")
Key = {
    A = 'a',
    B = 'b',
    C = 'c',
    D = 'd',
    E = 'e',
    F = 'f',
    G = 'g',
    H = 'h',
    I = 'i',
    J = 'j',
    K = 'k',
    L = 'l',
    M = 'm',
    N = 'n',
    O = 'o',
    P = 'p',
    Q = 'q',
    R = 'r',
    S = 's',
    T = 't',
    U = 'u',
    V = 'v',
    W = 'w',
    X = 'x',
    Y = 'y',
    Z = 'z',
    _0 = '0',
    _1 = '1',
    _2 = '2',
    _3 = '3',
    _4 = '4',
    _5 = '5',
    _6 = '6',
    _7 = '7',
    _8 = '8',
    _9 = '9',
    Up = 'up',
    Right = 'right',
    Down = 'down',
    Left = 'left',
    Space = 'space'
}

Mouse = {
    Left = 1,
    Right = 2,
    Middle = 3
}

State = {
    none = 0,
    down = 1,
    hold = 2,
    up = 3
}

Input = {
    keys = {},
    key_state = {},
    mouse = {},
    mouse_state = {}
}

function Input.init()
    -- init keyboard keys
    for k, v in pairs(Key) do
        Input.keys[v] = false
        Input.key_state[v] = State.none
    end

    -- init mouse keys
    for k, v in pairs(Mouse) do
        Input.mouse[v] = false
        Input.mouse_state[v] = State.none
    end
end

function Input.update()
    -- iterate keyboard 
    for k, v in pairs(Key) do
        if love.keyboard.isDown(v) == true then
            -- key down
            if Input.keys[v] == false then
                Input.keys[v] = true
                Input.key_state[v] = State.down
            -- key hold
            elseif Input.keys[v] == true then
                Input.keys[v] = true
                Input.key_state[v] = State.hold
            end
        --key up
        elseif love.keyboard.isDown(v) == false and Input.keys[v] == true then
            Input.keys[v] = false
            Input.key_state[v] = State.up
        -- key none
        elseif love.keyboard.isDown(v) == false and Input.keys[v] == false then
            Input.key_state[v] = State.none
        end
    end

    -- iterate mouse
    for k, v in pairs(Mouse) do
        if love.mouse.isDown(v) == true then
            -- key down
            if Input.mouse[v] == false then
                Input.mouse[v] = true
                Input.mouse_state[v] = State.down
            -- key hold
            elseif Input.mouse[v] == true then
                Input.mouse[v] = true
                Input.mouse_state[v] = State.hold
            end
        --key up
        elseif love.mouse.isDown(v) == false and Input.mouse[v] == true then
            Input.mouse[v] = false
            Input.mouse_state[v] = State.up
        -- key none
        elseif love.mouse.isDown(v) == false and Input.mouse[v] == false then
            Input.mouse_state[v] = State.none
        end
    end
end

function Input.get_key_down(key)
    return Input.key_state[key] == State.down
end

function Input.get_key_up(key)
    return Input.key_state[key] == State.up
end

function Input.get_key_hold(key)
    return Input.key_state[key] == State.hold
end

function Input.get_mouse_down(key)
    return Input.mouse_state[key] == State.down
end

function Input.get_mouse_up(key)
    return Input.mouse_state[key] == State.up
end

function Input.get_mouse_hold(key)
    return Input.mouse_state[key] == State.hold
end

function Input.get_mouse_world()
    if Camera.view_mtx == nil then
        return vector2.zero
    end

    local screen_mouse_pos = vector2.new(
        love.mouse.getX() - love.graphics.getWidth() / 2,
        love.mouse.getY() - love.graphics.getHeight() / 2
    )

    local world_mouse_pos = Camera:screen_to_world(screen_mouse_pos)
    return world_mouse_pos
end