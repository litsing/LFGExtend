--LFG 界面修改
-- HONOR_INSET_WIDTH
local LFG, L, P, C, G = unpack(LFGExtend)

local _G = _G
local C_LFGList_GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local C_LFGList_GetSearchResultMemberInfo = C_LFGList.GetSearchResultMemberInfo
local C_LFGList_GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID

local formatMapName = ""
if LFG.locale == "zhCN" or LFG.locale == "zhTW" then
    formatMapName = "^(.+)（.+）$"
else
    formatMapName = "^(.+)%(.+%)$"
end
local RoleIconTextures = {
    SUNUI = {
        TANK = G.Media.Icons.sunUITank,
        HEALER = G.Media.Icons.sunUIHealer,
        DAMAGER = G.Media.Icons.sunUIDPS
    },
    LYNUI = {
        TANK = G.Media.Icons.lynUITank,
        HEALER = G.Media.Icons.lynUIHealer,
        DAMAGER = G.Media.Icons.lynUIDPS
    },
    ELVUI = {
        TANK = G.Media.Icons.ElvUITank,
        HEALER = G.Media.Icons.ElvUIHealer,
        DAMAGER = G.Media.Icons.ElvUIDPS
    },
    PhilMod = {
        TANK = G.Media.Icons.PhilModTank,
        HEALER = G.Media.Icons.PhilModHealer,
        DAMAGER = G.Media.Icons.PhilModDPS
    },
    LEADERICON =
    {
        ROUNDED = G.Media.Textures.leaderborder,
        BLZ = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
}}
-- local DungeonData = {}

-- local ActivityIdToMapId = {
--     [180] = 169,
--     [183] = 166,
--     [471] = 227,
--     [473] = 234,
--     [679] = 369,
--     [683] = 370,
--     [691] = 379, --"PF",
--     [695] = 377, --"DOS",
--     [699] = 378, --"HOA",
--     [703] = 375, --"MOTS",
--     [705] = 380, --"SD",
--     [709] = 381, --"SOA",
--     [713] = 376, --"NW",
--     [717] = 382, --"TOP",
--     [1016] = 391,
--     [1017] = 392,
-- }
local localizedSpecNameToIcon = {}

for classID = 1, 13 do
    local classFile = select(2, GetClassInfo(classID)) -- 
    
    if classFile then
        
        if not localizedSpecNameToIcon[classFile] then
            localizedSpecNameToIcon[classFile] = {}
        end
        
        for specIndex = 1, 4 do
            local specId, localizedSpecName, _, icon = GetSpecializationInfoForClassID(classID, specIndex)
            if specId and localizedSpecName and icon then
                localizedSpecNameToIcon[classFile][localizedSpecName] = icon
            end
        end
    end
end

local function DecodeDescriptionData(description)
    if not description or description == '' then
        return
    end
    local summary, data = description:match('^(.*)%((.+)%)$')
    if data then
        return summary, AceSerializer:Deserialize(data)
    else
        return description
    end
end
-- local function filterTable(t, ids)
--     filteredIDs = {}
--     for _, id in ipairs(ids) do
--         for j = #t, 1, -1 do
--             if (t[j] == id) then
--                 tremove(t, j)
--                 tinsert(filteredIDs, id)
--                 break
--             end
--         end
--     end
-- end

-- local function selectedDungeonCount()
--     --  if true then return 0 end
--     local selectedCount = 0;
--     G.selectedDungeton = ''
--     for _, v in pairs(DungeonData) do
--         --           selectedCount = v.selected and selectedCount + 1 or selectedCount
--         if v.selected then
--             selectedCount = selectedCount + 1
--             G.selectedDungeton = G.selectedDungeton..v.shortName.."     "
--         end
--     end
--     LFGListFrame.SearchPanel.filterDungeon.selectedDungeton:SetText(G.selectedDungeton)
--     return selectedCount
-- end
-- local dungeonChecked = function(self)
--     return DungeonData[self.value].selected
-- end

-- local updateDungeonList = function(self, arg1, arg2, checked)
--     DungeonData[arg1].selected = not DungeonData[arg1].selected
--     local dungeonText = selectedDungeonCount()
--     if (dungeonText > 0) then
--         dungeonText = "|cFF00FF00" .. dungeonText.. "|r"
--     end
--     UIDropDownMenu_SetText(LFGListFrame.SearchPanel.filterDungeon, dungeonText)
--     if LFGListFrame.SearchPanel:IsShown() then
--         LFGListFrame.SearchPanel.RefreshButton:Click()
--     end
--     if LFGListFrame.ApplicationViewer:IsShown() then
--         LFGListFrame.ApplicationViewer.RefreshButton:Click()
--     end
-- end

-- local dungeonMenuInit = function(self)
--     UIDropDownMenu_AddButton({text = L["LFG Filter Dungeon"], isTitle = true, value = 0, notCheckable = 1})
--     local actIdList = C_LFGList.GetAvailableActivities(2, nil, 1)
--     for i = 1, #actIdList do
--         local activityId = actIdList[i]
--         if ActivityIdToMapId[activityId] then
--             local shortName = G.MapShortName[activityId]
--             local mapName = C_ChallengeMode.GetMapUIInfo(ActivityIdToMapId[activityId]);
--             if not DungeonData[activityId] then
--                 DungeonData[activityId] = {
--                     name = mapName,
--                     shortName = shortName,
--                     selected = false,
--                     activityId = activityId
--                 }
--             end

--             local dungeonEntry = UIDropDownMenu_CreateInfo();
--             dungeonEntry.text, dungeonEntry.value, dungeonEntry.arg1, dungeonEntry.arg2 = mapName, activityId, activityId, nil
--             dungeonEntry.keepShownOnClick = 1
--             dungeonEntry.checked = dungeonChecked
--             dungeonEntry.func = updateDungeonList

--             UIDropDownMenu_AddButton(dungeonEntry)
--         end
--     end
-- end
-- local function addFilteredId(self, id)
--     if (not self.filteredIDs) then
--         self.filteredIDs = {}
--     end
--     tinsert(self.filteredIDs, id)
-- end
-- local function FilterSearchResults(searchResultID)
--     local searchResultInfo = C_LFGList.GetSearchResultInfo(searchResultID)
--     if searchResultInfo then
--         local friendGuildChar = (searchResultInfo.numBNetFriends or 0) + (searchResultInfo.numCharFriends or 0) + (searchResultInfo.numGuildMates or 0)
--         if (friendGuildChar == 0) then

--             --  local remainingRole = RemainingSlotsForLocalPlayerRole(searchResultID)
--             -- local searchResultScore = searchResultInfo.leaderOverallDungeonScore or 0
--             -- local filterByScore = scoreFilter and ((searchResultScore <= minScore) or (searchResultScore >= maxScore)) or false
--             -- local filterByRole = ignoreNoRole and not remainingRole or false
--             local filterByDungeon = false
--             if selectedDungeonCount() > 0 then
--                 if DungeonData[searchResultInfo.activityID] and DungeonData[searchResultInfo.activityID].selected then
--                     filterByDungeon = not DungeonData[searchResultInfo.activityID].selected
--                 else
--                     filterByDungeon = true
--                 end
--             end
--             --   if (filterByScore or filterByRole or filterByDungeon) then
--             if filterByDungeon then
--                 addFilteredId(LFGListFrame.SearchPanel, searchResultID)
--             end
--         end
--     end
-- end

-- local function LFGRewardsFrame_PointReset(parentFrame, dungeonID)
--     local parentName = parentFrame:GetName();
--     local leaderChecked, tankChecked, healerChecked, damageChecked = LFDQueueFrame_GetRoles();
--     local _, moneyAmount, _, _, _, numRewards = GetLFGDungeonRewards(dungeonID);

--     local itemButtonIndex = 1;
--     for i = 1, numRewards do
--         local name, texture, numItems, isBonusReward, rewardType, rewardID, quality = GetLFGDungeonRewardInfo(dungeonID, i);
--         if (isBonusReward == false) then
--             if rewardType == "currency" and C_CurrencyInfo.IsCurrencyContainer(rewardID, numItems) then
--                 name, texture, numItems, quality = CurrencyContainerUtil.GetCurrencyContainerInfo(rewardID, numItems, name, texture, quality);
--             end
--             lastFrame = LFGRewardsFrame_SetItemButton(parentFrame, dungeonID, itemButtonIndex, i, name, texture, numItems, rewardType, rewardID, quality);
--             itemButtonIndex = itemButtonIndex + 1;
--         end
--     end
--     if (not IsInGroup(LE_PARTY_CATEGORY_HOME)) then
--         for shortageIndex = 1, LFG_ROLE_NUM_SHORTAGE_TYPES do
--             local eligible, forTank, forHealer, forDamage, itemCount = GetLFGRoleShortageRewards(dungeonID, shortageIndex);
--             if (eligible and ((tankChecked and forTank) or (healerChecked and forHealer) or (damageChecked and forDamage))) then
--                 for rewardIndex = 1, itemCount do
--                     itemButtonIndex = itemButtonIndex + 1;
--                 end
--             end
--         end
--     end

