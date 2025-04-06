Instance = require "Packages.YannUtil.Instance"
Enemy = require "Scripts.Enemy"

BossAI = require "Scripts.BossAI"

BossIdleState = require"Scripts.BossStates.BossIdleState"
BossWalkingState = require"Scripts.BossStates.BossWalkingState"
BossFireSwordState = require"Scripts.BossStates.BossFireSwordState"
BossFireBreathState = require"Scripts.BossStates.BossFireBreathState"

local Boss = Class{
    __includes = {Enemy},

    health = 64.0,
    speedStopCutoff = 10.0,
    zorderPosOffset = 0,

    startWalkDistance = 10,

    shadowRadiusx = 22,
    shadowRadiusy = 6,
    shadowOffsety = 2,

    getHitEffectDuration = 0.3,

    init = function(self, position, playerInstance)
        Enemy.init(self, position, Boss.health)
        self.player = playerInstance

        self.position = position
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.targetPosition = self.position

        self.idleState = BossIdleState(self)
        self.walkingState = BossWalkingState(self)
        self.fireSwordState = BossFireSwordState(self)
        self.fireBreathState = BossFireBreathState(self)

        self.timeUntilDecision = 0

        self.state = self.idleState
        self.AI = BossAI(self, self.player)

        local myColliderRect = Rectangle(Vector(0,0), 32, 8)
        myColliderRect:setPosition(self.position - Vector(16,4))
        self.collider = Collider({myColliderRect}, self.position, "Enemy", self)
        World:add(self.collider)

        self.getHitShader = love.graphics.newShader("Shaders/hitEffect.glsl")
        self.getHitShader:send("frac", 0.0)

        self.collisionTypes = {"BossGameEdge", "PlayerCollider"}
    end,

    DoDamage = function(self, amount, origin, knockback)
        self:TakeDamage(amount)
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

    changeState = function(self, newState)
        if newState == self.state then
            return false
        end

        self.state:exit()
        self.state = newState
        self.state:enter()
        return true
    end,

    getState = function(self)
        local isFireSword = (self.state == self.fireSwordState) and (not self.fireSwordState.attackEnded)
        if isFireSword then return self.fireSwordState end

        local isFireBreath = (self.state == self.fireBreathState) and (not self.fireBreathState.attackEnded)
        if isFireBreath then return self.fireBreathState end

        return self.AI.requestedState
    end,

    resolveMovementObstructions = function(self, moveStep)
        -- Diagonal
        local tryPos = self.position:clone() + moveStep
        self.collider:setPosition(tryPos)
        local colliding = World:checkCollision(self.collider, self.collisionTypes)
        if not colliding then
            return tryPos
        end

        -- Try along x
        tryPos = self.position:clone()
        tryPos.x = tryPos.x + moveStep.x
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider, self.collisionTypes)
        if not colliding then
            return tryPos
        end
        
        -- Try along y
        tryPos = self.position:clone()
        tryPos.y = tryPos.y + moveStep.y
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider, self.collisionTypes)
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

        self.walkingState:passiveUpdate(dt)
        self.fireSwordState:passiveUpdate(dt)
        self.fireBreathState:passiveUpdate(dt)

        self.AI:update(dt)

        local newState = self:getState()
        self:changeState(newState)

        self.state:update(dt) 
        self:doMovement(dt)

        self.zorder = self.position.y + Boss.zorderPosOffset
    end,

    drawShadow = function(self)
        --love.graphics.setColor(68/255,56/255,70/255,1.0)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.ellipse('fill', self.position.x, self.position.y + Boss.shadowOffsety, Boss.shadowRadiusx, Boss.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    doGetHitEffect = function(self)
        local frac = 1.0 - (self.time - self.damagedTime) / Boss.getHitEffectDuration
        if frac < 0.0 then frac = 0.0 end
        if frac > 1.0 then frac = 1.0 end

        self.getHitShader:send("frac", frac)
    end,

    draw = function(self)
        self:drawShadow()

        love.graphics.setShader(self.getHitShader)
        self.state:draw()
        love.graphics.setShader()

        love.graphics.setColor(Colors.red)
        love.graphics.print(self.health, 5, 5)
        love.graphics.setColor(Colors.white)

        --love.graphics.setColor(Colors.red)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
        
        --love.graphics.setColor(Colors.red)
        --love.graphics.ellipse("fill", self.targetPosition.x, self.targetPosition.y, 5, 5)
        --love.graphics.setColor(Colors.white)
    end,
}

return Boss