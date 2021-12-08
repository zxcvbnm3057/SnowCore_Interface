local Widget = require "widgets/widget"
local VisibleDebuffSlot = require "widgets/visibledebuffslot"

local SLOTDIST = 60

local VisibleDebuffContainer =
	Class(
	Widget,
	function(self, owner)
		Widget._ctor(self, "Visibledebuffcontainer")
		self.owner = owner
		self.buffslots = {}

		self:SetHAnchor(1)
		self:SetVAnchor(2)
	end
)

function VisibleDebuffContainer:AddBuff(name, ent, percent, activated, ispositive)
	if not self.buffslots[name] then
		self.buffslots[name] = self:AddChild(VisibleDebuffSlot(self.owner, name, ent, percent, activated))
		self.buffslots[name].OnBuffEntityRemove = function()
			self:RemoveBuff(name)
		end
		self.buffslots[name].ispositive = ispositive

		self:Sort()
		self.owner:ListenForEvent("onremove", self.buffslots[name].OnBuffEntityRemove, ent)
	end
	self.buffslots[name]:SetBuff(percent, activated)
end

function VisibleDebuffContainer:RemoveBuff(name)
	local ent = self.buffslots[name]:GetBuffEntity()
	self.owner:RemoveEventCallback("onremove", self.buffslots[name].OnBuffEntityRemove, ent)

	self.buffslots[name]:Kill()
	self.buffslots[name] = nil
	self:Sort()
end

function VisibleDebuffContainer:Sort()
	local index = 1
	for name, buffslot in pairs(self.buffslots) do
		local x, y, z = buffslot.ispositive and 0 or SLOTDIST, SLOTDIST * (index - 1), 0
		buffslot:SetPosition(x, y, z)
		index = index + 1
	end
end

return VisibleDebuffContainer
