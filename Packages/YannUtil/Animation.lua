
Animation = Class{
    init = function(self, sprites, speed, startFrame)
        if not startFrame then startFrame = 1 end

        self.sprites = sprites
        self.speed = speed

        self.curFrame = startFrame
        self.currentTime = (startFrame - 1) / self.speed
    end,

    _updateTime = function(self, dt)
        local duration = #self.sprites / self.speed
        
        self.currentTime = self.currentTime + dt
        self.currentTime = self.currentTime % duration
    end,

    _updateFrame = function(self)
        self.curFrame = math.floor( self.currentTime * self.speed ) + 1
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