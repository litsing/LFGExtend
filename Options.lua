local LFG, L, P, C, G = unpack(LFGExtend)

local _G = _G

P.options = {
    width = 960,
    height = 580,
    LFGskinEnable = true,
    HistoryskinEnable = true,
    LFGskinicon = "ELVUI",
    Historyskinicon = "ELVUI",
    LFGClassEnable = true,
    LFGLeaderEnable = true,
    LFGLeadericon = "BLZ",
    LFGShortMapEnable = true,
    LFGMapNameColorEnable = true,
    LFGLeaderScoreEnable = true,
    LFGLeaderNameEnable = true,
    LFGilvlEnable = true,
    LFGScoreEnable = true,
    LFGcommentEnable = true,
    ChallengesEnable = true,
    nokeystonestexture = 1,
    DoubleSignUpButtonEnable = true,
    DoubleSignUpEnable = true,
    LFGAutoAcceptButtonEnable = false,
    LFGAutoAcceptEnable = false,
    LFGAutoInviteButtonEnable = true,
    LFGAutoInviteEnable = false,
    LFGAutoInviteTime = 0,
    AutoKeystoneEnable = true,
    DuneonfilteredButton = false,
    LFGFilterDungeonButtonEnable =false,
    IsSendkeystone = false,
    PartyKeyStonesEnable = true,
    DungeonColor = {
        [1] = {r = 0.12, g = 1 , b = 0},
        [2] = {r = 0, g = 0.45 , b = 0.86},
        [3] = {r = 0.64, g = 0.21 , b = 0.93},
        [4] = {r = 1, g = 0.22 , b = 0.38},
    },
    LFGilvl = {
        500,
        585,
        600,
        610,
        620,
    },
    LevelColor = {
        [1] = {r = 1, g = 1, b = 1},
        [2] = {r = 0.12, g = 1 , b = 0},
        [3] = {r = 0, g = 0.45 , b = 0.86},
        [4] = {r = 0.64, g = 0.21 , b = 0.93},
        [5] = {r = 1, g = 0.5, b = 0},
        [6] = {r = .8, g = .8, b = .8},
    },
}

G.PartyKeyStones = {}
G.PartyKeyStonesName = {}
G.MyRealm = GetRealmName()

G.addonsIsLoad = {
    ELVUI = false,
    ElvUI_WindTools_KeystoneEnable = false,
    AngryKeystones = false,
}
G.mapIDtoshortName = {
    [166] = L["Grimrail Depot"],
    [169] = L["Iron Docks"],
    [227] = L["Karazhan L"],
    [234] = L["Karazhan U"],
    [353] = L["Siege Of Boralus"],
    [369] = L["Mechagon Junkyard"],
    [370] = L["Mechagon Workshop"],
    [375] = L["MOTS"],
    [376] = L["NW"],
    [377] = L["DOS"],
    [378] = L["HOA"],
    [379] = L["PF"],
    [380] = L["SD"],
    [381] = L["SOA"],
    [382] = L["TOP"],
    [391] = L["TWS"],
    [392] = L["TSC"],
    [501] = L["The Stonevault"],
    [502] = L["city of threads"],
    [503] = L["Arakara city of echoes"],
    [505] = L["The Dawnbreaker"],
    [507] = L["grim batol"],
}



G.MapShortName = {
    [180] = L["Iron Docks"],
    [183] = L["Grimrail Depot"],
    [471] = L["Karazhan L"],
    [473] = L["Karazhan U"],
    [679] = L["Mechagon Junkyard"], 
    [683] = L["Mechagon Workshop"],
    [688] = L["PF"],
    [689] = L["PF"],
    [690] = L["PF"],
    [691] = L["PF"],
    [692] = L["DOS"],
    [693] = L["DOS"],
    [694] = L["DOS"],
    [695] = L["DOS"],
    [696] = L["HOA"],
    [697] = L["HOA"],
    [698] = L["HOA"],
    [699] = L["HOA"],
    [700] = L["MOTS"],
    [701] = L["MOTS"],
    [702] = L["MOTS"],
    [703] = L["MOTS"],
    [704] = L["SD"],
    [705] = L["SD"],
    [706] = L["SD"],
    [707] = L["SD"],
    [708] = L["SOA"],
    [709] = L["SOA"],
    [710] = L["SOA"],
    [711] = L["SOA"],
    [712] = L["NW"],
    [713] = L["NW"],
    [714] = L["NW"],
    [715] = L["NW"],
    [716] = L["TOP"],
    [717] = L["TOP"],
    [718] = L["TOP"],
    [719] = L["TOP"],
    [746] = "集市",
    [1016] = L["TWS"],
    [1017] = L["TSC"],
    [1018] = L["TWS"],
    [1019] = L["TSC"],
}
G.DifficultyName = {}

