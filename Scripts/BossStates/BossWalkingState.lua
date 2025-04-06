
BossWalkingState = Class{

    moveSpeed = 50.0,

    spriteSheet = Sprites.Boss_walking,
    animSpeed = 8,
    spriteOffsetHor = -5,
    spriteOffsetVer = 26,

    init = function(self, bossInstance)
        self.boss = bossInstance

        self.hasArrived = true

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossWalkingState.spriteSheet, 96, 96, 0, 0)
        self.runningAnimation = Animation(self.sprites, BossWalkingState.animSpeed)
    end,

    enter = function(self)
        self.hasArrived = false
    end,


    doWalkSound = function(self)
        if (self.runningAnimation.curFrame == 2) or (self.runningAnimation.curFrame == 5) then
            self.boss.stompSound:play()
        end
    end,   

    move = function(self, dt)
        local dirVector = (self.boss.targetPosition - self.boss.position):normalized()
        self.boss.velocity = dirVector * BossWalkingState.moveSpeed

        local distToTarget = self.boss.position:dist(self.boss.targetPosition)
        if distToTarget < BossWalkingState.moveSpeed * dt then
            self.boss.velocity = Vector(0,0)
            self.boss:setPosition(self.boss.targetPosition)
            self.hasArrived = true
        end
    end,

    update = function(self, dt)
        self.runningAnimation:update(dt)
        self:doWalkSound()
        self:move(dt)
    end,
    
    passiveUpdate = function(self, dt)
        if self.boss.state == self then return end

        local distToTarget = self.boss.position:dist(self.boss.targetPosition)
        if distToTarget > BossWalkingState.moveSpeed * dt then
            self.hasArrived = false
        else
            self.hasArrived = true
        end
    end,

    exit = function(self)
        local playerPos = self.boss.player.position
        self.boss.lookDir = Lume.sign( playerPos.x - self.boss.position.x )
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossWalkingState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossWalkingState.spriteOffsetVer
        self.runningAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                   0, -self.boss.lookDir, 1, ox, oy)
    end,
}

return BossWalkingState