local Sprite = Class{
    init = function(self, imageData, image, quad)
        self.imageData = imageData
        self.image = image
        if quad then self.quad = quad else self.quad = nil end


    end,

    getWidth = function(self) 
        if self.quad == nil then
            return self.image:getWidth()
        else
            local quadx, quady, quadw, quadh = self.quad:getViewport()
            return quadw
        end
    end,
    getHeight = function(self)
        if self.quad == nil then
            return self.image:getHeight()
        else    
            local quadx, quady, quadw, quadh = self.quad:getViewport()
            return quadh
        end
    end,

    getPixel = function(self, x, y)
        local quadx, quady, quadw, quadh = self.quad:getViewport()
        local imagePosx = quadx + x
        local imagePosy = quady + y
        return self.imageData:getPixel(imagePosx, imagePosy)
    end,

    draw = function(self, ...)
        local args = {...}

        if self.quad == nil then
            return love.graphics.draw(self.image, unpack(args))
        else
            return love.graphics.draw(self.image, self.quad, unpack(args))
        end
    end,
}

function loadSpritesFromFolder(folder, spriteList)
    local filenames = love.filesystem.getDirectoryItems(folder)

    for i,file in ipairs(filenames) do
        local splitted = Lume.split(file, ".")
        local name = splitted[1]
        local extension = splitted[#splitted]

        if (extension == "png") then
            local spriteData = love.image.newImageData(folder .. "/" .. file)
            local sprite = love.graphics.newImage(spriteData)

            if spriteList[name] then
                print("WARNING: Sprite name \"" .. name .. "\" already exists!")
            end

            spriteList[name] = Sprite(spriteData, sprite)
        end
    end

    return spriteList
end

function getSpritesFromSpriteSheet(spriteSheet, sizeHor, sizeVer, spacingHor, spacingVer)
    if not spacingHor then spacingHor = 0 end
    if not spacingVer then spacingVer = 0 end

    numx = math.ceil(spriteSheet:getWidth() / (sizeHor + spacingHor))
    numy = math.ceil(spriteSheet:getHeight() / (sizeVer + spacingVer))

    totalNum = numx * numy
    sprites = {}

    for j=1,numy do
        posy = (j-1)*(sizeVer + spacingVer)

        for i=1,numx do
            posx = (i-1)*(sizeHor + spacingHor)
            
            quad = love.graphics.newQuad(posx, posy, sizeHor, sizeVer, spriteSheet.image)

            arrIndex = i + numx*(j-1)
            --sprites[arrIndex] = quad
            sprites[arrIndex] = Sprite(spriteSheet.imageData, spriteSheet.image, quad)
        end
    end

    return sprites
end


-- the module
return setmetatable({
	loadSpritesFromFolder = loadSpritesFromFolder,
    getSpritesFromSpriteSheet = getSpritesFromSpriteSheet,
}, {
	__call = function(_, ...) return new(...) end
})

