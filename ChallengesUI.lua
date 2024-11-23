-------------------------------
--地下城挑战页面修改
-------------------------------
local LFG, L, P, H, G = unpack(LFGExtend)

local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local GetScoreColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetSeasonSocreMap = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap
local GetActivities = C_WeeklyRewards.GetActivities
local GetMapTable = C_ChallengeMode.GetMapTable
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local FirstOpenChallenge = true
-- local affixes

local MAP_FILE_PREFIX = "Interface\\AddOns\\LFGExtend\\Media\\Textures\\Maps\\";

local IsInParty = false
local PartyKeyStonesCanClear = false

local AFFIX_TYRANNICAL;

local zoneID = {}
local mapnum = 0
local rewardProgress = {}
local ThisWeekBestHistory = {}
local StoneKeyFormat = "|T%s:12:12:0:0:96:96:0:64:0:64|t|cffEEA560%s|r|cfffb3939[%s]|r"


local mapUIInfo = {
    [375] = {name = 'mists-of-tirna-scithe', barColor ='6273f4'},
    [376] = {name = 'the-necrotic-wake', barColor = '63c29a'},
    [377] = {name = 'de-other-side', barColor = '8240e8'},
    [378] = {name = 'halls-of-atonement', barColor = 'd80075'},
    [379] = {name = 'plaguefall', barColor = '6fd54f'},
    [380] = {name = 'sanguine-depths', barColor = 'f73b39'},
    [381] = {name = 'spires-of-ascension', barColor = '85c5ff'},
    [382] = {name = 'theater-of-pain', barColor = '83c855'},
    [391] = {name = 'tazavesh-the-veiled-market', barColor = '5f8afa'},     --Street
    [392] = {name = 'tazavesh-the-veiled-market', barColor = '5f8afa'},     --Gambit
    
    [369] = {name = 'operation-mechagon', barColor = '4ebbc9'},    --Junkyard
    [370] = {name = 'operation-mechagon', barColor = '4ebbc9'},    --Workshop
    [227] = {name = 'return-to-karazhan', barColor = '68abe0'},    --Lower
    [234] = {name = 'return-to-karazhan', barColor = '68abe0'},    --Upper
    [166] = {name = 'grimrail-depot', barColor = 'b79266'},
    [169] = {name = 'iron-docks', barColor = 'b79266'},
    
    [165] = {name = 'shadowmoon-burial-grounds', },
    [399] = {name = 'ruby-life-pools', },
    [400] = {name = 'the-nokhud-offensive', },
    [401] = {name = 'the-azure-vault', },
    [200] = {name = 'halls-of-valor', },
    [210] = {name = 'court-of-stars', },
    [402] = {name = 'algethar-academy', },
    [2] = {name = 'temple-of-the-jade-serpent', },
    
    [438] = {name = 'the-vortex-pinnacle', },
    [403] = {name = 'uldaman-legacy-of-tyr', },
    [404] = {name = 'neltharus', },
    [406] = {name = 'halls-of-infusion', },
    [251] = {name = 'the-underrot', },
    [245] = {name = 'freehold', },
    [206] = {name = 'neltharions-lair', },
    [405] = {name = 'brackenhide-hollow', },
    
    [244] = {name = 'ataldazar', },
    [199] = {name = 'black-rook-hold', },
    [198] = {name = 'darkheart-thicket', },
    [168] = {name = 'the-everbloom', },
    [456] = {name = 'throne-of-the-tides', },
    [248] = {name = 'waycrest-manor', },
    [463] = {name = 'dawn-of-the-infinite', },  --Galakrond
    [464] = {name = 'dawn-of-the-infinite', },  --Murozond
    
    [501] = {name = 'the-stonevault'},
    [503] = {name = 'arakara-city-of-echoes'},
    [507] = {name = 'grim-batol'},
    [505] = {name = 'the-dawnbreaker'},
    [353] = {name = 'siege-of-boralus'},
    [502] = {name = 'city-of-threads'},
};

local function FormatDuration(seconds)
    seconds = (seconds and tonumber(seconds)) or 0;
    local minutes = math.floor(seconds / 60);
    local restSeconds = seconds - minutes * 60;
    if restSeconds < 10 then
        restSeconds = "0"..restSeconds;
    end
    if minutes < 10 then
        minutes = "0"..minutes;
    end
    return string.format("%s:%s", minutes, restSeconds);
end



local function CacheAffixName()
    if not AFFIX_TYRANNICAL then
        AFFIX_TYRANNICAL = C_ChallengeMode.GetAffixInfo(9);
    end
    -- if not AFFIX_FORTIFIED then
    --     AFFIX_FORTIFIED = C_ChallengeMode.GetAffixInfo(10);
    -- end
end



-- 对本地缓存的大秘境历史记录进行更新

local comparison = function(entry1, entry2)
    if ( entry1.level == entry2.level ) then
        return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
    else
        return entry1.level > entry2.level;
    end
end


local function UpdateWeekBest()
    local runInfo = C_MythicPlus.GetRunHistory(false,true)
    if runInfo then
        wipe(ThisWeekBestHistory)
        table.sort(runInfo,comparison)
        if #runInfo >0 then
            for _,v in pairs(runInfo) do 
                if v.thisWeek then
                    ThisWeekBestHistory = v
                    ThisWeekBestHistory.mapname = GetMapUIInfo(v.mapChallengeModeID);
                    return
                end
            end
        end
    end
end

-- 获取以及刷新宝库奖励



local function activityInfoRefresh(activityInfo)
    if not rewardProgress[activityInfo.type] then rewardProgress[activityInfo.type] = {} end
    rewardProgress[activityInfo.type][activityInfo.index] = {
        id = activityInfo.id,
        progress = activityInfo.progress,
        threshold = activityInfo.threshold,
        unlocked = activityInfo.progress >= activityInfo.threshold,
        itemLink = nil,
        itemLevel = nil,
    }
    if rewardProgress[activityInfo.type][activityInfo.index].unlocked then
        local itemLink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activityInfo.id);
        rewardProgress[activityInfo.type][activityInfo.index].itemLink = itemLink;
        if itemLink and itemLink ~= "[]" then
            rewardProgress[activityInfo.type][activityInfo.index].itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink);
        end
    end
