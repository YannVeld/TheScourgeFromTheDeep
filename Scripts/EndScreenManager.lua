
Instance = require "Packages.YannUtil.Instance"

local EndScreenManager = Class{
    __includes = {Instance},

    fadeTime = 2,
    backgroundColor = {34/255,29/255,37/255,1},
    textColor = {176/255,169/255,135/255,1},

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
        local texty = 10 --Push:getHeight() / 2

        local backgroundColor = Lume.clone(EndScreenManager.backgroundColor)
        backgroundColor[4] = self.alpha
        local textColor = Lume.clone(EndScreenManager.textColor)
        textColor[4] = self.alpha

        -- Background
        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", -20, -20, Push:getWidth()+40, Push:getHeight()+40) 

        -- Message to player
        love.graphics.setColor(textColor)
        local lines
        if self.win then
            lines = {"You win!", "Thank you for playing!", "", "", "Press R to restart", "Press esc. to quit"}
        else
            lines = {"You are dead!", "", "", "", "Press R to restart", "Press esc. to quit"}
        end
       
        for ii,str in pairs(lines) do
            local strWidth = font:getWidth(str)
            love.graphics.print(str, Push:getWidth()/2 - strWidth/2, texty + ii*10)
        end
    
        -- Game time
        local time = self.getTimeInMinutes(self.endTime)
        local mins = time[1]
        local secs = time[2]

        str = "Fight duration: "..mins.." mins. and "..secs.." secs."
        strWidth = font:getWidth(str)

        love.graphics.print(str, Push:getWidth()/2 - strWidth/2, Push:getHeight() - 30)

        love.graphics.setColor(Colors.white)
    
    end,
}

return EndScreenManager