
Instance = require "Packages.YannUtil.Instance"

local HealthPickup = Class{
    __includes = {Instance},

    spriteSheet = Sprites.HealthPickup,
    animSpeed = 14,
    zorderPosOffset = 5,

    speedStopCutoff = 1.0,
    friction = 500,

    healAmount = 35,

    shadowRadiusx = 6,
    shadowRadiusy = 2,
    shadowOffsetx = 0,
    shadowOffsety = 8,

    init = function(self, position, velocity)
        Instance.init(self)

        self.zorder = self.zorder + 999

        self.position = position
        self.velocity = velocity
        
        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(HealthPickup.spriteSheet, 16, 16, 0, 0)
        self.animation = Animation(self.sprites, HealthPickup.animSpeed, 1)

        local collHeight = 14
        local collWidth = 10
        local myRect = Rectangle(self.position - Vector(collWidth/2, collHeight/2), collWidth, collHeight)
        self.collider = Collider({myRect}, self.position, "HealthPickup", self)

        self.collisionTypes = {"GameEdge", "Enemy"}
    end,

    setPosition = function(self, position)
        self.position = position
        self.collider:setPosition(position)
    end,

    resolveMovementObstructions = function(self, moveStep)
        -- Diagonal
        local tryPos = self.position:clone() + moveStep
        self.collider:setPosition(tryPos)
        local colliding = World:checkCollision(self.collider, self.collisionTypes)
        if not colliding then
            return tryPos
        end

        -- Try along x
        tryPos = self.position:clone()
        tryPos.x = tryPos.x + moveStep.x
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider, self.collisionTypes)
        if not colliding then
            return tryPos
        end
        
        -- Try along y
        tryPos = self.position:clone()
        tryPos.y = tryPos.y + moveStep.y
        self.collider:setPosition(tryPos)
        colliding = World:checkCollision(self.collider, self.collisionTypes)
        if not colliding then
            return tryPos
        end

        return self.position
    end,

    doMovement = function(self, dt)
        -- Acceleratio
        local normedVelocity = self.velocity:normalized()
        local frictionVec = Vector(0,0)
        frictionVec.x = - normedVelocity.x * HealthPickup.friction
        frictionVec.y = - normedVelocity.y * HealthPickup.friction

        self.velocity = self.velocity + frictionVec * dt

        if math.abs( self.velocity.x ) < HealthPickup.speedStopCutoff then
            self.velocity.x = 0.0
        end
        if math.abs( self.velocity.y ) < HealthPickup.speedStopCutoff then
            self.velocity.y = 0.0
        end

        local moveStep = self.velocity * dt
        local newPos = self:resolveMovementObstructions(moveStep)
        self:setPosition(newPos)
    end,


    checkCollision = function(self)
        local colls = World:getCollisions(self.collider)

        local ii,coll
        for ii, coll in pairs(colls) do
            if coll.type == "Player" then
                local healed = coll.instance:Heal(HealthPickup.healAmount)
                if healed then
                    self:destroy()
                end
                return
            end
        end    
    end,

    update = function(self, dt)
        self.animation:update(dt)
        self:doMovement(dt)
        self:checkCollision()
        self.zorder = self.position.y + HealthPickup.zorderPosOffset
    end,

    drawShadow = function(self)
        --love.graphics.setColor(68/255,56/255,70/255,1)
        love.graphics.setColor(0,0,0,0.6)
        love.graphics.ellipse('fill', self.position.x + HealthPickup.shadowOffsetx, self.position.y + HealthPickup.shadowOffsety, HealthPickup.shadowRadiusx, HealthPickup.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    draw = function(self)
        self:drawShadow()

        local ox = self.sprites[1]:getWidth() / 2
        local oy = self.sprites[1]:getHeight() / 2
        self.animation:draw(self.position.x, self.position.y, 0, 1, 1, ox, oy)

        --love.graphics.setColor(Colors.blue)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
    end,
}

return HealthPickup