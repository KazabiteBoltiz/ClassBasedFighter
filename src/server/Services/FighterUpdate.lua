local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)
local Knit = require(Packages.Knit)

--//

local Players = game.Players

--//

local FighterUpdate = Knit.CreateService{
    Name = 'FighterUpdate', 
    Client = {FighterClass = Knit.CreateProperty()}
}

function FighterUpdate:KnitInit()
    Players.CharacterAutoLoads = false
    self.FighterChanged = Signal.new()
    self.respawnTroves = {}
end

function FighterUpdate:KnitStart()

    local FighterModules = RepS.FighterModules

    local function handleRespawns(plr)
        local fighterClass = self.Client.FighterClass:GetFor(plr)
        local newFighter = FighterModules[fighterClass]:WaitForChild('Avatar'):Clone()
        newFighter.Name = plr.Name

        local newHumanoid = newFighter:WaitForChild('Humanoid')
        local respawnTrove = self.respawnTroves[plr.UserId]

        plr.Character = newFighter
        newFighter.Parent = workspace

        self.Client.FighterClass:SetFor(plr, fighterClass)

        respawnTrove:Clean()
        respawnTrove:Connect(newHumanoid.Died, function()
            handleRespawns(plr)
        end)
    end

    Players.PlayerAdded:Connect(function(plr)
        self.respawnTroves[plr.UserId] = Trove.new()

        self.Client.FighterClass:SetFor(plr, 'Shogun')
        self.FighterChanged:Fire(plr, 'Shogun')
        
        handleRespawns(plr)
    end)

end

return FighterUpdate