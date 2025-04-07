
Player = require("Scripts/Player")
Boss = require("Scripts/Boss")
Barrel = require("Scripts/Barrel")

UIManager = require("Scripts/UIManager")
EndScreenManager = require("Scripts/EndScreenManager")
SceneTransitionManager = require("Scripts/SceneTransitionManager")


local thegame = {}
local player
local boss
local uiManager

local startedTransition
local pressedRestart

function thegame:enter()
    player = Player(Vector(26, 74))
    boss = Boss(Vector(Push:getWidth()-40, 90), player)

    uiManager = UIManager(player, boss)
    endScreenManager = EndScreenManager()
    sceneTransitionManager = SceneTransitionManager()


    local barrelPos = {Vector(22,47), Vector(12,112), Vector(44,124), Vector(235,120), Vector(230,102), Vector(222,66)}
    local ii
    for ii,pos in pairs(barrelPos) do
        Barrel(pos)
    end


    --barrel1 = Barrel(Vector(64, 110))
    --barrel2 = Barrel(Vector(20, 80))
    --barrel3 = Barrel(Vector(120, 50))

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

    startedTransition = false
    pressedRestart = false
end

local function PlayMusic()
    if TutorialMusicSource:isPlaying() then return end
    if BossMusicSource:isPlaying() then return end

    BossMusicSource:play()
end

local function ToNextScene()
    if not pressedRestart then return end

    if startedTransition and (not sceneTransitionManager.inTransition) then
        InstanceManager:removeAll()
        SwitchGameState("Tutorial")
        return
    end

    sceneTransitionManager:DoFadeOut()
    startedTransition = true
end


function thegame:update(dt)
    PlayMusic()
    endScreenManager:update(dt)
    ToNextScene()

    if player.isDead then
        endScreenManager:showEndScreen(false)

        if endScreenManager.alpha >= 1 then
            boss:destroySelf()
        end
    end
    if boss.isDead then
        endScreenManager:showEndScreen(true)
    end
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
        pressedRestart = true
        --InstanceManager:removeAll()
        --SwitchGameState("Tutorial")
        return
    end
end

return thegame