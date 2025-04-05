
PlayerInputManager = Class{

    walkUp = "w",
    walkDown = "s",
    walkLeft = "a",
    walkRight = "d",
    dash = "space",

    init = function(self)
        self.verticalInput = 0
        self.horizontalInput = 0
        self.moveKeyPressed = false
        self.dashPressed = false
    end,

    boolToNumber = function(bool)
        return bool and 1 or 0
    end,

    update = function(self, dt)
        self.verticalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkDown))
                           - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkUp))
        self.horizontalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkRight))
                             - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkLeft))

        self.moveKeyPressed = (self.verticalInput ~= 0) or (self.horizontalInput ~= 0)
    end,

    lateUpdate = function(self, dt)
        self.dashPressed = false
    end,

    keypressed = function(self, key, scancode, isrepeat)
        if key == PlayerInputManager.dash then
            self.dashPressed = true
        end
    end,
}
