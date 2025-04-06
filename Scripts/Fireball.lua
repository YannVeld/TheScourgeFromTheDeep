
Instance = require "Packages.YannUtil.Instance"

local Fireball = Class{
    __includes = {Instance},

    spriteSheet = Sprites.Fireball,
    animSpeed = 14,

    init = function(self, position, velocity, damage, knockback)
        Instance.init(self)

        self.zorder = self.zorder + 999

        self.position = position
        self.velocity = velocity
        self.damage = damage
        self.knockback = knockback
        
        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(Fireball.spriteSheet, 32, 32, 0, 0)
        self.animation = Animation(self.sprites, Fireball.animSpeed, 1, false)

        self.hitList = {}

        local collSize = 10
        local myRect = Rectangle(self.position - Vector(collSize/2, collSize/2), collSize, collSize)
        self.collider = Collider({myRect}, self.position, "Projectile", self)
    end,

    doMovement = function(self, dt)
        self.position = self.position + self.velocity * dt
    end,

    destroyFireball = function(self, dt)
        self:destroy()
    end,

    checkCollision = function(self)
        -- Destroy when out of bounds
        if self.position.x + self.sprites[1]:getWidth()  < 0 then self:destroyFireball() end
        if self.position.x > Push:getWidth() then self:destroyFireball() end
        if self.position.y + self.sprites[1]:getHeight() < 0 then self:destroyFireball() end
        if self.position.y > Push:getHeight() then self:destroyFireball() end


        local colls = World:getCollisions(self.collider)

        local ii,coll
        for ii, coll in pairs(colls) do
            if coll.type == "Player" then
                if Lume.find(self.hitList, coll) == nil then
                    table.insert(self.hitList, coll)
                    coll.instance:DoDamage(self.damage, self.position, self.knockback)
                end
            end
        end    
    end,

    update = function(self, dt)
        self.animation:update(dt)
        self:doMovement(dt)

        self.collider:setPosition(self.position)
        self:checkCollision()

    end,

    draw = function(self)
        local ox = self.sprites[1]:getWidth() / 2
        local oy = self.sprites[1]:getHeight() / 2
        self.animation:draw(self.position.x, self.position.y, 0, 1, 1, ox, oy)


        --love.graphics.setColor(Colors.blue)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
        --love.graphics.ellipse("fill", self.position.x, self.position.y, 5, 5)
    end,
}

return Fireball