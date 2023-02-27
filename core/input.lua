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

State = {
    none = 0,
    down = 1,
    hold = 2,
    up = 3
}

Input = {
    keys = {},
    state = {}
}

function Input.init()
    for k, v in pairs(Key) do
        Input.keys[v] = false
        Input.state[v] = State.none
    end
end

function Input.update()
    for k, v in pairs(Key) do
        if love.keyboard.isDown(v) == true then
            -- key down
            if Input.keys[v] == false then
                Input.keys[v] = true
                Input.state[v] = State.down
            -- key hold
            elseif Input.keys[v] == true then
                Input.keys[v] = true
                Input.state[v] = State.hold
            end
        --key up
        elseif love.keyboard.isDown(v) == false and Input.keys[v] == true then
            Input.keys[v] = false
            Input.state[v] = State.up
        -- key none
        elseif love.keyboard.isDown(v) == false and Input.keys[v] == false then
            Input.state[v] = State.none
        end
    end
end

function Input.get_key_down(key)
    return Input.state[key] == State.down
end

function Input.get_key_up(key)
    return Input.state[key] == State.up
end

function Input.get_key_hold(key)
    return Input.state[key] == State.hold
end