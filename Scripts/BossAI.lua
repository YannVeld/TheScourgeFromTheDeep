
local BossAI = Class{
    bossActions = {walk=1, chase=2, firebreath=3, idle=4, firesword=5, roar=6},

    init = function(self, bossInstance, playerInstance)
        self.boss = bossInstance
        self.player = playerInstance

        self.timeUntilDecision = 0

        self.stage = 0
        self.AIAction = BossAI.bossActions.idle

        self.requestedState = self.boss.idleState
    end,

    updateContinuousTargetPosition = function(self)
        if self.AIAction == BossAI.bossActions.chase then
            self.boss.targetPosition = self.player.position
        end
        if self.AIAction == BossAI.bossActions.idle then
            self.boss.targetPosition = self.boss.position
        end
    end,

    interruptAction = function(self)
        -- Dont interrupt certain states
        if self.boss.state == self.boss.spawningState then return nil end
        if self.boss.state == self.boss.fireSwordState then return nil end
        if self.boss.state == self.boss.fireBreathState then return nil end
        if self.boss.state == self.boss.roarState then return nil end

        -- Firesword
        local vecToPlayer = self.player.position - self.boss.position
        local distToPlayer = vecToPlayer:len()
        local playerSide = Lume.sign( vecToPlayer.x )
        local lookingAtPlayer = playerSide == self.boss.lookDir

        local playerInRange = self.boss.fireSwordState:checkPlayerInRange()

        if playerInRange and lookingAtPlayer and self.boss.fireSwordState.canAttack then
            return BossAI.bossActions.firesword
        end

        return nil
    end,

    checkPreviousActionDone = function(self)
        if self.AIAction == BossAI.bossActions.walk then
            if self.boss.movementInterrupted then return true end
            if self.boss.walkingState.hasArrived then return true end
        end

        if self.AIAction == BossAI.bossActions.chase then
            if (self.boss.state == self.boss.walkingState) and self.boss.movementInterrupted then return true end
            if self.boss.walkingState.hasArrived then return true end
        end

        if self.AIAction == BossAI.bossActions.firebreath then
            if self.boss.fireBreathState.attackEnded then 
                return true
            else
                return false
            end
        end

        if self.AIAction == BossAI.bossActions.roar then
            if self.boss.roarState.attackEnded then 
                return true
            else
                return false
            end
        end

        if self.AIAction == BossAI.bossActions.firesword then
            if self.boss.fireSwordState.attackEnded then 
                return true
            else
                return false
            end
        end

        if self.timeUntilDecision <= 0 then
            return true
        end

        return false
    end,

    getNextAction = function(self)
        --return 3
        --local actionList = {BossAI.bossActions.idle, BossAI.bossActions.roar}

        -- Idle when previous action was breath or roar
        if (self.AIAction == BossAI.bossActions.firebreath) or (self.AIAction == BossAI.bossActions.roar) then
            return BossAI.bossActions.idle
        end

        local actionList
        if self.stage == 3 then
            actionList = {[BossAI.bossActions.idle] = 1,
                          [BossAI.bossActions.chase] = 1,
                          [BossAI.bossActions.firebreath] = 1,
                          [BossAI.bossActions.roar] = 1}
        end
        if self.stage == 2 then
            actionList = {[BossAI.bossActions.idle] = 2,
                          [BossAI.bossActions.walk] = 1,
                          [BossAI.bossActions.chase] = 1,
                          [BossAI.bossActions.firebreath] = 1,
                          [BossAI.bossActions.roar] = 1}
        end
        if self.stage == 1 then
            actionList = {[BossAI.bossActions.idle] = 1,
                          [BossAI.bossActions.walk] = 1,
                          [BossAI.bossActions.chase] = 1,
                          [BossAI.bossActions.firebreath] = 1}
        end
        if self.stage == 0 then
            actionList = {[BossAI.bossActions.idle] = 2,
                          [BossAI.bossActions.walk] = 2,
                          [BossAI.bossActions.firebreath] = 1,
                          [BossAI.bossActions.firesword] = 1}
        end

        local next = Lume.weightedchoice(actionList)
        while next == self.AIAction do
            next = Lume.weightedchoice(actionList)
        end

        return next
    end,

    doBossAI = function(self, dt)
        local interrupt = self:interruptAction()

        if interrupt == nil then
            if not self:checkPreviousActionDone() then return end
            self.AIAction = self:getNextAction()
        else
            self.AIAction = interrupt
        end

        -- Perform actions
        if self.AIAction == BossAI.bossActions.walk then
            --print("Walking")
            self.requestedState = self.boss.walkingState
            xpos = Lume.randomchoice({50, Push:getWidth()/2, Push:getWidth()-50})
            ypos = Lume.randomchoice({50,Push:getHeight()/2, Push:getHeight()-50})
            newpos = Vector(xpos, ypos)
            self.boss.targetPosition = newpos

            self.timeUntilDecision = 1
        end

        if self.AIAction == BossAI.bossActions.chase then
            --print("Chasing")
            self.requestedState = self.boss.walkingState
            self.boss.targetPosition = self.player.position
            self.timeUntilDecision = 4
        end

        if self.AIAction == BossAI.bossActions.firebreath then
            --print("Firebreath")
            self.requestedState = self.boss.fireBreathState
            self.timeUntilDecision = 2
        end

        if self.AIAction == BossAI.bossActions.idle then
            --print("Idle")
            self.requestedState = self.boss.idleState

            if self.stage == 0 then self.timeUntilDecision = 2 end
            if self.stage == 1 then self.timeUntilDecision = 1 end
            if self.stage == 2 then self.timeUntilDecision = 0.5 end
            if self.stage == 3 then self.timeUntilDecision = 0.5 end
        end

        if self.AIAction == BossAI.bossActions.firesword then
            --print("Firesword")
            self.requestedState = self.boss.fireSwordState
            self.timeUntilDecision = 2
        end

        if self.AIAction == BossAI.bossActions.roar then
            print("Roaring")
            self.requestedState = self.boss.roarState
            self.timeUntilDecision = 2
        end


        -- Follow mouse
        --local mouseX, mouseY = love.mouse.getPosition()
        --mouseX, mouseY = Push:toGame(mouseX, mouseY)
        --if (mouseX ~= nil) or (mouseY ~= nil) then
        --    self.targetPosition = Vector(mouseX, mouseY)
        --end
    end,

    getBossStage = function(self)
        if self.boss.state == self.boss.spawningState then return 0 end

        local healthFrac = self.boss.health / Boss.health

        if healthFrac < 0.25 then return 3 end
        if healthFrac < 0.5 then return 2 end
        if healthFrac < 0.75 then return 1 end
        return 0
    end,

    update = function(self, dt)
        self.timeUntilDecision = self.timeUntilDecision - dt

        self.stage = self:getBossStage()
        self:doBossAI(dt)

        self:updateContinuousTargetPosition()

        --print("Stage:", self.stage)
    end,
}

return BossAI