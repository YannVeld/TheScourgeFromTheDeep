
Player = require("Instances/Player")


local thegame = {}

local player

function thegame:enter()
    player = Player()
end

function thegame:update(dt)
end

function thegame:draw()
end

function thegame:keypressed( key, scancode, isrepeat )
    if key == "escape" then
        love.event.quit()
        return
    end
end

return thegame