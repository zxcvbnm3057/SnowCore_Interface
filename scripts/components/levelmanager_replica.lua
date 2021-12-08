local LevelManager =
	Class(
	function(self, inst)
		self.inst = inst

		self._exp = net_shortint(inst.GUID, "LevelManager._exp", "expdirty")
		self._max_exp = net_shortint(inst.GUID, "LevelManager._max_exp", "maxexpdirty")
		self._level = net_shortint(inst.GUID, "LevelManager._level", "leveldirty")
		self._max_level = net_shortint(inst.GUID, "LevelManager._max_level", "maxleveldirty")

		self._levelup = net_event(inst.GUID, "LevelManager._levelup")
		if not TheNet:IsDedicated() then
			inst:ListenForEvent(
				"LevelManager._levelup",
				function(inst)
					inst:PushEvent("levelupdirty")
				end
			)
		end

		self.init = true
	end
)

function LevelManager:SetExp(val)
	self._exp:set(val)
end

function LevelManager:SetLevelMaxExp(val)
	self._max_exp:set(val)
end

function LevelManager:SetLevel(val)
	local old_val = self._level:value()
	self._level:set(val)
	local new_val = self._level:value()
	if not self.init and new_val > old_val then
		self._levelup:push()
	end
end

function LevelManager:SetMaxLevel(val)
	self._max_level:set(val)
end

-----------------------------------------------------

function LevelManager:GetExp()
	return self._exp:value()
end

function LevelManager:GetMaxExp()
	return self._max_exp:value()
end

function LevelManager:GetLevel()
	return self._level:value()
end

function LevelManager:GetMaxLevel()
	return self._max_level:value()
end

return LevelManager
