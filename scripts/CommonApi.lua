GLOBAL.ModSkillList = {}

GLOBAL.SKILLICON = {}
GLOBAL.SKILLSTRINGS = {}

GLOBAL.AddModSkill = function(name, data)
    ModSkillList[name] = data
end

GLOBAL.BUFFICONS = {}
GLOBAL.BUFFSTRINGS = {}

-- AddModSkill(
--     "example_skill",
--     {
--         onlearn = function(inst)
--         end,
--         onlaunch = function(inst, pos, target)
--         end,
--         onforget = function(inst)
--         end,
--         onlearn_client = function(inst)
--         end,
--         onlaunch_client = function(inst, pos, target)
--         end,
--         onforget_client = function(inst)
--         end,
--         ispassive = false,
--         cd = 10,
--         description = "This is a example skill",
--         image = "",
--         altas = ""
--     }
-- )

--------------------------------------------------------------------------------------------------------
