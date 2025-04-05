
PlayerInputManager = Class{

    walkUp = "w",
    walkDown = "s",
    walkLeft = "a",
    walkRight = "d",

    init = function(self)
        self.verticalInput = 0
        self.horizontalInput = 0
    end,

    boolToNumber = function(bool)
        return bool and 1 or 0
    end,

    update = function(self, dt)
        self.verticalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkDown))
                           - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkUp))
        self.horizontalInput = PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkRight))
                             - PlayerInputManager.boolToNumber(love.keyboard.isDown(PlayerInputManager.walkLeft))
    end,
}