--     for i = 2, parentFrame.numRewardFrames do
--         _G[parentName.."Item"..i]:SetPoint("LEFT", _G[parentName.."Item"..i - 1], "RIGHT", 50, 0);
--     end

--     if (moneyAmount > 0) then
--         parentFrame.MoneyReward:ClearAllPoints()
--         if (itemButtonIndex > 1) then
--             parentFrame.MoneyReward:SetPoint("LEFT", parentName.."Item" .. (itemButtonIndex - 1), "RIGHT", 50, 0);

--         else
--             parentFrame.MoneyReward:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 2, -8);
--         end
--     end
-- end

local function hook_LFGListApplicationViewer(btn, id)
    local applicantInfo = C_LFGList.GetApplicantInfo(id);
    if not btn.comment then
        btn.comment = btn:CreateFontString(nil, 'OVERLAY')
        btn.comment:SetFont(G.font, 11, "NONE")
        btn.comment:SetJustifyH("LEFT")
        btn.comment:SetSize(260, 30)
    end
    if LFGApplicationViewerRatingColumnHeader:IsShown() then
        btn.comment:ClearAllPoints()
        btn.comment:SetPoint('LEFT', btn, 'LEFT', 285, 0)
    else
        btn.comment:ClearAllPoints()
        btn.comment:SetPoint('LEFT', btn, 'LEFT', 205, 0)
    end
    if applicantInfo.comment then
        btn.comment:SetText(DecodeDescriptionData(applicantInfo.comment))
    end
end
local function IsDeclined(appStatus)
    return appStatus == "declined" or appStatus == "declined_delisted" or appStatus == "declined_full";
end
local function GetIconTextureWithClassAndSpecName(class, spec)
    return localizedSpecNameToIcon[class] and localizedSpecNameToIcon[class][spec]
end
local function ReskinIcon(self, icon, role, data)
    local class = data and data[1]
    local spec = data and data[2]
    local isLeader = data and data[3]
    
    if role and LFG.db.profile.options.LFGskinEnable then
        local selecticon = LFG.db.profile.options.LFGskinicon
        if selecticon == "SPEC" and (not class or not spec) then
            icon:SetTexture(RoleIconTextures['ELVUI'][role])
            icon:SetTexCoord(0, 1, 0, 1)
            icon:SetSize(20, 20)
        elseif selecticon == "SPEC" then
            local tex = GetIconTextureWithClassAndSpecName(class, spec)
            icon:SetTexture(tex)
            icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
            icon:SetSize(18, 18)
        else
            icon:SetTexture(RoleIconTextures[selecticon][role])
            icon:SetTexCoord(0, 1, 0, 1)
            icon:SetSize(20, 20)
        end     
        icon:Show()
    end
    
    -- 创建一个职业颜色
    if self then
        if class and LFG.db.profile.options.LFGClassEnable then
            if not icon.class then
                --icon.class = self:CreateTexture(nil, "BACKGROUND")
                icon.class = self:CreateTexture(nil, "ARTWORK")
                icon.class:SetTexture(G.Media.Textures.mask)
                icon.class:SetSize(20, 20)
                icon.class:SetPoint("CENTER", icon, 0, 0)
            end
            icon.class:SetShown(LFG.db.profile.options.LFGskinEnable and LFG.db.profile.options.LFGskinicon ~= "SPEC")
            local color = LFG:ClassColor(class, false)
            icon.class:SetVertexColor(color.r, color.g, color.b, 0.75)
            -- icon.class:SetAlpha(0.75)
        elseif icon.class then
            icon.class:Hide()
        end
        
        --队长指示
        if LFG.db.profile.options.LFGLeaderEnable then
            if not icon.leader then
                icon.leader = self:CreateTexture(nil, "OVERLAY")
            end
            if LFG.db.profile.options.LFGLeadericon == "BLZ" then
                icon.leader:ClearAllPoints()
                icon.leader:SetSize(13, 13)
                icon.leader:SetPoint("TOP", icon, 5, 5)
                icon.leader:SetRotation(rad(-15))
            else
                icon.leader:ClearAllPoints()
                icon.leader:SetSize(20, 20)
                icon.leader:SetPoint("CENTER", icon, 0, 0)
                icon.leader:SetRotation(0)
            end
            icon.leader:SetTexture(RoleIconTextures["LEADERICON"][LFG.db.profile.options.LFGLeadericon])
            icon.leader:SetShown(isLeader)
        end
    end
end
-- local function DifficultyColor(name)
--     for i = 1, 4 do
--         if G.DifficultyName[i] == name then return i end
--     end
--     return false
-- end

local function DecodeCommetData(comment)
    if not comment or comment == '' then
        return ''
    end
    local summary, data = comment:match('^(.*)%((^1^.+^^)%)$')
    if not data then
        return comment
    end
    return summary
end

-- local function LFGDataDisplay_Update(self, categoryID)
--     if(not categoryID) then
--         return;
--     end
--     if categoryID == 1 or categoryID == 113 then
--         self.RoleCount:Hide();
--         self.Enumerate:Hide();
--         self.PlayerCount:Show();
--     elseif categoryID == 2 then
--         self.RoleCount:Hide();
--         self.Enumerate:Show();
--         self.PlayerCount:Hide();
--     elseif categoryID == 3 or categoryID == 6 then
--         self.RoleCount:Show();
--         self.Enumerate:Hide();
--         self.PlayerCount:Hide();
--     else
--         GMError("Unknown display type");
--         self.RoleCount:Hide();
--         self.Enumerate:Hide();
--         self.PlayerCount:Hide();
--     end
-- end

