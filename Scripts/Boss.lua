Instance = require "Packages.YannUtil.Instance"
Enemy = require "Scripts.Enemy"

BossIdleState = require"Scripts.BossStates.BossIdleState"

local Boss = Class{
    __includes = {Enemy},

    health = 64.0,
    speedStopCutoff = 10.0,
    zorderPosOffset = 0,

    shadowRadiusx = 16,
    shadowRadiusy = 8,
    shadowOffsety = 2,

    getHitEffectDuration = 0.3,

    init = function(self, position)
        Enemy.init(self, position, Boss.health)

        self.position = position
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.idleState = BossIdleState(self)

        self.state = self.idleState

        local myColliderRect = Rectangle(Vector(0,0), 32, 8)
        myColliderRect:setPosition(self.position - Vector(16,4))
        self.collider = Collider({myColliderRect}, self.position, "Enemy", self)
        World:add(self.collider)

        self.getHitShader = love.graphics.newShader("Shaders/hitEffect.glsl")
        self.getHitShader:send("frac", 0.0)
    end,

    checkDead = function(self)
        if self.isDead then
            World:remove(self.collider)
            self:destroy()
        end
    end,

    setPosition = function(self, position)
        self.position = position
        self.collider:setPosition(position)
    end,

    changeState = function(self)
        return self.idleState

        --local speed = self.velocity:len()
        --local isMoving = speed > 0
        --local isDashing = (self.state == self.dashingState) and (not self.dashingState.dashEnded)
        --local isAttacking = (self.state == self.attackingState) and (not self.attackingState.attackEnded)

        --if isAttacking then
        --    return self.attackingState
        --end
        --if isDashing then
        --    return self.dashingState
        --end

        --if (not isAttacking) and (not isDashing) then
        --    if self.inputManager.attackPressed and self.attackingState.canAttack then
        --        self.inputManager:resetAttackPress()
        --        return self.attackingState
        --    end

        --    if self.inputManager.dashPressed and self.dashingState.canDash then
        --        self.inputManager:resetDashPress()
        --        return self.dashingState
        --    end
        --end

        --if isMoving or self.inputManager.moveKeyPressed then
        --    return self.runningState
        --end

        --return self.idleState
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
            self.lookDir = Lume.sign( self.velocity.x )
        end

        local moveStep = self.velocity * dt
        local newPos = self:resolveMovementObstructions(moveStep)
        self:setPosition(newPos)
    end,

    update = function(self, dt)
        self:doGetHitEffect()
        Enemy.update(self, dt)

        self:checkDead()

        --self.dashingState:passiveUpdate(dt)
        --self.attackingState:passiveUpdate(dt)

        local newState = self:changeState()
        if newState ~= self.state then
            self.state:exit()
            self.state = newState
            self.state:enter()
        end

        self.state:update(dt) 
        self:doMovement(dt)

        self.zorder = self.position.y + Boss.zorderPosOffset
    end,

    drawShadow = function(self)
        love.graphics.setColor(68/255,56/255,70/255,1)
        love.graphics.ellipse('fill', self.position.x, self.position.y + Boss.shadowOffsety, Boss.shadowRadiusx, Boss.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    doGetHitEffect = function(self)
        local frac = 1.0 - (self.time - self.damagedTime) / Boss.getHitEffectDuration

        if (frac >= 0.0) and (frac <= 1.0) then
            self.getHitShader:send("frac", frac)
        end
    end,

    draw = function(self)
        self:drawShadow()

        love.graphics.setShader(self.getHitShader)
        self.state:draw()
        love.graphics.setShader()

        love.graphics.setColor(Colors.white)
        love.graphics.print(self.health, 5, 5)
        love.graphics.setColor(Colors.white)

        --love.graphics.setColor(Colors.red)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
    end,
}

return Boss