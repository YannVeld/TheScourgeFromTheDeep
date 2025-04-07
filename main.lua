require("Packages")
Sprites = require("Sprites")
require("Fonts")

local InstanceManager = require "Packages.YannUtil.InstanceManager"
require "Scripts.Collisions.Rectangle"
require "Scripts.Collisions.Collider"
require "Scripts.Collisions.ColliderWorld"

local Gamestate_thegame = require("GameStates/thegame")
local Gamestate_thetutorial = require("GameStates/thetutorial")
local initialGameState = Gamestate_thetutorial
--local initialGameState = Gamestate_thegame

local camera, instanceManager


local gameWidth, gameHeight = 240, 135
--local gameWidth, gameHeight = 480, 270

--local windowWidth, windowHeight = 960, 540
--local windowWidth, windowHeight = 1440, 810
local windowWidth, windowHeight = 1920, 1080

local backgroundSprite = Sprites.Background


SoundsVolume = 0.5
MusicVolume = 0.25

function love.load()
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, pixelperfect = true})
    Shack:setDimensions(Push:getDimensions())

    World = ColliderWorld()

    love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())
    camera = Camera()
    Gamestate.registerEvents()
    Gamestate.switch(initialGameState)

    -- Setup font
    Fonts.m3x6:setLineHeight(0.7)
    love.graphics.setFont(Fonts.m3x6)

    -- Music
    SetupGameMusic()
end

function SetupGameMusic()
    TutorialMusicSource = love.audio.newSource("Music/LD57MusicTutorial.wav", "stream")
    --TutorialMusicSource:setLooping(true)
    TutorialMusicSource:setVolume(MusicVolume)

    BossMusicSource = love.audio.newSource("Music/LD57Music.wav", "stream")
    --BossMusicSource:setLooping(true)
    BossMusicSource:setVolume(MusicVolume)

end

function SwitchGameState(tostate)
    if tostate == "Game" then
        InstanceManager:removeAll()
        Gamestate.switch(Gamestate_thegame)
    end
    if tostate == "Tutorial" then
        InstanceManager:removeAll()
        Gamestate.switch(Gamestate_thetutorial)
    end
end

function love.update(dt)
    Shack:update(dt)
    InstanceManager.update(dt)
    Timer.update(dt)
end

function love.draw()
    Push:start()
    Shack:apply()

    backgroundSprite:draw(0,0)

    camera:attach()
    InstanceManager.draw()
    camera:detach()
    InstanceManager.drawUI()
    Push:finish()
end

function love.mousepressed(x, y, button, istouch, presses)
    InstanceManager.mousepressed(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isrepeat)
    InstanceManager.keypressed(key, scancode, isrepeat)
end