local function LFGListSearch_Update(self)
    local resultID = self.resultID;
    if not resultID or not C_LFGList.HasSearchResultInfo(resultID) then
        return;
    end
    local _, appStatus, pendingStatus, appDuration = C_LFGList.GetApplicationInfo(resultID);
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
    local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)
    local iLvlColor = LFG.db.profile.options.LevelColor[6]
    local activityColor = LFG_LIST_DELISTED_FONT_COLOR;
    local disableColor = LFG_LIST_DELISTED_FONT_COLOR;
    local isAppFinished = searchResultInfo.isDelisted or LFGListUtil_IsStatusInactive(appStatus) or LFGListUtil_IsStatusInactive(pendingStatus);
    
    --语音位置修改
    self.VoiceChat:SetPoint('LEFT', 240, -1)
    self.VoiceChat:SetSize(12, 12)
    
    --显示队长名字
    if not self.leader then
        self.leader = self:CreateFontString(nil, 'ARTWORK', "GameFontNormal")
        self.leader:SetPoint('LEFT', self, 'LEFT', 260, 0)
    end
    self.leader:SetText('')
    if LFG.db.profile.options.LFGLeaderNameEnable then
        local leader = ""
        if searchResultInfo.leaderName then
            leader = searchResultInfo.leaderName:match('^(.+)%-') or searchResultInfo.leaderName or ""
        end
        local class = select(2, C_LFGList.GetSearchResultMemberInfo(resultID, 1))
        local leaderColor = LFG:ClassColor(class, false)
        leader = LFG:StringWithRGB(leader, isAppFinished and disableColor or leaderColor)
        self.leader:SetText(leader)
    end
    --地下城名字修改
    self.ActivityName:SetWidth(300)
    local activityName = self.ActivityName:GetText()
    local leaderScore = ''
    
    --缩写地图名
    if LFG.db.profile.options.LFGShortMapEnable then
        activityName = activityName:match(formatMapName) or activityName
        activityName = G.MapShortName[searchResultInfo.activityID] or activityName
    end
    --颜色区别难度
    if LFG.db.profile.options.LFGMapNameColorEnable then
        activityName = activityName:match(formatMapName) or activityName
        local orderIndex = G.DifficultyName[activityInfo.shortName]
        if orderIndex and orderIndex > 0 then
            activityColor = LFG.db.profile.options.DungeonColor[orderIndex]
            activityName = LFG:StringWithRGB(activityName, isAppFinished and disableColor or activityColor)
        end
    elseif not LFG.db.profile.options.LFGMapNameColorEnable and LFG.db.profile.options.LFGShortMapEnable then
        activityName = activityName..G.DifficultyShortName[G.DifficultyName[activityInfo.shortName]]
    end
    
    --显示队长分数
    if LFG.db.profile.options.LFGLeaderScoreEnable then
        local score = 0
        if activityInfo.isMythicPlusActivity then
            score = searchResultInfo.leaderOverallDungeonScore or 0
        elseif activityInfo.isPvpActivity and searchResultInfo.leaderPvpRatingInfo then
            score = searchResultInfo.leaderPvpRatingInfo.rating or 0
        end
        if score > 0 then
            local color = score and C_ChallengeMode_GetDungeonScoreRarityColor(score) or iLvlColor
            leaderScore = LFG:StringWithRGB(score, isAppFinished and disableColor or color)
            activityName = leaderScore..'-'..activityName
        end
    end
    
    self.ActivityName:SetText(activityName)
    
    --装等要求以及分数
    local ilvl = ''
    if not self.iLvl then
        self.iLvl = self:CreateFontString(nil, 'ARTWORK', "GameFontNormal")
        self.iLvl:SetPoint('CENTER', self, 'LEFT', 220, 0)
        self.iLvl:SetWidth(60)
        self.iLvl:SetSpacing(2)
        --  self.iLvl:SetJustifyH("CENTER")
        -- self.iLvl:SetJustifyV("MIDDLE")
    end
    self.iLvl:SetText(ilvl)
    --装等要求
    if LFG.db.profile.options.LFGilvlEnable then
        --装等颜色
        if isAppFinished then
            iLvlColor = disableColor
        else
            for i = 5, 1, -1 do
                if searchResultInfo.requiredItemLevel >= LFG.db.profile.options.LFGilvl[i] then
                    iLvlColor = LFG.db.profile.options.LevelColor[i]
                    break
                end
            end
        end
        ilvl = searchResultInfo.requiredItemLevel > 0 and math.floor(searchResultInfo.requiredItemLevel) or ''
        ilvl = LFG:StringWithRGB(ilvl, iLvlColor)
    end
    
    --大米分数或PVP分数要求显示
    local scoreText = ''
    if LFG.db.profile.options.LFGScoreEnable then
        if activityInfo.isMythicPlusActivity or activityInfo.isMythicActivity then
            local score = searchResultInfo.requiredDungeonScore or 0
            local color = score and C_ChallengeMode_GetDungeonScoreRarityColor(score) or iLvlColor
            score = math.floor(score)
            score = score > 0 and score or ''
            scoreText = LFG:StringWithRGB(score, isAppFinished and disableColor or color)
        elseif activityInfo.isPvpActivity and searchResultInfo.requiredPvpRating > 0 then
            scoreText = LFG:StringWithRGB(math.floor(searchResultInfo.requiredPvpRating), isAppFinished and disableColor or iLvlColor)
        end
    end
    
    if activityInfo.isMythicPlusActivity or activityInfo.isPvpActivity then
        self.iLvl:SetText(ilvl.."\n"..scoreText)
    else
        self.iLvl:SetText(ilvl)
    end
    --队伍描述
    if not self.comment then
        self.comment = self:CreateFontString(nil, 'ARTWORK', "GameFontNormal")
        self.comment:SetPoint('LEFT', self, 'LEFT', 365, 0)
        self.comment:SetSize(200, 30)
        self.comment:SetJustifyH("LEFT")
        --  self.comment:SetPoint('LEFT', self, 'LEFT', 460, 0)
    end
    self.comment:SetText('')
    if LFG.db.profile.options.LFGcommentEnable then
        self.comment:SetText(DecodeCommetData(searchResultInfo.comment) or '')
        if isAppFinished then
            self.comment:SetTextColor(disableColor.r, disableColor.g, disableColor.b)
        else
            self.comment:SetTextColor(1, 1, 1)
        end
    end
    
end

local function UpdateEnumerate(self, numPlayers)
    local button = self:GetParent():GetParent()
    
    if not button.resultID then
        return
    end
    
    local resultInfo = C_LFGList_GetSearchResultInfo(button.resultID)
    
    if not resultInfo then
        return
    end
    
    local cache = {
        TANK = {},
        HEALER = {},
        DAMAGER = {},
    }
    for i = 1, resultInfo.numMembers do
        local role, class, _, spec = C_LFGList_GetSearchResultMemberInfo(button.resultID, i)
        tinsert(cache[role], {class, spec, i == 1})
    end
    --清除上一条痕迹
    for i = 5, 1, -1 do
        local icon = self["Icon" .. i]
        local roleIcon = icon.RoleIcon
        if roleIcon and roleIcon.class then
            roleIcon.class:Hide()
        end
        if roleIcon and roleIcon.leader then
            roleIcon.leader:Hide()
        end
    end
    for i = numPlayers, 1, -1 do
        local icon = self["Icon" .. i]
        local roleIcon = icon.RoleIcon
        local classCircle = icon.ClassCircle
        
        if roleIcon and roleIcon.SetTexture then
            if #cache.TANK > 0 then
                ReskinIcon(self, roleIcon, "TANK", cache.TANK[1])
                tremove(cache.TANK, 1)
            elseif #cache.HEALER > 0 then
                ReskinIcon(self, roleIcon, "HEALER", cache.HEALER[1])
                tremove(cache.HEALER, 1)
            elseif #cache.DAMAGER > 0 then
                ReskinIcon(self, roleIcon, "DAMAGER", cache.DAMAGER[1])
                tremove(cache.DAMAGER, 1)
            else
                ReskinIcon(self, roleIcon)
            end
        end
        
        if classCircle and LFG.db.profile.options.LFGClassEnable then
            classCircle:Hide()
        end
    end
end

-- local function UpdateLFGListGroupDataDisplay(self, activityID)
--     local activityInfo = C_LFGList.GetActivityInfoTable(activityID);
--     if(not activityInfo) then
--         return;
--     end
--     self:SetPoint("RIGHT", -250, 0)
--     LFGDataDisplay_Update(self, activityInfo.categoryID)
-- end

local function UpdateRoleCount(RoleCount)
    if LFG.db.profile.options.LFGskinEnable then
        if RoleCount.TankIcon then
            ReskinIcon(nil, RoleCount.TankIcon, "TANK")
        end
        if RoleCount.HealerIcon then
            ReskinIcon(nil, RoleCount.HealerIcon, "HEALER")
        end
        if RoleCount.DamagerIcon then
            ReskinIcon(nil, RoleCount.DamagerIcon, "DAMAGER")
        end
    end
end
local function OnDoubleSignUpClick()
    if LFG.db.profile.options.DoubleSignUpButtonEnable and LFG.db.profile.options.DoubleSignUpEnable then
        if LFGListFrame.SearchPanel.SignUpButton:IsEnabled() then
            LFGListFrame.SearchPanel.SignUpButton:Click()
        end
        if (not IsAltKeyDown()) and LFGListApplicationDialog:IsShown() and LFGListApplicationDialog.SignUpButton:IsEnabled() then
            LFGListApplicationDialog.SignUpButton:Click()
        end
    end
end

local function OnDoubleSignUp(self)
    local status = self:GetChecked()
    LFG.db.profile.options.DoubleSignUpEnable = status
end

local function AutoAcceptClick(self)
    local status = self:GetChecked()
    LFG.db.profile.options.LFGAutoAcceptEnable = status
end

local function LFGAutoInviteTimeEnable(self, status)
    if true then return end
    if status then
        self.LFGAutoInviteTime:Enable()
        self.LFGAutoInviteTime:SetTextColor(1, 1, 1)
        self.LFGAutoInviteTime.Text:SetTextColor(1, 1, 1)
    else
        self.LFGAutoInviteTime:Disable()
        self.LFGAutoInviteTime:SetTextColor(0.3, 0.3, 0.3)
        self.LFGAutoInviteTime.Text:SetTextColor(0.3, 0.3, 0.3)
        
    end
end

local function CanelAutoInvite()
    for _, v in ipairs(G.handle) do
        if v then
            v:Cancel()
        end
    end
    wipe(G.handle)
end

