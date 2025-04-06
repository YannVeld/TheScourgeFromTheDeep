
ColliderWorld = Class{
    init = function(self)
        self.colliders = {}
    end,

    add = function(self, collider)
        table.insert(self.colliders, collider)
    end,

    remove = function(self, collider)
        local index = Lume.find(self.colliders, collider)
        if index == nil then return end
        table.remove(self.colliders, index)
    end,

    checkCollision = function(self, collider)
        local ii, other, coll

        for ii,other in pairs(self.colliders) do
            if not (other == collider) then
                coll = collider:checkCollision(other)
                if coll then return true end
            end
        end
        return false
    end,

    getCollisions = function(self, collider)
        local ii, other, coll

        local collisions = {}

        for ii,other in pairs(self.colliders) do
            if not (other == collider) then
                coll = collider:checkCollision(other)
                if coll then
                    table.insert(collisions, other)
                end
            end
        end

        return collisions
    end,
}