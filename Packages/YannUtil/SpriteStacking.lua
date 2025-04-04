SpriteLoading = require "Packages.YannUtil.SpriteLoading"

return Class{
    init = function(self, spriteSheet, sizeHor, sizeVer, spacingHor, spacingVer, stackStartInd, stackEndInd)
        self._spriteSheet = spriteSheet
        self._sizeHor = sizeHor
        self._sizeVer = sizeVer
        if spacingHor then self._spacingHor = spacingHor else self._spacingHor = 0 end
        if spacingVer then self._spacingVer = spacingVer else self._spacingVer = 0 end

        self._quads = SpriteLoading.getQuadsFromSpriteSheet(self._spriteSheet, self._sizeHor, self._sizeVer, self._spacingHor, self._spacingVer)

        if stackStartInd then self._stackStartInd = stackStartInd else self._stackStartInd = 1 end
        if stackEndInd then self._stackEndInd = stackEndInd else self._stackEndInd = #self._quads end
    end,

    draw = function(self, x, y, r, sx, sy, ox, oy, kx, ky)
        for i=self._stackStartInd,self._stackEndInd do
            local stackedy = y - (i - self._stackStartInd)
            love.graphics.draw(self._spriteSheet, self._quads[i], x, stackedy, r, sx, sy, ox, oy, kx, ky)
        end
    end,

    getWidth = function(self)
        return self._sizeHor
    end,
    getHeight = function(self)
        return self._sizeVer
    end,
    getQuads = function(self)
        return self._quads
    end,
}