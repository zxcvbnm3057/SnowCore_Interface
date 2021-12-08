GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

modimport("scripts/CommonApi.lua")

if TheNet:GetIsServer() then
    modimport("scripts/ServerApi.lua")
end

AddReplicableComponent("cdmanager")
AddReplicableComponent("levelmanager")
AddReplicableComponent("skillmanager")
AddReplicableComponent("visibledebuff")
AddReplicableComponent("visibledebuffmanager")

if not TheNet:IsDedicated() then
    modimport("scripts/ClientApi.lua")
end
