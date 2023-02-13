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

function Fighter.Setup(fighterModule, anims, sounds)
    local self = setmetatable({}, Fighter)

    self.anims = anims or {}
    self.sounds = sounds or {}

    StateMachine.Create(fighterModule, self, 'Idle')

    self:Assets()
    self:Abilities()

    return self
end

function Fighter:Assets()
    self.Assets = Assets.new(nil, self.anims, self.sounds)
    local onSpawned, respawnUpdateKill = Utils.RespawnVars(self)
    self.respawnUpdateKill = respawnUpdateKill
    onSpawned:Connect(function()
        self.Assets:Load(self.hum)
    end)
end

function Fighter:Abilities() 
    self.myTrove = Trove.new()
    self.keyboard = Keyboard.new()

    self.myTrove:Connect(self.keyboard.KeyDown, 
        function(key, typing)
            if typing or self.State.Name ~= 'Idle' then return end

            for input, action in pairs(self.abilities) do
                if table.find(input, key.Name) then
                    self:ChangeState(action)
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