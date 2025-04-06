
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

        Shack:setShake(0)
        self.win = win
        self.endTime = self.gameTime
    end,

    getTimeInMinutes = function(time)
        local mins = math.floor(time / 60)
        local secs = time - mins * 60

        secs = math.floor(secs)
        return {mins, secs}
    end,

    drawUI = function(self)
        local font = love.graphics.getFont()
        local texty = Push:getHeight() / 2 - 50

        local backgroundColor = Lume.clone(Colors.black)
        backgroundColor[4] = self.alpha
        local textColor = Lume.clone(Colors.white)
        textColor[4] = self.alpha

        -- Background
        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", -20, -20, Push:getWidth()+40, Push:getHeight()+40) 

        -- Message to player
        love.graphics.setColor(textColor)
        local lines
        if self.win then
            lines = {"You Win!", "Thank you for playing!", "", "Press R to restart"}
        else
            lines = {"You are dead!", "", "", "Press R to restart"}
        end
       
        for ii,str in pairs(lines) do
            local strWidth = font:getWidth(str)
            love.graphics.print(str, Push:getWidth()/2 - strWidth/2, texty + ii*10)
        end
    
        -- Game time
        local time = self.getTimeInMinutes(self.endTime)
        local mins = time[1]
        local secs = time[2]

        str = "Game Time: "..mins.." mins. and "..secs.." secs."
        strWidth = font:getWidth(str)

        love.graphics.print(str, Push:getWidth()/2 - strWidth/2, Push:getHeight() - 30)

        love.graphics.setColor(Colors.white)
    
    end,
}

return EndScreenManager