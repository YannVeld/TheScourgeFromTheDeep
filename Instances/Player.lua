Instance = require "Packages.YannUtil.Instance"

PlayerIdleState = require"Instances.PlayerStates.PlayerIdleState"
PlayerRunningState = require"Instances.PlayerStates.PlayerRunningState"

local Player = Class{
    __includes = {Instance},

    speedStopCutoff = 1.0,

    init = function(self)
        Instance.init(self)

        self.position = Vector(50.0, 50.0)
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.idleState = PlayerIdleState(self)
        self.runningState = PlayerRunningState(self)

        self.state = self.idleState
    end,

    changeState = function(self)
        local speed = self.velocity:len()
        local isMoving = speed > 0

        local moveKeyPressed = love.keyboard.isDown("w") or love.keyboard.isDown("s") or love.keyboard.isDown("a") or love.keyboard.isDown("d")

        if isMoving or moveKeyPressed then
            return self.runningState
        end

        return self.idleState
    end,

    sign = function(n)
        return n < 0 and -1 or n > 0 and 1 or 0
    end,

    doMovement = function(self, dt)
        local speed = self.velocity:len()
        if speed < self.speedStopCutoff then
            self.velocity = Vector(0,0)
        end

        if math.abs(self.velocity.x) > 0 then
            self.lookDir = Player.sign( self.velocity.x )
        end

        self.position = self.position + self.velocity * dt
    end,

    update = function(self, dt)
        self.state = self:changeState()
        self.state:update(dt) 
        self:doMovement(dt)
    end,

    draw = function(self)
        --local sprWidth = 8
        --local sprHeight = 18
        --love.graphics.setColor(Colors.black)
        --love.graphics.rectangle("line", self.position.x-sprWidth/2, self.position.y-sprHeight/2, 8, 18)
        --love.graphics.setColor(Colors.white)

        self.state:draw()
    end,

}

return Player