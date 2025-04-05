
IdleState = Class{

    spriteSheet = Sprites.Knight_idle,
    animSpeed = 10,
    spriteOffsetHor = -1,
    spriteOffsetVer = -1,

    init = function(self, playerInstance)
        self.player = playerInstance

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(IdleState.spriteSheet, 32, 32, 0, 0)
        self.idleAnimation = Animation(self.sprites, IdleState.animSpeed)
    end,

    enter = function(self)
    end,

    update = function(self, dt)
        self.idleAnimation:update(dt)
    end,

    exit = function(self)
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + IdleState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + IdleState.spriteOffsetVer
        self.idleAnimation:draw(self.player.position.x, self.player.position.y, 
                                0, self.player.lookDir, 1, ox, oy)
    end,
}

return IdleState