local function LFGAutoInviteChecked(self)
    local status = self:GetChecked()
    local parent = self:GetParent()
    LFGAutoInviteTimeEnable(parent, status)
    if not status then
        CanelAutoInvite()
    end
    if parent.RefreshButton then
        parent.RefreshButton:Click()
    end
    
    LFG.db.profile.options.LFGAutoInviteEnable = status
end

-- local function SortSearchResults(results)
--     if LFG.db.profile.options.DuneonfilteredButton then
--         if LFGListFrame.CategorySelection.selectedCategory ~= 2 then
--             return
--         end
--         if (#results > 0) then
--             for _, id in ipairs(results) do
--                 FilterSearchResults(id)
--             end
--         end
--         if (LFGListFrame.SearchPanel.filteredIDs) then
--             filterTable(LFGListFrame.SearchPanel.results, LFGListFrame.SearchPanel.filteredIDs)
--             LFGListFrame.SearchPanel.filteredIDs = nil
--         end
--         if #results > 0 then
--             LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
--         end
--     end
-- end

local function LFGAutoInviteTimeEditBoxEnter(self)
    local num = self:GetText()
    if not num then
        self:SetText(LFG.db.profile.options.LFGAutoInviteTime)
        self:ClearFocus()
        return
    end
    num = tonumber(num)
    if not num then
        self:SetText(LFG.db.profile.options.LFGAutoInviteTime)
        self:ClearFocus()
        return
    end
    num = math.floor(num) > 0 and math.floor(num) or 0
    LFG.db.profile.options.LFGAutoInviteTime = num
    LFGListFrame.ApplicationViewer.RefreshButton:Click()
    self:ClearFocus()
end

local function LFGAutoInviteTimeEditBoxESC(self)
    self:SetText(LFG.db.profile.options.LFGAutoInviteTime)
    self:ClearFocus()
end
local function BlzBugFixed()
    
    --显示2个申请
    hooksecurefunc("LFGListSearchPanel_UpdateResultList", function(self)
            if next(self.results) and next(self.applications) then
                for _, value in ipairs(self.applications) do
                    tDeleteItem(self.results, value)
                end
                self.totalResults = #self.results
                
                LFGListSearchPanel_UpdateResults(self)
            end
    end)
    --双击申请导致转圈圈
    hooksecurefunc("LFGListSearchPanel_UpdateResultList", function(self)
            if next(self.results) and next(self.applications) then
                for _, value in ipairs_reverse(self.applications) do
                    local resultInfo = C_LFGList.GetSearchResultInfo(value)
                    local _, status, _, _, role = C_LFGList.GetApplicationInfo(value)
                    if status == "none" then
                        tDeleteItem(self.applications, value)
                    end
                    self.totalResults = #self.results
                    LFGListSearchPanel_UpdateResults(self)
                end
            end
    end)
    
end

--创建队伍修改
local function CreateEntryCreationLFGAutoInvite(self)
    --背景
    self.Inset.CustomBG:SetAllPoints()
    --名称标签
    local IsShownPlayStyleDropdown = false
    
    -- hooksecurefunc('LFGListEntryCreation_OnLoad', function(self)
    --     self.GroupDropdown:ClearAllPoints()
    --     self.GroupDropdown:SetPoint("LEFT", self.LFGAutoInvite, "RIGHT", 100, 0)
    -- end)
    
    --创建队伍修改 创建自动邀请
    if not self.LFGAutoInvite then
        self.LFGAutoInvite = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        self.LFGAutoInvite:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 100, 100)
        --   self.LFGAutoInvite:SetPoint("BOTTOMLEFT", self.NameLabel, "TOPLEFT", 0, -290)
        self.LFGAutoInvite:SetSize(25, 25)
        self.LFGAutoInvite:SetChecked(LFG.db.profile.options.LFGAutoInviteEnable)
        self.LFGAutoInvite.Text:SetText(L["LFG Auto Invite"])
        self.LFGAutoInvite:SetScript("OnClick", LFGAutoInviteChecked)
        
        self.LFGAutoInviteTime = CreateFrame("EditBox", "Time", self, "InputBoxTemplate")
        self.LFGAutoInviteTime:SetPoint("LEFT", self.LFGAutoInvite, "RIGHT", 145, 0)
        self.LFGAutoInviteTime:SetSize(20, 20)
        self.LFGAutoInviteTime:SetAutoFocus(false)
        self.LFGAutoInviteTime:SetText(LFG.db.profile.options.LFGAutoInviteTime)
        self.LFGAutoInviteTime:SetJustifyH("RIGHT")
        self.LFGAutoInviteTime:SetScript("OnEscapePressed", LFGAutoInviteTimeEditBoxESC)
        self.LFGAutoInviteTime:SetScript("OnEditFocusLost", LFGAutoInviteTimeEditBoxESC)
        self.LFGAutoInviteTime:SetScript("OnEnterPressed", LFGAutoInviteTimeEditBoxEnter)
        self.LFGAutoInviteTime.Text = self.LFGAutoInviteTime:CreateFontString(nil, "OVERLAY")
        self.LFGAutoInviteTime.Text:SetFont(G.font, 12)
        self.LFGAutoInviteTime.Text:SetText(L["seconds Auto Invite"])
        self.LFGAutoInviteTime.Text:SetPoint("LEFT", 23, 0)
        self.LFGAutoInviteTime:Hide()
        
    end
    
    hooksecurefunc('LFGListEntryCreation_Select', function(self)
            --           self.GroupDropdown:SetWidth(541);
            if self.GroupDropdown:IsShown() then
                self.GroupDropdown:SetWidth(350);
                self.GroupDropdown:ClearAllPoints()
                self.GroupDropdown:SetPoint("TOPLEFT", self, "TOPLEFT", 100, -80)
                -- self.ActivityDropdown:SetWidth(238);
                IsShownPlayStyleDropdown = self.PlayStyleDropdown:IsShown()
                if IsShownPlayStyleDropdown then
                    self.PlayStyleLabel:SetPoint("TOPLEFT", 100, -315);
                end
                
            end
            self.NameLabel:ClearAllPoints();
            if (not self.ActivityDropdown:IsShown() and not self.GroupDropdown:IsShown()) then
                self.NameLabel:SetPoint("TOPLEFT", 100, -82);
            else
                self.NameLabel:SetPoint("TOPLEFT", 100, -120);
                
            end
            self.Name:SetWidth(500);
            self.Description:SetSize(500, 100);
            
    end)
    hooksecurefunc('LFGListEntryCreation_UpdateAuthenticatedState', function(self)
            self.LFGAutoInvite:SetShown(LFG.db.profile.options.LFGAutoInviteButtonEnable)
            -- self.LFGAutoInviteTime:SetShown(LFG.db.profile.options.LFGAutoInviteButtonEnable)
    end)
end

local function CreateApplicationViewerLFGAutoInvite(self)
    if not self.LFGAutoInvite then
        self.LFGAutoInvite = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
        self.LFGAutoInvite:SetPoint("TOPLEFT", self, "TOPLEFT", 15, -90)
        --  self.LFGAutoInvite:SetSize(50,20)
        self.LFGAutoInvite:SetChecked(LFG.db.profile.options.LFGAutoInviteEnable)
        self.LFGAutoInvite.Text:SetText(L["LFG Auto Invite"])
        self.LFGAutoInvite:SetScript("OnClick", LFGAutoInviteChecked)
        
        self.LFGAutoInviteTime = self.LFGAutoInviteTime or CreateFrame("EditBox", "Time", self, "InputBoxTemplate")
        self.LFGAutoInviteTime:SetPoint("LEFT", self.LFGAutoInvite, "RIGHT", 120, 0)
        self.LFGAutoInviteTime:SetSize(30, 20)
        self.LFGAutoInviteTime:SetAutoFocus(false)
        self.LFGAutoInviteTime:SetJustifyH("RIGHT")
        self.LFGAutoInviteTime:SetText(LFG.db.profile.options.LFGAutoInviteTime)
        self.LFGAutoInviteTime:SetScript("OnEscapePressed", LFGAutoInviteTimeEditBoxESC)
        self.LFGAutoInviteTime:SetScript("OnEditFocusLost", LFGAutoInviteTimeEditBoxESC)
        self.LFGAutoInviteTime:SetScript("OnEnterPressed", LFGAutoInviteTimeEditBoxEnter)
        self.LFGAutoInviteTime.Text = self.LFGAutoInviteTime.Text or self.LFGAutoInviteTime:CreateFontString(nil, "OVERLAY")
        self.LFGAutoInviteTime.Text:SetFont(G.font, 15)
        self.LFGAutoInviteTime.Text:SetText(L["seconds Auto Invite"])
        self.LFGAutoInviteTime.Text:SetPoint("LEFT", 35, 0)
        self.LFGAutoInviteTime:Hide()
        
        LFGAutoInviteChecked(self.LFGAutoInvite)
    end
