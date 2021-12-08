local function onexp(self, exp)
    self.inst.replica.levelmanager:SetExp(exp)
end

local function onlevelmaxexp(self, levelmaxexp)
    self.inst.replica.levelmanager:SetLevelMaxExp(levelmaxexp)
end

local function onlevel(self, level)
    self.inst.replica.levelmanager:SetLevel(level)
end

local function onmaxlevel(self, maxlevel)
    self.inst.replica.levelmanager:SetMaxLevel(maxlevel)
end

local LevelManager =
    Class(
    function(self, inst)
        self.inst = inst

        self.exp = 0
        self.levelmaxexp = 0

        self.level = 1
        self.maxlevel = 30

        self.onlevelup = nil
        self.onresetlevel = nil
        self.ongainexp = nil
        self.getlevelexp = function(level)
            return level * 100
        end
    end,
    nil,
    {
        exp = onexp,
        levelmaxexp = onlevelmaxexp,
        level = onlevel,
        maxlevel = onmaxlevel
    }
)

function LevelManager:SetExp(exp)
    self.exp = exp
    self.inst:PushEvent("expdelta", {exp = exp})
    if self.onsetexp then
        self.onsetexp(exp)
    end
end

function LevelManager:GetCurrentExp()
    return self.exp
end

function LevelManager:SetLevelExp(levelmaxexp)
    self.levelmaxexp = levelmaxexp
end

function LevelManager:ReCalcMaxExp()
    self:SetLevelExp(self.getlevelexp(self.inst, self.level))
end

function LevelManager:GetCurrentLevel()
    return self.level
end

function LevelManager:SetLevel(level)
    if self.level ~= level then
        if level == 0 then
            self.inst:PushEvent("resetlevel")
            if self.onresetlevel then
                self.onresetlevel()
            end
        else
            self.inst:PushEvent("levelup", {oldlevel = self.level, newlevel = level})

            if self.onlevelup then
                self.onlevelup(level)
            end
        end
        self.level = level
        self:ReCalcMaxExp()
    end
end

function LevelManager:SetMaxLevel(level)
    self.maxlevel = level
end

function LevelManager:SetLevelUp(fn)
    self.onlevelup = fn
end

function LevelManager:SetOnResetLevel(fn)
    self.onresetlevel = fn
end

function LevelManager:SetOnGainExp(fn)
    self.ongainexp = fn
end

function LevelManager:SetLevelExpFn(fn)
    self.getlevelexp = fn
end

function LevelManager:OnLoad(data)
    if data then
        self:SetLevel(data.level)
        self:ReCalcMaxExp()
        self:SetExp(data.exp)
    end
end

function LevelManager:OnSave()
    local data = {}
    data.exp = self.exp
    data.level = self.level
    return data
end

function LevelManager:IsLevelMaxed()
    return self.level >= self.maxlevel
end

function LevelManager:ExpDoDelta(delta)
    if self:IsLevelMaxed() then
        return
    end

    local exp = self.exp + delta

    while exp >= self.levelmaxexp do
        exp = exp - self.levelmaxexp
        self:SetLevel(self:GetCurrentLevel() + delta)
    end

    self:SetExp(exp)
    if self.ongainexp then
        self.ongainexp(exp)
    end
end

return LevelManager
