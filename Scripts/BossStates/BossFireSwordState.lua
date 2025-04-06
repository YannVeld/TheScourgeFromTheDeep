
BossFireSwordState = Class{

    attackCooldown = 2.0,
    attackHitFrames = {10,11},
    attackDamage = 20.0,

    spriteSheet = Sprites.Boss_swordSwing,
    animSpeed = 14,
    spriteOffsetHor = -5+16,
    spriteOffsetVer = 26-16,

    init = function(self, playerInstance)
        self.boss = playerInstance
        self.attackEnded = false
        self.canAttack = true
        self.timeSinceExit = 0

        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(BossFireSwordState.spriteSheet, 128, 128, 0, 0)
        self.attackingAnimation = Animation(self.sprites, BossFireSwordState.animSpeed, 1, false)


        self:createCollider()
    end,

    createCollider = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossFireSwordState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossFireSwordState.spriteOffsetVer

        local drawx = self.boss.position.x - ox
        local drawy = self.boss.position.y - oy
        local drawPos = Vector(drawx, drawy)

        -- Left
        local collRectsLeft = {}
        collRectsLeft[1] = Rectangle(drawPos:clone() + Vector(67,63), 20, 21)
        collRectsLeft[2] = Rectangle(drawPos:clone() + Vector(37,7), 30, 79)
        collRectsLeft[3] = Rectangle(drawPos:clone() + Vector(25,9), 12, 72)
        collRectsLeft[4] = Rectangle(drawPos:clone() + Vector(12,21), 13, 52)

        self.attackColliderLeft = Collider(collRectsLeft, self.boss.position, "BossAttack", self.boss)

        -- Right
        drawPos.x = self.boss.position.x + ox
        local collRectsRight = {}
        collRectsRight[1] = Rectangle(drawPos:clone() + Vector(-67,63) - Vector(20,0), 20, 21)
        collRectsRight[2] = Rectangle(drawPos:clone() + Vector(-37,7) - Vector(30,0), 30, 79)
        collRectsRight[3] = Rectangle(drawPos:clone() + Vector(-25,9) - Vector(12,0), 12, 72)
        collRectsRight[4] = Rectangle(drawPos:clone() + Vector(-12,21) - Vector(13,0), 13, 52)

        self.attackColliderRight = Collider(collRectsRight, self.boss.position, "BossAttack", self.boss)
    end,

    enter = function(self)
        self.canAttack = false
        self.timeSinceEnter = 0
        self.attackEnded = false

        self.boss.velocity = Vector(0,0)

        self.attackHitList = {}
        self.attackColliderRight:setPosition(self.boss.position)
        self.attackColliderLeft:setPosition(self.boss.position)

        self.attackingAnimation:reset()
    end,

    checkAttackStage = function(self)
        if self.attackingAnimation.animationDone then
            return 0
        end

        return 1
    end,

    doAttack = function(self)
        local inAttack = false
        if Lume.find(BossFireSwordState.attackHitFrames, self.attackingAnimation.curFrame) ~= nil then
            inAttack = true
        end

        -- Reset hit lists
        if not inAttack then 
            self.attack1HitList = {}
            return
        end

        -- Set colliders
        self.attackColliderRight:setPosition(self.boss.position)
        self.attackColliderLeft:setPosition(self.boss.position)

        -- Get collisions
        local colls
        if self.boss.lookDir > 0 then
            colls = World:getCollisions(self.attackColliderRight)
        else
            colls = World:getCollisions(self.attackColliderLeft)
        end

        -- Hit things
        local ii,coll
        for ii, coll in pairs(colls) do
            if inAttack then self:hitAttack(coll) end
        end    
    end,

    hitAttack = function(self, other)
        if not (other.type == "Player" or other.type == "Enemy") then return end
        if other.instance == self.boss then return end
        if Lume.find(self.attackHitList, other) ~= nil then return end

        table.insert(self.attackHitList, other)
        other.instance:DoDamage(BossFireSwordState.attackDamage, self.boss.position)
    end,

    checkPlayerInRange = function(self)
        -- Set colliders
        self.attackColliderRight:setPosition(self.boss.position)
        self.attackColliderLeft:setPosition(self.boss.position)

        -- Get collisions
        local colls
        if self.boss.lookDir > 0 then
            colls = World:getCollisions(self.attackColliderRight)
        else
            colls = World:getCollisions(self.attackColliderLeft)
        end

        -- Check if player is in range
        local ii,coll
        for ii, coll in pairs(colls) do
            if coll.type == "Player" then
                return true
            end
        end    

        return false
    end,

    update = function(self, dt)
        self.attackingAnimation:update(dt)

        self:doAttack()

        self.timeSinceEnter = self.timeSinceEnter + dt

        self.attackStage = self:checkAttackStage()
        if self.attackStage == 0 then
            self.attackEnded = true
        end
    end,

    passiveUpdate = function(self, dt)
        if self.boss.state == self then return end

        if self.timeSinceExit > BossFireSwordState.attackCooldown then
            self.canAttack = true
        else
            self.timeSinceExit = self.timeSinceExit + dt
        end
    end,

    exit = function(self)
        self.timeSinceExit = 0
    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2 + BossFireSwordState.spriteOffsetHor
        local oy = self.sprites[1]:getHeight() / 2 + BossFireSwordState.spriteOffsetVer
        self.attackingAnimation:draw(self.boss.position.x, self.boss.position.y, 
                                     0, -self.boss.lookDir, 1, ox, oy)
                                     
        --love.graphics.setColor(Colors.red)
        --self.attackColliderRight:draw()
        --self.attackColliderLeft:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return BossFireSwordState