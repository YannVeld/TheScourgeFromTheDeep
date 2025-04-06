
Fireball = require("Scripts/Fireball")


BossFireBreathState = Class{

    attackCooldown = 2.0,
    shootFireballFrame = 8,

    fireballSpeed = 100,
    fireballDamage = 10,
    fireballKnockback = 200,

    spriteSheet = Sprites.Boss_fireBreath,
    animSpeed = 12,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, playerInstance)
        self.boss = playerInstance
        self.attackEnded = false
        self.canAttack = true
        self.timeSinceExit = 0
        self.didFire = false

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossFireBreathState.spriteSheet, 96, 96, 0, 0)
        self.attackingAnimation = Animation(self.sprites, BossFireBreathState.animSpeed, 1, false)
    end,

    getMouthPos = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossFireBreathState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossFireBreathState.spriteOffsetVer

        local drawx = self.boss.position.x + ox * self.boss.lookDir
        local drawy = self.boss.position.y - oy
        local drawPos = Vector(drawx, drawy)

        local mouthPos = drawPos + Vector(- 34 * self.boss.lookDir,46)
        return mouthPos
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false
        self.didFire = false

        self.boss.velocity = Vector(0,0)

        self.attackingAnimation:reset()
    end,

    doAttack = function(self)
        if not (self.attackingAnimation.curFrame == BossFireBreathState.shootFireballFrame) then
            return
        end
        if self.didFire then return end

        self.didFire = true
        local mouthPos = self:getMouthPos()


        local vecToPlayer = self.boss.player.position - mouthPos
        local distToPlayer = vecToPlayer:len()
        
        local futurePlayerPos = self.boss.player.position + self.boss.player.velocity * distToPlayer / 2 / BossFireBreathState.fireballSpeed
        local vecToFuturePlayer = futurePlayerPos - mouthPos

        local ii,fireball
        local fireballCount = 3
        local angleVariation = 40 * 3 / 360 * math.floor(fireballCount / 2)
        for ii = 1, fireballCount do
            --local angle = Lume.random(-angleVariation, angleVariation)
            local angle = angleVariation * (ii - math.ceil(fireballCount / 2))

            local velocityVec = vecToFuturePlayer:normalized() * BossFireBreathState.fireballSpeed
            velocityVec:rotateInplace(angle)

            fireball = Fireball(mouthPos, velocityVec,
                                BossFireBreathState.fireballDamage, BossFireBreathState.fireballKnockback)
        end
    end,

    faceThePlayer = function(self)
        local vecToPlayer = self.boss.player.position - self.boss.position
        local playerLoc = Lume.sign( vecToPlayer.x )
        self.boss.lookDir = playerLoc
    end,

    update = function(self, dt)
        self.attackingAnimation:update(dt)

        self:faceThePlayer()

        self:doAttack()

        self.timeSinceEnter = self.timeSinceEnter + dt

        if self.attackingAnimation.animationDone then
            self.attackEnded = true
        end
    end,

    passiveUpdate = function(self, dt)
        if self.boss.state == self then return end

        if self.timeSinceExit > BossFireBreathState.attackCooldown then
            self.canAttack = true
        else
            self.timeSinceExit = self.timeSinceExit + dt
        end
    end,

    exit = function(self)
        self.timeSinceExit = 0
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossFireBreathState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossFireBreathState.spriteOffsetVer
        self.attackingAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                     0, -self.boss.lookDir, 1, ox, oy)
                                     
        --love.graphics.setColor(Colors.red)
        --self.attackColliderRight:draw()
        --self.attackColliderLeft:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return BossFireBreathState