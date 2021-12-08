local SkillManager =
    Class(
    function(self, inst)
        self.inst = inst
        self.learnedskills = {}
        self.newlearn = net_string(inst.GUID, "SkillManager._newlearn", "learnskilldirty")
        self.newforget = net_string(inst.GUID, "SkillManager._newforget", "forgetskilldirty")

        inst:ListenForEvent(
            "learnskilldirty",
            function(inst)
                local name = self.newlearn:value()
                if not TheNet:IsDedicated() and ModSkillList[name] then
                    if inst.HUD and inst.HUD.controls and inst.HUD.controls.VisibleSkillUI then
                        inst.HUD.controls.VisibleSkillUI:AddSkill(name, ModSkillList[name].ispassive)
                    end
                    if ModSkillList[name].onlearn_client then
                        ModSkillList[name].onlearn_client(self.inst)
                    end
                end
                self.learnedskills[name] = true
                self.newlearn:set_local("")
            end
        )
        inst:ListenForEvent(
            "forgetskilldirty",
            function(inst)
                local name = self.newforget:value()
                if not TheNet:IsDedicated() and ModSkillList[name] then
                    if inst.HUD and inst.HUD.controls and inst.HUD.controls.VisibleSkillUI then
                        inst.HUD.controls.VisibleSkillUI:RemoveSkill(name, ModSkillList[name].ispassive)
                    end
                end
                if ModSkillList[name].onforget_client then
                    ModSkillList[name].onforget_client(self.inst)
                end
                self.learnedskills[name] = nil
                self.newforget:set_local("")
            end
        )
    end
)

function SkillManager:IsSkillLearned(name)
    return self.learnedskills[name] or false
end

function SkillManager:Learn(name)
    self.newlearn:set(name)
end

function SkillManager:Forget(name)
    self.newforget:set(name)
end

function SkillManager:LaunchskillClient(name, pos, target)
    if self:IsSkillLearned(name) then
        if ModSkillList[name].onlaunch_client then
            ModSkillList[name].onlaunch_client(self.inst, pos, target)
        end
    end
end

return SkillManager
