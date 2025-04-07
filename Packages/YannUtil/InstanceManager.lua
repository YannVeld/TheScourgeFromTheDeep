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
        instance.zorder = #InstanceManager.list

        table.insert(InstanceManager.list, instanceID, instance)
    end,

    remove = function(instance)
        instance:onDestroy()
        Lume.remove(InstanceManager.list, instance)
    end,

    update = function(dt)
        for i,instance in ipairs(InstanceManager.list) do
            instance:update(dt)
        end
    end,

    draw = function()
        -- Order on zorder
        local function drawSort(a,b) return a.zorder < b.zorder end
        table.sort(InstanceManager.list, drawSort)

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

    keypressed = function(key, scancode, isrepeat)
        for i,instance in ipairs(InstanceManager.list) do
            instance:keypressed(key, scancode, isrepeat)
        end
    end,

    removeAll = function()
        local ii
        for ii=#InstanceManager.list,1,-1 do
            local instance = InstanceManager.list[ii]
            InstanceManager.remove(instance)
        end
    end,
}

InstanceManager = InstanceManagerClass()
return InstanceManager