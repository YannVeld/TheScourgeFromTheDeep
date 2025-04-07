
Instance = require "Packages.YannUtil.Instance"

local TutorialGate = Class{
    __includes = {Instance},

    spriteSheet = Sprites.Gate,
    animSpeed = 10,

    init = function(self, player, position)
        Instance.init(self)

        self.player = player
        self.position = position
        
        self.sprites = SpriteLoading.getSpritesFromSpriteSheet(TutorialGate.spriteSheet, 37, 40, 0, 0)
        self.openAnimation = Animation(self.sprites, 0, 1, false)

        self.gateIsOpen = false

        local myColliderRect = Rectangle(self.position + Vector(0,32), 37, 12)
        self.collider = Collider({myColliderRect}, self.position, "GateCollider", self)
    end,

    CheckPlayerAtGate = function(self)
        return self.collider:checkCollision(self.player.hitbox) 
    end,

    OpenGate = function(self)
        self.gateIsOpen = true
        self.openAnimation:setAnimationSpeed(TutorialGate.animSpeed)
    end,

    update = function(self, dt)
        self.openAnimation:update(dt)
    end,

    draw = function(self)
        self.openAnimation:draw(self.position.x, self.position.y)

        --love.graphics.setColor(Colors.blue)
        --self.collider:draw()
        --love.graphics.setColor(Colors.white)
    end,
}

return TutorialGate