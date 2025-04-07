
BossDyingState = Class{

    spawnTime = 1,

    spriteSheet = Sprites.Boss_die,
    animSpeed = 10,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, bossInstance)
        self.boss = bossInstance

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossDyingState.spriteSheet, 96, 96, 0, 0)
        self.dieAnimation = Animation(self.sprites, BossDyingState.animSpeed, 1, false)

        self.hasDied = false
        self.playedSound = false
    end,

    enter = function(self)
        self.boss.velocity = Vector(0,0)
        self.playedSound = false

        World:remove(self.boss.collider)
    end,

    doAttackSound = function(self)
        if self.playedSound then return end

        --if self.dieAnimation.curFrame >= 3 then
        --    self.boss.roarSound:play()
        --    self.playedSound = true
        --end
    end,   

    update = function(self, dt)
        self:doAttackSound()
        self.dieAnimation:update(dt)

        if self.dieAnimation.animationDone then
            self.hasDied = true
        end
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossDyingState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossDyingState.spriteOffsetVer
        self.dieAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                0, -self.boss.lookDir, 1, ox, oy)

    end,
}

return BossDyingState