end

local function WeeklyRewardsRefresh()
    local activities = C_WeeklyRewards.GetActivities();
    wipe(rewardProgress)
    for _, activityInfo in ipairs(activities) do
        activityInfoRefresh(activityInfo);
    end
end


local function GetMapTexture(mapID)
    if mapID and mapUIInfo[mapID] then
        return MAP_FILE_PREFIX.. mapUIInfo[mapID].name
    else
        return "Interface\\AddOns\\LFGExtend\\Media\\Textures\\bg"
    end
end

local function AreaSet(self,num)
    for i=0, 3 do
        if i==num then
            self["Area"..i]:SetFont(G.font,18);
            self["Area"..i]:SetTextColor(1, 1, 1);
        else
            self["Area"..i]:SetFont(G.font,12);
            self["Area"..i]:SetTextColor(0.5, 0.5, 0.5);
        end
    end
end

local function UpdateTimelinePointer(self, timeLimit, yourTime)
    local p = self.Pointer;
    local centeralTime = timeLimit * 0.8;
    local offsetXPerSec = 64 / (timeLimit * 0.2);
    --local maxOffset = 260;
    local offsetX = math.floor((yourTime - centeralTime) * offsetXPerSec);
    if offsetX > 130 then
        offsetX = 130
    elseif offsetX < -130 then
        offsetX = -130;
    end
    p:ClearAllPoints();
    p:SetPoint("TOP", self.Timeline, "BOTTOM", offsetX, 0);
    if timeLimit < yourTime then
        p:SetVertexColor(1, 80/255, 80/255);
    else
        p:SetVertexColor(124/255, 197/255, 118/255);
    end
end

local function GetClassColorByClassID(classID)
    local classInfo = classID and C_CreatureInfo.GetClassInfo(classID);
    if classInfo then
        return C_ClassColor.GetClassColor(classInfo.classFile);
    end
end


local function WrapNameWithClassColor(name, classID, specID, showIcon, offsetY)
    local classInfo = C_CreatureInfo.GetClassInfo(classID);
    if classInfo then
        local color = GetClassColorByClassID(classID);
        if color then
            if specID and showIcon then
                local str = color:WrapTextInColorCode(name);
                local _, _, _, icon, role = GetSpecializationInfoByID(specID);
                if icon then
                    offsetY = offsetY or 0;
                    str = "|T"..icon..":12:12: - 1:"..offsetY..":64:64:4:60:4:60|t" ..str;
                end
                return str
            else
                return color:WrapTextInColorCode(name);
            end
        else
            return name
        end
    else
        return name
    end
end


local function SetWeeklyRewardsActivity(index, activity)
    if activity.unlocked then
        if activity.itemLevel then
            return string.format(L["Weekly Reward unlocked"], index, activity.itemLevel)
        elseif activity.itemLink and activity.itemLink ~= "[]" then
            activity.itemLevel = C_Item.GetDetailedItemLevelInfo(activity.itemLink)
            return string.format(L["Weekly Reward unlocked"], index, activity.itemLevel)
        else
            local itemlink = C_WeeklyRewards.GetExampleRewardItemHyperlinks(activity.id)
            if itemLink and itemLink ~= "[]" then
                activity.itemLevel = C_Item.GetDetailedItemLevelInfo(itemLink)
                return string.format(L["Weekly Reward unlocked"], index, activity.itemLevel)
            else
                return RETRIEVING_ITEM_INFO
            end
        end
    else
        return string.format(L["Weekly Reward locked"], index, activity.progress,activity.threshold)
    end
end

--创建最佳记录

local function SharedOnMouseDown(self, button)
    if button == "RightButton" then
        for _, child in ipairs(ChallengesFrame.DungeonIcons) do
            child:SetShown(true)
        end
        ChallengesFrame.ChallengesSkinFrame.MapDetail:SetShown(false);
    end
end


local function MapDetail_OnLoad(self)
    if not self.MapDetail then
        self.MapDetail = CreateFrame("Button", nil, self, "MythicPlusTemplate")
        self.MapDetail.Pointer:SetTexture(G.Media.Textures.TimerlinePointer, nil, nil, "TRILINEAR");
        
        self.MapDetail:SetScript("OnMouseDown", SharedOnMouseDown);
        --词缀
        for i = 3, 0, -1 do
            local f = CreateFrame("Frame", nil, self.MapDetail, "MythicPlusAffixFrameTemplate");
            f:SetPoint("LEFT", self.MapDetail.ScoreBound, "RIGHT", 250 - i * 35, 0);
        end
    end
end

local function ThisWeekBest_OnLoad(self)
    if not self.ThisWeekBest then
        self.ThisWeekBest = CreateFrame("Frame",nil, self,"ThisWeekBestTemplate")
        self.ThisWeekBest.weekbestlable:SetText(L["This Week Best"])
        self.ThisWeekBest.Week2:SetFont(G.font, 18)
        self.ThisWeekBest.mapname:SetFont(G.font, 16)
        self.ThisWeekBest.Pointer:SetTexture(G.Media.Textures.TimerlinePointer, nil, nil, "TRILINEAR");
    end
end

--
local function ToggleMapDetail(self,state)
    self.MapDetail:SetShown(state);
    -- if state then
    --     if not self.MapDetail.MouseButton then
    --         --Create a note that informs user you can right click to go back to the main frame.
    --         local f = CreateFrame("Frame", nil, self.MapDetail, "HotkeyNotificationTemplate");
    --         self.MapDetail.MouseButton = f;
    --         f:SetKey(nil, "RightButton", LL["Return"], true);
    --         f:SetPoint("TOPRIGHT", self.MapDetail, "BOTTOMRIGHT", -6, -4);
    --         f:SetIgnoreParentScale(true);
    --     end
    -- end
end

local function GetNameForKeystone(keystoneMapID, keystoneLevel)
    local keystoneMapName, _, _, icon = GetMapUIInfo(keystoneMapID)
    if keystoneLevel and keystoneMapName and icon then
        return string.format(StoneKeyFormat, icon, keystoneMapName, keystoneLevel)
    end
end



