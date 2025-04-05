
AttackingState = Class{

    attack1EndFrame = 5,
    attackCooldown = 0.4,

    spriteSheet = Sprites.Knight_attack,
    animSpeed = 14,
    spriteOffsetHor = -1,
    spriteOffsetVer = -1,

    init = function(self, playerInstance)
        self.player = playerInstance
        self.attackEnded = false
        self.canAttack = true
        self.timeSinceExit = 0

        self.attackStage = 1

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(AttackingState.spriteSheet, 32, 32, 0, 0)
        self.attackingAnimation = Animation(self.sprites, AttackingState.animSpeed, 1, false)
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false

        self.player.velocity = Vector(0,0)

        self.attackingAnimation:reset()
    end,

    checkAttackStage = function(self)
        if self.attackingAnimation.curFrame <= AttackingState.attack1EndFrame then
            return 1
        end
        if self.attackingAnimation.curFrame < #self.sprites then
            if self.player.inputManager.attackPressed then
                return 2
            else
                if self.attackStage == 1 then
                    return 0
                end
            end
        end
        if self.attackingAnimation.animationDone then
            return 0
        end

        return self.attackStage
    end,


    update = function(self, dt)
        self.attackingAnimation:update(dt)

        self.timeSinceEnter = self.timeSinceEnter + dt

        self.attackStage = self:checkAttackStage()
        if self.attackStage == 0 then
            self.attackEnded = true
        end
    end,

    passiveUpdate = function(self, dt)
        if self.player.state == self.player.attackingState then
            return
        end

        if self.timeSinceExit > AttackingState.attackCooldown then
            self.canAttack = true
        else
            self.timeSinceExit = self.timeSinceExit + dt
        end
    end,

    exit = function(self)
        self.timeSinceExit = 0
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + RunningState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + RunningState.spriteOffsetVer
        self.attackingAnimation:draw(self.player.position.x, self.player.position.y, 
                                     0, self.player.lookDir, 1, ox, oy)
    end,
}

return AttackingState