# [API] Snow Core Interface

这是一个提供了大多数mod可能用到的一些功能的通用接口mod，初衷是为了减少多个mod载入相同名称或功能的组件，这可能会导致兼容性问题，并增加服务器内存消耗。本mod仅依赖于饥荒官方内核，并对层提供拓展api及组件。bug反馈、功能建议请提交issue，参与贡献请提交pr，如果本mod中包含的源码无意中侵犯了您的权益，请联系我删除。

接口文档及说明请参考wiki，下面是包含的一些组件及方法列表。

## components

|        组件名        |        功能        |
| :------------------: | :----------------: |
|      cdmanager      |     技能cd计算     |
|    hotkeymanager    |      按键监听      |
|     skillmanager     |        技能        |
|     levelmanager     |        等级        |
|    visibledebuff    |      buff效果      |
| visibledebuffmanager | 实体上buff的管理器 |

## function

|       函数名       |             功能             |
| :-----------------: | :--------------------------: |
|      AOEAttack      |           范围攻击           |
|   MakeUIDragable   |         使界面可拖动         |
|     AddModSkill     |           添加技能           |
| AddVisibleDebuffUI |     为玩家添加buff图标栏     |
| AddVisibleDebuffUI |     为玩家添加技能图标栏     |
| SetEntityInvincible |           实体无敌           |
| WatchSharedVariable | 添加多层世界共享变量修改回调 |
|  SetSharedVariable  |     设置多层世界共享变量     |
|  GetSharedVariable  |    获取多层世界共享变量值    |

## widget

|      组件名      |          功能          |
| :---------------: | :--------------------: |
| visibledebuffcontainer |    一个buff图标列表    |
| visibledebuffslot | 用于显示buff图标的窗格 |
| visibleskillcontainer |    一个技能图标列表    |
| visibleskillslot | 用于显示技能图标的窗格 |