local function PartyKeyStonesFrame_OnLoad(self)
    if not self.PartyKeyStonesFrame then
        local frame = CreateFrame("Frame", nil, self)
        frame:SetSize(250, 120)
        frame:SetPoint("LEFT", self, "CENTER", 15, 65);
        frame.PartyName = {}
        frame.PartyKeyStones = {}
        frame.bg = frame:CreateTexture()
        frame.bg:SetAllPoints()
        frame.bg:SetColorTexture(0, 0, 0, 0.6)
        for i = 1, 5 do
            frame.PartyName[i] = frame:CreateFontString(nil, 'OVERLAY')
            frame.PartyKeyStones[i] = frame:CreateFontString(nil, 'OVERLAY')
            if i == 1 then
                frame.PartyName[i]:SetFont(G.font, 16)
                frame.PartyName[i]:SetPoint("TOPLEFT",5,-5);
                frame.PartyName[i]:SetText(L["PartyKeyStones"])
                frame.PartyKeyStones[i]:SetFont(G.font, 16)
                frame.PartyKeyStones[i]:SetPoint("TOPRIGHT",-5,-5);
                frame.PartyKeyStones[i]:SetText(' ')
            else
                frame.PartyName[i]:SetFont(G.font, 13)
                frame.PartyName[i]:SetPoint("TOPLEFT",frame.PartyName[i-1],'BOTTOMLEFT',0,-10);
                frame.PartyName[i]:SetText('')
                frame.PartyKeyStones[i]:SetFont(G.font, 13)
                frame.PartyKeyStones[i]:SetPoint("TOPRIGHT",frame.PartyKeyStones[i-1],'BOTTOMRIGHT',0,-10);
                frame.PartyKeyStones[i]:SetText('')
            end
        end
        self.PartyKeyStonesFrame = frame
    end
end

local function keyStoneFrame_OnLoad(self)
    if not self.keyStoneFrame then
        local keyStoneFrame = CreateFrame("Frame", nil, self)
        keyStoneFrame:SetPoint("TOPRIGHT", self, "TOPRIGHT", -290, -138);
        keyStoneFrame:SetSize(135, 135)
        keyStoneFrame:SetFrameLevel(3)
        keyStoneFrame.keyname = keyStoneFrame:CreateFontString(nil, "OVERLAY")
        keyStoneFrame.keyname:SetFont(G.font, 16)
        keyStoneFrame.keyname:SetPoint("BOTTOM", 0, -25);
        keyStoneFrame.keyname:SetTextColor(1, 1, 1)
        keyStoneFrame.keyname:SetText("")
        
        keyStoneFrame.keyeffect = keyStoneFrame:CreateFontString(nil, "OVERLAY")
        keyStoneFrame.keyeffect:SetFont(G.font, 12)
        keyStoneFrame.keyeffect:SetText("")
        keyStoneFrame.keyeffect:SetPoint("TOPLEFT", -5, -100);
        keyStoneFrame.keyeffect:SetTextColor(1, 1, 1)
        
        keyStoneFrame.keyicon = keyStoneFrame:CreateTexture(nil, "ARTWORK")
        keyStoneFrame.keyicon:SetAllPoints(keyStoneFrame)
        if not keyStoneFrame.mask then
            keyStoneFrame.mask = keyStoneFrame:CreateMaskTexture()
            keyStoneFrame.mask:SetTexture(G.Media.Textures.mask)
        end
        keyStoneFrame.mask:SetAllPoints(keyStoneFrame.keyicon)
        keyStoneFrame.keyicon:AddMaskTexture(keyStoneFrame.mask)
        self.keyStoneFrame = keyStoneFrame
    end
end
--宝库奖励
local function ActivityListFrame_OnLoad(self)
    if not self.ActivityFrame then
        local frame = CreateFrame("Frame", nil, self)
        frame:SetSize(260, 120)
        frame:SetPoint("LEFT", self, "CENTER", 15, -115);
        frame.Activity = {}
        
        for i = 1, 12 do
            frame.Activity[i] = frame:CreateFontString(nil, 'OVERLAY')
            if i == 1 then
                frame.Activity[i]:SetFont(G.font, 18)
                frame.Activity[i]:SetPoint("TOPLEFT", 160, 0);
                frame.Activity[i]:SetText(L["Dungeon"])
                frame.ActivityTimes = frame:CreateFontString(nil, 'OVERLAY')
                frame.ActivityTimes:SetFont(G.font, 12)
                frame.ActivityTimes:SetPoint("BOTTOMLEFT", frame.Activity[i], "BOTTOMRIGHT", 0, 0);
                frame.ActivityTimes:SetText('')
                --    frame.Activity[i]:SetText("|cFFffc300大秘境|r")
            elseif i == 5 then
                frame.Activity[i]:SetFont(G.font, 18)
                frame.Activity[i]:SetText(L["World"])
                frame.Activity[i]:SetPoint("TOPLEFT", 320, 0);
            elseif i == 9 then
                frame.Activity[i]:SetFont(G.font, 18)
                frame.Activity[i]:SetText(L["RAID"])
                frame.Activity[i]:SetPoint("TOPLEFT", 0, 0);
            else
                frame.Activity[i]:SetFont(G.font, 14)
                if i == 2 or i == 6 or i == 10 then
                    frame.Activity[i]:SetPoint("TOPLEFT", frame.Activity[i - 1], "BOTTOMLEFT", 0, -8);
                else
                    frame.Activity[i]:SetPoint("TOPLEFT", frame.Activity[i - 1], "BOTTOMLEFT", 0, -5);
                end
            end
            frame.Activity[i]:SetJustifyH("LEFT")
        end
        self.ActivityFrame = frame
    end
end

