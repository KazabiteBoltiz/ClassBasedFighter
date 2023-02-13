local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Knit = require(Packages.Knit)

local ServerS = game:GetService('ServerScriptService')
local Modules = RepS.Modules
local StateMachine = require(Modules.StateMachine)

local Battle = Knit.CreateService{
    Name = 'Battle',

    Client = {
        OnAttack = Knit.CreateSignal(), 
        AbilityLog = Knit.CreateProperty(),
    }
}

function Battle:KnitInit()        
    self.StateMachines = {}
end

function Battle:KnitStart()

    local FighterUpdate = Knit.GetService('FighterUpdate')
    local FighterModules = ServerS.FighterModules

    local function onFighterChanged(plr, fighterClass)

        print('Player ('..plr.Name..') Is Now A', fighterClass..'!')

        if self.StateMachines[plr.UserId] then
            self.StateMachines[plr.UserId]:Destroy()
        end

        self.Client.AbilityLog:ClearFor(plr)
        self.StateMachines[plr.UserId] = {}

        StateMachine.Create(
            FighterModules:WaitForChild(fighterClass),
            self.StateMachines[plr.UserId],
            'Idle'
        )

        local function onStateChanged(newState)
            local abilityLog = self.Client.AbilityLog:GetFor(plr)
            table.insert(abilityLog, newState)
            self.Client.AbilityLog:SetFor(plr, abilityLog)
        end

        self.StateMachines[plr.UserId].StateChanged:Connect(onStateChanged)

    end
        
    FighterUpdate.FighterChanged:Connect(onFighterChanged)
    
end

return Battle