
Player = require("Scripts/Player")
Boss = require("Scripts/Boss")
Barrel = require("Scripts/Barrel")



local thegame = {}
local player


function thegame:enter()
    player = Player(Vector(50, 50))
    boss = Boss(Vector(150, 50), player)

    barrel1 = Barrel(Vector(64, 110))
    barrel2 = Barrel(Vector(20, 80))
    barrel3 = Barrel(Vector(120, 50))

    local gameWidth = Push:getWidth()
    local gameHeight = Push:getHeight()
    local topEdgeOffset = 34

    local rectTop = Rectangle(Vector(-10,-10+topEdgeOffset), gameWidth+20, 10)
    local rectBottom = Rectangle(Vector(-10,gameHeight), gameWidth+20, 10)
    local rectLeft = Rectangle(Vector(-10,-10), 10, gameHeight+20)
    local rectRight = Rectangle(Vector(gameWidth,-10), 10, gameHeight+20)

    local edgeCollider = Collider({rectTop, rectBottom, rectLeft, rectRight}, Vector(0,0), "GameEdge", nil)
    World:add(edgeCollider)

    local bossTopEdgeOffset = 40
    local bossRectTop = Rectangle(Vector(-10,-10+bossTopEdgeOffset), gameWidth+20, 10)
    local bossEdgeCollider = Collider({bossRectTop, rectBottom, rectLeft, rectRight}, Vector(0,0), "BossGameEdge", nil)
    World:add(bossEdgeCollider)
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