--大秘境时限
local function TimeListFrame_OnLoad(self, num)
    if not self.TimeFrame then
        local frame = CreateFrame("Frame", nil, self)
        frame:SetSize(100, 100)
        frame:SetPoint("LEFT", ChallengesFrame, "CENTER", 15, -220);
        frame.MapTime = {}
        local midnum = math.floor(num/2 + 2)
        for i = 1, num do
            frame.MapTime[i] = frame:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
            if i == 1 then
                frame.MapTime[i]:SetFont(G.font, 18)
                frame.MapTime[i]:SetPoint("TOPLEFT", 0, 0);
                frame.MapTime[i]:SetText(L["MapTime"])
            elseif i == 2 then
                frame.MapTime[i]:SetFont(G.font, 13)
                frame.MapTime[i]:SetPoint("TOPLEFT", frame.MapTime[1], "BOTTOMLEFT", 0, -5);
                frame.MapTime[i]:SetText("")
            elseif i == midnum then
                frame.MapTime[i]:SetFont(G.font, 13)
                frame.MapTime[i]:SetPoint("TOPLEFT", frame.MapTime[2], "BOTTOMLEFT", 0, -10);
                frame.MapTime[i]:SetText("")
            else
                frame.MapTime[i]:SetFont(G.font, 13)
                frame.MapTime[i]:SetPoint("LEFT", frame.MapTime[i - 1], "LEFT", 115, 0);
                frame.MapTime[i]:SetText("")
            end
            frame.MapTime[i]:SetJustifyH("LEFT") --文本左右中 "LEFT","RIGHT", or "CENTER"
            frame.MapTime[i]:SetJustifyV("MIDDLE")   --文本上下中 "TOP","BOTTOM", or "MIDDLE"
            if i > 1 then
                local shortName = G.mapIDtoshortName[zoneID[i-1]]
                local time = date("%M:%S", select(3, GetMapUIInfo(zoneID[i-1])))
                if shortName then              
                    frame.MapTime[i]:SetText(string.format("|cffffc215%s|r\n%s", shortName, time))
                else
                    frame.MapTime[i]:SetText(string.format("|cffffc215%s|r\n%s", GetMapUIInfo(zoneID[i-1]), time))
                end
            end
        end
        
        self.TimeFrame = frame
    end
end


-- 宝库位置修改
local function WeeklyChestReset(self)
    if self.WeeklyInfo.Child.WeeklyChest then
        self.WeeklyInfo.Child.WeeklyChest:SetPoint("TOPRIGHT", self.WeeklyInfo.Child, "TOPRIGHT", -100, -160);
        self.WeeklyInfo.Child.WeeklyChest.Icon:SetSize(128, 128)
    end
end
--词缀位置修改
local function affixesReset(self)
    if self.WeeklyInfo.Child.ThisWeekLabel then
        self.WeeklyInfo.Child.ThisWeekLabel:SetPoint("TOP", 168, -30)
        self.WeeklyInfo.Child.ThisWeekLabel:SetText()
    end
    self.WeeklyInfo.Child.AffixesContainer:SetPoint("RIGHT",-120,50)
    -- if (affixes) then
    --     for i, affix in ipairs(affixes) do
    --         local affixName = C_ChallengeMode.GetAffixInfo(affix.id);
    --         local frame = self.WeeklyInfo.Child.AffixesContainer[i]
    --         frame.Portrait:ClearAllPoints();
    --         frame:SetSize(50, 50);
    --         frame.Portrait:SetSize(50, 50);
    --         frame.Portrait:SetPoint("LEFT", 0, 0)
    --         if not frame.affixName then
    --             frame.affixName = frame:CreateFontString(nil, 'OVERLAY')
    --         end
    --         frame.affixName:SetFont(G.font, 15, "OUTLINE")
    --         frame.affixName:SetTextColor(1, 1, 1)
    --         frame.affixName:SetPoint("TOP",frame,'BOTTOM' , 0, -5)
    --         frame.affixName:SetText(affixName)
    --              if i > 1 then
    --                 frame:ClearAllPoints();
    --                 frame:SetPoint("LEFT", self.WeeklyInfo.Child.Affixes[i - 1], "RIGHT", 50, 0);
    --              end
    --     end
    -- end
end

MythicPlusAffixFrameMixin = {};

function MythicPlusAffixFrameMixin:OnEnter()
    self.Icon:SetVertexColor(1, 1, 1);
    
    local name, description, icon = C_ChallengeMode.GetAffixInfo(self.affixID);
    local tp = GameTooltip;
    tp:Hide();
    tp:SetOwner(self, "ANCHOR_NONE");
    tp:SetText(name);
    tp:AddLine(description, 1, 1, 1, true);
    tp:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0);
    tp:Show();
end

function MythicPlusAffixFrameMixin:OnLeave()
    self.Icon:SetVertexColor(0.8, 0.8, 0.8);
    GameTooltip:Hide();
end

function MythicPlusAffixFrameMixin:OnMouseDown(button)
    SharedOnMouseDown(nil, button);
end

function MythicPlusAffixFrameMixin:SetByID(affixID)
    self.affixID = affixID;
    if affixID then
        local _, _, icon = C_ChallengeMode.GetAffixInfo(affixID);
        self.Icon:SetTexture(icon);
        if self:IsMouseOver() then
            self:OnEnter();
        else
            self:OnLeave();
        end
        self:Show();
    else
        self:Hide();
    end
end

