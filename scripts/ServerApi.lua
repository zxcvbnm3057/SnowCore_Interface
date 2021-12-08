GLOBAL.SetEntityInvincible = function(prefab, isInvincible, key)
    if not prefab.components.health or key == nil then
        return
    end
    prefab.invincibleSource = prefab.invincibleSource or {}
    prefab.invincibleSource[key] = isInvincible or nil
    prefab.components.health:SetInvincible(GetTableSize(prefab.invincibleSource) > 0)
end

--------------------------------------------------------------------------------------------------------

GLOBAL.AOEAttack = function(pos, attackfn, range, noattacktags)
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, range, {"_combat"}, noattacktags)
    for _, target in pairs(ents) do
        attackfn(target)
    end
end

--------------------------------------------------------------------------------------------------------

AddModRPCHandler(
    "SnowCore.skillmanager",
    "learnskill",
    function(inst, skillname)
        inst.components.skillmanager:Learn(skillname)
    end
)

AddModRPCHandler(
    "SnowCore.skillmanager",
    "forgetskill",
    function(inst, skillname)
        inst.components.skillmanager:Forget(skillname)
    end
)

AddModRPCHandler(
    "SnowCore.skillmanager",
    "launchskill",
    function(inst, x, y, z, entity, name)
        inst.components.skillmanager:LaunchSkill(name, Vector3(x, y, z), entity)
    end
)

-- SendModRPCToServer(GetModRPC("SnowCore.skillmanager", "learnskill"), skillname)
-- SendModRPCToServer(GetModRPC("SnowCore.skillmanager", "forgetskill"), skillname)

--------------------------------------------------------------------------------------------------------

local sharedvar = {}
local sharedvarlisteners = {}

AddShardModRPCHandler(
    "SnowCore.sharedvar",
    "changesharedvar",
    function(name, value)
        for _, callback in pairs(sharedvarlisteners[name]) do
            callback(value, sharedvar[name])
        end
        sharedvar[name] = value
    end
)

GLOBAL.WatchSharedVariable = function(name, callback)
    sharedvarlisteners[name] = sharedvarlisteners[name] or {}
    table.insert(sharedvarlisteners[name], callback)
end

GLOBAL.StopWatchingSharedVariable = function(name, callback)
    if GetTableSize(sharedvarlisteners[name]) > 0 then
        table.removearrayvalue(sharedvarlisteners[name], callback)
    end
end

GLOBAL.GetSharedVariable = function(name)
    return sharedvar[name]
end

GLOBAL.SetSharedVariable = function(name, value)
    assert(type(value) ~= "function", "Unsupported variable type")
    assert(type(value) ~= "table", "Unsupported variable type")
    SendModRPCToShard(GetShardModRPCHandler("SnowCore.sharedvar", "changesharedvar"), name, value)
end

--------------------------------------------------------------------------------------------------------
