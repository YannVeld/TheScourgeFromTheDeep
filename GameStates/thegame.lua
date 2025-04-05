
Player = require("Scripts/Player")


local thegame = {}

local player

function thegame:enter()
    player = Player()
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
end

return thegame