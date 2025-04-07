
Instance = require "Packages.YannUtil.Instance"

local SceneTransitionManager = Class{
    __includes = {Instance},

    fadeTime = 0.5,
    backgroundColor = {34/255,29/255,37/255,1},

    init = function(self)
        Instance.init(self)

        self.inTransition = true
        self.fadeTimer = 0

        self.fadeMode = "in"
    end,

    DoFadeIn = function(self)
        self.fadeMode = "in"
        
        if self.fadeTimer < SceneTransitionManager.fadeTime then
            self.inTransition = true
        end
    end,

    DoFadeOut = function(self)
        self.fadeMode = "out"

        if self.fadeTimer > 0.0 then
            self.inTransition = true
        end
    end,

    getAlpha = function(self)
        local alpha = 1 - self.fadeTimer / SceneTransitionManager.fadeTime
        alpha = Lume.clamp(alpha, 0, 1)
        return alpha
    end,

    updateTimer = function(self, dt)
        if self.fadeMode == "in" then
            self.fadeTimer = self.fadeTimer + dt
            if self.fadeTimer >= SceneTransitionManager.fadeTime then
                self.inTransition = false
            end
        else
            self.fadeTimer = self.fadeTimer - dt
            if self.fadeTimer <= 0.0 then
                self.inTransition = false
            end
        end

        self.fadeTimer = Lume.clamp(self.fadeTimer, 0, SceneTransitionManager.fadeTime)
    end,

    update = function(self, dt)
        self:updateTimer(dt)
    end,


    drawUI = function(self)
        local alpha = self:getAlpha()
        local backgroundColor = Lume.clone(SceneTransitionManager.backgroundColor)
        backgroundColor[4] = alpha

        love.graphics.setColor(backgroundColor)
        love.graphics.rectangle("fill", -20, -20, Push:getWidth()+40, Push:getHeight()+40) 
        love.graphics.setColor(Colors.white)
    end,
}

return SceneTransitionManager