local RepS = game.ReplicatedStorage
local BaseClasses = RepS.BaseClasses

local FighterClass = require(BaseClasses.Fighter)

local Shogun = {}
Shogun.__index = Shogun

function Shogun.new(BattleServer)
    local self = FighterClass.Setup(script, BattleServer, {}, {})

    self.abilities = {
        [{'Q'}] = 'Incision',
        [{'E'}] = 'Exile'
    }
    
    return self
end

return Shogun
