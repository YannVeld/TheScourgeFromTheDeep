
Rectangle = Class{
    init = function(self, position, width, height)
        self.position = position
        self.width = width
        self.height = height
    end,

    setPosition = function(self, position) self.position = position end,
    setWidth = function(self, width) self.width = width end,
    setHeight = function(self, height) self.height = height end,

    getWidth = function(self) return self.width end,
    getHeight = function(self) return self.height end,

    getLeftEdge = function(self) return self.position.x end,
    getRightEdge = function(self) return self.position.x + self.width end,
    getTopEdge = function(self) return self.position.y end,
    getBottomEdge = function(self) return self.position.y + self.height end,

    getTopLeft = function(self) return self.position + Vector(0, 0) end,
    getTopRight = function(self) return self.position + Vector(self.width, 0) end,
    getBottomLeft = function(self) return self.position + Vector(0, self.height) end,
    getBottomRight = function(self) return self.position + Vector(self.width, self.height) end,
    getCenter = function(self) return self.position + Vector(self.width/2, self.height/2) end,

    checkOverlap = function(self, other)
        if other:getLeftEdge() > self:getRightEdge() then
            return false
        end
        if other:getRightEdge() < self:getLeftEdge() then
            return false
        end
        if other:getTopEdge() > self:getBottomEdge() then
            return false
        end
        if other:getBottomEdge() < self:getTopEdge() then
            return false
        end
        return true
    end,

    draw = function(self, mode, ...)
        if mode == nil then mode = 'line' end
        local args = {...}

        love.graphics.rectangle(mode, self.position.x, self.position.y, self.width, self.height, unpack(args))
    end,
}