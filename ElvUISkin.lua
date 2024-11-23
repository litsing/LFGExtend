
local LFG, _, _, _, G = unpack(LFGExtend)
function LFG:ElvUI()
    local E = unpack(ElvUI)
    local S = E:GetModule('Skins')

    if LFGListFrame.SearchPanel.DoubleSignUp then
        S:HandleCheckBox(LFGListFrame.SearchPanel.DoubleSignUp)
    end

    if LFGListFrame.SearchPanel.AutoAcceptButton then
        S:HandleCheckBox(LFGListFrame.SearchPanel.AutoAcceptButton)
    end

    if LFGListFrame.EntryCreation.LFGAutoInvite  then
        S:HandleCheckBox(LFGListFrame.EntryCreation.LFGAutoInvite)
    end

    if LFGListFrame.EntryCreation.LFGAutoInviteTime  then
        S:HandleEditBox(LFGListFrame.EntryCreation.LFGAutoInviteTime)
    end

    if LFGListFrame.ApplicationViewer.LFGAutoInvite  then
        S:HandleCheckBox(LFGListFrame.ApplicationViewer.LFGAutoInvite)
    end

    if LFGListFrame.ApplicationViewer.LFGAutoInviteTime  then
        S:HandleEditBox(LFGListFrame.ApplicationViewer.LFGAutoInviteTime)
    end


end

LFG:AddCallbackForAddon("ElvUI")


function LFG:ElvUI_WindTools()
    if not LFG.db.profile.options.ChallengesEnable then return end
    local W = unpack(WindTools)
    local LL = W:GetModule("LFGList")
    hooksecurefunc(LL, "UpdatePartyKeystoneFrame", function()
       G.addonsIsLoad.ElvUI_WindTools_KeystoneEnable = LL.db.partyKeystone.enable
end)
end

LFG:AddCallbackForAddon("ElvUI_WindTools")
