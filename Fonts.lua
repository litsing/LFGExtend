local LFG, L, P, C, G = unpack(LFGExtend)

local _G = _G
local strsub = strsub

function LFG:SetFont(obj, font, size, style, sR, sG, sB, sA, sX, sY, r, g, b, a)
    if not obj then return end

    if style == 'NONE' or not style then style = '' end

    local shadow = strsub(style, 0, 6) == 'SHADOW'
    if shadow then style = strsub(style, 7) end -- shadow isnt a real style

    obj:SetFont(font, size, style)
    obj:SetShadowColor(sR or 0, sG or 0, sB or 0, sA or (shadow and (style == '' and 1 or 0.6)) or 0)
    obj:SetShadowOffset(sX or (shadow and 1) or 0, sY or (shadow and -1) or 0)

    if r and g and b then
        obj:SetTextColor(r, g, b)
    end

    if a then
        obj:SetAlpha(a)
    end
end
function LFG:UpdateBlizzardFonts()
        LFG:SetFont(_G.SystemFont_Shadow_Med1,                "Fonts\\FRIZQT__.TTF", 13, 'SHADOW')
        LFG:SetFont(_G.SystemFont_Shadow_Small,               "Fonts\\FRIZQT__.TTF", 10, 'SHADOW')
    end