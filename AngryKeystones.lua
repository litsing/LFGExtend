
local LFG, L, P, C, G = unpack(LFGExtend)

local _G = _G
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = C_AddOns.LoadAddOn

local function AngryKeystones(self)
    local Mod = _G.AngryKeystones.Schedule
    G.addonsIsLoad.AngryKeystones = true

    self.WeeklyInfo.Child.WeeklyChest:ClearAllPoints()

    self.WeeklyInfo.Child.WeeklyChest:SetPoint("TOPRIGHT", self.WeeklyInfo.Child, "TOPRIGHT", -105, -160);
    Mod.AffixFrame:ClearAllPoints()
    -- Mod.AffixFrame:SetSize(246, 92)
    Mod.AffixFrame:SetPoint("CENTER", ChallengesFrame, "CENTER", 90, -190);
    Mod.PartyFrame:ClearAllPoints()
    Mod.PartyFrame:SetPoint("TOPLEFT", Mod.AffixFrame, "TOPRIGHT", 5, 0);
    Mod.KeystoneText:Hide()
    self.ChallengesSkinFrame.TimeFrame:SetShown(not G.addonsIsLoad.AngryKeystones)
end
function LFG:AngryKeystones()
    if not (_G.AngryKeystones.Config.schedule and LFG.db.profile.options.ChallengesEnable) then return end
    G.addonsIsLoad.AngryKeystones = true
    --     if C_AddOns.IsAddOnLoaded("Blizzard_ChallengesUI") and ChallengesFrame:IsShown() then
    --     hooksecurefunc(ChallengesFrame, "Update", AngryKeystones)
    -- end
    C_Timer.After(3, function()
        if not IsAddOnLoaded("Blizzard_ChallengesUI") then
            LoadAddOn("Blizzard_ChallengesUI")
        end
        hooksecurefunc(ChallengesFrame, "Update", AngryKeystones)
    end)

end

LFG:AddCallbackForAddon("AngryKeystones")
