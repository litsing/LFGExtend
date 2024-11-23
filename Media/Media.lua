local LFG, L, P, C, G = unpack(LFGExtend)

local ceil = ceil
local format = format

G.Media = {
	Icons = {},
	Textures = {}
}

local MediaPath = "Interface/Addons/LFGExtend/Media/"

--[[
    获取图标字符串
    @param {string} icon 图标路径
    @param {number} size 图标大小
    @returns {string} 图标字符串
]]

function LFG:TextureString(texture, data)
	return format('|T%s%s|t', texture, data or "")
end



local function AddMedia(name, file, type)
	G.Media[type][name] = MediaPath .. type .. "/" .. file
end


AddMedia("ElvUITank", "ElvUI/Tank.tga", "Icons")
AddMedia("ElvUIDPS", "ElvUI/DPS.tga", "Icons")
AddMedia("ElvUIHealer", "ElvUI/Healer.tga", "Icons")

AddMedia("sunUITank", "SunUI/Tank.tga", "Icons")
AddMedia("sunUIDPS", "SunUI/DPS.tga", "Icons")
AddMedia("sunUIHealer", "SunUI/Healer.tga", "Icons")

AddMedia("lynUITank", "LynUI/Tank.tga", "Icons")
AddMedia("lynUIDPS", "LynUI/DPS.tga", "Icons")
AddMedia("lynUIHealer", "LynUI/Healer.tga", "Icons")

AddMedia("PhilModTank", "PhilMod/Tank.tga", "Icons")
AddMedia("PhilModDPS", "PhilMod/DPS.tga", "Icons")
AddMedia("PhilModHealer", "PhilMod/Healer.tga", "Icons")

AddMedia("mask", "mask.tga", "Textures")
AddMedia("leaderborder", "leaderborder.tga", "Textures")
AddMedia("TimerlinePointer", "TimerlinePointer.tga", "Textures")
AddMedia("MapMask", "MapMask.tga", "Textures")
AddMedia("Tearlaments", "NoKey/Tearlaments.png", "Textures")
AddMedia("Joyous", "NoKey/Joyous.png", "Textures")
AddMedia("Albion", "NoKey/Albion.png", "Textures")
AddMedia("Fenrir", "NoKey/Fenrir.png", "Textures")
AddMedia("Nibiru", "NoKey/Nibiru.png", "Textures")
AddMedia("WhiteDragon", "NoKey/WhiteDragon.png", "Textures")
AddMedia("ScoreBound", "ScoreBound.tga", "Textures")


-- AddMedia("White8x8", "White8x8.tga", "Textures")
-- AddMedia("NormTex2", "NormTex2.tga", "Textures")

