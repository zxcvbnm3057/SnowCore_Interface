GLOBAL.MakeUIDragable = function(name)
    local inject = function(self)
        self.OnControl = function(self, control, down)
            self:Dragable_OnControl(control, down)
        end

        function self:Dragable_OnControl(control, down)
            if control == CONTROL_ACCEPT then
                if down then
                    self:StartDrag()
                else
                    self:EndDrag()
                end
            end
        end

        function self:StartDrag()
            if not self.followhandler then
                self.dragPosDiff = self:GetPosition() - TheInput:GetScreenPosition()
                self.followhandler =
                    TheInput:AddMoveHandler(
                    function(x, y)
                        self:SetPosition(Vector3(x, y) + self.dragPosDiff)
                    end
                )
            end
        end

        function self:EndDrag()
            if self.followhandler then
                self.followhandler:Remove()
            end
            self.followhandler = nil
            self.dragPosDiff = nil
            local x, y, z = self:GetPosition():Get()
            SNOWCORE.DATA["UIPosition"][name] = {x = x, y = y, z = z}
            SNOWCORE.SAVEDATA()
        end

        self.inst:DoTaskInTime(
            0,
            function()
                if SNOWCORE.DATA["UIPosition"][name] then
                    print(
                        SNOWCORE.DATA["UIPosition"][name].x,
                        SNOWCORE.DATA["UIPosition"][name].y,
                        SNOWCORE.DATA["UIPosition"][name].z
                    )
                    self:SetPosition(
                        SNOWCORE.DATA["UIPosition"][name].x,
                        SNOWCORE.DATA["UIPosition"][name].y,
                        SNOWCORE.DATA["UIPosition"][name].z
                    )
                end
            end
        )
    end

    if type(name) == "string" then
        AddClassPostConstruct(name, inject)
    else
        inject(name)
    end
end

-----------------------------------------------------------------------------------------------------------------------------

GLOBAL.AddVisibleDebuffUI = function()
    local VisibleDebuffContainer = require("widgets/visibledebuffcontainer")
    AddClassPostConstruct(
        "widgets/controls",
        function(self, owner)
            if not self.VisibleDebuffUI then
                self.VisibleDebuffUI = self:AddChild(VisibleDebuffContainer(self.owner))
                self.VisibleDebuffUI:SetPosition(200, 125)
            end
        end
    )
end

-----------------------------------------------------------------------------------------------------------------------------

GLOBAL.AddVisibleSkillUI = function()
    local VisibleSkillContainer = require("widgets/visibleskillcontainer")
    AddClassPostConstruct(
        "widgets/controls",
        function(self, owner)
            if not self.VisibleSkillUI then
                self.VisibleSkillUI = self:AddChild(VisibleSkillContainer(self.owner))
                self.VisibleSkillUI:SetPosition(430, 130)
            end
        end
    )
end

-----------------------------------------------------------------------------------------------------------------------------

GLOBAL.SNOWCORE = {}
SNOWCORE.DATA_FILE = "mod_config_data/snowcore_data_save"
SNOWCORE.DATA = {}

TheSim:GetPersistentString(
    SNOWCORE.DATA_FILE,
    function(load_success, str)
        if load_success then
            local success, savedata = RunInSandboxSafe(str)
            if success and string.len(str) > 0 then
                SNOWCORE.DATA = savedata
            end
        end
    end
)

SNOWCORE.DATA["UIPosition"] = SNOWCORE.DATA["UIPosition"] or {}

SNOWCORE.SAVEDATA = function()
    if SNOWCORE.DATA and type(SNOWCORE.DATA) == "table" and SNOWCORE.DATA_FILE and type(SNOWCORE.DATA_FILE) == "string" then
        SavePersistentString(SNOWCORE.DATA_FILE, DataDumper(SNOWCORE.DATA, nil, true))
    end
end
