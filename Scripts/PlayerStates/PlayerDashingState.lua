
DashingState = Class{

    dashSpeed = 300, 
    exitSpeed = 200,
    dashDistance = 64,
    dashCooldown = 0.5,

    sprite = Sprites.Knight_dash,
    spriteOffsetHor = -1,
    spriteOffsetVer = -1,

    init = function(self, playerInstance)
        self.player = playerInstance
        self.dashEnded = true
        self.canDash = true
        self.timeSinceExit = 0
    end,

    enter = function(self)
        self.canDash = false
        self.timeSinceEnter = 0
        self.dashEnded = false

        local speed = self.player.velocity:len()

        if speed < 10.0 then
            self.player.velocity.y = 0
            self.player.velocity.x = self.player.lookDir * DashingState.dashSpeed
        else
            self.player.velocity = self.player.velocity:normalized() * DashingState.dashSpeed
        end

        self.player.dashSound:play()
    end,

    checkEndDash = function(self)
        local timeOver = DashingState.dashSpeed * self.timeSinceEnter > DashingState.dashDistance

        local standingStill = false
        local speed = self.player.velocity:len()
        if speed < 10.0 then standingStill = true end

        return timeOver or standingStill
    end,


    update = function(self, dt)
        self.timeSinceEnter = self.timeSinceEnter + dt
        self.dashEnded = self:checkEndDash()
    end,

    passiveUpdate = function(self, dt)
        if self.player.state == self.player.dashingState then
            return
        end

        if self.timeSinceExit > DashingState.dashCooldown then
            self.canDash = true
        else
            self.timeSinceExit = self.timeSinceExit + dt
        end

        if not self.canDash then
            self.player.inputManager:resetDashPress()
        end
    end,

    exit = function(self)
        self.timeSinceExit = 0
        self.player.velocity = self.player.velocity:normalized() * DashingState.exitSpeed
    end,

    draw = function(self)
        local ox = self.sprite:getWidth() / 2 + DashingState.spriteOffsetHor
        local oy = self.sprite:getHeight() / 2 + DashingState.spriteOffsetVer
        self.sprite:draw(self.player.position.x, self.player.position.y, 
                         0, self.player.lookDir, 1, ox, oy)
    end,
}

return DashingState