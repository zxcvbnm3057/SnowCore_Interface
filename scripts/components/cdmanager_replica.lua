local CDManager =
    Class(
    function(self, inst)
        self.inst = inst
        self.timers = {}
        self.listeners = {}

        self.startcd = net_string(inst.GUID, "cdmanager.startcd", "cdmanager.startcd")
        self.stopcd = net_string(inst.GUID, "cdmanager.stopcd", "cdmanager.stopcd")

        self.inst:ListenForEvent(
            "cdmanager.startcd",
            function()
                local name = self.startcd:value()
                if not self.timers[name] then
                    self.timers[name] = {
                        cd_left = net_byte(self.inst.GUID, "cdmanager.cd_left." .. name, "cdmanager.cd_left." .. name),
                        cd_percent = net_byte(
                            self.inst.GUID,
                            "cdmanager.cd_percent." .. name,
                            "cdmanager.cd_percent." .. name
                        ),
                        quantity = net_smallbyte(
                            self.inst.GUID,
                            "cdmanager.quantity." .. name,
                            "cdmanager.quantity." .. name
                        ),
                        recharge_percent = net_byte(
                            self.inst.GUID,
                            "cdmanager.recharge_percent." .. name,
                            "cdmanager.recharge_percent." .. name
                        )
                    }
                end
                self.startcd:set_local("")

                if not TheNet:IsDedicated() then
                    self.listeners[name] = function(inst)
                        if ModSkillList[name] then
                            if inst.HUD and inst.HUD.controls and inst.HUD.controls.VisibleSkillUI then
                                inst.HUD.controls.VisibleSkillUI:UpdateSkillCD(
                                    name,
                                    self.timers[name].cd_percent:value(),
                                    self.timers[name].cd_left:value(),
                                    self.timers[name].quantity:value(),
                                    self.timers[name].recharge_percent:value()
                                )
                            end
                        end
                    end

                    self.inst:ListenForEvent("cdmanager.cd_left." .. name, self.listeners[name])
                    self.inst:ListenForEvent("cdmanager.cd_percent." .. name, self.listeners[name])
                    self.inst:ListenForEvent("cdmanager.quantity." .. name, self.listeners[name])
                    self.inst:ListenForEvent("cdmanager.recharge_percent." .. name, self.listeners[name])
                end
            end
        )

        self.inst:ListenForEvent(
            "cdmanager.stopcd",
            function(inst)
                local name = self.stopcd:value()
                self.inst:RemoveEventCallback("cdmanager.remain." .. name, self.listeners[name])
                self.inst:RemoveEventCallback("cdmanager.total." .. name, self.listeners[name])
                self.inst:RemoveEventCallback("cdmanager.quantity." .. name, self.listeners[name])
                self.listeners[name] = nil
                -- self.timers[name] = nil
                self.stopcd:set_local("")
            end
        )
    end
)

function CDManager:SetCD(name, data)
    if self.timers[name] then
        self.timers[name].cd_percent:set(100 * data.cooldowntime_left / data.cooldowntime_total)
        self.timers[name].cd_left:set(data.cooldowntime_left)
        self.timers[name].quantity:set(data.quantity)
        self.timers[name].recharge_percent:set(100 * data.rechargetime_left / data.rechargetime_total)
    end
end

function CDManager:StartCD(name)
    self.startcd:set(name)
end
function CDManager:StopCD(name)
    self.stopcd:set(name)
end

return CDManager
