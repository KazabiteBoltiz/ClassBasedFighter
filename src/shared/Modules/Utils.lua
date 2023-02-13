local RepS = game.ReplicatedStorage
local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Signal = require(Packages.Signal)

local Utils = {}

function Utils.RespawnVars(mod, targetPlr)

    local respawnTrove = Trove.new()
    local onSpawned = Signal.new()

    local plr = targetPlr or game.Players.LocalPlayer

    local function endFunction()
        respawnTrove:Clean()
        onSpawned:Destroy()
    end

    local function handleRespawns()
        mod.char = plr.Character or plr.CharacterAdded:Wait()
        mod.hum = mod.char:WaitForChild('Humanoid')
        mod.hrp = mod.char:WaitForChild('HumanoidRootPart')

        onSpawned:Fire(mod.char)

        respawnTrove:Clean()
        respawnTrove:Connect(mod.hum.Died, function()
            handleRespawns()
        end)
    end

    handleRespawns()

    return onSpawned, endFunction 
end

-- local SequenceProvider = game:GetService("KeyframeSequenceProvider")

-- local function getAnimationEvents(animID)
-- 	local events = {}
-- 	local keyFrameData = SequenceProvider:GetKeyframeSequenceAsync(animID)
-- 	keyFrameData.Parent = workspace
	
-- 	local function addEventsDeep(parent)
-- 		for _, child in ipairs(parent:GetChildren()) do
-- 			if child:IsA('KeyframeMarker') then
-- 				if events[child.Parent.Time] then
-- 					table.insert(events[child.Parent.Time], {child.Name, child.Value})
-- 				else
-- 					events[child.Parent.Time] = {{child.Name, child.Value}}
-- 				end
-- 			end
-- 			if #child:GetChildren() > 0 then
-- 				addEventsDeep(child)
-- 			end
-- 		end
-- 	end
	
-- 	addEventsDeep(keyFrameData)
	
-- 	return events
-- end 

-- local AnimEvents = getAnimationEvents("rbxassetid://11151865873")

return Utils