-- local RepS = game.ReplicatedStorage
-- local Packages = RepS.Packages
-- local Timer = require(Packages.Timer)

local Incision = {}

function Incision.new(mod)
    local self = setmetatable({}, Incision)

    self.mod = mod
    self.Battle = self.mod.BattleServer
    self.myTrove = mod.StateTrove

    return self
end

function Incision:Start()
    print('Incision Began!')
    self.mod:ChangeState('Idle')
end

function Incision:End()
    print('Incision Ended!')
end

return Incision