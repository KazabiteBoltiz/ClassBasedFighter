local RepS = game.ReplicatedStorage
local Modules = RepS.Modules
local StateMachine = require(Modules.StateMachine)

local Exile = {}

function Exile.new(mod)
    local self = setmetatable({}, Exile)

    self.mod = mod
    StateMachine.Create(script, self, 'Parry')

    return self
end

function Exile:Start()
    print('Exile Began!')
    self.mod:ChangeState('Idle')
end

function Exile:End()
    print('Exile Ended!')
end

return Exile