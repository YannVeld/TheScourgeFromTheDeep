
Instance = require "Packages.YannUtil.Instance"

local Enemy = Class{
    __includes = {Instance},

    init = function(self, position, health)
        Instance.init(self)

        self.position = position
        self.health = health
    end,
}

return Enemy