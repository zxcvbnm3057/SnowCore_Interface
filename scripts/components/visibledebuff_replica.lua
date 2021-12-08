local Visibledebuff =
	Class(
	function(self, inst)
		self.inst = inst
		self._name = net_string(inst.GUID, "visibledebuff._name")
		self._target = net_entity(inst.GUID, "visibledebuff._target", "ontargetdirty")

		self._percent = net_float(inst.GUID, "visibledebuff._percent", "onpercentdirty")
		self._decrease_rate = net_float(inst.GUID, "visibledebuff._decrease_rate")
		self._decrease_rate_activated = net_float(inst.GUID, "visibledebuff._decrease_rate_activated")

		self._activated = net_bool(inst.GUID, "visibledebuff._activated", "onactivateddirty")
	end
)

function Visibledebuff:SetName(name)
	self._name:set(name)
end

function Visibledebuff:SetTarget(target)
	self._target:set(target)
end

function Visibledebuff:SetPercent(val)
	self._percent:set(val)
end

function Visibledebuff:SetActivated(val)
	self._activated:set(val)
end

function Visibledebuff:SetDecreaseRate(val)
	self._decrease_rate:set(val)
end

function Visibledebuff:SetDecreaseRateActivated(val)
	self._decrease_rate_activated:set(val)
end

function Visibledebuff:GetName()
	return self._name:value()
end

function Visibledebuff:GetTarget()
	return self._target:value()
end

function Visibledebuff:GetPercent()
	return self._percent:value()
end

function Visibledebuff:IsActivated()
	return self._activated:value()
end

function Visibledebuff:GetTimeRemain()
	local rate = self:IsActivated() and self._decrease_rate_activated:value() or self._decrease_rate:value() or 0
	return rate > 0 and self:GetPercent() / rate
end

return Visibledebuff