G.DifficultyShortName = {
    [1] = "(N)",
    [2] = "(H)",
    [3] = "(M)",
    [4] = "(M+)",
}

G.Nokeystonestexture = {
    [1] = G.Media.Textures.Tearlaments,
    [2] = G.Media.Textures.Joyous,
    [3] = G.Media.Textures.Albion,
    [4] = G.Media.Textures.Fenrir,
    [5] = G.Media.Textures.Nibiru,
    [6] = G.Media.Textures.WhiteDragon,
}
G.font = "Fonts\\FRIZQT__.ttf"
G.time = 0
G.selectedDungeton = ''
G.handle = {}
local SampleStrings = {}
do
    local icons = ""
    icons = icons .. LFG:TextureString(G.Media.Icons.ElvUITank, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.ElvUIHealer, ":16:16:0:0:64:64:2:56:2:56") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.ElvUIDPS, ":16:16")
    SampleStrings.elvui = icons
    
    icons = ""
    icons = icons .. LFG:TextureString(G.Media.Icons.sunUITank, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.sunUIHealer, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.sunUIDPS, ":16:16")
    SampleStrings.sunui = icons
    
    icons = ""
    icons = icons .. LFG:TextureString(G.Media.Icons.lynUITank, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.lynUIHealer, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.lynUIDPS, ":16:16")
    SampleStrings.lynui = icons
    
    icons = ""
    icons = icons .. LFG:TextureString(G.Media.Icons.PhilModTank, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.PhilModHealer, ":16:16") .. " "
    icons = icons .. LFG:TextureString(G.Media.Icons.PhilModDPS, ":16:16")
    SampleStrings.PhilMod = icons
end

