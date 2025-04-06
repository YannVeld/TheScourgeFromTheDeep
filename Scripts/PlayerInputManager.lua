
PlayerInputManager = Class{

    walkUp = "w",
    walkDown = "s",
    walkLeft = "a",
    walkRight = "d",
    dash_keyboard = "lshift",
    dash_mouse = 2,
    attack_keyboard = "space", 
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

    update = function(self, dt)
        self.time = self.time + dt

        self.verticalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkDown))
                           - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkUp))
        self.horizontalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkRight))
                             - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkLeft))

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
        if key == PlayerInputManager.dash_keyboard then
            self.dashPressed = true
            self.dashPressTime = self.time
        end
        if key == PlayerInputManager.attack_keyboard then
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
