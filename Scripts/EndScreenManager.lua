
Instance = require "Packages.YannUtil.Instance"

local EndScreenManager = Class{
    __includes = {Instance},

    fadeTime = 2,

    init = function(self, player, boss)
        Instance.init(self)

        self.zorder = 99999999

        self.gameTime = 0.0
        self.alpha = 0.0

        self.win = false
        self.endTime = -1.0
    end,

    getAlpha = function(self)
        if self.endTime < 0 then 
            self.alpha = 0.0 
            return
        end

        self.alpha = (self.gameTime - self.endTime) / EndScreenManager.fadeTime
        self.alpha = Lume.clamp(self.alpha, 0, 1)
    end,

    update = function(self, dt)
        self.gameTime = self.gameTime + dt

        self:getAlpha()
    end,

    showEndScreen = function(self, win)
        if self.endTime > 0.0 then return end

        self.win = win
        self.endTime = self.gameTime
    end,

    draw = function(self)
        local textx = Push:getWidth() / 2
        local texty = Push:getHeight() / 2

        local backgroundColor = Lume.clone(Colors.black)
        backgroundColor[4] = self.alpha
        local textColor = Lume.clone(Colors.white)
        textColor[4] = self.alpha

        love.graphics.setColor(backgroundColor)

        love.graphics.rectangle("fill", -20, -20, Push:getWidth()+40, Push:getHeight()+40) 

        love.graphics.setColor(textColor)
        if self.win then
            love.graphics.print("You Win!", textx, texty)
        else
            love.graphics.print("You Lose!\n Press R to restart", textx, texty)
        end

        love.graphics.setColor(Colors.white)
    
    end,
}

return EndScreenManager