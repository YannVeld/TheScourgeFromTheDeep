
Instance = require "Packages.YannUtil.Instance"

local FallingFire = Class{
    __includes = {Instance},

    fallSpeed = 200,
    lifeTime = 4,

    spriteSheetFalling = Sprites.FallingFire,
    spriteSheetGround = Sprites.Fire,
    spriteSheetMarker = Sprites.GroundMarker,
    spriteSheetExplosion = Sprites.Explosion,
    fireAnimSpeed = 12,
    markerAnimSpeed = 16,
    explosionAnimSpeed = 16,

    fireSpriteOffsety = 26,

    init = function(self, position, damage, knockback, height)
        Instance.init(self)

        self.zorder = position.y

        self.position = position

        self.groundy = self.position.y
        self.position.y = self.position.y - height
        self.damage = damage
        self.knockback = knockback

        self.hasLanded = false
        self.timeSinceLanding = 0
        
        self.spritesFalling = SpriteLoading.getSpritesFromSpriteSheet(FallingFire.spriteSheetFalling, 28, 38, 0, 0)
        self.animationFalling = Animation(self.spritesFalling, FallingFire.fireAnimSpeed, 1)
        self.spritesGround = SpriteLoading.getSpritesFromSpriteSheet(FallingFire.spriteSheetGround, 28, 38, 0, 0)
        self.animationGround = Animation(self.spritesGround, FallingFire.fireAnimSpeed, 1)
        self.spritesMarker = SpriteLoading.getSpritesFromSpriteSheet(FallingFire.spriteSheetMarker, 16, 16, 0, 0)
        self.animationMarker = Animation(self.spritesMarker, FallingFire.markerAnimSpeed, 1, false)
        self.spritesExplosion = SpriteLoading.getSpritesFromSpriteSheet(FallingFire.spriteSheetExplosion, 32, 32, 0, 0)
        self.animationExplosion = Animation(self.spritesExplosion, 0, 1, false)

        self.explodeSound = love.audio.newSource("Sounds/Explosion1.wav", "static")
        self.explodeSound:setVolume(SoundsVolume)

        self.hitList = {}

        local collSize = 10
        local myRect = Rectangle(self.position - Vector(collSize/2, collSize/2 - height), collSize, collSize)
        self.collider = Collider({myRect}, self.position, "Fire", self)
    end,

    doMovement = function(self, dt)
        if self.hasLanded then return end

        if self.position.y > self.groundy then
            self.position.y = self.groundy
            self.hasLanded = true
            return
        end

        self.position.y = self.position.y + FallingFire.fallSpeed * dt
    end,

    destroyFallingFire = function(self, dt)
        self:destroy()
    end,

    checkCollision = function(self)
        -- Dont do damage when not yet landed
        if not self.hasLanded then return end

        self.collider:setPosition(self.position)
        local colls = World:getCollisions(self.collider)

        local ii,coll
        for ii, coll in pairs(colls) do
            if coll.type == "PlayerCollider" then
                if Lume.find(self.hitList, coll) == nil then
                    table.insert(self.hitList, coll)
                    coll.instance:DoDamage(self.damage, self.position, self.knockback)
                    self:destroy()
                end
            end
        end    
    end,

    playExplosionSound = function(self)
        if not self.hasLanded then return end
        if self.timeSinceLanding > 0 then return end
        self.explodeSound:play()
    end,

    checkDestroySelf = function(self, dt)
        if not self.hasLanded then return end

        self.timeSinceLanding = self.timeSinceLanding + dt
        if self.timeSinceLanding > FallingFire.lifeTime then
            self:destroy()
        end
    end,

    update = function(self, dt)
        self.animationFalling:update(dt)
        self.animationGround:update(dt)
        self.animationExplosion:update(dt)
        self.animationMarker:update(dt)
        self:doMovement(dt)
        self:playExplosionSound()
        self:checkCollision()
        self:checkDestroySelf(dt)

        if self.hasLanded then
            self.animationExplosion:setAnimationSpeed(FallingFire.explosionAnimSpeed)
        end
    end,

    draw = function(self)
        local ox, oy

        -- Draw marker
        if not self.hasLanded then
            ox = self.spritesMarker[1]:getWidth() / 2
            oy = self.spritesMarker[1]:getHeight() / 2
            self.animationMarker:draw(self.position.x - ox, self.groundy - oy)
        end

        -- Draw Fire
        local fireAnim = self.animationFalling
        local mySprites = self.spritesFalling
        if self.hasLanded then
            fireAnim = self.animationGround
            mySprites = self.spritesGround
        end

        ox = mySprites[1]:getWidth() / 2
        oy = FallingFire.fireSpriteOffsety
        fireAnim:draw(self.position.x, self.position.y, 0, 1, 1, ox, oy)

        -- Draw Explosion
        if self.hasLanded then
            if not self.animationExplosion.animationDone then
                ox = self.spritesExplosion[1]:getWidth() / 2
                oy = self.spritesExplosion[1]:getHeight() / 2
                self.animationExplosion:draw(self.position.x - ox, self.position.y - oy)
            end
        end

        --love.graphics.setColor(Colors.blue)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
    end,
}

return FallingFire