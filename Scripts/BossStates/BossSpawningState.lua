
BossSpawningState = Class{

    spawnTime = 2,

    spriteSheet = Sprites.Boss_idle,
    animSpeed = 10,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, bossInstance)
        self.boss = bossInstance

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossSpawningState.spriteSheet, 96, 96, 0, 0)
        self.idleAnimation = Animation(self.sprites, BossSpawningState.animSpeed)

        self.spawnCountdown = BossSpawningState.spawnTime
        self.hasSpawned = false
    end,

    enter = function(self)
        self.boss.velocity = Vector(0,0)
    end,

    update = function(self, dt)
        self.spawnCountdown = self.spawnCountdown - dt
        self.idleAnimation:update(dt)

        if self.spawnCountdown <= 0 then
            self.hasSpawned = true
        end
    end,

    exit = function(self)
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossSpawningState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossSpawningState.spriteOffsetVer
        self.idleAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                0, -self.boss.lookDir, 1, ox, oy)

    end,
}

return BossSpawningState