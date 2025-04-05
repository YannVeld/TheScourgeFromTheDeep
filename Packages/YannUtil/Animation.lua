
Animation = Class{
    init = function(self, sprites, speed, startFrame, repeatAnim)
        if startFrame == nil then startFrame = 1 end
        if repeatAnim == nil then repeatAnim = true end

        self.sprites = sprites
        self.speed = speed
        self.repeatAnim = repeatAnim

        self:reset(startFrame)
    end,

    setAnimationSpeed = function(self, speed)
        self.speed = speed
    end,

    _updateTime = function(self, dt)
        if self.speed == 0 then
            return
        end

        local duration = #self.sprites / self.speed
        
        self.currentTime = self.currentTime + dt

        if self.repeatAnim then
            self.currentTime = self.currentTime % duration
        else
            if self.currentTime > duration then
                self.currentTime = duration
                self.animationDone = true
            end
        end
    end,

    _updateFrame = function(self)
        if self.speed == 0 then
            return
        end

        self.curFrame = math.floor( self.currentTime * self.speed ) + 1
        if self.curFrame > #self.sprites then
            self.curFrame = #self.sprites
        end
    end,

    reset = function(self, startFrame)
        if not startFrame then startFrame = 1 end

        self.curFrame = startFrame
        if self.speed == 0 then
            self.currentTime = 0
        else
            self.currentTime = (startFrame - 1) / self.speed
        end
        self.animationDone = false
    end,

    update = function(self, dt)
        self:_updateTime(dt)
        self:_updateFrame()
    end,

    draw = function(self, ...)
        local args = {...}
        self.sprites[self.curFrame]:draw(unpack(args))
    end
}