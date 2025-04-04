require("Packages")
Sprites = require("Sprites")

local InstanceManager = require "Packages.YannUtil.InstanceManager"

local Gamestate_thegame = require("GameStates/thegame")
local initialGameState = Gamestate_thegame

local camera, instanceManager

function love.load()
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
    camera:attach()
    InstanceManager.draw()
    camera:detach()
    InstanceManager.drawUI()
end

function love.mousepressed(x, y, button, istouch, presses)
    InstanceManager.mousepressed(x, y, button, istouch, presses)
end