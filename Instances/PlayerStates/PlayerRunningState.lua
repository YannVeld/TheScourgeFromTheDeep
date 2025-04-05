
RunningState = Class{

    maxSpeed = 500.0,
    clickAccel = 500.0,
    friction = 500.0,
    moveSpeed = 100.0,

    spriteSheet = Sprites.Knight_run,
    animSpeed = 10,
    spriteOffsetHor = -1,
    spriteOffsetVer = -1,

    init = function(self, playerInstance)
        self.player = playerInstance

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(RunningState.spriteSheet, 32, 32, 0, 0)
        self.runningAnimation = Animation(self.sprites, RunningState.animSpeed)
    end,


    move = function(self, dt)
        local horPress = self.player.inputManager.horizontalInput
        local verPress = self.player.inputManager.verticalInput

        -- Friction
        local acceleration = Vector(0,0)
        local normedVelocity = self.player.velocity:normalized()
        local frictionVec = Vector(0,0)
        frictionVec.x = - (1 - horPress) * normedVelocity.x * RunningState.friction
        frictionVec.y = - (1 - verPress) * normedVelocity.y * RunningState.friction
        acceleration = acceleration + frictionVec

        -- Change velocity
        if (horPress ~= 0) or (verPress ~= 0) then
            self.player.velocity = Vector(horPress, verPress):normalized() * RunningState.moveSpeed
        end

        self.player.velocity = self.player.velocity + acceleration * dt

        local speed = self.player.velocity:len()
        if speed > RunningState.maxSpeed then
            self.player.velocity = Vector(0,0)
        end

    end,


    update = function(self, dt)
        self.runningAnimation:update(dt)
        self:move(dt)
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + RunningState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + RunningState.spriteOffsetVer
        self.runningAnimation:draw(self.player.position.x, self.player.position.y, 
                                   0, self.player.lookDir, 1, ox, oy)
    end,
}

return RunningState