local options = {
    name = "LFGExtend",
    handler = LFGExtend,
    type = "group",
    args = {
        LFGList = {
            order = 1,
            type = "group",
            inline = true,
            name = L["LFG List"],
            args = {
                LFGwidth = {
                    order = 1,
                    type = "range",
                    name = L["LFG width"],
                    min = 950,
                    max = 1280,
                    step = 1,
                    width = 1.5,
                    hidden = true,
                    get = function(info) return LFG.db.profile.options.width end,
                    set = function(info, value) LFG.db.profile.options.width = value end,
                },
                LFGheight = {
                    order = 2,
                    type = "range",
                    name = L["LFG height"],
                    min = 580,
                    max = 800,
                    step = 1,
                    width = 1.5,
                    hidden = true,
                    get = function(info) return LFG.db.profile.options.height end,
                    set = function(info, value) LFG.db.profile.options.height = value end,
                },
                LFGreskin = {
                    order = 3,
                    type = "toggle",
                    name = L["LFG List Reskin Icon"],
                    desc = L["Change LFG List role icons."],
                    width = 1.5,
                    get = function(info) return LFG.db.profile.options.LFGskinEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGskinEnable = value end,
                },
                LFGpack = {
                    order = 4,
                    type = "select",
                    name = L["Reskin Icon"],
                    desc = L["Change the icons that indicate the role."],
                    disabled = function() return not LFG.db.profile.options.LFGskinEnable end,
                    values = {
                        SPEC = L["Specialization"],
                        SUNUI = SampleStrings.sunui,
                        LYNUI = SampleStrings.lynui,
                        ELVUI = SampleStrings.elvui,
                        PhilMod = SampleStrings.PhilMod,
                    },
                    get = function(info) return LFG.db.profile.options.LFGskinicon end,
                    set = function(info, value) LFG.db.profile.options.LFGskinicon = value end,
                },
                LFGLeader = {
                    order = 5,
                    type = "toggle",
                    name = L["LFG List leader Icon"],
                    desc = L["Show LFG leader Icon."],
                    width = 1.5,
                    get = function(info) return LFG.db.profile.options.LFGLeaderEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGLeaderEnable = value end,
                },
                LFGLeaderIcon = {
                    order = 6,
                    type = "select",
                    name = L["Reskin Leader Icon"],
                    desc = "",
                    disabled = function() return not LFG.db.profile.options.LFGLeaderEnable end,
                    values = {
                        ROUNDED = LFG:TextureString(G.Media.Textures.leaderborder, ":16:16"),
                        BLZ = LFG:TextureString("Interface\\GroupFrame\\UI-Group-LeaderIcon", ":16:16"),
                    },
                    
                    get = function(info) return LFG.db.profile.options.LFGLeadericon end,
                    set = function(info, value) LFG.db.profile.options.LFGLeadericon = value end,
                },
                LFGClass = {
                    order = 7,
                    type = "toggle",
                    name = L["Class Color"],
                    desc = L["Show Class Color."],
                    get = function(info) return LFG.db.profile.options.LFGClassEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGClassEnable = value end,
                },
                LFGShortMap = {
                    order = 8,
                    type = "toggle",
                    name = L["Short MapName"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGShortMapEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGShortMapEnable = value end,
                },
                LFGMapNameColor = {
                    order = 9,
                    type = "toggle",
                    name = L["MapName Color"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGMapNameColorEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGMapNameColorEnable = value end,
                },
                LFGLeaderScore = {
                    order = 10,
                    type = "toggle",
                    name = L["Leader Score"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGLeaderScoreEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGLeaderScoreEnable = value end,
                },
                LFGLeaderName = {
                    order = 11,
                    type = "toggle",
                    name = L["Leader Name"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGLeaderNameEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGLeaderNameEnable = value end,
                },
                LFGilvl = {
                    order = 12,
                    type = "toggle",
                    name = L["Item level"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGilvlEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGilvlEnable = value end,
                },
                LFGScore = {
                    order = 13,
                    type = "toggle",
                    name = L["Required Score"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGScoreEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGScoreEnable = value end,
                },
                LFGcomment = {
                    order = 14,
                    type = "toggle",
                    name = L["comment"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.LFGcommentEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGcommentEnable = value end,
                },
                AutoKeystone = {
                    order = 15,
                    type = "toggle",
                    name = L["AutoKeystone"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.AutoKeystoneEnable end,
                    set = function(info, value) LFG.db.profile.options.AutoKeystoneEnable = value end,
                },
                
            },
        },
        -- HistoryList = {
        --         order = 2,
        --         type = "group",
        --         inline = true,
        --         name = L["History List"],
        --         args = {
        --             Historyskin = {
        --                 order = 1,
        --                 type = "toggle",
        --                 name = L["History skin Icon"],
        --                 desc = L["Change History role icons."],
        --                 get = function(info) return LFG.db.profile.options.HistoryskinEnable end,
        --                 set = function(info, value) LFG.db.profile.options.HistoryskinEnable = value end,
        --             },
        --             Historypack = {
        --                 order = 2,
        --                 type = "select",
        --                 name = L["Reskin Icon"],
        --                 desc = L["Change the icons that indicate the role."],
        --                 disabled = function() return not LFG.db.profile.options.HistoryskinEnable end,
        --                 values = {
        --                      SPEC = L["Specialization"],
        --                      SUNUI = SampleStrings.sunui,
        --                      LYNUI = SampleStrings.lynui,
        --                      ELVUI = SampleStrings.elvui,
        --                      PhilMod = SampleStrings.PhilMod,
        --                 },
        --                 get = function(info) return LFG.db.profile.options.Historyskinicon end,
        --                 set = function(info, value) LFG.db.profile.options.Historyskinicon = value end,
        --             },
        --         }
        -- },
        Challenges = {
            order = 3,
            type = "group",
            inline = true,
            name = L["Challenges skin"],
            args = {
                Challengesskin = {
                    order = 1,
                    type = "toggle",
                    name = L["Enable"],
                    desc = "",
                    width = 0.8,
                    get = function(info) return LFG.db.profile.options.ChallengesEnable end,
                    set = function(info, value) LFG.db.profile.options.ChallengesEnable = value end,
                },
                PartyKeyStones = {
                    order = 2,
                    type = "toggle",
                    name = L["PartyKeyStonesEnable"],
                    desc = L["PartyKeyStonesEnabletip"],
                    width = 0.8,
                    get = function(info) return LFG.db.profile.options.PartyKeyStonesEnable end,
                    set = function(info, value) LFG.db.profile.options.PartyKeyStonesEnable = value end,
                },
                Sendkeystones = {
                    order = 3,
                    type = "toggle",
                    name = L["Sendkeystones"],
                    desc = L["Sendkeystonestip"],
                    width = 0.8,
                    get = function(info) return LFG.db.profile.options.IsSendkeystone end,
                    set = function(info, value) LFG.db.profile.options.IsSendkeystone = value end,
                },
                NoKeyStonestexture = {
                    order = 4,
                    type = "select",
                    name = L["No KeyStones texture"],
                    desc = "",
                    values = {
                        [1] = L["Tearlaments"],
                        [2] = L["Ash Blossom & Joyous Spring"],
                        [3] = L["Albion the Sanctifire Dragon"],
                        [4] = L["Kashtira Fenrir"],
                        [5] = L["Nibiru,the Primal Being"],
                        [6] = L["Legendary Dragon of White"],
                    },
                    
                    get = function(info) return LFG.db.profile.options.nokeystonestexture end,
                    set = function(info, value) LFG.db.profile.options.nokeystonestexture = value end,
                },
            }
        },
        Others = {
            order = 4,
            type = "group",
            inline = true,
            name = L["other"],
            args = {
                DoubleSignUpButton = {
                    order = 1,
                    type = "toggle",
                    name = L["LFG Double SignUp Button"],
                    desc = "",
                    get = function(info) return LFG.db.profile.options.DoubleSignUpButtonEnable end,
                    set = function(info, value) LFG.db.profile.options.DoubleSignUpButtonEnable = value end,
                },
                AutoAcceptButton = {
                    order = 2,
                    type = "toggle",
                    name = L["LFG Auto Accept Button"],
                    desc = L["LFG Auto Accept Button Tip"],
                    hidden = true,
                    disabled = true,
                    get = function(info) return LFG.db.profile.options.LFGAutoAcceptButtonEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGAutoAcceptButtonEnable = value end,
                },
                AutoInviteButton = {
                    order = 3,
                    type = "toggle",
                    name = L["LFG Auto Invite Button"],
                    desc = "",
                    --    hidden = true,
                    get = function(info) return LFG.db.profile.options.LFGAutoInviteButtonEnable end,
                    set = function(info, value) LFG.db.profile.options.LFGAutoInviteButtonEnable = value end,
                },
                -- FilterDungeonButton = {
                --     order = 4,
                --     type = "toggle",
                --     name = L["LFG Filter Dungeon Button"],
                --     desc = "",
                --     get = function(info) return LFG.db.profile.options.LFGFilterDungeonButtonEnable end,
                --     set = function(info, value) LFG.db.profile.options.LFGFilterDungeonButtonEnable = value end,
                -- },
            }
        },
        DungeonColor = {
            order = 5,
            type = "group",
            name = L["Custom Dungeon Color"],
            inline = true,
            disabled = function() return not LFG.db.profile.options.LFGMapNameColorEnable end,
            desc = "",
            args = {
                NormalColor = {
                    order = 1,
                    type = "color",
                    name = L["Normal Color"],
                    -- hasAlpha = true,
                    get = function(info)
                        local db = LFG.db.profile.options.DungeonColor[1]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.DungeonColor[1]
                        db.r, db.g, db.b = r, g, b
                    end,
                    width = 0.8,
                },
                HardColor = {
                    order = 2,
                    type = "color",
                    name = L["Hard Color"],
                    -- hasAlpha = true,
                    get = function(info)
                        local db = LFG.db.profile.options.DungeonColor[2]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.DungeonColor[2]
                        db.r, db.g, db.b = r, g, b
                    end,
                    width = 0.8,
                },
                MythicColor = {
                    order = 3,
                    type = "color",
                    name = L["Mythic Color"],
                    -- hasAlpha = true,
                    get = function(info)
                        local db = LFG.db.profile.options.DungeonColor[3]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.DungeonColor[3]
                        db.r, db.g, db.b = r, g, b
                    end,
                    width = 0.8,
                },
                MythicDungeon = {
                    order = 4,
                    type = "color",
                    name = L["Mythic+ Color"],
                    -- hasAlpha = true,
                    get = function(info)
                        local db = LFG.db.profile.options.DungeonColor[4]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.DungeonColor[4]
                        db.r, db.g, db.b = r, g, b
                    end,
                    width = 0.8,
                },
            },
        },
        ilvlColor = {
            order = 6,
            type = "group",
            inline = true,
            name = L["Custom ilvl Color"],
            desc = "",
            disabled = function() return not LFG.db.profile.options.LFGilvlEnable end,
            args = {
                ilvl1 = {
                    order = 1,
                    name = L["ilvl"],
                    type = "range",
                    min = 1,
                    max = 999,
                    step = 1,
                    width = 1.2,
                    get = function(info) return LFG.db.profile.options.LFGilvl[1] end,
                    set = function(info, value) LFG.db.profile.options.LFGilvl[1] = value end,
                },
                ilvlColor1 = {
                    order = 2,
                    type = "color",
                    name = L["Color"],
                    -- hasAlpha = true,
                    width = 1.5,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[1]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[1]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
                ilvl2 = {
                    order = 3,
                    name = L["ilvl"],
                    type = "range",
                    min = 1,
                    max = 999,
                    step = 1,
                    width = 1.2,
                    get = function(info)
                        if LFG.db.profile.options.LFGilvl[1] > LFG.db.profile.options.LFGilvl[2] then
                            LFG.db.profile.options.LFGilvl[2] = LFG.db.profile.options.LFGilvl[1]
                        end
                        return LFG.db.profile.options.LFGilvl[2] end,
                    set = function(info, value) LFG.db.profile.options.LFGilvl[2] = value end,
                },
                ilvlColor2 = {
                    order = 4,
                    type = "color",
                    name = L["Color"],
                    -- hasAlpha = true,
                    width = 1.5,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[2]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[2]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
                ilvl3 = {
                    order = 5,
                    name = L["ilvl"],
                    type = "range",
                    min = 1,
                    max = 999,
                    step = 1,
                    width = 1.2,
                    get = function(info)
                        if LFG.db.profile.options.LFGilvl[2] > LFG.db.profile.options.LFGilvl[3] then
                            LFG.db.profile.options.LFGilvl[3] = LFG.db.profile.options.LFGilvl[2]
                        end
                        return LFG.db.profile.options.LFGilvl[3] end,
                    set = function(info, value) LFG.db.profile.options.LFGilvl[3] = value end,
                },
                ilvlColor3 = {
                    order = 6,
                    type = "color",
                    name = L["Color"],
                    -- hasAlpha = true,
                    width = 1.5,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[3]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[3]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
                ilvl4 = {
                    order = 7,
                    name = L["ilvl"],
                    type = "range",
                    min = 1,
                    max = 999,
                    step = 1,
                    width = 1.2,
                    get = function(info)
                        if LFG.db.profile.options.LFGilvl[3] > LFG.db.profile.options.LFGilvl[4] then
                            LFG.db.profile.options.LFGilvl[4] = LFG.db.profile.options.LFGilvl[3]
                        end
                        return LFG.db.profile.options.LFGilvl[4] end,
                    set = function(info, value) LFG.db.profile.options.LFGilvl[4] = value end,
                },
                ilvlColor4 = {
                    order = 8,
                    type = "color",
                    name = L["Color"],
                    -- hasAlpha = true,
                    width = 1.5,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[4]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[4]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
                ilvl5 = {
                    order = 9,
                    name = L["ilvl"],
                    type = "range",
                    min = 1,
                    max = 999,
                    step = 1,
                    width = 1.2,
                    get = function(info)
                        if LFG.db.profile.options.LFGilvl[4] > LFG.db.profile.options.LFGilvl[5] then
                            LFG.db.profile.options.LFGilvl[5] = LFG.db.profile.options.LFGilvl[4]
                        end
                        return LFG.db.profile.options.LFGilvl[5] end,
                    set = function(info, value) LFG.db.profile.options.LFGilvl[5] = value end,
                },
                ilvlColor5 = {
                    order = 10,
                    type = "color",
                    name = L["Color"],
                    -- hasAlpha = true,
                    width = 1.5,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[5]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[5]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
                NormalColor = {
                    order = 11,
                    type = "color",
                    name = L["Normal Color"],
                    width = 1.5,
                    -- hasAlpha = true,
                    get = function(info)
                        local db = LFG.db.profile.options.LevelColor[6]
                        return db.r, db.g, db.b
                    end,
                    set = function(info, r, g, b, a)
                        local db = LFG.db.profile.options.LevelColor[6]
                        db.r, db.g, db.b = r, g, b
                    end,
                },
            },
        },
        ---------------------
    },
}




function LFG:InitOptions()
    LFG.db = LFG.Libs.AceDB:New("LFGExDB", LFG.DF, true);
    LibStub("AceConfig-3.0"):RegisterOptionsTable("LFGExtend", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LFGExtend", "LFGExtend")
    self:RegisterChatCommand("lfgex", "ChatCommand")
    self:RegisterChatCommand("lfgextend", "ChatCommand")
end

function LFG:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("lfgex", "LFGExtend", input)
    end
end



