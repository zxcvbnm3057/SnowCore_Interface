local function onname(self, val)
    self.inst.replica.visibledebuff:SetName(val)
end

local function ontarget(self, val)
    self.inst.replica.visibledebuff:SetTarget(val)
end

local function onpercent(self, val)
    self.inst.replica.visibledebuff:SetPercent(val)
end

local function onactivated(self, val)
    self.inst.replica.visibledebuff:SetActivated(val)
end

local function ondecrease_rate(self, val)
    self.inst.replica.visibledebuff:SetDecreaseRate(val)
end

local function ondecrease_rate_activated(self, val)
    self.inst.replica.visibledebuff:SetDecreaseRateActivated(val)
end

local Visibledebuff =
    Class(
    function(self, inst)
        self.inst = inst
        --self.name = nil
        --self.target = nil

        self.percent = 0
        self.decrease_rate = 0
        self.decrease_rate_activated = 0

        self.activated = false
        self.activated_num = 0

        self.onattachedfn = nil
        self.ondetachedfn = nil
        self.onextendedfn = nil
        self.onactivatedfn = nil
        self.keep_on_despawn = true
    end,
    nil,
    {
        name = onname,
        target = ontarget,
        percent = onpercent,
        activated = onactivated,
        decrease_rate = ondecrease_rate,
        decrease_rate_activated = ondecrease_rate_activated
    }
)

function Visibledebuff:SetAttachedFn(fn)
    self.onattachedfn = fn
end

function Visibledebuff:SetDetachedFn(fn)
    self.ondetachedfn = fn
end

function Visibledebuff:SetExtendedFn(fn)
    self.onextendedfn = fn
end

function Visibledebuff:SetActivatedFn(fn)
    self.onactivatedfn = fn
end

function Visibledebuff:IsActivated()
    return self.activated
end

function Visibledebuff:GetPercent()
    return self.percent
end

function Visibledebuff:Stop()
    self.inst:StopUpdatingComponent(self)
    if self.target ~= nil and self.target.components.visibledebuffmanager ~= nil then
        self.target.components.visibledebuffmanager:RemoveDebuff(self.name)
    end
end

function Visibledebuff:AttachTo(name, target, followsymbol, followoffset)
    self.name = name
    self.target = target

    if self.onattachedfn ~= nil then
        self.onattachedfn(self.inst, target, followsymbol, followoffset)
    end

    if self.percent >= 1 and not self.activated then
        self:Activated(followsymbol, followoffset)
    end

    self.inst:StartUpdatingComponent(self)
end

function Visibledebuff:OnDetach()
    local target = self.target
    --self.name = nil
    self.target = nil
    if self.ondetachedfn ~= nil then
        self.ondetachedfn(self.inst, target)
    end
end

function Visibledebuff:Extend(addpercent, followsymbol, followoffset)
    self.percent = self.percent + addpercent
    self.percent = math.min(1, self.percent)

    if self.onextendedfn ~= nil then
        self.onextendedfn(self.inst, self.target, followsymbol, followoffset)
    end

    if self.percent >= 1 and not self.activated then
        self:Activated(followsymbol, followoffset)
    end
end

function Visibledebuff:Activated(followsymbol, followoffset)
    self.activated = true
    self.activated_num = self.activated_num + 1
    if self.onactivatedfn ~= nil then
        self.onactivatedfn(self.inst, self.target, followsymbol, followoffset, self.activated_num)
    end
end

function Visibledebuff:OnUpdate(dt)
    self.percent = self.percent - (self.activated and self.decrease_rate_activated or self.decrease_rate) * dt
    if self.percent <= 0 then
        self:Stop()
    end
end

function Visibledebuff:OnSave()
    return {
        percent = self.percent,
        activated = self.activated,
        activated_num = self.activated_num
    }
end

function Visibledebuff:OnLoad(data)
    if data then
        self.percent = data.percent
        self.activated = data.activated
        self.activated_num = data.activated_num
    end
end

return Visibledebuff
