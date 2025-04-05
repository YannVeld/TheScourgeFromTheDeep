
Instance = require "Packages.YannUtil.Instance"

local Enemy = Class{
    __includes = {Instance},

    init = function(self, position, health)
        Instance.init(self)

        self.position = position
        self.health = health
        self.isDead = false
    end,

    DoDamage = function(self, amount)
        self.health = self.health - amount

        if self.health <= 0 then
            self.health = 0
            self.isDead = true
        end
    end,
}

return Enemy