end

--自动邀请实现


function LFG:CheckCanInvite(id,numAllowed)
    local applicantInfo = C_LFGList.GetApplicantInfo(id)
    local status = applicantInfo.applicationStatus
    local numMembers = applicantInfo.numMembers
    
    if numAllowed == 0 then
        numAllowed = MAX_RAID_MEMBERS
    end
    
    local currentCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
    local numInvited = C_LFGList.GetNumInvitedApplicantMembers()
    
    if numMembers + currentCount + numInvited > numAllowed then
        return
    elseif status == 'applied' then
        return true
    end
end
local function GetPlayerRegion()
    local regionTable = { "US", "KR", "EU", "TW", "CN" }
    local playerAccountInfo = C_BattleNet.GetAccountInfoByGUID(UnitGUID("player"))
    local currentRegion = GetCurrentRegion()
    
    if not playerAccountInfo or not playerAccountInfo.gameAccountInfo or not playerAccountInfo.gameAccountInfo.regionID then
        return regionTable[currentRegion]
    else
        return regionTable[playerAccountInfo.gameAccountInfo.regionID]
    end
end

--自动邀请实现
function LFG:LFG_LIST_APPLICANT_LIST_UPDATED()
    if not (LFG.db.profile.options.LFGAutoInviteButtonEnable and LFG.db.profile.options.LFGAutoInviteEnable and UnitIsGroupLeader("player")) then
        return
    end
    local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
    if not activeEntryInfo then return end
    
    local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID);
    local numAllowed = activityInfo.maxNumPlayers;
    
    if numAllowed == 0 then
        numAllowed = MAX_RAID_MEMBERS
    end
    
    if LFG.locale == "zhCN" then
        ConsoleExec("profanityFilter 1")
        
        local playerRegion = GetPlayerRegion()
        
        local applicants = C_LFGList.GetApplicants() or {}
        ConsoleExec("portal CN")
        for k, v in pairs(applicants) do
            if LFG:CheckCanInvite(v,numAllowed) then           
                C_LFGList.InviteApplicant(v)        
            end
        end
        ConsoleExec("portal " .. playerRegion)
    else
        local applicants = C_LFGList.GetApplicants() or {}
        for k, v in pairs(applicants) do
            if LFG:CheckCanInvite(v,numAllowed) then           
                C_LFGList.InviteApplicant(v)        
            end
        end
    end
end


-- local function AutoInviteMember(member, appID, memberIdx, status)
--     if not (LFG.db.profile.options.LFGAutoInviteButtonEnable and LFG.db.profile.options.LFGAutoInviteEnable and UnitIsGroupLeader("player")) then
--         return
--     end
--     local applicantInfo = C_LFGList.GetApplicantInfo(appID)
--     local numMembers = applicantInfo.numMembers --申请人数
--     local numInvited = C_LFGList.GetNumInvitedApplicantMembers() --已邀请人数
--     local currentCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
--     if status == 'applied' and member:GetParent().numMembers then
--         local name = C_LFGList.GetApplicantMemberInfo(appID, memberIdx);
--         if G.handle[name] then return end
--         print(name)
--         if numMembers + numInvited + currentCount >= 4 and not IsInRaid() then
--             C_PartyInfo.ConvertToRaid()
--         end
--         if LFG.db.profile.options.LFGAutoInviteTime > 0 then
--             local handle = C_Timer.NewTimer(LFG.db.profile.options.LFGAutoInviteTime, function()
--                     if numMembers + numInvited + currentCount <= 40 then
--                         member:GetParent().InviteButton:Click()
--                     end
--                     if GetTime() > G.time + 1 then
--                         LFGListFrame.ApplicationViewer.RefreshButton:Click()
--                         G.time = GetTime()
--                     end
--             end)
--             G.handle[name] = handle
--         else
--             if numMembers + numInvited + currentCount <= 40 then
--                 member:GetParent().InviteButton:Click()
--             end
--             if GetTime() > G.time + 1 then
--                 C_Timer.After(.1, function()
--                         LFGListFrame.ApplicationViewer.RefreshButton:Click()
--                 end)
--                 G.time = GetTime()
--             end

--         end
--     end
-- end

-- function LFG:PARTY_LEADER_CHANGED()
--     LFG.db.profile.options.LFGAutoInviteEnable = false
-- end

