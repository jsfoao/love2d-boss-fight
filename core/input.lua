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
    MLeft = 
}
Input = {
    keys = {}
}

function Input.init()
    for k, v in pairs(Key) do
        Input.keys[v] = false
    end
end

function Input.get_key_down(key)
    local c = Input.keys[key] == false and love.keyboard.isDown(key)
    if c == true then
        Input.keys[key] = true
    end
    return c
end

function Input.get_key_up(key)
    local c = Input.keys[key] == true and not love.keyboard.isDown(key)
    if c == true then
        Input.keys[key] = false
    end
    return c
end

function Input.get_key_hold(key)
    return Input.keys[key] == true
end