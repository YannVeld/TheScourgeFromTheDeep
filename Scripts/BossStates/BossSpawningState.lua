
BossSpawningState = Class{

    spawnTime = 1,

    spriteSheet = Sprites.Boss_roar,
    animSpeed = 10,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, bossInstance)
        self.boss = bossInstance

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossSpawningState.spriteSheet, 96, 96, 0, 0)
        self.roarAnimation = Animation(self.sprites, BossSpawningState.animSpeed, 1, false)

        self.spawnCountdown = BossSpawningState.spawnTime
        self.hasSpawned = false
        self.playedSound = false
    end,

    enter = function(self)
        self.boss.velocity = Vector(0,0)
        self.playedSound = false
    end,

    doAttackSound = function(self)
        if self.playedSound then return end

        if self.roarAnimation.curFrame >= 3 then
            self.boss.roarSound:play()
            self.playedSound = true
        end
    end,   

    updateHealth = function(self)
        local frac = 1 - self.spawnCountdown / BossSpawningState.spawnTime
        local newHealth = frac * Boss.health
        newHealth = Lume.clamp(newHealth,1,Boss.health)
        self.boss.health = newHealth
    end,

    update = function(self, dt)
        self:doAttackSound()
        self.spawnCountdown = self.spawnCountdown - dt
        self.roarAnimation:update(dt)

        self:updateHealth()

        if self.spawnCountdown <= 0 then
            self.hasSpawned = true
        end
    end,

    exit = function(self)
        self.boss.health = Boss.health
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossSpawningState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossSpawningState.spriteOffsetVer
        self.roarAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                0, -self.boss.lookDir, 1, ox, oy)

    end,
}

return BossSpawningState