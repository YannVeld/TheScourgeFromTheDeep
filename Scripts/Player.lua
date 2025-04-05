Instance = require "Packages.YannUtil.Instance"

require"Scripts.PlayerInputManager"

PlayerIdleState = require"Scripts.PlayerStates.PlayerIdleState"
PlayerRunningState = require"Scripts.PlayerStates.PlayerRunningState"
PlayerDashingState = require"Scripts.PlayerStates.PlayerDashingState"
PlayerAttackingState = require"Scripts.PlayerStates.PlayerAttackingState"

local Player = Class{
    __includes = {Instance},

    speedStopCutoff = 10.0,
    zorderPosOffset = 6,

    init = function(self)
        Instance.init(self)

        self.position = Vector(50.0, 50.0)
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.inputManager = PlayerInputManager()

        self.idleState = PlayerIdleState(self)
        self.runningState = PlayerRunningState(self)
        self.dashingState = PlayerDashingState(self)
        self.attackingState = PlayerAttackingState(self)

        self.state = self.idleState

        local myColliderRect = Rectangle(Vector(0,0), 8, 4)
        myColliderRect:setPosition(self.position - Vector(4,-6))
        self.collider = Collider({myColliderRect}, self.position, "Player")
        World:add(self.collider)
    end,

    setPosition = function(self, position)
        self.position = position
        self.collider:setPosition(position)
    end,

    changeState = function(self)
        local speed = self.velocity:len()
        local isMoving = speed > 0
        local isDashing = (self.state == self.dashingState) and (not self.dashingState.dashEnded)
        local isAttacking = (self.state == self.attackingState) and (not self.attackingState.attackEnded)

        if isAttacking then
            return self.attackingState
        end
        if isDashing then
            return self.dashingState
        end

        if (not isAttacking) and (not isDashing) then
            if self.inputManager.attackPressed and self.attackingState.canAttack then
                self.inputManager:resetAttackPress()
                return self.attackingState
            end

            if self.inputManager.dashPressed and self.dashingState.canDash then
                self.inputManager:resetDashPress()
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

    resolveMovementObstructions = function(self, moveStep)
        -- Diagonal
        local tryPos = self.position:clone() + moveStep
        self.collider:setPosition(tryPos)
        local colliding = World:checkCollision(self.collider)
        if not colliding then
            return tryPos
        end

        -- Try along x
        tryPos = self.position:clone()
        tryPos.x = tryPos.x + moveStep.x
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider)
        if not colliding then
            return tryPos
        end
        
        -- Try along y
        tryPos = self.position:clone()
        tryPos.y = tryPos.y + moveStep.y
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider)
        if not colliding then
            return tryPos
        end

        return self.position
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

        local moveStep = self.velocity * dt
        local newPos = self:resolveMovementObstructions(moveStep)
        self:setPosition(newPos)
    end,

    update = function(self, dt)
        self.inputManager:update(dt)
        self.dashingState:passiveUpdate(dt)
        self.attackingState:passiveUpdate(dt)

        local newState = self:changeState()
        if newState ~= self.state then
            self.state:exit()
            self.state = newState
            self.state:enter()
        end

        self.state:update(dt) 
        self:doMovement(dt)

        self.inputManager:lateUpdate(dt)

        self.zorder = self.position.y + Player.zorderPosOffset
    end,

    draw = function(self)
        self.state:draw()

        --love.graphics.setColor(Colors.blue)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
    end,

    keypressed = function(self, key, scancode, isrepeat)
        self.inputManager:keypressed(key, scancode, isrepeat)
    end,
    mousepressed = function(self, x, y, button, istouch, presses)
        self.inputManager:mousepressed(x, y, button, istouch, presses)
    end,
}

return Player