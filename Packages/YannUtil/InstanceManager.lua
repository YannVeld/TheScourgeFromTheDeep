Lume = require("Packages/lume/lume")

InstanceManagerClass = Class{
    init = function(self)
        if InstanceManager ~= nil then
            error("Cannot initialize the InstanceManager class twice!")
        end
        self.list = {}
    end,

    declare = function(instance, instanceID)
        if instanceID == nil then 
            instanceID = #InstanceManager.list + 1
        end

        table.insert(InstanceManager.list, instanceID, instance)
    end,

    remove = function(instance)
        Lume.remove(InstanceManager.list, instance)
    end,

    update = function(dt)
        for i,instance in ipairs(InstanceManager.list) do
            instance:update(dt)
        end
    end,

    draw = function()
        for i,instance in ipairs(InstanceManager.list) do
            instance:draw()
        end
    end,

    drawUI = function()
        for i,instance in ipairs(InstanceManager.list) do
            instance:drawUI()
        end
    end,

    mousereleased = function(x, y, button, istouch, presses)
        for i,instance in ipairs(InstanceManager.list) do
            instance:mousereleased(x, y, button, istouch, presses)
        end
    end,

    mousepressed = function(x, y, button, istouch, presses)
        for i,instance in ipairs(InstanceManager.list) do
            instance:mousepressed(x, y, button, istouch, presses)
        end
    end,

    removeAll = function()
        Lume.clear(InstanceManager.list)
    end,
}

InstanceManager = InstanceManagerClass()
return InstanceManager