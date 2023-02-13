local Assets = {}
Assets.__index = Assets

function Assets.new(hum, animations, sounds)
	local self = setmetatable({}, Assets)
	
	self.animInstances = {}
	self.animTracks = {}
	self.animations = animations
	
	self.soundInstances = {}
	self.sounds = sounds

	for animName, animId in pairs(self.animations) do
		local animInst = Instance.new('Animation')
		animInst.AnimationId = "rbxassetid://"..animId
		self.animInstances[animName] = animInst
	end
	
	for soundName, soundId in pairs(self.sounds) do
		if type(soundId) == 'number' then
			local soundInst = Instance.new('Sound')
			soundInst.SoundId = "rbxassetid://"..soundId
			self.soundInstances[soundName] = soundInst
		end
	end
	
	if hum then
		self:Load(hum)
	end

	return self
end

function Assets:GetAnim(animName)
	if self.animTracks[animName] then
		return self.animTracks[animName], self.animInstances[animName]
	end
end

function Assets:GetSound(soundName)
	
	if type(soundName) == 'function' then
		soundName = soundName()
	end
	
	if type(soundName) == 'string' then
		if self.soundInstances[soundName] then
			return self.soundInstances[soundName]
		end
	elseif type(soundName) == 'number' then
		for _, sound in pairs(self.soundInstances) do
			if sound.SoundId == "rbxassetid://"..tostring(soundName) then
				return sound
			end
		end
	end
end

function Assets:Load(hum)
	
	self.animTrack = {}
	
	for animInstName, animInst in pairs(self.animInstances) do
		self.animTracks[animInstName] = hum:LoadAnimation(animInst)
	end
end

function Assets:Destroy()
	for _,inst in pairs(self.animInstances) do
		inst:Destroy()
	end
	self.animInstances = {}

	for _,inst in pairs(self.soundInstances) do
		inst:Destroy()
	end
	self.soundInstances = {}

	for _, tracks in pairs(self.animTracks) do
		tracks:Stop()
	end
	self.animTracks = {}
end

return Assets