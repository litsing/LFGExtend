--PVP 界面修改
local LFG, L, P, C, G = unpack(LFGExtend)

function LFG:Blizzard_PVPUI()

    _G.LFGListPVPStub:SetSize(LFG.db.profile.options.width - 225, LFG.db.profile.options.height)
    _G.PVPUIFrame:SetSize(LFG.db.profile.options.width - 225, LFG.db.profile.options.height)
    hooksecurefunc("PVPQueueFrame_ShowFrame", function(self)
        PVEFrame:SetWidth(LFG.db.profile.options.width);
    end)

    --PVPQueueFrame.HonorInset:SetHeight(LFG.db.profile.options.height)
    do
    local Hx = LFG.db.profile.options.width - 800
    PVPQueueFrame.HonorInset:ClearAllPoints()
    PVPQueueFrame.HonorInset:SetPoint("TOPRIGHT", Hx, -22)
    PVPQueueFrame.HonorInset:SetPoint("BOTTOMRIGHT", Hx, 28)
    end
   
   HonorFrame:SetSize(LFG.db.profile.options.width - 390, LFG.db.profile.options.height-28)
   HonorFrame.BonusFrame.WorldBattlesTexture:SetAllPoints()
    HonorFrame.ConquestBar:SetWidth(LFG.db.profile.options.width - 450)
   HonorFrame.ConquestBar.Background:SetWidth(LFG.db.profile.options.width - 415)
   HonorFrame.ConquestBar.Border:SetWidth(LFG.db.profile.options.width - 415)
   HonorFrameBottom:ClearAllPoints()
   HonorFrameBottom:SetPoint("BOTTOM",0, -100)

   ConquestFrame:SetSize(LFG.db.profile.options.width - 390, LFG.db.profile.options.height-28)

   ConquestFrame.ConquestBar:SetWidth(LFG.db.profile.options.width - 450)
   ConquestFrame.ConquestBar.Background:SetWidth(LFG.db.profile.options.width - 415)
   ConquestFrame.ConquestBar.Border:SetWidth(LFG.db.profile.options.width - 415)
   ConquestFrame.RatedBGTexture:SetSize(LFG.db.profile.options.width - 390, LFG.db.profile.options.height-138)

-- HonorFrameQueueButton:ClearAllPoints()
--    HonorFrameQueueButton:SetPoint('BOTTOM',0,-2)
--    ConquestJoinButton:ClearAllPoints()
--    ConquestJoinButton:SetPoint('BOTTOM',0,-2)

    local buttons = {
            HonorFrame.BonusFrame.RandomBGButton,
            HonorFrame.BonusFrame.Arena1Button,
            HonorFrame.BonusFrame.RandomEpicBGButton,
            HonorFrame.BonusFrame.BrawlButton,
            HonorFrame.BonusFrame.BrawlButton2,
            ConquestFrame.RatedSoloShuffle,
            ConquestFrame.RatedBGBlitz,
            ConquestFrame.Arena2v2,
            ConquestFrame.Arena3v3,
            ConquestFrame.RatedBG,
    };
    for i =1 ,#buttons do
        local button = buttons[i]
        button:SetWidth(LFG.db.profile.options.width - 390)
        if button.Reward then
            button.Reward:ClearAllPoints()
            button.Reward:SetPoint("RIGHT",-10, 0)
        end
        if button.Tier then
            button.Tier:ClearAllPoints()
            button.Tier:SetPoint("CENTER",0, 0)
        end


        if button.TierIcon then
            button.TierIcon:ClearAllPoints()
            button.TierIcon:SetPoint("CENTER",0, 0)
        end
    end


   -- hooksecurefunc("HonorFrameBonusFrame_Update", function()
   --      local buttons = {
   --          HonorFrame.BonusFrame.RandomBGButton,
   --          HonorFrame.BonusFrame.Arena1Button,
   --          HonorFrame.BonusFrame.RandomEpicBGButton,
   --          HonorFrame.BonusFrame.BrawlButton,
   --          HonorFrame.BonusFrame.BrawlButton2, 
   --      };
   --      for i =1 ,#buttons do
   --          buttons[i]:SetWidth(LFG.db.profile.options.width - 390)
   --      end

   --  end)
   --特定战场大小修改
   ---好像没这玩意了
   --HonorFrame.SpecificFrame:SetPoint("BOTTOMLEFT", 60, 130)
    -- hooksecurefunc("HonorFrameSpecificList_Update", function()
    --     local scrollFrame = HonorFrame.SpecificScrollBox;
    --     local offset = HybridScrollFrame_GetOffset(scrollFrame);
    --     local buttons = scrollFrame.buttons;
    --     local numButtons = #buttons;
    --     local numBattlegrounds = GetNumBattlegroundTypes();
    --     local buttonCount = -offset;
    --     for i = 1, numBattlegrounds do
    --         local localizedName, canEnter, isHoliday, isRandom= GetBattlegroundInfo(i);
    --         if ( localizedName and canEnter and not isRandom ) then
    --         buttonCount = buttonCount + 1;
    --         if ( buttonCount > 0 and buttonCount <= numButtons ) then
    --             local button = buttons[buttonCount];
    --             button:SetSize(LFG.db.profile.options.width - 420,45)
    --         end
    --     end
    --     end
    -- end)
   
    --PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest
end


LFG:AddCallbackForAddon('Blizzard_PVPUI')
