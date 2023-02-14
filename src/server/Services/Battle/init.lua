local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Knit = require(Packages.Knit)

local ServerS = game:GetService('ServerScriptService')
local Modules = RepS.Modules
local StateMachine = require(Modules.StateMachine)

local function time()
    return workspace:GetServerTimeNow()
end

local Battle = Knit.CreateService{
    Name = 'Battle',

    Client = {
        AbilityRequest = Knit.CreateSignal(), 
        AbilityLog = Knit.CreateProperty(),
        AbilityCooldown = Knit.CreateProperty()
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

        self.Client.AbilityLog:SetFor(plr, {})

        local cdTable = {}
        local allAbilities = FighterModules[fighterClass]:GetChildren()
        for _, abilityModule in ipairs(allAbilities) do
            cdTable[abilityModule.Name] = 0
            print('setting :', abilityModule.Name, 'to', cdTable)
        end
        self.Client.AbilityCooldown:SetFor(plr, cdTable)

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
        
    local function onAbilityRequest(plr, ability)

        local class = FighterUpdate.Client.FighterClass:GetFor(plr)
        local abilityIsValid = FighterModules[class]:FindFirstChild(ability)
        
        if not abilityIsValid then return end

        local plrStateMachine = self.StateMachines[plr.UserId]
        local currentAbility = plrStateMachine.State

        local cdData = self.Client.AbilityCooldown:GetFor(plr)
        local now = time()
        if now - cdData[ability] > 0 then
            print('Valid Move!')
            cdData[ability] = now + 5
            print('updating client...')
            self.Client.AbilityCooldown:SetFor(plr, cdData)
        else
            return
        end

        plrStateMachine:ChangeState(ability)

    end

    self.Client.AbilityRequest:Connect(onAbilityRequest)
    FighterUpdate.FighterChanged:Connect(onFighterChanged)
    
end

return Battle