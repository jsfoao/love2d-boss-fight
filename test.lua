local entity = {}

-- constructor
entity.new = function ()
    local self = {}

    -- public property
    self.public_property = "public"

    -- private property
    local private_property = "private"

    -- public function
    function self.public_function()
        print("inside public function")
    end

    -- private function 
    local function private_function()
        print("inside private function")
    end

    -- virtual
    function self.base_function_1()
        print("inside base function 1")
    end

    function self.base_function_2()
        print("inside base function 2")
    end

    -- abstract
    function self.abstract_function()
        error("abstract function")
    end

    return self
end

entity.static_function = function ()
    print("inside static function")
end

local player = {}
player.new = function()
    local self = entity.new()

    self.health = 100

    -- override
    -- not calling base function
    function self.base_function_1()
        print("inside override function 1")
    end

    local parent_base_function_2 = self.base_function_2
    function self.base_function_2()
        parent_base_function_2()
        print("inside override function 2")
    end

    -- override abstract
    function self.abstract_function()
        print("inside override abstact function")
    end

    function self:damage(dmg)
        self.health = self.health - dmg
    end
    
    function self:log()
        print(self.health)
    end
    return self
end

local function main()
    local player_instance = player.new()
    player_instance.base_function_1()
    player_instance:damage(10)
    player_instance:log()
end

main()