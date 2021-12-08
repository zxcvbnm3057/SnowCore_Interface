name = "[API] Snow Core Interface"
version = "0.1.1"
description =
    "这是一个提供了大多数mod可能用到的一些功能的通用接口mod，初衷是为了减少多个mod载入相同名称或功能的组件，这可能会导致兼容性问题，并增加服务器内存消耗。本mod仅依赖于饥荒官方内核，并对上层提供拓展api及组件。bug反馈、功能建议请提交issue，参与贡献请提交pr，如果本mod中包含的源码无意中侵犯了您的权益，请联系我删除。"

author = "Fengying"

api_version = 10

dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true

priority = -100

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "SnowCore"
}
