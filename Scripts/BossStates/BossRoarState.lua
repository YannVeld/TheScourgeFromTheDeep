
FallingFire = require("Scripts/FallingFire")


BossRoarState = Class{

    attackCooldown = 2.0,
    shootFireballFrame = 8,

    fireDamage = 10,
    fireKnockback = 200,

    spriteSheet = Sprites.Boss_roar,
    animSpeed = 12,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, playerInstance)
        self.boss = playerInstance
        self.attackEnded = false
        self.canAttack = true
        self.timeSinceExit = 0
        self.didFire = false
        self.playedSound = false

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossRoarState.spriteSheet, 96, 96, 0, 0)
        self.attackingAnimation = Animation(self.sprites, BossRoarState.animSpeed, 1, false)
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false
        self.didFire = false
        self.playedSound = false
        
        self.boss.velocity = Vector(0,0)

        self.attackingAnimation:reset()
    end,

    doAttackSound = function(self)
        if self.playedSound then return end

        if self.attackingAnimation.curFrame >= 3 then
            self.boss.roarSound:play()
            self.playedSound = true
        end
    end,   

    doAttack = function(self)
        if not (self.attackingAnimation.curFrame == BossRoarState.shootFireballFrame) then
            return
        end
        if self.didFire then return end

        self.didFire = true

        -- Spawn fires
        --local futurePlayerPos = self.boss.player.position + self.boss.player.velocity * avgFireHeight / FallingFire.fallSpeed
        local ii,fire
        local fireCount = 3
        local avgFireHeight = 250

        for ii = 1, fireCount do
            local posx = Lume.random(10, Push:getWidth()-10)
            local posy = Lume.random(45, Push:getHeight()-10)
            local pos = Vector(posx, posy)

            local height = avgFireHeight + Lume.random(-50,50)

            fire = FallingFire(pos, BossRoarState.fireDamage, BossRoarState.fireKnockback, height)
        end
    end,

    faceThePlayer = function(self)
        local vecToPlayer = self.boss.player.position - self.boss.position
        local playerLoc = Lume.sign( vecToPlayer.x )
        self.boss.lookDir = playerLoc
    end,

    update = function(self, dt)
        self.attackingAnimation:update(dt)
        self:doAttackSound()

        self:faceThePlayer()

        self:doAttack()

        self.timeSinceEnter = self.timeSinceEnter + dt

        if self.attackingAnimation.animationDone then
            self.attackEnded = true
        end
    end,

    passiveUpdate = function(self, dt)
        if self.boss.state == self then return end

        if self.timeSinceExit > BossRoarState.attackCooldown then
            self.canAttack = true
        else
            self.timeSinceExit = self.timeSinceExit + dt
        end
    end,

    exit = function(self)
        self.timeSinceExit = 0
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossRoarState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossRoarState.spriteOffsetVer
        self.attackingAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                     0, -self.boss.lookDir, 1, ox, oy)
                                     
        --love.graphics.setColor(Colors.red)
        --self.attackColliderRight:draw()
        --self.attackColliderLeft:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return BossRoarState