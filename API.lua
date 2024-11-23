local LFG, L, P, C, G = unpack(LFGExtend)

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
LFG.allowBypass = {}
LFG.addonsToLoad = {}
LFG.nonAddonsToLoad = {}


function LFG:ADDON_LOADED(_, addonName)
	if not self.allowBypass[addonName] and not LFG.initialized then
		return
	end

	local object = self.addonsToLoad[addonName]
	if object then
		LFG:CallLoadedAddon(addonName, object)
	end
end
function LFG:RGBToHex(r, g, b)
	return format("%02x%02x%02x", r * 255, g * 255, b * 255)
end
function LFG:ClassColor(class, usePriestColor)
	if not class then return end

	local color = (_G.CUSTOM_CLASS_COLORS and _G.CUSTOM_CLASS_COLORS[class]) or _G.RAID_CLASS_COLORS[class]
	if type(color) ~= 'table' then return end

	if not color.colorStr then
		color.colorStr = LFG:RGBToHex(color.r, color.g, color.b, 'ff')
	elseif strlen(color.colorStr) == 6 then
		color.colorStr = 'ff'..color.colorStr
	end

	if usePriestColor and class == 'PRIEST' and tonumber(color.colorStr, 16) > tonumber(LFG.PriestColors.colorStr, 16) then
		return LFG.PriestColors
	else
		return color
	end
end
function LFG:StringWithHex(text, color)
	return format("|cff%s%s|r", color, text)
end

function LFG:StringWithRGB(text, r, g, b)
	if type(text) ~= "string" then
		text = tostring(text)
	end

	if type(r) == "table" then
		r, g, b = r.r, r.g, r.b
	end

	return LFG:StringWithHex(text, LFG:RGBToHex(r, g, b))
end



function LFG:AddCallbackForAddon(addonName, name, func, forceLoad, bypass, position) -- arg2: name is 'given name'; see example above.
	local load = (type(name) == 'function' and name) or (not func and (LFG[name] or LFG[addonName]))
	LFG:RegisterCallback(addonName, load or func, forceLoad, bypass, position)
end


function LFG:AddCallback(name, func, position) -- arg1: name is 'given name'
	local load = (type(name) == 'function' and name) or (not func and LFG[name])
	LFG:RegisterCallback('LFGExtend', load or func, nil, nil, position)
end


function LFG:RegisterCallback(addonName, func, forceLoad, bypass, position)
	if bypass then
		self.allowBypass[addonName] = true
	end

	if forceLoad then
		xpcall(func, errorhandler)
		self.addonsToLoad[addonName] = nil
	elseif addonName == 'LFGExtend' then
		if position then
			tinsert(self.nonAddonsToLoad, position, func)
		else
			tinsert(self.nonAddonsToLoad, func)
		end
	else
		local addon = self.addonsToLoad[addonName]
		if not addon then
			self.addonsToLoad[addonName] = {}
			addon = self.addonsToLoad[addonName]
		end

		if position then
			tinsert(addon, position, func)
		else
			tinsert(addon, func)
		end
	end
end


function LFG:CallLoadedAddon(addonName, object)
	for _, func in next, object do
		xpcall(func, errorhandler)
	end

	self.addonsToLoad[addonName] = nil
end

function LFG:InitAPI()
	for index, func in next, self.nonAddonsToLoad do
        xpcall(func, errorhandler)
        self.nonAddonsToLoad[index] = nil
    end
    for addonName, object in pairs(self.addonsToLoad) do
        local isLoaded, isFinished = IsAddOnLoaded(addonName)
        if isLoaded and isFinished then
            LFG:CallLoadedAddon(addonName, object)
        end
    end
end

LFG:RegisterEvent('ADDON_LOADED')