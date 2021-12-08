local HotkeyManager =
    Class(
    function(self, inst)
        self.inst = inst
        self.enabled = true
        self.HotkeyManagerKeyBlinding = {}
        --[[ 
            {
                KEY = {
                    Down = {
                        RPC = {
                            Namespace = "",
                            Action = "",
                            Data = {}
                        },
                        clientfn = function(inst, pos, entity)
                            ...
                        end
                    },
                    While = {
                        ...
                    },
                    Up = {
                        ...
                    },
                    TickTime = 1
                },
                ...
            }
         ]]
        self.HotkeyManagerTickTimes = {}
        self.HotkeyManagerTickTasks = {}
        self.keyhandler =
            TheInput:AddKeyHandler(
            function(key, down)
                self:OnInputEvent(key, down)
            end
        )
        self.mousehandler =
            TheInput:AddMouseButtonHandler(
            function(button, down)
                self:OnInputEvent(button, down)
            end
        )

        self.inst:ListenForEvent(
            "hotkeymanager_keydown",
            function(inst, data)
                if
                    data.inst == ThePlayer and self.HotkeyManagerKeyBlinding[data.key] and
                        not IsEntityDeadOrGhost(ThePlayer, true)
                 then
                    if self.HotkeyManagerKeyBlinding[data.key].Down then
                        self:TriggerCallback(self.HotkeyManagerKeyBlinding[data.key].Down)
                    end
                    if
                        self.HotkeyManagerKeyBlinding[data.key].TickTime and
                            self.HotkeyManagerKeyBlinding[data.key].While
                     then
                        self:SetTickTime(data.key, self.HotkeyManagerKeyBlinding[data.key].TickTime)
                        self:StartTrackingWhileDown(data.key, self.HotkeyManagerKeyBlinding[data.key].While)
                    end
                end
            end
        )

        self.inst:ListenForEvent(
            "hotkeymanager_keyup",
            function(inst, data)
                if
                    data.inst == ThePlayer and self.HotkeyManagerKeyBlinding[data.key] and
                        not IsEntityDeadOrGhost(ThePlayer, true)
                 then
                    if self.HotkeyManagerKeyBlinding[data.key].Up then
                        self:StopTrackingWhileDown(data.key, self.HotkeyManagerKeyBlinding[data.key].Up)
                    end
                end
            end
        )
    end
)

function HotkeyManager:OnRemoveEntity()
    TheInput.onkey:RemoveHandler(self.keyhandler)
    TheInput.onmousebutton:RemoveHandler(self.mousehandler)
end

function HotkeyManager:SetEnabled(enable)
    self.enabled = enable
end

function HotkeyManager:IsMonitoring()
    return self.enabled and TheFrontEnd:GetActiveScreen() == ThePlayer.HUD
end

function HotkeyManager:SetTickTime(key, time)
    self.HotkeyManagerTickTimes[key] = time or self.HotkeyManagerTickTimes[key] or 0
end

function HotkeyManager:OnInputEvent(key, down)
    if ThePlayer and self:IsMonitoring() then
        if (key and not down) then
            ThePlayer:PushEvent("hotkeymanager_keyup", {inst = self.inst, player = ThePlayer, key = key})
        elseif key and down then
            ThePlayer:PushEvent("hotkeymanager_keydown", {inst = self.inst, player = ThePlayer, key = key})
        end
    end
end

function HotkeyManager:TriggerCallback(action)
    local pos = TheInput:GetWorldPosition() or Vector3(0, 0, 0)
    local entity = TheInput:GetWorldEntityUnderMouse()
    if action.clientfn then
        action.clientfn(self.inst, pos, entity)
    end
    if action.RPC then
        SendModRPCToServer(
            GetModRPC(action.RPC.Namespace, action.RPC.Action),
            pos.x,
            pos.y,
            pos.z,
            entity,
            action.RPC.Data and unpack(action.RPC.Data) or nil
        )
    end
end

function HotkeyManager:StartTrackingWhileDown(Key, action)
    if not self.HotkeyManagerTickTasks[Key] then
        self.HotkeyManagerTickTasks[Key] =
            self.inst:DoTaskInTime(
            self.HotkeyManagerTickTimes[Key],
            function()
                self:TriggerCallback(action)
                self:StopTrackingWhileDown(Key)
                self:StartTrackingWhileDown(Key, action)
            end
        )
    end
end

function HotkeyManager:StopTrackingWhileDown(Key, action)
    if self.HotkeyManagerTickTasks[Key] then
        self.HotkeyManagerTickTasks[Key]:Cancel()
    end
    self.HotkeyManagerTickTasks[Key] = nil
    self:TriggerCallback(action)
end

function HotkeyManager:AddKeyHandler(key, handler)
    if not self.HotkeyManagerKeyBlinding[key] then
        self.HotkeyManagerKeyBlinding[key] = handler
    end
end

function HotkeyManager:RemoveKeyHandler(key)
    self.HotkeyManagerKeyBlinding[key] = nil
end

return HotkeyManager
