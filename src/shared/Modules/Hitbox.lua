local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Timer = require(Packages.Timer)
local Signal = require(Packages.Signal)

local hitbox = {}
hitbox.__index = hitbox

local function getHitHumanoids(result)
	local hums = {}
	for _, part in ipairs(result) do
		if part.Parent:FindFirstChild('Humanoid') then
			local newHum = part.Parent:WaitForChild('Humanoid')
			if not table.find(hums, newHum) then
				table.insert(hums, newHum)
			end
		end
	end
	return hums
end

local function getDirectionVector(p1,p2)
	return (p2 - p1).Unit
end

function hitbox.new(pos, size, overlapParams)
	local self = setmetatable({}, hitbox)

	self.overlapData = overlapParams

	self.hitPart = Instance.new('Part')
	self.hitPart.CanCollide = false
	self.hitPart.Position = pos
	self.hitPart.Size = size
	self.hitPart.Material = Enum.Material.ForceField
	self.hitPart.Color = Color3.fromRGB(255, 0, 89)
	self.hitPart.Transparency = .35
	self.hitPart.Parent = workspace
	
	self.origin = Instance.new('Attachment')
	self.origin.Parent = self.hitPart
	
	self.bodyVel = Instance.new('LinearVelocity')
	self.bodyVel.Attachment0 = self.origin
	self.bodyVel.VectorVelocity = Vector3.new()
	self.bodyVel.MaxForce = math.huge
	self.bodyVel.Parent = self.hitPart

	self.detectedHums = {}
	self.myTrove = Trove.new()
	self.OnHit = Signal.new()
	self.active = true
	
	self.hitPart.Touched:Connect(function()
		if not self.active then return end
		self:DetectNow()
	end)

	self:DetectNow()

	return self
end

function hitbox:DetectNow()
	local result = workspace:GetPartsInPart(self.hitPart, self.overlapData)
	local detectedHums = getHitHumanoids(result)

	local newHums = {}
	for _ , hum in ipairs(detectedHums) do
		if not table.find(self.detectedHums, hum) then
			table.insert(self.detectedHums, hum)
			table.insert(newHums, hum)
		end
	end
	
	if #newHums > 0 then
		self.OnHit:Fire(newHums)
	end

	return newHums
end

function hitbox:MoveTo(targetPos, time)

  self.active = true
	self.detectedHums = {}
	self.myTrove:Clean()
	
	local p1 = self.hitPart.Position
	local p2 = targetPos
	local distance = (p2-p1).Magnitude
	
	self.bodyVel.VectorVelocity = getDirectionVector(p1, p2) * (distance/time)
	
	local endTimer = Timer.new(time)
	endTimer.Tick:Connect(function()
		self.bodyVel.VectorVelocity = Vector3.new()
		self:Destroy()
	end)
	endTimer:Start()
	
	self.myTrove:Add(endTimer, 'Destroy')
	
end

function hitbox:MoveToward(direction, speed, duration)

  self.active = true
  self.detectedHums = {}
	self.myTrove:Clean()

	self.bodyVel.VectorVelocity = direction * speed

	local endTimer = Timer.new(duration)
	endTimer.Tick:Connect(function()
		self.bodyVel.VectorVelocity = Vector3.new()
		self:Destroy()
	end)
	endTimer:Start()

	self.myTrove:Add(endTimer, 'Destroy')

end

function hitbox:Destroy()
  self.hitPart:Destroy()
  self.myTrove:Clean()
end

-- function hitbox:Attach(part, CFOffset)
-- 	self.hitPart.CFrame = part.CFrame * CFOffset
-- 	local weld = Instance.new('WeldConstraint')
-- 	weld.Part0 = self.hitPart
-- 	weld.Part1 = part
-- 	weld.Parent = self.hitPart
-- 	weld:SetAttribute('Target', part)
-- end

return hitbox
