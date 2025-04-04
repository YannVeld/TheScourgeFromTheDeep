SpriteLoading = require "Packages.YannUtil.SpriteLoading"

love.graphics.setDefaultFilter("nearest", "nearest", 1)
local Sprites = {}

Sprites = SpriteLoading.loadSpritesFromFolder("Sprites/Placeholder", Sprites)
Sprites = SpriteLoading.loadSpritesFromFolder("Sprites", Sprites)

return Sprites