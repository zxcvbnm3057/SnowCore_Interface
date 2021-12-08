local ItemSlot = require "widgets/itemslot"
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local VisibleSkillSlot =
	Class(
	Widget,
	function(self, name, owner)
		ItemSlot._ctor(self, nil, nil, owner)

		self.name = name

		self.bgimage:SetScale(0.5, 0.5)
		self.bgimage:SetTexture(
			ModSkillList[name].altas or ("images/skillicons/" .. name .. ".xml"),
			ModSkillList[name].image or (name .. ".tex")
		)

		self.label =
			self:AddChild(
			Text(NUMBERFONT, 32, ModSkillList[self.name].name .. "\n" .. ModSkillList[self.name].description, {1, 1, 1, 1})
		)
		self.label:SetPosition(0, 80)
		self.label:Hide()

		self.quantity = self:AddChild(Text(NUMBERFONT, 36))
		self.quantity:SetPosition(24, -16, 0)

		self.cdtimer = self:AddChild(Text(NUMBERFONT, 42))
		self.cdtimer:SetPosition(0, 0, 0)

		self.recharge = self:AddChild(UIAnim())
		self.recharge:GetAnimState():SetBank("recharge_meter")
		self.recharge:GetAnimState():SetBuild("recharge_meter")
		self.recharge:GetAnimState():SetMultColour(1, 1, 1, 0)
		self.recharge:GetAnimState():SetAddColour(47 / 255, 47 / 255, 47 / 255, 0.6)
		self.recharge:SetScale(-1, 1)
		self.recharge:SetClickable(false)
	end
)

function VisibleSkillSlot:GetSkillEntity()
	return self.ent
end

function VisibleSkillSlot:OnGainFocus()
	self.label:Show()
end

function VisibleSkillSlot:OnLoseFocus()
	self.label:Hide()
end

function VisibleSkillSlot:SetSkillCD(cd_percent, cd_left, quantity, recharge_percent)
	self.recharge:GetAnimState():SetPercent("recharge", cd_percent * 0.01)
	self.cdtimer:SetString(cd_left)
	self.quantity:SetString(quantity)

	if quantity >= 0 then
		self.quantity:Show()
	else
		self.quantity:Hide()
	end

	if cd_left > 0 then
		self.recharge:Show()
		self.cdtimer:Show()
	else
		self.recharge:Hide()
		self.cdtimer:Hide()
	end
end

return VisibleSkillSlot
