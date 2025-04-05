Instance = require "Packages.YannUtil.Instance"

local Player = Class{
    __includes = {Instance},

    maxSpeed = 500.0,
    clickAccel = 500.0,
    friction = 500.0,
    moveSpeed = 100.0,

    sprite = Sprites.Knight,

    init = function(self)
        Instance.init(self)

        self.position = Vector(0.0, 0.0)
        self.velocity = Vector(0.0, 0.0)
    end,

    boolToNumber = function(bool)
        return bool and 1 or 0
    end,

    move = function(self, dt)
        local verPress = - Player.boolToNumber(love.keyboard.isDown("w")) + Player.boolToNumber(love.keyboard.isDown("s"))
        local horPress = Player.boolToNumber(love.keyboard.isDown("d")) - Player.boolToNumber(love.keyboard.isDown("a"))

        -- Friction
        local acceleration = Vector(0,0)
        local normedVelocity = self.velocity:normalized()
        local frictionVec = Vector(0,0)
        frictionVec.x = - (1 - horPress) * normedVelocity.x * Player.friction
        frictionVec.y = - (1 - verPress) * normedVelocity.y * Player.friction
        acceleration = acceleration + frictionVec

        -- Change velocity
        if horPress ~= 0 then
            self.velocity.x = horPress * Player.moveSpeed
        end
        if verPress ~= 0 then
            self.velocity.y = verPress * Player.moveSpeed
        end

        self.velocity = self.velocity + acceleration * dt

        local speed = self.velocity:len()
        if speed > Player.maxSpeed then
            self.velocity = Vector(0,0)
        end

        -- Change position
        self.position = self.position + self.velocity * dt
    end,


    update = function(self, dt)
        self:move(dt)
    end,

    draw = function(self)
        love.graphics.draw(Player.sprite.image, self.position.x, self.position.y)
    end,

}

return Player