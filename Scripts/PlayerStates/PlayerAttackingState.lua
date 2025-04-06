
AttackingState = Class{

    attack1EndFrame = 5,
    attackCooldown = 0.1,

    attack1HitFrames = {4,5},
    attack2HitFrames = {9,10},
    attack1Damage = 5.0,
    attack2Damage = 5.0,
    attack1Knockback = 200,
    attack2Knockback = 200,

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

        local halfSpriteSize = Vector( self.sprites[1]:getWidth() / 2, self.sprites[1]:getHeight() / 2 )
        local spriteOffset = Vector(AttackingState.spriteOffsetHor, AttackingState.spriteOffsetVer)
        local colliderHeight = 26
        local colliderWidth = 17

        local rightRectPos = self.player.position:clone()
        rightRectPos.y = rightRectPos.y - halfSpriteSize.y - spriteOffset.y - colliderHeight/2 + 14
        local attackRectangleRight = Rectangle(rightRectPos, colliderWidth, colliderHeight)
        self.attackColliderRight = Collider({attackRectangleRight}, self.player.position, "PlayerAttack", self.player)

        local leftRectPos = rightRectPos:clone()
        leftRectPos.x = leftRectPos.x - colliderWidth
        local attackRectangleLeft = Rectangle(leftRectPos, colliderWidth, colliderHeight)
        self.attackColliderLeft = Collider({attackRectangleLeft}, self.player.position, "PlayerAttack", self.player)
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false

        self.player.velocity = Vector(0,0)

        self.attack1HitList = {}
        self.attack2HitList = {}
        self.attackColliderRight:setPosition(self.player.position)
        self.attackColliderLeft:setPosition(self.player.position)

        self.attackingAnimation:reset()
    end,

    doAttackSound = function(self)
        if (self.attackingAnimation.curFrame == 4) or (self.attackingAnimation.curFrame == 9) then
            self.player.swordSound:setPitch(love.math.random(0.95, 1.05))
            self.player.swordSound:play()
        end
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
        local inAttack1 = false
        local inAttack2 = false
        if Lume.find(AttackingState.attack1HitFrames, self.attackingAnimation.curFrame) ~= nil then
            inAttack1 = true
        end
        if Lume.find(AttackingState.attack2HitFrames, self.attackingAnimation.curFrame) ~= nil then
            inAttack2 = true
        end

        -- Reset hit lists
        if not inAttack1 then self.attack1HitList = {} end
        if not inAttack2 then self.attack2HitList = {} end

        -- Not attacking
        if (not inAttack1) and (not inAttack2) then return end

        -- Set colliders
        self.attackColliderRight:setPosition(self.player.position)
        self.attackColliderLeft:setPosition(self.player.position)

        -- Get collisions
        local colls
        if self.player.lookDir > 0 then
            colls = World:getCollisions(self.attackColliderRight)
        else
            colls = World:getCollisions(self.attackColliderLeft)
        end

        -- Hit things
        local ii,coll
        for ii, coll in pairs(colls) do
            if inAttack1 then self:hitAttack1(coll) end
            if inAttack2 then self:hitAttack2(coll) end
        end    
    end,

    hitAttack1 = function(self, other)
        if other.type ~= "Enemy" then return end
        if Lume.find(self.attack1HitList, other) ~= nil then return end

        table.insert(self.attack1HitList, other)
        other.instance:DoDamage(PlayerAttackingState.attack1Damage, self.player.position, PlayerAttackingState.attack1Knockback)
    end,

    hitAttack2 = function(self, other)
        if other.type ~= "Enemy" then return end
        if Lume.find(self.attack2HitList, other) ~= nil then return end

        table.insert(self.attack2HitList, other)
        other.instance:DoDamage(PlayerAttackingState.attack2Damage, self.player.position, PlayerAttackingState.attack2Knockback)
    end,

    update = function(self, dt)
        self.attackingAnimation:update(dt)
        self:doAttackSound()

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
        --self.attackColliderRight:draw()
        --self.attackColliderLeft:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return AttackingState