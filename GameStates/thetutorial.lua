
Player = require("Scripts/Player")
Barrel = require("Scripts/Barrel")


UIManager = require("Scripts/UIManager")
TutorialUIManager = require("Scripts/TutorialUIManager")
TutorialGate = require("Scripts/TutorialGate")
SceneTransitionManager = require("Scripts/SceneTransitionManager")

local thetutorial = {}
local player
local uiManager

local startedTransition


function thetutorial:enter()
    player = Player(Vector(26, 74))

    uiManager = UIManager(player)
    tutorialuiManager = TutorialUIManager(player)
    tutorialGate = TutorialGate(player, Vector(85,0))
    sceneTransitionManager = SceneTransitionManager()

    local barrelPos = {Vector(11,53), Vector(28,45), Vector(17,106), Vector(40,104), Vector(31,121), 
                       Vector(106,120), Vector(133,124), Vector(198,123), Vector(223,126), Vector(225,97),
                       Vector(215,63), Vector(188,51)}
    local ii
    for ii,pos in pairs(barrelPos) do
        Barrel(pos)
    end

    local gameWidth = Push:getWidth()
    local gameHeight = Push:getHeight()
    local topEdgeOffset = 34

    local rectTop = Rectangle(Vector(-10,-10+topEdgeOffset), gameWidth+20, 10)
    local rectBottom = Rectangle(Vector(-10,gameHeight), gameWidth+20, 10)
    local rectLeft = Rectangle(Vector(-10,-10), 10, gameHeight+20)
    local rectRight = Rectangle(Vector(gameWidth,-10), 10, gameHeight+20)

    local edgeCollider = Collider({rectTop, rectBottom, rectLeft, rectRight}, Vector(0,0), "GameEdge", nil)
    World:add(edgeCollider)

    startedTransition = false
end

local function PlayMusic()
    if TutorialMusicSource:isPlaying() then return end
    if BossMusicSource:isPlaying() then return end

    TutorialMusicSource:play()
end

local function OpenGate()
    if tutorialuiManager.endedTutorial then
        tutorialGate:OpenGate()
    end
end

local function ToNextScene()
    if not tutorialGate.gateIsOpen then return end

    if startedTransition and (not sceneTransitionManager.inTransition) then
        SwitchGameState("Game")
        return
    end

    if tutorialGate:CheckPlayerAtGate() then
        sceneTransitionManager:DoFadeOut()
        startedTransition = true
    end
end

function thetutorial:update(dt)
    PlayMusic()
    OpenGate()
    ToNextScene()

    if player.isDead then
        endScreenManager:showEndScreen(false)
    end
end

function thetutorial:draw()
    love.graphics.setBackgroundColor(102/255, 89/255, 100/255, 1)
end

function thetutorial:keypressed( key, scancode, isrepeat )
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

return thetutorial