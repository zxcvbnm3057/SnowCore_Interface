local CDManager =
    Class(
    function(self, inst)
        self.inst = inst
        self.cdqueue = {}

        self.inst:StartUpdatingComponent(self)

        self.inst:ListenForEvent(
            "skilllearned",
            function(inst, data)
                self.inst.replica.cdmanager:StartCD(data.name)
                self:StartCooldown(data.name, {cooldowntime_left = 0})
            end
        )
        self.inst:ListenForEvent(
            "skillforgot",
            function(inst, data)
                self:StopCooldown(data.name)
            end
        )
    end
)

function CDManager:IsReady(name)
    return self.cdqueue[name].cooldowntime_left <= 0
end

function CDManager:StartCooldown(name, data)
    if self.cdqueue[name] then
        return
    end

    data = data or {}

    self.cdqueue[name] = {
        cooldowntime_left = data.cooldowntime_left or ModSkillList[name].cd,
        cooldowntime_total = data.cooldowntime_total or ModSkillList[name].cd,
        quantity = data.quantity or data.quantity_max or ModSkillList[name].quantity_max,
        quantity_max = data.quantity_max or ModSkillList[name].quantity_max,
        rechargetime_left = data.rechargetime_left or ModSkillList[name].rechargetime,
        rechargetime_total = data.rechargetime_total or ModSkillList[name].rechargetime,
        paused = data.paused or false
    }
end

function CDManager:StopCooldown(name)
    self.cdqueue[name] = nil
    self.inst.replica.cdmanager:StopCD(name)
end

function CDManager:OnUpdate(dt)
    for k, v in pairs(self.cdqueue) do
        if not v.paused then
            v.cooldowntime_left = math.max(0, v.cooldowntime_left - dt)
            if v.cooldowntime_left == 0 then
                self.inst:PushEvent("skillcooldown", {name = k})
            end
            v.rechargetime_left = math.max(0, v.rechargetime_left - dt)
            if v.rechargetime_left == 0 then
                v.quantity = math.min(v.quantity + 1, v.quantity_max)
                self.inst:PushEvent("skillrecharged", {name = k, quantity = v.quantity})
                if v.quantity < v.quantity_max then
                    v.rechargetime_left = v.rechargetime_total
                end
            end
            self.inst.replica.cdmanager:SetCD(k, v)
        end
    end
end

CDManager.LongUpdate = CDManager.OnUpdate

function CDManager:GetCDLeft(name)
    return self.cdqueue[name].cooldowntime_left or 0
end

function CDManager:SetCDLeft(name, time)
    self.cdqueue[name].cooldowntime_left = time
end

function CDManager:GetQuantity(name)
    return self.cdqueue[name].quantity
end

function CDManager:CostQuantity(name, num)
    self.cdqueue[name].quantity =
        math.min(self.cdqueue[name].quantity_max, math.max(0, self.cdqueue[name].quantity - num))
end

function CDManager:Pause(name)
    self.cdqueue[name].paused = true
end

function CDManager:Resume(name)
    self.cdqueue[name].paused = false
end

function CDManager:OnSave()
    local data = {}
    for k, v in pairs(self.cdqueue) do
        data[k] = {
            cooldowntime_left = v.cooldowntime_left,
            cooldowntime_total = v.cooldowntime_total,
            quantity = v.quantity,
            quantity_max = v.quantity_max,
            rechargetime_left = v.rechargetime_left,
            rechargetime_total = v.rechargetime_total,
            paused = v.paused
        }
    end
    return data
end

function CDManager:OnLoad(data)
    if data then
        for k, v in pairs(data) do
            self:StartCooldown(k, v)
        end
    end
end

return CDManager
