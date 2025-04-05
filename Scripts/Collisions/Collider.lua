
Collider = Class{
    init = function(self, rectangles, position, type, instance)
        if type == nil then type = "None" end

        self.rectangles = rectangles
        self.position = position
        self.type = type
        self.instance = instance
    end,

    setPosition = function(self, position)
        local ii, rect

        for ii, rect in pairs(self.rectangles) do
            local relPos = rect.position - self.position
            rect.position = position + relPos
        end
        self.position = position
    end,

    checkCollision = function(self, other)
        local ii,jj,rect1,rect2
        for ii, rect1 in pairs(self.rectangles) do
            for jj, rect2 in pairs(other.rectangles) do
                local coll = rect1:checkOverlap(rect2)
                if coll then return true end
            end
        end
        return false
    end,

    draw = function(self, mode, ...)
        if mode == nil then mode = 'line' end
        local args = {...}

        for ii, rect in pairs(self.rectangles) do
            rect:draw(mode, unpack(args))
        end
    end,
}