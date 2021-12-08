local Widget = require "widgets/widget"
local VisibleSkillSlot = require "widgets/visibleskillslot"

local SLOTDIST = 60

local VisibleSkillContainer =
	Class(
	Widget,
	function(self, owner)
		Widget._ctor(self, "Visibleskillcontainer")
		self.owner = owner
		self.skillslots = {}

		self:SetHAnchor(1)
		self:SetVAnchor(2)
	end
)

function VisibleSkillContainer:AddSkill(name, ispassive)
	if not self.skillslots[name] then
		self.skillslots[name] = self:AddChild(VisibleSkillSlot(name, self.owner))
		self:Sort()
	end
end

function VisibleSkillContainer:UpdateSkillCD(name, cd_percent, cd_left, quantity, recharge_percent)
	if self.skillslots[name] then
		self.skillslots[name]:SetSkillCD(cd_percent, cd_left, quantity, recharge_percent)
	end
end

function VisibleSkillContainer:RemoveSkill(name)
	self.skillslots[name]:Kill()
	self.skillslots[name] = nil
	self:Sort()
end

function VisibleSkillContainer:Sort()
	local index = 1
	for name, v in pairs(self.skillslots) do
		local x, y, z = SLOTDIST * (index - 1), 0, 0
		v:SetPosition(x, y, z)
		index = index + 1
	end
end

return VisibleSkillContainer
