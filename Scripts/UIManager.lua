
Instance = require "Packages.YannUtil.Instance"

local UIManager = Class{
    __includes = {Instance},

    healthMeterSprite = Sprites.HealthMeter,
    healthMeterContentSprite = Sprites.HealthMeter_content,

    dashMeterSprite = Sprites.DashMeter,
    dashMeterContentSprite = Sprites.DashMeter_content,

    bossHealthMeterSprite = Sprites.BossHealthMeter,
    bossHealthMeterContentSprite = Sprites.BossHealthMeter_content,

    init = function(self, player, boss)
        Instance.init(self)

        self.player = player
        self.boss = boss

        self.zorder = 999999

        self.healthMeterPos = Vector(Push:getWidth()-20, 3)
        self.dashMeterPos = Vector(Push:getWidth()-30, 3)
        self.bossHealthMeterPos = Vector(Push:getWidth()/2 - UIManager.bossHealthMeterSprite:getWidth()/2, 3)


        self.healthShader = love.graphics.newShader("Shaders/healthBarVertical.glsl")
        self.healthShader:send("frac", 1.0)
        self.healthShader:send("topBound", 0.2)
        self.healthShader:send("bottomBound", 1.0)
        self.dashShader = love.graphics.newShader("Shaders/healthBarVertical.glsl")
        self.dashShader:send("frac", 1.0)
        self.dashShader:send("topBound", 0.3)
        self.dashShader:send("bottomBound", 1.0)
        if self.boss ~= nil then
            self.bossHealthShader = love.graphics.newShader("Shaders/healthBarHorizontal.glsl")
            self.bossHealthShader:send("frac", 1.0)
            self.bossHealthShader:send("rightBound", 1.0)
            self.bossHealthShader:send("leftBound", 0.211)
        end
    end,

    update = function(self, dt)
        healthFrac = 1.0 - self.player.health / Player.health
        healthFrac = Lume.clamp(healthFrac, 0.0, 1.0)
        self.healthShader:send("frac", healthFrac)

        dashFrac = 1.0 - self.player.dashingState.timeSinceExit / DashingState.dashCooldown
        dashFrac = Lume.clamp(dashFrac, 0.0, 1.0)
        self.dashShader:send("frac", dashFrac)

        if self.boss ~= nil then
            bossHealthFrac = self.boss.health / Boss.health 
            bossHealthFrac = Lume.clamp(bossHealthFrac, 0.0, 1.0)
            self.bossHealthShader:send("frac", bossHealthFrac)
        end
    end,

    draw = function(self)
        -- Meter sprites
        UIManager.healthMeterSprite:draw(self.healthMeterPos.x, self.healthMeterPos.y)
        UIManager.dashMeterSprite:draw(self.dashMeterPos.x, self.dashMeterPos.y)
        if (self.boss ~= nil) and (not self.boss.isDead) then
            UIManager.bossHealthMeterSprite:draw(self.bossHealthMeterPos.x, self.bossHealthMeterPos.y)
        end

        -- Content
        love.graphics.setShader(self.healthShader)
        UIManager.healthMeterContentSprite:draw(self.healthMeterPos.x, self.healthMeterPos.y)
        love.graphics.setShader(self.dashShader)
        UIManager.dashMeterContentSprite:draw(self.dashMeterPos.x, self.dashMeterPos.y)
        love.graphics.setShader(self.bossHealthShader)
        if (self.boss ~= nil) and (not self.boss.isDead) then
            UIManager.bossHealthMeterContentSprite:draw(self.bossHealthMeterPos.x, self.bossHealthMeterPos.y)
        end
        love.graphics.setShader()
    end,
}

return UIManager