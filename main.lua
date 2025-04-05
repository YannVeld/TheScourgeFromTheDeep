require("Packages")
Sprites = require("Sprites")

local InstanceManager = require "Packages.YannUtil.InstanceManager"

local Gamestate_thegame = require("GameStates/thegame")
local initialGameState = Gamestate_thegame

local camera, instanceManager


local gameWidth, gameHeight = 480, 270
--local windowWidth, windowHeight = 960, 540
--local windowWidth, windowHeight = 1440, 810
local windowWidth, windowHeight = 1920, 1080

function love.load()
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, pixelperfect = true})

    love.math.setRandomSeed(love.timer.getTime())
    math.randomseed(love.timer.getTime())
    camera = Camera()
    Gamestate.registerEvents()
    Gamestate.switch(initialGameState)
end

function love.update(dt)
    InstanceManager.update(dt)
    Timer.update(dt)
end

function love.draw()
    Push:start()
    camera:attach()
    InstanceManager.draw()
    camera:detach()
    InstanceManager.drawUI()
    Push:finish()
end

function love.mousepressed(x, y, button, istouch, presses)
    InstanceManager.mousepressed(x, y, button, istouch, presses)
end