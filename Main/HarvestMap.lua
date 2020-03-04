
local function OnLoad(eventCode, addOnName)
		
	if addOnName ~= "HarvestMap" then
		return
	end
	
	LibDAU:VerifyAddon("HarvestMap")
	
end

EVENT_MANAGER:RegisterForEvent("HarvestMap-corrupted", EVENT_ADD_ON_LOADED, OnLoad)
