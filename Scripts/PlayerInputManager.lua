
PlayerInputManager = Class{

    walkUp = {"w","up"},
    walkDown = {"s","down"},
    walkLeft = {"a","left"},
    walkRight = {"d","right"},
    dash_keyboard = {"lshift", "rshift", "lctrl", "rctrl"},
    dash_mouse = 2,
    attack_keyboard = {"space"}, 
    attack_mouse = 1, 

    registerTime = 0.5,

    init = function(self)
        self.time = 0

        self.verticalInput = 0
        self.horizontalInput = 0
        self.moveKeyPressed = false

        self.dashPressed = false
        self.dashPressTime = -1

        self.attackPressed = false
        self.attackPressTime = -1
    end,

    boolToNumber = function(bool)
        return bool and 1 or 0
    end,

    isKeyListDown = function(keys)
        local pressed
        for ii,key in pairs(keys) do
            pressed = love.keyboard.isDown(key)
            if pressed then return true end
        end
        return false 
    end,

    update = function(self, dt)
        self.time = self.time + dt

        self.verticalInput = PlayerInputManager.boolToNumber(PlayerInputManager.isKeyListDown(PlayerInputManager.walkDown))
                           - PlayerInputManager.boolToNumber(PlayerInputManager.isKeyListDown(PlayerInputManager.walkUp))
        self.horizontalInput = PlayerInputManager.boolToNumber(PlayerInputManager.isKeyListDown(PlayerInputManager.walkRight))
                             - PlayerInputManager.boolToNumber(PlayerInputManager.isKeyListDown(PlayerInputManager.walkLeft))

        self.moveKeyPressed = (self.verticalInput ~= 0) or (self.horizontalInput ~= 0)
    end,

    lateUpdate = function(self, dt)
        if self.time - self.dashPressTime > PlayerInputManager.registerTime then
            self.dashPressed = false
        end
        if self.time - self.attackPressTime > PlayerInputManager.registerTime then
            self.attackPressed = false
        end
    end,

    keypressed = function(self, key, scancode, isrepeat)
        if Lume.find(PlayerInputManager.dash_keyboard, key) then
            self.dashPressed = true
            self.dashPressTime = self.time
        end
        if Lume.find(PlayerInputManager.attack_keyboard, key) then
            self.attackPressed = true
            self.attackPressTime = self.time
        end
    end,

    mousepressed = function(self, x, y, button, istouch, presses)
        if button == PlayerInputManager.dash_mouse then
            self.dashPressed = true
            self.dashPressTime = self.time
        end
        if button == PlayerInputManager.attack_mouse then
            self.attackPressed = true
            self.attackPressTime = self.time
        end
    end,

    resetDashPress = function(self) self.dashPressed = false end,
    resetAttackPress = function(self) self.attackPressed = false end,
}
