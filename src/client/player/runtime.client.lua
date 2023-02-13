local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Knit = require(Packages.Knit)

local Controllers = RepS.Controllers
Knit.AddControllers(Controllers)

Knit.Start():andThen(function()
    print('Knit Started!')
end)