function LFG:LookingForGroupFrames()
    --修改大小
    local width = LFG.db.profile.options.width - 225
    hooksecurefunc("PVEFrame_ShowFrame", function(self) PVEFrame:SetWidth(LFG.db.profile.options.width) end)
    _G.PVEFrame:SetHeight(LFG.db.profile.options.height)
    _G.PVEFrame.TopTileStreaks:Hide()
    _G.PVEFrameLeftInset:SetHeight(LFG.db.profile.options.height)
    
    _G.PVEFrameBlueBg:SetHeight(LFG.db.profile.options.height-30)
    
    _G.LFGListPVEStub:SetSize(width, LFG.db.profile.options.height)
    
    _G.LFDParentFrame:SetSize(width, LFG.db.profile.options.height) -- 地下城查找器
    _G.LFDParentFrameRoleBackground:ClearAllPoints()
    _G.LFDParentFrameRoleBackground:SetSize(LFG.db.profile.options.width + 130, 150)
    _G.LFDParentFrameRoleBackground:SetPoint("TOPLEFT", 0, -20)
    
    _G.RaidFinderFrame:SetSize(width, LFG.db.profile.options.height) --随机团本查找
    
    --对地下城查找器重新布局
    --职责选择
    --_G.LFDQueueFrame:SetPoint("TOPLEFT", _G.LFDParentFrame, "TOPLEFT", 0, 0)
    -- _G.LFDQueueFrameBackground:SetTexture(_G.LFDQueueFrameBackground:GetTexture(), "REPEAT", "REPEAT")
    _G.LFDParentFrameInset:Hide()
    _G.LFDQueueFrameBackground:ClearAllPoints()
    _G.LFDQueueFrameBackground:SetSize(LFG.db.profile.options.width + 150, LFG.db.profile.options.height - 205)
    _G.LFDQueueFrameBackground:SetPoint("LEFT", 0, -60)
    
    
    hooksecurefunc("LFGRewardsFrame_UpdateFrame", function(self) 
            _G.LFDQueueFrameBackground:ClearAllPoints()
            _G.LFDQueueFrameBackground:SetSize(LFG.db.profile.options.width + 150, LFG.db.profile.options.height - 205)
            _G.LFDQueueFrameBackground:SetPoint("LEFT", 0, -60)
    end)
    -- _G.LFDQueueFrameBackground:Hide()
    local widthx = width / 4
    _G.LFDQueueFrameRoleButtonTank:ClearAllPoints()
    _G.LFDQueueFrameRoleButtonTank:SetPoint("TOPLEFT", _G.LFDQueueFrame, "TOPLEFT", 50, -50)
    _G.LFDQueueFrameRoleButtonHealer:SetPoint("LEFT", _G.LFDQueueFrameRoleButtonTank, "LEFT", widthx, 0)
    _G.LFDQueueFrameRoleButtonDPS:SetPoint("LEFT", _G.LFDQueueFrameRoleButtonHealer, "LEFT", widthx, 0)
    _G.LFDQueueFrameRoleButtonLeader:SetPoint("LEFT", _G.LFDQueueFrameRoleButtonDPS, "LEFT", widthx, 0)
    
    --寻找队伍按钮
    _G.LFDQueueFrameFindGroupButton:SetPoint('BOTTOM', 0, 15)
    
    --类型
    _G.LFDQueueFrameTypeDropdown:ClearAllPoints()
    _G.LFDQueueFrameTypeDropdown:SetPoint("TOPRIGHT", _G.LFDQueueFrame, "TOPRIGHT", -50, -130)
    
    --指定地下城修改
    LFDQueueFrameFollowerTitle:SetPoint( "TOPLEFT", 0, -168)
    -- LFDQueueFrameFollower.ScrollBox:SetPoint( "TOPLEFT", 0, -165)
    -- LFDQueueFrameFollower.ScrollBox:SetPoint( "BOTTOMRIGHT", -35, 35)
    LFDQueueFrameSpecific.ScrollBox:SetPoint( "TOPLEFT", 0, -165)
    LFDQueueFrameSpecific.ScrollBox:SetPoint( "BOTTOMRIGHT", -35, 35)
    -- do
    --     local Specificbtnheight = (LFG.db.profile.options.height - 200)/16
    --     LFDQueueFrameSpecificListButton1:SetPoint("BOTTOMLEFT", _G.LFDQueueFrame, "BOTTOMLEFT", 0, LFG.db.profile.options.height - 200)
    --     hooksecurefunc("LFDQueueFrameSpecificList_Update", function(self)
    --             for i = 1, NUM_LFD_CHOICE_BUTTONS do
    --                 _G["LFDQueueFrameSpecificListButton"..i]:SetWidth(LFG.db.profile.options.width - 265);
    --                 _G["LFDQueueFrameSpecificListButton"..i]:SetHeight(Specificbtnheight)
    --             end
    --     end)
    -- end
    
    --随机地下城
    LFDQueueFrameRandomScrollFrame:ClearAllPoints()
    LFDQueueFrameRandomScrollFrame:SetSize(LFG.db.profile.options.width - 285, LFG.db.profile.options.height - 250)
    LFDQueueFrameRandomScrollFrame:SetPoint("TOPLEFT", _G.LFDQueueFrame, "TOPLEFT", 60, -230)
    LFDQueueFrameRandomScrollFrameChildFrameDescription:SetWidth(560)
    LFDQueueFrameRandomScrollFrameChildFrameRewardsLabel:SetPoint("BOTTOM", _G.LFDQueueFrameRandomScrollFrameChildFrameDescription, "TOP", 0, -50)
    
    --重新排序奖励
    -- hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function(self)
    --     local dungeonID = LFDQueueFrame.type;
    --     if (type(dungeonID) ~= "number") then --We haven't gotten info on available dungeons yet.
    --         return;
    --     end
    --     LFGRewardsFrame_PointReset(LFDQueueFrameRandomScrollFrameChildFrame, dungeonID);
    -- end)
    
    --对随机团本查找器重新布局
    _G.RaidFinderFrameBottomInset:Hide()
    -- _G.RaidFinderFrameRoleBackground:ClearAllPoints()
    _G.RaidFinderFrameRoleBackground:SetSize(LFG.db.profile.options.width + 130, 150)
    -- _G.RaidFinderFrameRoleBackground:SetPoint("TOPLEFT", 0, 20)
    _G.RaidFinderQueueFrameBackground:ClearAllPoints()
    _G.RaidFinderQueueFrameBackground:SetSize(LFG.db.profile.options.width + 150, LFG.db.profile.options.height - 205)
    _G.RaidFinderQueueFrameBackground:SetPoint("LEFT", 0, -60)
    
    --职责选择
    _G.RaidFinderQueueFrame:SetAllPoints(_G.RaidFinderFrame)
    
    _G.RaidFinderQueueFrameRoleButtonTank:ClearAllPoints()
    _G.RaidFinderQueueFrameRoleButtonTank:SetPoint("TOPLEFT", 50, -50)
    _G.RaidFinderQueueFrameRoleButtonHealer:SetPoint("LEFT", _G.RaidFinderQueueFrameRoleButtonTank, "LEFT", widthx, 0)
    _G.RaidFinderQueueFrameRoleButtonDPS:SetPoint("LEFT", _G.RaidFinderQueueFrameRoleButtonHealer, "LEFT", widthx, 0)
    _G.RaidFinderQueueFrameRoleButtonLeader:SetPoint("LEFT", _G.RaidFinderQueueFrameRoleButtonDPS, "LEFT", widthx, 0)
    
    --寻找队伍按钮
    _G.RaidFinderFrameFindRaidButton:SetPoint('BOTTOM', 0, 15)
    
    --团本选择
    _G.RaidFinderQueueFrameSelectionDropdown:ClearAllPoints()
    _G.RaidFinderQueueFrameSelectionDropdown:SetPoint("TOPRIGHT", _G.RaidFinderQueueFrame, "TOPRIGHT", -50, -130)
    
    --说明提示
    _G.RaidFinderQueueFrameScrollFrame:ClearAllPoints(0)
    _G.RaidFinderQueueFrameScrollFrame:SetSize(LFG.db.profile.options.width - 285, LFG.db.profile.options.height - 250)
    _G.RaidFinderQueueFrameScrollFrame:SetPoint("TOPLEFT", _G.RaidFinderQueueFrame, "TOPLEFT", 60, -230)
    _G.RaidFinderQueueFrameScrollFrameChildFrameDescription:SetWidth(560)
    _G.RaidFinderQueueFrameScrollFrameChildFrameRewardsDescription:SetWidth(560)
    _G.RaidFinderQueueFrameScrollFrameChildFrameRewardsLabel:SetPoint("BOTTOM", _G.RaidFinderQueueFrameScrollFrameChildFrameDescription, "TOP", 0, -50)
    
    --预创建队伍
    --_G.LFGListFrame.CategorySelection:SetPoint("TOPLEFT", 220, 0)
    _G.LFGListFrame.SearchPanel:ClearAllPoints()
    _G.LFGListFrame.SearchPanel:SetSize(width, LFG.db.profile.options.height - 25)
    _G.LFGListFrame.SearchPanel:SetPoint('TOP', 0, 0)
    
    LFGListFrame.CategorySelection.Inset.CustomBG:SetSize(width-10, LFG.db.profile.options.height - 90)
    --创建地下城筛选
    --已经自带无需创建
    -- if LFG.db.profile.options.LFGFilterDungeonButtonEnable and not LFGListFrame.SearchPanel.filterDungeon then
    --     LFGListFrame.SearchPanel.filterDungeon = CreateFrame("Frame", nil, LFGListFrame.SearchPanel, "UIDropDownMenuTemplate")
    --     LFGListFrame.SearchPanel.filterDungeon:SetPoint("LEFT",LFGListFrame.SearchPanel.CategoryName,"LEFT",50,-2)
    --     G.selectedDungeton = ""
    --     LFGListFrame.SearchPanel.filterDungeon.selectedDungeton = LFGListFrame.SearchPanel.filterDungeon:CreateFontString(nil, 'ARTWORK', "GameFontNormal")
    --     LFGListFrame.SearchPanel.filterDungeon.selectedDungeton:SetFont(G.font, 13, "NONE")
    --     LFGListFrame.SearchPanel.filterDungeon.selectedDungeton:SetJustifyH("LEFT")
    --     LFGListFrame.SearchPanel.filterDungeon.selectedDungeton:SetPoint("LEFT", 90, 2)
    
    --     UIDropDownMenu_JustifyText(LFGListFrame.SearchPanel.filterDungeon, "LEFT")
    --     UIDropDownMenu_SetWidth(LFGListFrame.SearchPanel.filterDungeon, 39)
    --     UIDropDownMenu_SetText(LFGListFrame.SearchPanel.filterDungeon, selectedDungeonCount())
    --     UIDropDownMenu_Initialize(LFGListFrame.SearchPanel.filterDungeon, dungeonMenuInit)
    --     hooksecurefunc("LFGListUtil_SortSearchResults", SortSearchResults)
    --     hooksecurefunc('LFGListSearchPanel_SetCategory', function(self, categoryID)
    --             if categoryID == 2 and LFG.db.profile.options.LFGFilterDungeonButtonEnable and LFGListFrame.SearchPanel.filterDungeon then
    --                 LFGListFrame.SearchPanel.filterDungeon:SetShown(true)
    --             else
    --                 LFGListFrame.SearchPanel.filterDungeon:SetShown(false)
    --             end
    --     end)
    -- end
    
    --创建双击申请按钮
    if LFG.db.profile.options.DoubleSignUpButtonEnable then
        if not LFGListFrame.SearchPanel.DoubleSignUp then
            LFGListFrame.SearchPanel.DoubleSignUp = CreateFrame("CheckButton", nil, LFGListFrame.SearchPanel, "InterfaceOptionsCheckButtonTemplate")
            LFGListFrame.SearchPanel.DoubleSignUp.Text:SetText(L["LFG Double SignUp"])
            LFGListFrame.SearchPanel.DoubleSignUp:SetPoint("LEFT", LFGListFrame.SearchPanel.SearchBox, "RIGHT", 120, 0)
            LFGListFrame.SearchPanel.DoubleSignUp:SetScript("OnClick", OnDoubleSignUp)
        end
        LFGListFrame.SearchPanel.DoubleSignUp:SetChecked(LFG.db.profile.options.DoubleSignUpEnable)
    end
    
    --创建自动进组按钮
    if LFG.db.profile.options.LFGAutoAcceptButtonEnable then
        if not LFGListFrame.SearchPanel.AutoAcceptButton then
            LFGListFrame.SearchPanel.AutoAcceptButton = CreateFrame("CheckButton", nil, LFGListFrame.SearchPanel, "InterfaceOptionsCheckButtonTemplate")
            LFGListFrame.SearchPanel.AutoAcceptButton.Text:SetText(LFG_LIST_AUTO_ACCEPT)
            LFGListFrame.SearchPanel.AutoAcceptButton:SetPoint("LEFT", LFGListFrame.SearchPanel.SearchBox, "RIGHT", 220, 0)
            LFGListFrame.SearchPanel.AutoAcceptButton:SetScript("OnClick", AutoAcceptClick)
        end
        LFGListFrame.SearchPanel.AutoAcceptButton:SetChecked(LFG.db.profile.options.LFGAutoAcceptEnable)
    end
    
    LFGListInviteDialog:SetScript("OnShow", function(self)
            if LFG.db.profile.options.LFGAutoAcceptButtonEnable and LFG.db.profile.options.LFGAutoAcceptEnable then
                -- local _, status, _, _, role = C_LFGList.GetApplicationInfo(self.resultID)
                -- if status == "invited" then
                --     self.AcceptButton:Click()
                -- end
                -- if status == "inviteaccepted" then
                --     self.AcknowledgeButton:Click()
                -- end
                
                local _, status, _, _, role = C_LFGList.GetApplicationInfo(LFGListInviteDialog.resultID)
                if status == "invited" then
                    LFGListInviteDialog.AcceptButton:Click()
                end
                if status == "inviteaccepted" then
                    LFGListInviteDialog.AcknowledgeButton:Click()
                end
            end
    end)
    
    --创建队伍
    
    --LFGListFrame.CategorySelection.StartGroupButton:ClearAllPoints()
    --LFGListFrame.CategorySelection.StartGroupButton:SetPoint('BOTTOMLEFT', 10, 15)
    
    --寻找队伍
    --LFGListFrame.CategorySelection.FindGroupButton:ClearAllPoints()
    --LFGListFrame.CategorySelection.FindGroupButton:SetPoint('BOTTOMRIGHT', -10, 15)
    
    -- _G.LFGListFrame.EntryCreation:SetPoint("TOPLEFT", 180, 0)
    -- _G.LFGListFrame.EntryCreation.Label:SetPoint("CENTER",_G.LFGListFrame.EntryCreation,"CENTER",  -500, 0)
    --创建队伍
    --后退
    --LFGListFrame.EntryCreation.CancelButton:ClearAllPoints()
    --LFGListFrame.EntryCreation.CancelButton:SetPoint('BOTTOMLEFT', 10, 15)
    --列出队伍
    --LFGListFrame.EntryCreation.ListGroupButton:ClearAllPoints()
    --LFGListFrame.EntryCreation.ListGroupButton:SetPoint('BOTTOMRIGHT', -10, 15)
    
    -- --后退
    _G.LFGListFrame.SearchPanel.BackButton:ClearAllPoints()
    _G.LFGListFrame.SearchPanel.BackButton:SetPoint('BOTTOMLEFT', 10, -10)
    -- --申请
    _G.LFGListFrame.SearchPanel.SignUpButton:ClearAllPoints()
    _G.LFGListFrame.SearchPanel.SignUpButton:SetPoint('BOTTOMRIGHT', -10, -10)
    
    _G.LFGListFrame.SearchPanel.RefreshButton:SetPoint("TOPLEFT", _G.LFGListFrame.SearchPanel, 'TOPRIGHT', -50, -55)
    
    --修改预创建队伍里按钮大小
    hooksecurefunc('LFGListCategorySelection_AddButton', function(btn, btnIndex)
            local button = btn.CategoryButtons[btnIndex]
            if button then
                button:SetSize(LFG.db.profile.options.width - 300, 60)
                button.Icon:SetSize(LFG.db.profile.options.width - 300, 55)
                button.HighlightTexture:SetSize(LFG.db.profile.options.width - 300, 55)
                button.SelectedTexture:SetSize(LFG.db.profile.options.width - 300, 55)
                button.Cover:SetSize(LFG.db.profile.options.width - 280, 65)
            end
    end)
    --双击申请实现
    hooksecurefunc("LFGListSearchEntry_OnLoad", function(btn)
            btn:SetScript("OnDoubleClick", OnDoubleSignUpClick)
    end)
    
    -- HybridScrollFrame_CreateButtons(_G.LFGListFrame.SearchPanel.ScrollBox, "LFGListSearchEntryTemplate");
    hooksecurefunc('LFGListSearchPanel_UpdateResults', function(self)
            local startGroupButton = self.ScrollBox.StartGroupButton;
            local noResultsFound = self.ScrollBox.NoResultsFound;
            
            startGroupButton:SetPoint("TOP", self.ScrollBox, "TOP", 0, -200);
            noResultsFound:SetPoint("TOP", self.ScrollBox, "TOP", 0, -160);
            
            -- local buttons = self.ScrollBox.buttons;
            -- for i = 1, #buttons do
            --     buttons[i]:SetWidth(LFG.db.profile.options.width - 250)
            --     buttons[i]:HookScript("OnDoubleClick", OnDoubleSignUpClick)
            -- end
    end)
    
    --总体样式修改
    hooksecurefunc("LFGListSearchEntry_Update", LFGListSearch_Update);
    
    --更改职业图标
    hooksecurefunc("LFGListGroupDataDisplayEnumerate_Update", UpdateEnumerate)
    hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", UpdateRoleCount)
    
    --图标隐藏并移动位置
    --hooksecurefunc("LFGListGroupDataDisplay_Update", UpdateLFGListGroupDataDisplay)
    
    --申请列表
    LFGListFrame.ApplicationViewer:ClearAllPoints()
    LFGListFrame.ApplicationViewer:SetSize(LFG.db.profile.options.width - 275, LFG.db.profile.options.height - 50)
    LFGListFrame.ApplicationViewer:SetPoint('TOP', 0, 0)
    LFGListFrame.ApplicationViewer.InfoBackground:SetWidth(LFG.db.profile.options.width - 275)
    -- 队伍界面修改
    CreateEntryCreationLFGAutoInvite(LFGListFrame.EntryCreation)
    -- 浏览界面添加自动邀请
    CreateApplicationViewerLFGAutoInvite(LFGListFrame.ApplicationViewer)
    -- 自动邀请实现
    
    -- hooksecurefunc('LFGListApplicationViewer_UpdateApplicantMember', AutoInviteMember)
    if LFG.db.profile.options.LFGAutoInviteButtonEnable then
        
        LFGListFrame.CategorySelection.StartGroupButton:HookScript("OnClick", function(self)
                wipe(G.handle)
                if LFG.db.profile.options.LFGAutoInviteButtonEnable then
                    LFG.db.profile.options.LFGAutoInviteEnable = false
                    -- local panel = self:GetParent()
                    -- if panel.selectedCategory == 6 then
                    LFGListFrame.EntryCreation.LFGAutoInvite:Show()
                    LFGListFrame.EntryCreation.LFGAutoInvite:SetChecked(LFG.db.profile.options.LFGAutoInviteEnable)
                    -- LFGListFrame.EntryCreation.LFGAutoInviteTime:SetText(LFG.db.profile.options.LFGAutoInviteTime)
                    LFGAutoInviteTimeEnable(LFGListFrame.EntryCreation, LFG.db.profile.options.LFGAutoInviteEnable)
                    LFGListFrame.EntryCreation.LFGAutoInviteTime:Hide()
                else
                    LFGListFrame.EntryCreation.LFGAutoInvite:Hide()
                    LFGListFrame.EntryCreation.LFGAutoInviteTime:Hide()
                    -- end
                end
                
        end)
        LFGListFrame.EntryCreation.ListGroupButton:HookScript("OnClick", function(self)
                if LFG.db.profile.options.LFGAutoInviteButtonEnable then
                    -- local panel = self:GetParent()
                    -- if panel.selectedActivity == 16 or panel.selectedActivity == 17 then
                    LFGListFrame.ApplicationViewer.LFGAutoInvite:Show()
                    -- LFGListFrame.ApplicationViewer.LFGAutoInviteTime:Show()
                    LFGListFrame.ApplicationViewer.LFGAutoInvite:SetChecked(LFG.db.profile.options.LFGAutoInviteEnable)
                    -- LFGListFrame.ApplicationViewer.LFGAutoInviteTime:SetText(LFG.db.profile.options.LFGAutoInviteTime)
                    LFGAutoInviteTimeEnable(LFGListFrame.ApplicationViewer, LFG.db.profile.options.LFGAutoInviteEnable)
                else
                    LFGListFrame.ApplicationViewer.LFGAutoInvite:Hide()
                    LFGListFrame.ApplicationViewer.LFGAutoInviteTime:Hide()
                    -- end
                end
        end)
        LFGListFrame.ApplicationViewer.RemoveEntryButton:HookScript("OnClick", function(self)
                if LFG.db.profile.options.LFGAutoInviteButtonEnable then
                    LFG.db.profile.options.LFGAutoInviteEnable = false
                end
        end)
        LFGAutoInviteChecked(LFGListFrame.ApplicationViewer.LFGAutoInvite)
        
    end
    -- HybridScrollFrame_CreateButtons(LFGListFrame.ApplicationViewer.ScrollFrame, "LFGListApplicantTemplate")
    
    LFGListFrame.ApplicationViewer.EditButton:ClearAllPoints()
    LFGListFrame.ApplicationViewer.EditButton:SetPoint('BOTTOMRIGHT', -6, -35)
    LFGListFrame.ApplicationViewer.BrowseGroupsButton:ClearAllPoints()
    LFGListFrame.ApplicationViewer.BrowseGroupsButton:SetPoint('BOTTOMLEFT', 15, -35)
    LFGListFrame.ApplicationViewer.BrowseGroupsButton:SetSize(120, 22)
    
    LFGListFrame.ApplicationViewer.InfoBackground:SetWidth(LFG.db.profile.options.width - 250)
    
    LFGListFrame.ApplicationViewer.Inset:SetPoint('BOTTOMRIGHT', 0, 0)
    
    --LFGListApplicationViewerScrollFrame:SetPoint('BOTTOMRIGHT', 180, 0)
    LFGListFrame.ApplicationViewer.UnempoweredCover:SetPoint('BOTTOMRIGHT', 0, 0)
    --   PVEFrame.TopTileStreaks:SetPoint('BOTTOMRIGHT', 180, 0)
    
    --LFGListFrame.ApplicationViewer.DataDisplay:SetPoint('BOTTOMRIGHT', 180, 0)
    LFGListFrame.SearchPanel.BackToGroupButton:ClearAllPoints()
    LFGListFrame.SearchPanel.BackToGroupButton:SetPoint('BOTTOMLEFT', 15, -10)
    --LFGListApplicationViewerScrollFrameScrollBar:ClearAllPoints()
    --LFGListApplicationViewerScrollFrameScrollBar:Point('TOPLEFT', LFGListFrame.ApplicationViewer.Inset, 'TOPRIGHT', 5, -16)
    --LFGListApplicationViewerScrollFrameScrollBar:Point('BOTTOMLEFT', LFGListFrame.ApplicationViewer.Inset, 'BOTTOMRIGHT', 5, 16)
    
    _G.LFGListFrame.ApplicationViewer.ScrollBox.NoApplicants:SetPoint('CENTER', 0, 0)
    _G.LFGApplicationViewerRatingColumnHeader:SetWidth(80)
    _G.LFGApplicationViewerRatingColumnHeader.Label:SetAllPoints()
    _G.LFGApplicationViewerRatingColumnHeader.Label:SetJustifyH('CENTER')
    
    --创建一个描述标签
    if not _G.LFGListFrame.ApplicationViewer.CommentColumnHeader then
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader = CreateFrame("Button", nil, LFGListFrame.ApplicationViewer, "LFGListColumnHeaderTemplate")
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader:SetSize(280, 24)
        -- _G.LFGListFrame.ApplicationViewer.CommentColumnHeader.Label = _G.LFGListFrame.ApplicationViewer.CommentColumnHeader:CreateFontString(nil, 'OVERLAY')
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader.Label:SetFont(G.font, 15, "OUTLINE")
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader.Label:SetAllPoints()
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader.Label:SetJustifyH('CENTER')
        _G.LFGListFrame.ApplicationViewer.CommentColumnHeader.Label:SetText(L["comment"])
        
        --   S:HandleButton(LFGListFrame.ApplicationViewer.CommentColumnHeader, true)
    end
    -- 非队长下浏览其他队伍
    --创建浏览队伍
    -- if not _G.LFGListFrame.ApplicationViewer.BrowseGroups then
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups = CreateFrame("Button", nil, LFGListFrame.ApplicationViewer, "LFGListMagicButtonTemplate")
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups:SetSize(140, 22)
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups:SetText(GROUP_FINDER_BROWSE)
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups:SetPoint('BOTTOMLEFT', 15, -35)
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups:SetScript("OnClick", function()
    --             LFGListFrame.ApplicationViewer.BrowseGroupsButton:Click()
    --     end)
    --     _G.LFGListFrame.ApplicationViewer.BrowseGroups:SetShown(false);
    -- end
    
    -- --创建返回队伍
    if not _G.LFGListFrame.SearchPanel.BackToGroup then
        _G.LFGListFrame.SearchPanel.BackToGroup = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "LFGListMagicButtonTemplate")
        _G.LFGListFrame.SearchPanel.BackToGroup:SetSize(140, 22)
        _G.LFGListFrame.SearchPanel.BackToGroup:SetText(GROUP_FINDER_BACK_TO_GROUP)
        _G.LFGListFrame.SearchPanel.BackToGroup:SetPoint('BOTTOMLEFT', 60, -35)
        _G.LFGListFrame.SearchPanel.BackToGroup:SetScript("OnClick", function()
                LFGListFrame.SearchPanel.BackToGroupButton:Click()
        end)
        _G.LFGListFrame.SearchPanel.BackToGroup:SetShown(false);
    end
    
    -- hooksecurefunc('LFGListSearchPanel_UpdateButtonStatus', function(self)
    --         local canBrowseWhileQueued = C_LFGList.HasActiveEntryInfo()
    --         self.BackToGroupButton:SetShown(canBrowseWhileQueued)
    --         self.BackButton:SetShown(not canBrowseWhileQueued);
    -- end)
    
    hooksecurefunc('LFGListApplicationViewer_UpdateInfo', function(self)
            local isLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME)
            -- self.RemoveEntryButton:ClearAllPoints()
            -- if isLeader then
            --     self.RemoveEntryButton:SetPoint('RIGHT', self.EditButton, 'LEFT', -2, 0)
            -- else
            --     self.RemoveEntryButton:SetPoint('BOTTOMLEFT', 15, -35)
            -- end
            -- if not isPartyLeader then
            --     self.RemoveEntryButton:ClearAllPoints()
            --     self.RemoveEntryButton:SetPoint("LEFT", self.EditButton, "RIGHT", 15, 0);
            -- end
            -- if not isLeader then
            --     self.BrowseGroups:Show()
            -- end
            self.BrowseGroupsButton:SetShown(true);
            
            if LFGApplicationViewerRatingColumnHeader:IsShown() then
                _G.LFGApplicationViewerRatingColumnHeader.Label:SetJustifyH('CENTER')
                self.CommentColumnHeader:ClearAllPoints()
                self.CommentColumnHeader:SetPoint('LEFT', LFGApplicationViewerRatingColumnHeader, "RIGHT", 1, 0)
            else
                self.CommentColumnHeader:ClearAllPoints()
                self.CommentColumnHeader:SetPoint('LEFT', _G.LFGListFrame.ApplicationViewer.ItemLevelColumnHeader, "RIGHT", 1, 0)
            end
    end)
    
    hooksecurefunc('LFGListApplicationViewer_UpdateAvailability', function(self)
            self.ScrollBox.NoApplicants:Hide()
    end)
    
    hooksecurefunc('LFGListApplicationViewer_UpdateApplicant', function(button, id)
            button:SetWidth(LFG.db.profile.options.width - 285)
            hook_LFGListApplicationViewer(button, id)
    end)
    
    BlzBugFixed()
    for i = 1, 4 do
        local activityInfo = C_LFGList.GetActivityInfoTable(i + 699)
        G.DifficultyName[activityInfo.shortName] = i
    end
    
end
LFG:AddCallback('LookingForGroupFrames')