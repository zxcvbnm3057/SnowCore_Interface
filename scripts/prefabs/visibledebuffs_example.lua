local MakeVisibleDebuff = require("prefabs/visibledebuff_common")

local example_debuff = {
    -- 是否显示图标和文本
    noicon = false,
    -- buff图标
    bufficons = {
        {
            image_activate = "example_debuff_actived.tex",
            altas_activate = "images/bufficons/example_debuff_actived.xml",
            image_inactivate = "example_debuff.tex",
            altas_inactivate = "images/bufficons/example_debuff.xml"
        }
    },
    -- buff文本
    buffstrings = {
        name = "示例buff",
        describe_nomal = "未激活时文本",
        describe_activated = "激活时文本"
    },
    -- 是buff/debuff?
    ispositive = true,
    -- 主机回调
    OnActivated = function(inst, target)
        -- buff生效
    end,
    OnDetached = function(inst, target)
        -- buff失效
    end,
    OnExtended = function(inst, target)
        -- buff叠加
    end,
    -- 客机回调
    OnTargetDirty = function(inst)
        -- buff附加到实体上
    end,
    OnActivatedDirty = function(inst)
        -- buff生效
    end,
    OnPercentDirty = function(inst)
        -- buff时间刷新
    end,
    -- 死亡时移除
    keep_on_death = false,
    -- 退出时移除
    remove_on_despawn = false,
    -- 周期性回调的频率
    tick_period = 0.5,
    -- 周期回调函数
    tick_task = function(inst)
    end,
    -- buff未激活时总持续时间
    duration = 180,
    -- buff激活后持续时间
    duration_activated = 60
}

return MakeVisibleDebuff("example_debuff", example_debuff)
