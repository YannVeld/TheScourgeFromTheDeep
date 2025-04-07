
Instance = require "Packages.YannUtil.Instance"

local TutorialUIManager = Class{
    __includes = {Instance},

    keyBindsSprite = Sprites.KeyBinds,
    fadeOutTime = 1,

    init = function(self, player)
        Instance.init(self)

        self.player = player
        self.zorder = 999999

        local spriteWidth = TutorialUIManager.keyBindsSprite:getWidth()
        local spriteHeight = TutorialUIManager.keyBindsSprite:getHeight()

        self.keyBindsPos = Vector(Push:getWidth()/2-spriteWidth/2, Push:getHeight()/2-spriteHeight/2)

        -- Tutorial
        self.pressedWalk = false
        self.pressedAttack = false
        self.pressedDash = false
        self.endedTutorial = false
        self.fadeoutTimer = 0
    end,

    checkForKeyPresses = function(self)
        if self.endedTutorial then return end

        if (math.abs(self.player.inputManager.horizontalInput) > 0) or (math.abs(self.player.inputManager.verticalInput) > 0) then
            self.pressedWalk = true
        end
        if self.player.inputManager.attackPressTime > 0 then self.pressedAttack = true end
        if self.player.inputManager.dashPressTime > 0 then self.pressedDash = true end

        if self.pressedWalk and self.pressedAttack and self.pressedDash then
            self.endedTutorial = true
        end
    end,

    update = function(self, dt)
        if self.endedTutorial then
            self.fadeoutTimer = self.fadeoutTimer + dt
        end
        self:checkForKeyPresses()
    end,

    draw = function(self)
        local alpha = 1 - self.fadeoutTimer / TutorialUIManager.fadeOutTime
        alpha = Lume.clamp(alpha, 0, 1)

        local col = Lume.clone(Colors.white)
        col[4] = alpha
        love.graphics.setColor(col)
        TutorialUIManager.keyBindsSprite:draw(self.keyBindsPos.x, self.keyBindsPos.y)
        love.graphics.setColor(Colors.white)
    end,
}

return TutorialUIManager