local function SetMapDetail(self, mapid)
    if not mapid then return end;
    self.activeMapID = mapID;
    
    local f = self.MapDetail;
    -- f.page = DataProvider:GetPageByMapID(mapID);
    -- f.LeftArrow:SetShown(f.page ~= 1);
    -- f.RightArrow:SetShown(f.page ~= DataProvider.numCompleteMaps);
    local name, id, timeLimit, texture = GetMapUIInfo(mapid);
    f.Header:SetTexture(GetMapTexture(mapid));
    f.MapName:SetText(name);
    
    local intimeInfo, overtimeInfo, isCached = C_MythicPlus.GetSeasonBestForMap(mapid)
    local data;
    
    data = intimeInfo
    local hasData = false;
    -- for i = fromI, toI do
    --     if i == 1 then
    --         data = intimeInfo;
    --     else
    --         data = overtimeInfo;
    --     end
    if data then
        hasData = true;
        -- UpdateTabButtonVisual(i);
        local durationSec = data.durationSec;
        f.Duration:SetText(FormatDuration(durationSec) );
        f.Duration:SetTextColor(1, 1, 1);
        f.Level:SetText( data.level );
        f.Level:SetTextColor(1, 1, 1);
        f.Date:SetText( FormatShortDate(data.completionDate.day, data.completionDate.month, data.completionDate.year) );
        f.Score:SetText( data.dungeonScore );
        local color = C_ChallengeMode.GetSpecificDungeonScoreRarityColor(data.dungeonScore);
        if (not color) then
            color = HIGHLIGHT_FONT_COLOR;
        end
        f.Score:SetTextColor(color.r, color.g, color.b);
        
        --Time
        --local timeLimit = DataProvider:GetMapTimer(mapID);
        if timeLimit then
            local plus3 = timeLimit * 0.6;
            local plus2 = timeLimit * 0.8;
            if durationSec < plus3 then
                AreaSet(f,3)
            elseif durationSec < plus2 then
                AreaSet(f,2)
            elseif durationSec < timeLimit then
                AreaSet(f,1)
            else
                AreaSet(f,0)
            end
            
            f.Timer1:SetText( FormatDuration(timeLimit) );
            f.Timer2:SetText( FormatDuration(plus2) );
            f.Timer3:SetText( FormatDuration(plus3) );
            
            --Timeline Pointer
            UpdateTimelinePointer(f, timeLimit, durationSec);
            f.Pointer:Show();
        else
            f.Pointer:Hide();
        end
        
        --Affix Frames
        for j = 1, 4 do
            f.AffixFrames[j]:SetByID(data.affixIDs[j]);
        end
        
        --Members
        local memberString = "";
        for j = 1, #data.members do
            if j==3 then
                memberString = memberString.."\n";
            end
            memberString = memberString..WrapNameWithClassColor(data.members[j].name, data.members[j].classID, data.members[j].specID, true, -7).."   ";
        end
        f.MemberText:SetText(memberString)
        
        -- if not isCached then
        --     self:RequestMemberInfo();
        -- end
        -- break;
    end
    -- end
    
    if not hasData then
        f.Score:SetText("--");
        f.Score:SetTextColor(0.5, 0.5, 0.5);
        f.Date:SetText("No Date");
        f.Duration:SetText("00:00");
        f.Duration:SetTextColor(0.5, 0.5, 0.5);
        f.Level:SetText("--");
        f.Level:SetTextColor(0.5, 0.5, 0.5);
        for j = 1, 4 do
            f.AffixFrames[j]:SetByID(nil);
        end
        f.MemberText:SetText("");
        f.Timer1:SetText("");
        f.Timer2:SetText("");
        f.Timer3:SetText("");
        AreaSet(f, -1)
        f.Pointer:Hide();
    end
end

