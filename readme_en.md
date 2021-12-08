# [API] Snow Core Interface

This is a common interface mod which provides some functions and components that most mods may use. My original intention is to reduce the number of loading components by MODS which has the same name or function, which may cause compatibility problems ,that may cause server crash, and increase server memory consumption. This mod only depend on the kernel of DST and provides extended APIs and components for other MODS. For bug feedback and function suggestions, please submit issue. For contribution, please submit a pr. if the source code contained in this mod inadvertently infringes your rights and interests, please contact me to delete.

Please refer to wiki for interface documents and descriptions. The following is a list of some components and methods included.

## components

|         name         |          function           |
| :------------------: | :-------------------------: |
|      cdmanager       |    Skill CD Calculation     |
|    hotkeymanager     |       Key Monitoring        |
|     skillmanager     |           Skills            |
|     levelmanager     |        Level and Exp        |
|    visibledebuff     | Buffable components with UI |
| visibledebuffmanager |   Buff manager for Entity   |

## function

|       函数名        |                             功能                             |
| :-----------------: | :----------------------------------------------------------: |
|      AOEAttack      |                          AOE Attack                          |
|   MakeUIDragable    |                 Make HUD Controls Draggable                  |
|     AddModSkill     |                Add Skills For `skillmanager`                 |
| AddVisibleDebuffUI  |                Add Buff Icon Bar For Players                 |
| AddVisibleDebuffUI  |                Add Skill Icon Bar For Players                |
| SetEntityInvincible | Make Entity Invincible, Different Sources Has Different Key, Not Easily Covered |
| WatchSharedVariable |          Add Shared Variable Between World Callback          |
|  SetSharedVariable  |              Set Shared Variable Between World               |
|  GetSharedVariable  |              Get Shared Variable Between World               |

## widget

|      组件名       |              功能              |
| :---------------: | :----------------------------: |
| visibledebuffcontainer |   A Container For Buff Icons   |
| visibledebuffslot | A Icon Widget For Single Buff  |
| visibleskillcontainer  |  A Container For Skill Icons   |
| visibleskillslot  | A Icon Widget For Single Skill |
