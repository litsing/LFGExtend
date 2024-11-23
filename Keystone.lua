--自动放入钥石 来源wind工具
local LFG, L, P, C, G = unpack(LFGExtend)
local AK = LFG:GetModule('AutoKeystone')

local _G = _G


function AK:AutoKeystone()  --查找钥石并使用
if not LFG.db.profile.options.AutoKeystoneEnable then return end
    for bagIndex = 0, NUM_BAG_SLOTS do
        for slotIndex = 1, C_Container.GetContainerNumSlots(bagIndex) do
            local itemID = C_Container.GetContainerItemID(bagIndex, slotIndex)
            if itemID and C_Item.IsItemKeystoneByID(itemID) then
                C_Container.UseContainerItem(bagIndex, slotIndex)
                return
            end
        end
    end
end


function AK:UpdateHook(event, addon)
    if event then
        if addon == "Blizzard_ChallengesUI" then
            self:UnregisterEvent("ADDON_LOADED")
        else
            return
        end
    end

    local frame = _G.ChallengesKeystoneFrame
    if not frame then
        return
    end

    if LFG.db.profile.options.AutoKeystoneEnable then
        if not self:IsHooked(frame, "OnShow") then
            self:SecureHookScript(frame, "OnShow", "AutoKeystone")
        end
    else
        if self:IsHooked(frame, "OnShow") then
            self:Unhook(frame, "OnShow")
        end
    end
end


function AK:Initialize()

    if C_AddOns.IsAddOnLoaded("Blizzard_ChallengesUI") then
        self:UpdateHook()
    else
        self:RegisterEvent("ADDON_LOADED", "UpdateHook")
    end
end
