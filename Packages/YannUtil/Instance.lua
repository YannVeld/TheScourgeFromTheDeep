InstanceManager = require "Packages.YannUtil.InstanceManager"

return Class{
    init = function(self, instanceID)
        --InstanceID is optional!
        self.zorder = 0
        InstanceManager.declare(self, instanceID)
    end,

    update = function(self, dt)
    end,

    draw = function(self)
    end,

    drawUI = function(self)
    end,

    mousereleased = function(self, x, y, button, istouch, presses)
    end,

    mousepressed = function(self, x, y, button, istouch, presses)
    end,

    keypressed = function(self, key, scancode, isrepeat)
    end,

    destroy = function(self)
        InstanceManager.remove(self)
        self=nil
    end,
}