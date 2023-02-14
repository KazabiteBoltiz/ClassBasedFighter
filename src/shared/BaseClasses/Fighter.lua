local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Trove = require(Packages.Trove)

local Input = require(Packages.Input)
local Keyboard = Input.Keyboard

local Modules = RepS.Modules
local Assets = require(Modules.Assets)
local Utils = require(Modules.Utils)
local StateMachine = require(Modules.StateMachine)

local Fighter = {}
Fighter.__index = Fighter

local function time()
    return workspace:GetServerTimeNow()
end

function Fighter.Setup(fighterModule, battleServer, anims, sounds)
    local self = setmetatable({}, Fighter)

    print('battleServer :', battleServer)
    self.BattleServer = battleServer

    self.anims = anims or {}
    self.sounds = sounds or {}

    self.cooldowns = {}
    for _, abilityModule in ipairs(fighterModule:GetChildren()) do
        self.cooldowns[abilityModule.Name] = 0
    end

    StateMachine.Create(fighterModule, self, 'Idle')

    self:Assets()
    self:Abilities()

    return self
end

function Fighter:Assets()
    local onSpawned, respawnUpdateKill = Utils.RespawnVars(self)
    self.respawnUpdateKill = respawnUpdateKill
    
    onSpawned:Connect(function()
        self.Assets:Load(self.hum)
    end)

    self.Assets = Assets.new(nil, self.anims, self.sounds)
end

function Fighter:Abilities() 
    self.myTrove = Trove.new()
    self.keyboard = Keyboard.new()

    self.BattleServer.AbilityCooldown.Changed:Connect(function(value)

        print("DETECTED CHANGE IN COOLDONWS")

        for ability, cd in pairs(self.cooldowns) do
            if cd == -1 then
                self.cooldowns[ability] = value[ability]
                print('updated', ability,'to', value[ability])
            end
        end
    end)

    self.myTrove:Connect(self.keyboard.KeyDown, 
        function(key, typing)
            if typing or self.State.Name ~= 'Idle' then return end

            for input, action in pairs(self.abilities) do
                if table.find(input, key.Name) then
                    if time() - self.cooldowns[action] < 0 then return end
                    if self.cooldowns[action] == -1 then return end
                    self:ChangeState(action)
                    self.cooldowns[action] = -1
                end
            end
        end
    )
end

function Fighter:Destroy() 
    self:ChangeState('Idle')
    self.Assets:Destroy()
    self.respawnUpdateKill()
end

return Fighter