local function DungeonMapSocre(self)
    local affixScores, overallScore = C_MythicPlus.GetSeasonBestAffixScoreInfoForMap(self.mapID)
    local objects = {self.Level1, self.Duration1, self.Level2, self.Duration2};
    local mapSocre = select(2, GetSeasonSocreMap(self.mapID)) or 0
    self.HighestLevel:SetText(mapSocre)
    local mapname, _, _, icon = GetMapUIInfo(self.mapID)
    self.mapName:SetText(mapname)
    self.Icon:SetTexture(icon)
    self.ScoreBound:Show();
    
    if (overallScore and overallScore > 0) and (affixScores and #affixScores > 0) then
        local duration, overTime, level, score;
        local info1, info2;
        
        for i = 1, #affixScores do
            if affixScores[i].name == AFFIX_TYRANNICAL then
                info1 = affixScores[i];
            else
                info2 = affixScores[i];
            end
        end
        -- if #affixScores == 1 then
        --     if affixScores[1].name == AFFIX_TYRANNICAL then
        --         info1 = affixScores[1];
        --     else
        --         info2 = affixScores[1];
        --     end
        -- elseif #affixScores == 2 then
        --     if affixScores[1].name == AFFIX_TYRANNICAL then
        --         info1 = affixScores[1];
        --         info2 = affixScores[2];
        --     else
        --         info1 = affixScores[2];
        --         info2 = affixScores[1];
        --     end
        -- else
        --     info1 = affixScores[1];
        --     info2 = affixScores[2];
        -- end
        local info = {info1, info2};
        local data, v;
        for i = 1, 2 do
            data = info[i];
            if data then
                duration = data.durationSec;
                level = data.level;
                overTime = data.overTime;
                if overTime then
                    v = 0.6;
                else
                    v = 0.92;
                end
                objects[i * 2 - 1]:SetText(level);
                objects[i * 2 - 1]:SetTextColor(v, v, v, 0.9);
                objects[i * 2]:SetText(FormatDuration(duration));
                objects[i * 2]:SetTextColor(v, v, v);
                objects[i * 2 - 1]:Show();
                objects[i * 2]:Show();
            else
                objects[i * 2 - 1]:Hide();
                objects[i * 2]:Hide();
            end
        end
    else
        self.ScoreBound:Hide();
    end
end
local function DungeonIconsPointReset(self, i)
    self.DungeonIcons[i]:ClearAllPoints();
    -- 八本
    self.DungeonIcons[i]:SetSize(200, 90);
    -- 十本
    -- self.DungeonIcons[i]:SetSize(180, 80);
    self.DungeonIcons[i].Icon:SetAllPoints()
    if i == 1 then
        self.DungeonIcons[i]:SetPoint("TOPLEFT", ChallengesFrame, "TOPLEFT", 35, -75);
    elseif i == 2 then
        self.DungeonIcons[i]:SetPoint("TOPLEFT", self.DungeonIcons[1], "TOPRIGHT", 30, 0);
    else
        -- 八本
        self.DungeonIcons[i]:SetPoint("TOPLEFT", self.DungeonIcons[i - 2], "BOTTOMLEFT", 0, -10);
        -- 十本
        -- self.DungeonIcons[i]:SetPoint("TOPLEFT", self.DungeonIcons[i-2], "BOTTOMLEFT", 0, -2);
    end
end

local function Dungeon_OnClick(self)
    local mapSocre = select(2, GetSeasonSocreMap(self:GetParent().mapID))
    if not mapSocre then return end
    local parent = self:GetParent():GetParent()
    SetMapDetail(parent.ChallengesSkinFrame, self:GetParent().mapID)
    ToggleMapDetail(parent.ChallengesSkinFrame, true)
    for _, child in ipairs(ChallengesFrame.DungeonIcons) do
        child:SetShown(false)
    end
end

local function Dungeon_OnEnter(self)
    self:GetParent().BlackOverlay:Hide()
end

local function Dungeon_OnLeave(self)
    self:GetParent().BlackOverlay:Show()
end
local function SetTemplate(frame)
    if not frame.SetBackdrop then
        _G.Mixin(frame, _G.BackdropTemplateMixin)
        frame:HookScript('OnSizeChanged', frame.OnBackdropSizeChanged)
    end
    frame:SetBackdrop({
            edgeFile = [[Interface\AddOns\LFGExtend\Media\Textures\White8x8]],
            bgFile = [[Interface\AddOns\LFGExtend\Media\Textures\NormTex2]],
            edgeSize = 1
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    -- frame:SetBackdropBorderColor(0, 0, 0, 1)
end

local function DungeonIcons_OnLoad(self)
    for i, child in ipairs(self.DungeonIcons) do
        if child then
            child:GetRegions():SetAlpha(0)
            SetTemplate(child)
            child.Icon:SetTexCoord(0, 1, 0, 1)
            child.HighestLevel:ClearAllPoints()
            child.HighestLevel:SetPoint("CENTER", child, "LEFT", 36, -10)
            child.HighestLevel:SetFont(G.font, 24, "OUTLINE")
            
            if not child.ScoreBound then
                child.ScoreBound = child:CreateTexture(nil, "BORDER")
                --  child.ScoreBound:SetDrawLayer("BORDER" , -8)
                child.ScoreBound:SetSize(55, 35)
                child.ScoreBound:SetAlpha(0.5)
                child.ScoreBound:SetTexture(G.Media.Textures.ScoreBound)
                child.ScoreBound:SetPoint("CENTER", child, "LEFT", 36, -10)
            end
            
            if not child.mapName then
                child.mapName = child:CreateFontString(nil, 'OVERLAY')
                child.mapName:SetFont(G.font, 13, "OUTLINE")
                child.mapName:SetPoint("TOP", 0, -8)
            end
            
            if not child.Level1 then
                child.Level1 = child:CreateFontString(nil, 'OVERLAY')
                child.Level1:SetFont(G.font, 24, "OUTLINE")
                child.Level1:SetPoint("CENTER", child, "LEFT", 96, -10)
                child.Level1:SetJustifyV("TOP")
                child.Level1:SetJustifyH("CENTER")
            end
            
            if not child.Duration1 then
                child.Duration1 = child:CreateFontString(nil, 'OVERLAY')
                child.Duration1:SetFont(G.font, 12, "OUTLINE")
                child.Duration1:SetPoint("BOTTOM", child, "BOTTOMLEFT", 96, 8)
                child.Duration1:SetJustifyV("BOTTOM")
                child.Duration1:SetJustifyH("CENTER")
            end
            
            if not child.Level2 then
                child.Level2 = child:CreateFontString(nil, 'OVERLAY')
                child.Level2:SetFont(G.font, 24, "OUTLINE")
                child.Level2:SetPoint("CENTER", child, "LEFT", 150, -10)
                child.Level2:SetJustifyV("TOP")
                child.Level2:SetJustifyH("CENTER")
            end
            
            if not child.Duration2 then
                child.Duration2 = child:CreateFontString(nil, 'OVERLAY')
                child.Duration2:SetFont(G.font, 12, "OUTLINE")
                child.Duration2:SetPoint("BOTTOM", child, "BOTTOMLEFT", 150, 8)
                child.Duration2:SetJustifyV("BOTTOM")
                child.Duration2:SetJustifyH("CENTER")
            end
            
            if not child.btn then
                child.btn = CreateFrame("Button", nil, child)
                child.btn:SetAllPoints()
                child.btn:SetScript("OnClick", Dungeon_OnClick)
                child.btn:SetScript("OnEnter", Dungeon_OnEnter)
                child.btn:SetScript("OnLeave", Dungeon_OnLeave)
            end
            
            DungeonMapSocre(child)
            DungeonIconsPointReset(self, i)
            if not child.mask then
                child.mask = child:CreateMaskTexture()
                child.mask:SetAllPoints()
                child.mask:SetPoint("BOTTOMLEFT")
                child.mask:SetTexture(G.Media.Textures.MapMask)
            end
            child.Icon:AddMaskTexture(child.mask)
            
            if not child.BlackOverlay then
                child.BlackOverlay = child:CreateTexture(nil, "OVERLAY")
                child.BlackOverlay:SetAllPoints()
                child.BlackOverlay:SetTexture(G.Media.Textures.MapMask)
                child.BlackOverlay:SetVertexColor(0, 0, 0, 0.3)
            end
            if child.Center then
                child.Center:SetDrawLayer('BACKGROUND', -1)
            end
            -- child.NineSlice:SetBorderColor(1,1,1,0)
        end
    end
end

local function PartyKeyStonesFrame_Update(self, Description, descriptionShow)
    if not self.PartyKeyStonesFrame then return end
    self.PartyKeyStonesFrame:SetShown(IsInParty)
    if (not IsInParty) then return end
    if descriptionShow then
        Description:Hide()
    end
    for i=1, 5 do
        if i == 1 then
            local keystoneMapID = GetOwnedKeystoneChallengeMapID()
            local keystoneLevel = GetOwnedKeystoneLevel()
            if keystoneMapID and keystoneLevel then
                local KeyStoneMapName, _, _, icon = GetMapUIInfo(keystoneMapID)
                self.PartyKeyStonesFrame.PartyKeyStones[i]:SetText(format(StoneKeyFormat, icon, KeyStoneMapName, keystoneLevel))
            else
                self.PartyKeyStonesFrame.PartyKeyStones[i]:SetText(' ')
            end
        else
            if G.PartyKeyStonesName[i-1] then
                self.PartyKeyStonesFrame.PartyName[i]:SetText(G.PartyKeyStonesName[i-1][1])
                self.PartyKeyStonesFrame.PartyKeyStones[i]:SetText(G.PartyKeyStonesName[i-1][2])
            else
                self.PartyKeyStonesFrame.PartyName[i]:SetText('')
                self.PartyKeyStonesFrame.PartyKeyStones[i]:SetText('')
            end
        end
    end
end

local function PartyKeyStonesFrame_Leave(self)
    if not self.PartyKeyStonesFrame then return end
    for i=2, 5 do
        self.PartyKeyStonesFrame.PartyName[i]:SetText('')
        self.PartyKeyStonesFrame.PartyKeyStones[i]:SetText('')
    end
end

local function keyStoneFrame_Update(self, descriptionShow)
    if not self.keyStoneFrame then return end
    self.keyStoneFrame:SetShown(not (IsInParty or descriptionShow))
    if IsInParty or descriptionShow then return end
    local frame = self.keyStoneFrame
    local mapid = GetOwnedKeystoneChallengeMapID()
    local level = GetOwnedKeystoneLevel()
    if mapid and level then
        local icon = select(4, GetMapUIInfo(mapid))
        --   local mod = C_ChallengeMode.GetPowerLevelDamageHealthMod(level)
        local SeasonSocre = select(2, GetSeasonSocreMap(mapid)) or 0
        local keyname = string.format("%s[%s]", GetMapUIInfo(mapid), level)
        keyname = GetScoreColor(SeasonSocre * mapnum):WrapTextInColorCode(keyname)
        
        frame.keyicon:ClearAllPoints()
        frame.keyicon:SetAllPoints(frame)
        frame.keyname:SetText(keyname)
        frame.keyicon:SetTexture(icon)
        frame.keyicon:SetPoint("TOP")
        frame.keyicon:AddMaskTexture(frame.mask)
        -- frame.keyeffect:SetText(modifiers)
    else
        frame.keyname:SetText("")
        frame.keyicon:ClearAllPoints()
        frame.keyicon:SetSize(200, 200)
        frame.keyicon:SetPoint("TOP", 32, 38)
        frame.keyicon:RemoveMaskTexture(frame.mask)
        frame.keyicon:SetTexture(G.Nokeystonestexture[LFG.db.profile.options.nokeystonestexture])
    end
end

local function ActivityList_Update(self)
    if not self.ActivityFrame then return end
    local frame = self.ActivityFrame
    local num = 1
    for i, activityInfo in pairs(rewardProgress) do
        -- frame.Activity[num]:SetText(string.format(activityFormat, GetRewardTypeHead(i)))
        if i == 1 then
            if activityInfo[i].progress > 10 then
                frame.ActivityTimes:SetText(string.format(L["CallengesTimesFormat"], activityInfo[i].progress))
            end
        end
        num = num + 1
        for index, activity in pairs(activityInfo) do
            if num >= 13 then return end
            frame.Activity[num]:SetText(SetWeeklyRewardsActivity(index, activity))
            num = num + 1
        end
    end
    
end



local function ThisWeekBest_Update(self)
    if ThisWeekBestHistory.thisWeek then
        self.ThisWeekBest.Week1:SetText(ThisWeekBestHistory.level + 1)
        self.ThisWeekBest.Week2:SetText(ThisWeekBestHistory.level)
        self.ThisWeekBest.Week3:SetText(ThisWeekBestHistory.level - 1)
        self.ThisWeekBest.mapname:SetText(ThisWeekBestHistory.mapname)
        if ThisWeekBestHistory.completed then
            self.ThisWeekBest.Week2:SetTextColor(1, 1, 1)
        else
            self.ThisWeekBest.Week2:SetTextColor(1, 0, 0)
        end
    else
        self.ThisWeekBest.Week1:SetText()
        self.ThisWeekBest.Week2:SetText()
        self.ThisWeekBest.Week3:SetText()
        self.ThisWeekBest.mapname:SetText(L["This Week No Challenges"])
    end
end

local function ChallengesFrame_UI(self)
    local descriptionShow = self.WeeklyInfo.Child.Description:IsShown()
    -- self.WeeklyInfo.Child.RuneBG:Hide()
    -- self.WeeklyInfo.Child.RunesLarge:Hide()
    if descriptionShow then
        self.WeeklyInfo.Child.Description:ClearAllPoints()
        self.WeeklyInfo.Child.Description:SetPoint("TOPRIGHT", -50, -120)
    end
    -- if not affixes then
    --     affixes = C_MythicPlus.GetCurrentAffixes();
    -- end
    
    if FirstOpenChallenge then
        DungeonIcons_OnLoad(self)
        affixesReset(self)
        FirstOpenChallenge = false
    else
        for i, child in ipairs(self.DungeonIcons) do
            if child then
                DungeonMapSocre(child)
                DungeonIconsPointReset(self, i)
            end
        end
    end
    
    ThisWeekBest_Update(_G.ChallengesFrame.ChallengesSkinFrame)
    ActivityList_Update(_G.ChallengesFrame.ChallengesSkinFrame)
    ToggleMapDetail(self.ChallengesSkinFrame, false)
    if self.WeeklyInfo.Child.WeeklyChest then self.WeeklyInfo.Child.WeeklyChest.RunStatus:SetText("") end
    keyStoneFrame_Update(self.ChallengesSkinFrame, descriptionShow)
    PartyKeyStonesFrame_Update(self.ChallengesSkinFrame, self.WeeklyInfo.Child.Description, descriptionShow)
    
    self.ChallengesSkinFrame.TimeFrame:SetShown(not G.addonsIsLoad.ElvUI_WindTools_KeystoneEnable)
    
end


local function OnEventPartyKeyStones(event, prefix, message, type, sender)
    if event == "GROUP_ROSTER_UPDATE" or event == "CHALLENGE_MODE_MAPS_UPDATE" or event == "CHALLENGE_MODE_LEADERS_UPDATE" or event == "CHALLENGE_MODE_MEMBER_INFO_UPDATED" then
        if IsInGroup(LE_PARTY_CATEGORY_HOME) and LFG.db.profile.options.PartyKeyStonesEnable then
            IsInParty = true
            C_ChatInfo.SendAddonMessage("AngryKeystones", "Schedule|request", "PARTY") -- 发送“获取队友钥石信息”
        else
            IsInParty = false
            wipe(G.PartyKeyStones) --离队清空钥石信息
            wipe(G.PartyKeyStonesName)
            if PartyKeyStonesCanClear and LFG.db.profile.options.PartyKeyStonesEnable then
                PartyKeyStonesFrame_Leave(_G.ChallengesFrame.ChallengesSkinFrame)
            end
        end
    elseif event == "CHAT_MSG_ADDON" then
        if prefix == "AngryKeystones" then --返回队友钥石信息 保存到PartyKeyStones
            if LFG.db.profile.options.PartyKeyStonesEnable then
                if message == "Schedule|0" then
                    if G.PartyKeyStones[sender] ~= 0 then
                        G.PartyKeyStones[sender] = 0
                    end
                elseif message == "Schedule|request" and LFG.db.profile.options.IsSendkeystone then --向队友发送钥石信息
                    local keystoneMapID = GetOwnedKeystoneChallengeMapID()
                    local keystoneLevel = GetOwnedKeystoneLevel()
                    if keystoneMapID and keystoneLevel then
                        C_ChatInfo.SendAddonMessage("AngryKeystones", "Schedule|"..keystoneMapID..":"..keystoneLevel, "PARTY", sender)
                    else
                        C_ChatInfo.SendAddonMessage("AngryKeystones", "Schedule|0", "PARTY", sender)
                    end
                else
                    local arg1, arg2 = message:match("(%d+):(%d+)") 
                    local keystoneMapID = arg1 and tonumber(arg1)
                    local keystoneLevel = arg2 and tonumber(arg2)
                    if keystoneMapID and keystoneLevel then
                        G.PartyKeyStones[sender] = {keystoneMapID, keystoneLevel}
                    end
                end               
                for i = 1, 4 do
                    local name, realm = UnitName("party"..i)
                    if name then
                        local _, class = UnitClass("party"..i)
                        --  local _, class =  UnitClass("player")
                        local colorr, colorg, colorb = GetClassColor(class)
                        
                        local fullName
                        if not realm or realm == "" then
                            fullName = name.."-"..G.MyRealm
                        else
                            fullName = name.."-"..realm
                        end
                        name = format("|cff%02x%02x%02x%s|r", colorr * 255, colorg * 255, colorb * 255, name)
                        if G.PartyKeyStones[fullName] ~= nil then
                            if G.PartyKeyStones[fullName] == 0 then
                                G.PartyKeyStonesName[i] = {name, "|cffaaaaaa[NONE]|r"}
                            else
                                G.PartyKeyStonesName[i] = {name, GetNameForKeystone(G.PartyKeyStones[fullName][1], G.PartyKeyStones[fullName][2])}
                            end
                        else
                            G.PartyKeyStonesName[i] = {name, "|cffaaaaaa[NOT USED]|r"}
                        end
                    else
                        G.PartyKeyStonesName[i] = nil
                    end
                end         
            else
                if message == "Schedule|request" and LFG.db.profile.options.IsSendkeystone then --向队友发送钥石信息
                    local keystoneMapID = GetOwnedKeystoneChallengeMapID()
                    local keystoneLevel = GetOwnedKeystoneLevel()
                    if keystoneMapID and keystoneLevel then
                        C_ChatInfo.SendAddonMessage("AngryKeystones", "Schedule|"..keystoneMapID..":"..keystoneLevel, "PARTY", sender)
                    else
                        C_ChatInfo.SendAddonMessage("AngryKeystones", "Schedule|0", "PARTY", sender)
                    end
                end
            end 
        end
    end
end

function LFG:WEEKLY_REWARDS_UPDATE(event)
    WeeklyRewardsRefresh()
    UpdateWeekBest()
end
function LFG:CHALLENGE_MODE_COMPLETED(event)
    WeeklyRewardsRefresh()
    UpdateWeekBest() 
    OnEventPartyKeyStones(event)   
end
function LFG:CHALLENGE_MODE_MAPS_UPDATE(event)
    WeeklyRewardsRefresh()
    UpdateWeekBest() 
    OnEventPartyKeyStones(event) 
end

function LFG:GROUP_ROSTER_UPDATE(event)
    OnEventPartyKeyStones(event) 
end

function LFG:CHAT_MSG_ADDON(event,prefix, message, type, sender)
    OnEventPartyKeyStones(event, prefix, message, type, sender) 
end

function LFG:Blizzard_ChallengesUI()
    _G.ChallengesFrame.WeeklyInfo:SetSize(LFG.db.profile.options.width, LFG.db.profile.options.height)
    _G.ChallengesFrame.WeeklyInfo.Child:SetSize(LFG.db.profile.options.width, LFG.db.profile.options.height)
    _G.ChallengesFrame:DisableDrawLayer('BACKGROUND')
    
    
    if LFG.db.profile.options.ChallengesEnable then
        if not _G.ChallengesFrame.ChallengesSkinFrame then
            _G.ChallengesFrame.ChallengesSkinFrame = CreateFrame("Frame", "ChallengesSkinFrame", _G.ChallengesFrame)
            _G.ChallengesFrame.ChallengesSkinFrame:SetAllPoints()
            PartyKeyStonesCanClear = true
        end
        wipe(zoneID)
        zoneID = GetMapTable() --获取大秘境赛季地图ID
        mapnum = #zoneID
        CacheAffixName()
        UpdateWeekBest()
        MapDetail_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame)
        ThisWeekBest_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame)
        keyStoneFrame_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame)
        PartyKeyStonesFrame_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame)
        ActivityListFrame_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame)
        TimeListFrame_OnLoad(_G.ChallengesFrame.ChallengesSkinFrame, mapnum + 1)
        WeeklyChestReset(_G.ChallengesFrame)
        ThisWeekBest_Update(_G.ChallengesFrame.ChallengesSkinFrame)
        
        WeeklyRewardsRefresh()
        ActivityList_Update(_G.ChallengesFrame.ChallengesSkinFrame)
        
        -- hooksecurefunc("ChallengesFrame_Update", function(self) ChallengesFrame_UI(self) end)
        hooksecurefunc(ChallengesFrame, "Update", ChallengesFrame_UI)
    end
    
end

LFG:AddCallbackForAddon('Blizzard_ChallengesUI')