local VisibledebuffManager =
    Class(
    function(self, inst)
        self.inst = inst
        self.followsymbol = ""
        self.followoffset = Vector3(0, 0, 0)
        self.debuffs = {}

        self.inst:StartUpdatingComponent(self)
    end,
    nil
)

function VisibledebuffManager:CleanDebuffs()
    local k = next(self.debuffs)
    while k ~= nil do
        self:RemoveDebuff(k)
        k = next(self.debuffs)
    end
end

function VisibledebuffManager:RemoveOnDespawn()
    local toremove = {}
    for k, v in pairs(self.debuffs) do
        if not (v.inst.components.visibledebuff ~= nil and v.inst.components.visibledebuff.keep_on_despawn) then
            table.insert(toremove, k)
        end
    end
    for i, v in ipairs(toremove) do
        self:RemoveDebuff(v)
    end
end

function VisibledebuffManager:SetFollowSymbol(symbol, x, y, z)
    self.followsymbol = symbol
    self.followoffset.x = x
    self.followoffset.y = y
    self.followoffset.z = z
    for k, v in pairs(self.debuffs) do
        if v.inst.components.visibledebuff ~= nil then
            v.inst.components.visibledebuff:AttachTo(k, self.inst, symbol, self.followoffset)
        end
    end
end

function VisibledebuffManager:HasDebuff(name)
    return self.debuffs[name] ~= nil
end

function VisibledebuffManager:GetDebuff(name)
    local debuff = self.debuffs[name]
    return debuff ~= nil and debuff.inst or nil
end

local function RegisterDebuff(self, name, ent)
    if ent.components.visibledebuff ~= nil then
        self.debuffs[name] = {
            inst = ent,
            onremove = function()
                self.debuffs[name] = nil
            end
        }
        self.inst:ListenForEvent("onremove", self.debuffs[name].onremove, ent)
        ent.persists = false
        ent.components.visibledebuff:AttachTo(name, self.inst, self.followsymbol, self.followoffset)
    else
        ent:Remove()
    end
end

-- ThePlayer.components.visibledebuffmanager:AddDebuff("example_debuff", 0.3)

function VisibledebuffManager:AddDebuff(name, percent)
    percent = percent or 1
    if self.debuffs[name] == nil then
        local ent = SpawnPrefab(name)
        ent.components.visibledebuff.percent = percent
        if ent ~= nil then
            RegisterDebuff(self, name, ent)
        end
    else
        self.debuffs[name].inst.components.visibledebuff:Extend(percent, self.followsymbol, self.followoffset)
    end
end

function VisibledebuffManager:RemoveDebuff(name)
    local debuff = self.debuffs[name]
    if debuff ~= nil then
        self.debuffs[name] = nil
        self.inst:RemoveEventCallback("onremove", debuff.onremove, debuff.inst)
        if debuff.inst.components.visibledebuff ~= nil then
            debuff.inst.components.visibledebuff:OnDetach()
        else
            debuff.inst:Remove()
        end
    end
end

function VisibledebuffManager:OnSave()
    if next(self.debuffs) == nil then
        return
    end

    local data = {}
    for k, v in pairs(self.debuffs) do
        local saved = v.inst:GetSaveRecord()
        data[k] = saved
    end
    return {debuffs = data}
end

function VisibledebuffManager:OnLoad(data)
    if data ~= nil and data.debuffs ~= nil then
        for k, v in pairs(data.debuffs) do
            if self.debuffs[k] == nil then
                local ent = SpawnSaveRecord(v)
                if ent ~= nil then
                    RegisterDebuff(self, k, ent)
                    if ent.components.visibledebuff:IsActivated() then
                        ent.components.visibledebuff:Activated(self.followsymbol, self.followoffset)
                    end
                end
            end
        end
    end
end

function VisibledebuffManager:GetDebugString()
    local str = "Num Buffs: " .. tostring(GetTableSize(self.debuffs))

    for k, v in pairs(self.debuffs) do
        str = str .. "\n  " .. tostring(v.inst.prefab)
    end

    return str
end

return VisibledebuffManager
