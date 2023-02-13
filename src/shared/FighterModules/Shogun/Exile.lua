local Exile = {}

function Exile.new(mod)
    local self = setmetatable({}, Exile)

    self.mod = mod

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