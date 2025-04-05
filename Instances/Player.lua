Instance = require "Packages.YannUtil.Instance"

require"Instances.PlayerInputManager"

PlayerIdleState = require"Instances.PlayerStates.PlayerIdleState"
PlayerRunningState = require"Instances.PlayerStates.PlayerRunningState"
PlayerDashingState = require"Instances.PlayerStates.PlayerDashingState"

local Player = Class{
    __includes = {Instance},

    speedStopCutoff = 10.0,

    init = function(self)
        Instance.init(self)

        self.position = Vector(50.0, 50.0)
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.inputManager = PlayerInputManager()

        self.idleState = PlayerIdleState(self)
        self.runningState = PlayerRunningState(self)
        self.dashingState = PlayerDashingState(self)

        self.state = self.idleState
    end,

    changeState = function(self)
        local speed = self.velocity:len()
        local isMoving = speed > 0
        local isDashing = (self.state == self.dashingState) and (not self.dashingState.dashEnded)

        if isDashing then
            return self.dashingState
        else
            if self.inputManager.dashPressed and self.dashingState.canDash then
                return self.dashingState
            end
        end

        if isMoving or self.inputManager.moveKeyPressed then
            return self.runningState
        end

        return self.idleState
    end,

    sign = function(n)
        return n < 0 and -1 or n > 0 and 1 or 0
    end,

    doMovement = function(self, dt)
        if math.abs( self.velocity.x ) < self.speedStopCutoff then
            self.velocity.x = 0.0
        end
        if math.abs( self.velocity.y ) < self.speedStopCutoff then
            self.velocity.y = 0.0
        end

        if math.abs(self.velocity.x) > 0 then
            self.lookDir = Player.sign( self.velocity.x )
        end

        self.position = self.position + self.velocity * dt
    end,

    update = function(self, dt)
        self.inputManager:update(dt)
        self.dashingState:passiveUpdate(dt)

        local newState = self:changeState()
        if newState ~= self.state then
            self.state:exit()
            self.state = newState
            self.state:enter()
        end

        self.state:update(dt) 
        self:doMovement(dt)

        self.inputManager:lateUpdate(dt)
    end,

    draw = function(self)
        --local sprWidth = 8
        --local sprHeight = 18
        --love.graphics.setColor(Colors.black)
        --love.graphics.rectangle("line", self.position.x-sprWidth/2, self.position.y-sprHeight/2, 8, 18)
        --love.graphics.setColor(Colors.white)

        self.state:draw()
    end,

    keypressed = function(self, key, scancode, isrepeat)
        self.inputManager:keypressed(key, scancode, isrepeat)
    end,
}

return Player