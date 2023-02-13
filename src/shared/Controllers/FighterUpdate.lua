local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Knit = require(Packages.Knit)

local FighterUpdate = Knit.CreateController{Name = 'FighterUpdate'}

function FighterUpdate:KnitStart()
    local FighterUpdateServer = Knit.GetService('FighterUpdate')
    local BattleServer = Knit.GetService('Battle')

    local FighterModules = RepS.FighterModules
    local myFighterModule = nil;

    local function onFighterClassChanged(newClass)
        if myFighterModule then
            myFighterModule:Destroy()
        end
        if newClass then
            local newFighterModule = FighterModules:WaitForChild(newClass)
            myFighterModule = require(newFighterModule).new()
            myFighterModule.BattleServer = BattleServer
        end
    end

    FighterUpdateServer.FighterClass.Changed:Connect(onFighterClassChanged)
end

return FighterUpdate