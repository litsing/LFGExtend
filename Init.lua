
local _G, format, next = _G, format, next
local gsub, pairs, tinsert, type = gsub, pairs, tinsert, type

local CreateFrame = CreateFrame
local RegisterCVar = C_CVar.RegisterCVar
local GetAddOnEnableState = GetAddOnEnableState
local GetAddOnMetadata = GetAddOnMetadata
local DisableAddOn = DisableAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local ReloadUI = ReloadUI
local GetLocale = GetLocale
local GetTime = GetTime



local AceAddon, AceAddonMinor = _G.LibStub('AceAddon-3.0')
local CallbackHandler = _G.LibStub('CallbackHandler-1.0')

local AddOnName, Engine = ...
local LFG = AceAddon:NewAddon(AddOnName, 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0', 'AceHook-3.0')
local AK = LFG:NewModule("AutoKeystone", "AceHook-3.0", "AceEvent-3.0")
LFG.DF = {profile = {},  char = {}}
LFG.callbacks = LFG.callbacks or CallbackHandler:New(LFG)
LFG.locale = GetLocale()


Engine[1] = LFG
Engine[2] = {}
Engine[3] = LFG.DF.profile
Engine[4] = LFG.DF.char
Engine[5] = {}
_G.LFGExtend = Engine


LFG.PriestColors = { r = 0.99, g = 0.99, b = 0.99, colorStr = 'fffcfcfc' }


do
    LFG.Libs = {}
    LFG.LibsMinor = {}
    function LFG:AddLib(name, major, minor)
        if not name then return end
        
        -- in this case: `major` is the lib table and `minor` is the minor version
        if type(major) == 'table' and type(minor) == 'number' then
            LFG.Libs[name], LFG.LibsMinor[name] = major, minor
        else -- in this case: `major` is the lib name and `minor` is the silent switch
            LFG.Libs[name], LFG.LibsMinor[name] = _G.LibStub(major, minor)
        end
    end
    
    LFG:AddLib('AceAddon', AceAddon, AceAddonMinor)
    LFG:AddLib('AceDB', 'AceDB-3.0')
    -- LFG:AddLib('LSM', 'LibSharedMedia-3.0')
    
    
    
    -- LFG.LSM = LFG.Libs.LSM
    
end



function LFG:OnEnable()
    
    LFG.initialized = true
    
    LFG:InitAPI()
    LFG:UpdateBlizzardFonts()
    LFG:RegisterEvent("WEEKLY_REWARDS_UPDATE") 
    LFG:RegisterEvent("CHALLENGE_MODE_COMPLETED") -- 挑战完成
    LFG:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE") -- 
    LFG:RegisterEvent("GROUP_ROSTER_UPDATE") -- 
    LFG:RegisterEvent("CHAT_MSG_ADDON") -- 
    LFG:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED") -- 实现自动邀请

    AK:Initialize()
    -- LFG:RegisterEvent("PARTY_LEADER_CHANGED") -- 
end


function LFG:OnInitialize()
    LFG:InitOptions()
    
    --LFG:Initialize()
end

function LFG:OnDisable()
    
end


function LFG:OnEvent(this,event)
    
end

