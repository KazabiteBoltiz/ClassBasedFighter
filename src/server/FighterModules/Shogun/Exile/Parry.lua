local RepS = game.ReplicatedStorage
local Modules = RepS.Modules
local StateMachine = require(Modules.StateMachine)

local Parry = {}

function Parry.new(mod)
    local self = setmetatable({}, Parry)

    self.mod = mod
    StateMachine.Create(script, self, 'Parry')

    return self
end

function Parry:Start()
    print('Parry Began!')
    self.mod:ChangeState('Idle')
end

function Parry:End()
    print('Parry Ended!')
end

return Parry