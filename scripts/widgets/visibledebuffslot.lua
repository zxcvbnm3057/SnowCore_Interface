local ItemSlot = require "widgets/itemslot"
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local VisibleDebuffSlot =
	Class(
	Widget,
	function(self, owner, name, ent, percent, activated)
		self.image_activate = BUFFICONS[name].image_activate or (name .. "_activate.tex")
		self.altas_activate = BUFFICONS[name].altas_activate or ("images/bufficons/" .. name .. "_activate.xml")
		self.image_inactivate = BUFFICONS[name].image_inactivate or (name .. "_inactivate.tex")
		self.altas_inactivate = BUFFICONS[name].altas_inactivate or ("images/bufficons/" .. name .. "_inactivate.xml")

		ItemSlot._ctor(self, nil, nil, owner)

		self.owner = owner
		self.name = name
		self.ent = ent
		self.activated = activated

		self.bgimage:SetScale(0.5, 0.5)

		self.label = self:AddChild(Text(NUMBERFONT, 32, "", {1, 1, 1, 1}))
		self.label:SetPosition(0, 120)
		self.label:Hide()

		self.percent = self:AddChild(Text(NUMBERFONT, 42))
		self.percent:SetPosition(5, -32 + 15, 0)

		self.recharge = self:AddChild(UIAnim())
		self.recharge:GetAnimState():SetBank("recharge_meter")
		self.recharge:GetAnimState():SetBuild("recharge_meter")
		self.recharge:GetAnimState():SetMultColour(1, 1, 1, 0)
		self.recharge:GetAnimState():SetAddColour(47 / 255, 47 / 255, 47 / 255, 0.6)
		self.recharge:SetScale(-1, 1)
		self.recharge:SetClickable(false)

		self:SetScale(0.85, 0.85, 0.85)

		self:SetBuff(percent, activated)
	end
)

function VisibleDebuffSlot:GetBuffEntity()
	return self.ent
end

function VisibleDebuffSlot:OnGainFocus()
	self.label:Show()
end

function VisibleDebuffSlot:OnLoseFocus()
	self.label:Hide()
end

function VisibleDebuffSlot:SetBuff(percent, activated)
	local name = self.name
	self.activated = activated

	if self.activated then
		self.recharge:Show()
		self.percent:Hide()
		self.bgimage:SetTexture(self.altas_activate, self.image_activate)
		self.recharge:GetAnimState():SetPercent("recharge", percent)
	else
		self.recharge:Hide()
		self.percent:Show()
		local val_to_show = percent * 100
		if val_to_show > 0 and val_to_show < 1 then
			val_to_show = 1
		end
		self.percent:SetString(string.format("%2.0f%%", val_to_show))
		self.bgimage:SetTexture(self.altas_inactivate, self.image_inactivate)
	end

	local name_str = BUFFSTRINGS[name].name
	local des_str = activated and BUFFSTRINGS[name].describe_activated or BUFFSTRINGS[name].describe_nomal

	local time_demain = self.ent.replica.visibledebuff:GetTimeRemain()
	if time_demain then
		self.label:SetString(string.format("%s:\n剩余时间:%s秒\n%s", name_str, math.floor(time_demain), des_str))
	else
		self.label:SetString(string.format("%s:\n%s", name_str, des_str))
	end
end

return VisibleDebuffSlot
