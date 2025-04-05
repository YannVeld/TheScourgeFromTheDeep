
AttackingState = Class{

    attack1EndFrame = 5,
    attackCooldown = 0.4,

    attack1HitFrames = {4,5},
    attack1Damage = 5.0,

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

        local halfSpriteSize = Vector( - self.sprites[1]:getWidth() / 2, - self.sprites[1]:getHeight() / 2 )
        local attackRectangleRight1 = Rectangle(Vector(16,0) + halfSpriteSize, 14, 7)
        attackRectangleRight1:setPosition(self.player.position + attackRectangleRight1.position)
        local attackRectangleRight2 = Rectangle(Vector(22,7) + halfSpriteSize, 10, 18)
        attackRectangleRight2:setPosition(self.player.position + attackRectangleRight2.position)
        self.attack1ColliderRight = Collider({attackRectangleRight1,attackRectangleRight2}, self.player.position, "PlayerAttack", self.player)

        halfSpriteSize = Vector( - self.sprites[1]:getWidth() / 2, - self.sprites[1]:getHeight() / 2 )
        local attackRectangleLeft1 = Rectangle(Vector(6,0) + halfSpriteSize, 14, 7)
        attackRectangleLeft1:setPosition(self.player.position + attackRectangleLeft1.position)
        local attackRectangleLeft2 = Rectangle(Vector(0,7) + halfSpriteSize, 10, 18)
        attackRectangleLeft2:setPosition(self.player.position + attackRectangleLeft2.position)
        self.attack1ColliderLeft = Collider({attackRectangleLeft1,attackRectangleLeft2}, self.player.position, "PlayerAttack", self.player)
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false

        self.player.velocity = Vector(0,0)

        self.attack1HitList = {}
        self.attack1ColliderRight:setPosition(self.player.position)
        self.attack1ColliderLeft:setPosition(self.player.position)

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

    doAttack1 = function(self)
        if Lume.find(AttackingState.attack1HitFrames, self.attackingAnimation.curFrame) == nil then
            self.attack1HitList = {}
            return
        end

        self.attack1ColliderRight:setPosition(self.player.position)
        self.attack1ColliderLeft:setPosition(self.player.position)

        local colls
        if self.player.lookDir > 0 then
            colls = World:getCollisions(self.attack1ColliderRight)
        else
            colls = World:getCollisions(self.attack1ColliderLeft)
        end

        local ii,coll
        for ii, coll in pairs(colls) do
            if Lume.find(self.attack1HitList, coll) == nil then
                self:hitAttack1(coll)
                table.insert(self.attack1HitList, coll)
            end
        end    
    end,

    hitAttack1 = function(self, other)
        if other.type ~= "Enemy" then
            return
        end

        other.instance:DoDamage(PlayerAttackingState.attack1Damage)
    end,

    update = function(self, dt)
        self.attackingAnimation:update(dt)

        self:doAttack1()

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
                                     
        --love.graphics.setColor(Colors.blue)
        --self.attack1ColliderRight:draw()
        --self.attack1ColliderLeft:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return AttackingState