Instance = require "Packages.YannUtil.Instance"
Enemy = require "Scripts.Enemy"

local Barrel = Class{
    __includes = {Enemy},

    health = 10.0,
    spriteSheet = Sprites.Barrel,
    animSpeed = 10,

    shadowRadiusx = 8,
    shadowRadiusy = 4,
    shadowOffsetx = -0.5,
    shadowOffsety = 4,

    init = function(self, position)
        Enemy.init(self, position, Barrel.health)

        self.animationSpeed = 0
        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(Barrel.spriteSheet, 32, 32, 0, 0)
        self.breakingAnimation = Animation(self.sprites, self.animationSpeed, 1, false)

        local rectPos = self.position - Vector(4,2)
        local myRect = Rectangle(rectPos, 7, 5)
        self.collider = Collider({myRect}, self.position, "Barrel")
        World:add(self.collider)
    end,

    update = function(self, dt)
        Enemy.update(self, dt)

        self.breakingAnimation:update(dt)

        if self.breakingAnimation.animationDone then
            self:destroy()
        end

        self.zorder = self.position.y
    end,

    drawShadow = function(self)
        love.graphics.setColor(68/255,56/255,70/255,1)
        love.graphics.ellipse('fill', self.position.x + Barrel.shadowOffsetx, self.position.y + Barrel.shadowOffsety, Barrel.shadowRadiusx, Barrel.shadowRadiusy)
        love.graphics.setColor(Colors.white)
    end,

    draw = function(self)
        self:drawShadow()

        local ox = self.sprites[1]:getWidth() / 2
        local oy = self.sprites[1]:getHeight() / 2
        self.breakingAnimation:draw(self.position.x, self.position.y, 0, 1, 1, ox, oy)

        --love.graphics.setColor(Colors.red)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return Barrel