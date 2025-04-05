
Player = require("Scripts/Player")
Barrel = require("Scripts/Barrel")


local thegame = {}

local player

function thegame:enter()
    player = Player()

    barrel1 = Barrel(Vector(64, 80))
    barrel2 = Barrel(Vector(20, 96))
    barrel3 = Barrel(Vector(120, 20))
end

function thegame:update(dt)
end

function thegame:draw()
    love.graphics.setBackgroundColor(102/255, 89/255, 100/255, 1)

end

function thegame:keypressed( key, scancode, isrepeat )
    if key == "escape" then
        love.event.quit()
        return
    end
    if key == "r" then
        InstanceManager:removeAll()
        love.load()
        return
    end
end

return thegame