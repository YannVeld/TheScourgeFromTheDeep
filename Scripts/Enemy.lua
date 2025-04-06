
Instance = require "Packages.YannUtil.Instance"

local Enemy = Class{
    __includes = {Instance},

    init = function(self, position, health)
        Instance.init(self)

        self.position = position
        self.health = health
        self.isDead = false
        self.damagedTime = -10
        self.time = 0
    end,

    DoDamage = function(self, amount)
        self.health = self.health - amount
        self.damagedTime = self.time

        if self.health <= 0 then
            self.health = 0
            self.isDead = true
        end
    end,

    update = function(self, dt)
        self.time = self.time + dt
    end,
}

return Enemy