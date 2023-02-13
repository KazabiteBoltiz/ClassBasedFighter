local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Timer = require(Packages.Timer)

local Modules = RepS.Modules
local Hitbox = require(Modules.Hitbox)

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

    local myOverlap = OverlapParams.new()
    myOverlap.FilterDescendantsInstances = {}
    myOverlap.FilterType = Enum.RaycastFilterType.Blacklist

    local myHitbox = Hitbox.new(Vector3.new(0,5,0), Vector3.new(5,5,5), myOverlap)
    self.myTrove:Add(myHitbox, 'Destroy')

    local Anim = Instance.new('Animation')
    Anim.AnimationId = "rbxassetid://11151865873"
    
    local AnimTrack = self.mod.hum:LoadAnimation(Anim)
    AnimTrack:Play()

    self.Battle.OnAttack:Fire('Incision')

    self.myTrove:Add(AnimTrack, 'Stop')

    local endTimer = Timer.new(2)
    endTimer.Tick:ConnectOnce(function()
        self.mod:ChangeState('Idle')
    end)
    endTimer:Start()

    self.myTrove:Add(endTimer, 'Destroy')
end

function Incision:End()
    print('Incision Ended!')
end

return Incision