
KnockbackState = Class{

    friction = 500.0,
    movementThreshold = 1,

    sprite = Sprites.Knight,
    spriteOffsetHor = -1,
    spriteOffsetVer = -1,

    init = function(self, playerInstance)
        self.player = playerInstance

        self.isMoving = false
        self.lookDirAtEntry = 1
    end,

    enter = function(self)
        self.isMoving = true
        self.lookDirAtEntry = self.player.lookDir
    end,

    move = function(self, dt)
        -- Friction
        local acceleration = Vector(0,0)
        local normedVelocity = self.player.velocity:normalized()
        local frictionVec = Vector(0,0)
        frictionVec.x = - normedVelocity.x * KnockbackState.friction
        frictionVec.y = - normedVelocity.y * KnockbackState.friction
        acceleration = acceleration + frictionVec

        self.player.velocity = self.player.velocity + acceleration * dt
    end,

    checkMoving = function(self)
        local speed = self.player.velocity:len()
        if speed <= KnockbackState.movementThreshold then
            self.isMoving = false
        end
    end,

    update = function(self, dt)
        self:move(dt)
        self:checkMoving()
    end,

    exit = function(self)
        self.player.lookDir = self.lookDirAtEntry
    end,

    draw = function(self)
        local ox = self.sprite:getWidth() / 2 + KnockbackState.spriteOffsetHor
        local oy = self.sprite:getHeight() / 2 + KnockbackState.spriteOffsetVer
        self.sprite:draw(self.player.position.x, self.player.position.y, 
                         0, self.lookDirAtEntry, 1, ox, oy)
    end,
}

return KnockbackState