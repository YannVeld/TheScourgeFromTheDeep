Instance = require "Packages.YannUtil.Instance"

require"Scripts.PlayerInputManager"

PlayerIdleState = require"Scripts.PlayerStates.PlayerIdleState"
PlayerRunningState = require"Scripts.PlayerStates.PlayerRunningState"
PlayerDashingState = require"Scripts.PlayerStates.PlayerDashingState"
PlayerAttackingState = require"Scripts.PlayerStates.PlayerAttackingState"
PlayerKnockbackState = require"Scripts.PlayerStates.PlayerKnockbackState"

local Player = Class{
    __includes = {Instance},

    health = 100,

    speedStopCutoff = 10.0,
    zorderPosOffset = 6,

    shadowRadiusx = 8,
    shadowRadiusy = 3,
    shadowOffsety = 9,

    getHitEffectDuration = 0.3,
    getHitShakeMagnitude = 2,

    init = function(self, position)
        Instance.init(self)

        self.health = Player.health
        self.isDead = false

        self.position = position
        self.velocity = Vector(0.0, 0.0)
        self.lookDir = 1

        self.inputManager = PlayerInputManager()

        self.idleState = PlayerIdleState(self)
        self.runningState = PlayerRunningState(self)
        self.dashingState = PlayerDashingState(self)
        self.attackingState = PlayerAttackingState(self)
        self.knockbackState = PlayerKnockbackState(self)

        self.state = self.idleState

        local myColliderRect = Rectangle(Vector(0,0), 8, 4)
        myColliderRect:setPosition(self.position - Vector(4,-6))
        self.collider = Collider({myColliderRect}, self.position, "PlayerCollider", self)
        World:add(self.collider)

        local myHitBoxRect = Rectangle(self.position:clone() - Vector(3,7), 6, 14)
        self.hitbox = Collider({myHitBoxRect}, self.position, "Player", self)
        World:add(self.hitbox)

        self.getHitShader = love.graphics.newShader("Shaders/hitEffect.glsl")
        self.getHitShader:send("frac", 0.0)

        self.collisionTypes = {"Enemy", "GameEdge"}

        self.damagedTime = -10
        self.time = 0

        -- Sounds
        self.hurtSound = love.audio.newSource("Sounds/HurtPlayer.wav", "static")
        self.hurtSound:setVolume(SoundsVolume)
        self.swordSound = love.audio.newSource("Sounds/SwordSwing.wav", "static")
        self.swordSound:setVolume(SoundsVolume + 2)
        self.dashSound = love.audio.newSource("Sounds/Dash.wav", "static")
        self.dashSound:setVolume(SoundsVolume + 2)
    end,

    setPosition = function(self, position)
        self.position = position
        self.collider:setPosition(position)
        self.hitbox:setPosition(position)
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
        local isKnocked = (self.state == self.knockbackState) and self.knockbackState.isMoving
        if isKnocked then return self.knockbackState end

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
            self.lookDir = Player.sign( self.velocity.x )
        end

        local moveStep = self.velocity * dt
        local newPos = self:resolveMovementObstructions(moveStep)
        self:setPosition(newPos)
    end,

    checkDead = function(self)
        if self.isDead then
            World:remove(self.collider)
            self:destroy()
        end
    end,

    TakeDamage = function(self, amount)
        self.health = self.health - amount
        self.damagedTime = self.time

        if self.health <= 0 then
            self.health = 0
            self.isDead = true
        end
    end,

    DoDamage = function(self, amount, origin, knockback)
        if knockback == nil then knockback = 0 end

        -- Dont get hit when dashing or being knocked back
        if self.state == self.dashingState then return end
        if self.state == self.knockbackState then return end

        -- Knockback
        local vecFromOrigin = origin - self.position
        self.velocity = self.velocity - vecFromOrigin:normalized() * knockback
        self:changeState(self.knockbackState)

        -- Screen shake
        Shack:setShake(Player.getHitShakeMagnitude)

        -- Sound
        self.hurtSound:setPitch(love.math.random(0.98, 1.02))
        self.hurtSound:play()

        -- For damaged shader
        self:TakeDamage(amount)
    end,

    update = function(self, dt)
        self.time = self.time + dt
        self:doGetHitEffect()
        self:checkDead()

        self.inputManager:update(dt)
        self.dashingState:passiveUpdate(dt)
        self.attackingState:passiveUpdate(dt)

        local newState = self:getState()
        self:changeState(newState)

        self.state:update(dt) 
        self:doMovement(dt)

        self.inputManager:lateUpdate(dt)

        self.zorder = self.position.y + Player.zorderPosOffset
    end,

    drawShadow = function(self)
        --love.graphics.setColor(68/255,56/255,70/255,1)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.ellipse('fill', self.position.x, self.position.y + Player.shadowOffsety, Player.shadowRadiusx, Player.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    doGetHitEffect = function(self)
        local frac = 1.0 - (self.time - self.damagedTime) / Player.getHitEffectDuration
        if frac < 0.0 then frac = 0.0 end
        if frac > 1.0 then frac = 1.0 end

        self.getHitShader:send("frac", frac)
    end,

    draw = function(self)
        self:drawShadow()
        
        love.graphics.setShader(self.getHitShader)
        self.state:draw()
        love.graphics.setShader()

        --love.graphics.setColor(Colors.blue)
        ----self.collider:draw()
        --self.hitbox:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
    end,

    keypressed = function(self, key, scancode, isrepeat)
        self.inputManager:keypressed(key, scancode, isrepeat)
    end,
    mousepressed = function(self, x, y, button, istouch, presses)
        self.inputManager:mousepressed(x, y, button, istouch, presses)
    end,
}

return Player