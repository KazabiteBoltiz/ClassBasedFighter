local Idle = {}

function Idle.new(mod)
    local self = setmetatable({}, Idle)

    self.mod = mod

    return self
end

function Idle:Start()
    print('Idle Began!')
end

function Idle:End()
    print('Idle Ended!')
end

return Idle