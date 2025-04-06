Instance = require "Packages.YannUtil.Instance"
Enemy = require "Scripts.Enemy"

local Barrel = Class{
    __includes = {Enemy},

    health = 12.0,
    spriteSheet = Sprites.Barrel,
    animSpeed = 10,

    speedStopCutoff = 1.0,
    friction = 500,

    shadowRadiusx = 8,
    shadowRadiusy = 4,
    shadowOffsetx = -0.5,
    shadowOffsety = 4,

    getHitEffectDuration = 0.3,

    init = function(self, position)
        Enemy.init(self, position, Barrel.health)

        self.velocity = Vector(0,0)

        self.animationSpeed = 0
        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(Barrel.spriteSheet, 32, 32, 0, 0)
        self.breakingAnimation = Animation(self.sprites, self.animationSpeed, 1, false)

        local rectPos = self.position - Vector(4,2)
        local myRect = Rectangle(rectPos, 7, 5)
        self.collider = Collider({myRect}, self.position, "Enemy", self)
        World:add(self.collider)

        self.getHitShader = love.graphics.newShader("Shaders/hitEffect.glsl")
        self.getHitShader:send("frac", 0.0)

        self.collisionTypes = {"GameEdge", "Enemy", "PlayerCollider"}

        -- Sounds
        self.hurtSound = love.audio.newSource("Sounds/HitBarrel.wav", "static")
        self.hurtSound:setVolume(SoundsVolume)
    end,

    DoDamage = function(self, amount, origin, knockback)
        if knockback == nil then knockback = 0 end

        self:TakeDamage(amount)

        self.hurtSound:play()

        local vecFromOrigin = origin - self.position
        self.velocity = self.velocity - vecFromOrigin:normalized() * knockback
    end,

    setPosition = function(self, position)
        self.position = position
        self.collider:setPosition(position)
    end,

    checkDead = function(self)
        if self.isDead then
            World:remove(self.collider)
            self.animationSpeed = Barrel.animSpeed
            self.breakingAnimation:setAnimationSpeed(self.animationSpeed)
            self.velocity = Vector(0,0)
        end
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
        -- Acceleratio
        local normedVelocity = self.velocity:normalized()
        local frictionVec = Vector(0,0)
        frictionVec.x = - normedVelocity.x * Barrel.friction
        frictionVec.y = - normedVelocity.y * Barrel.friction

        self.velocity = self.velocity + frictionVec * dt

        if math.abs( self.velocity.x ) < Barrel.speedStopCutoff then
            self.velocity.x = 0.0
        end
        if math.abs( self.velocity.y ) < Barrel.speedStopCutoff then
            self.velocity.y = 0.0
        end

        local moveStep = self.velocity * dt
        local newPos = self:resolveMovementObstructions(moveStep)
        self:setPosition(newPos)
    end,


    update = function(self, dt)
        self:doGetHitEffect()
        Enemy.update(self, dt)

        self:doMovement(dt)
        self:checkDead()

        self.breakingAnimation:update(dt)

        if self.breakingAnimation.animationDone then
            self:destroy()
        end

        self.zorder = self.position.y
    end,

    drawShadow = function(self)
        --love.graphics.setColor(68/255,56/255,70/255,1)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.ellipse('fill', self.position.x + Barrel.shadowOffsetx, self.position.y + Barrel.shadowOffsety, Barrel.shadowRadiusx, Barrel.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    doGetHitEffect = function(self)
        local frac = 1.0 - (self.time - self.damagedTime) / Barrel.getHitEffectDuration
        if frac < 0.0 then frac = 0.0 end
        if frac > 1.0 then frac = 1.0 end

        self.getHitShader:send("frac", frac)
    end,

    draw = function(self)
        if not self.isDead then
            self:drawShadow()
        end

        love.graphics.setShader(self.getHitShader)

        local ox = self.sprites[1]:getWidth() / 2
        local oy = self.sprites[1]:getHeight() / 2
        self.breakingAnimation:draw(self.position.x, self.position.y, 0, 1, 1, ox, oy)

        love.graphics.setShader()

        --love.graphics.setColor(Colors.red)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return Barrel