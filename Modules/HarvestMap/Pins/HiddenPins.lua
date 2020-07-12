
local GPS = LibGPS2

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local Hidden = {}
Harvest:RegisterModule("hidden", Hidden)

function Hidden.Initialize()
	
	Hidden.ConfigureForSettings(Harvest.IsHiddenTimeUsed(), Harvest.GetHiddenTime(), Harvest.IsHiddenOnHarvest())
	
	local validSettings = {
		hiddenTime = true,
		useHiddenTime = true,
		hiddenOnHarvest = true,
	}
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, value)
		if validSettings[setting] then
			Hidden.ConfigureForSettings(Harvest.IsHiddenTimeUsed(), Harvest.GetHiddenTime(), Harvest.IsHiddenOnHarvest())
		end
	end)
	
	local function hideNodeOnHarvest(event, mapCache, nodeId)
		if Harvest.IsHiddenOnHarvest() and Harvest.IsHiddenTimeUsed() and Harvest.GetHiddenTime() > 0 then
			Hidden.HidePin(mapCache, nodeId)
		end
	end
	CallbackManager:RegisterForEvent(Events.NODE_HARVESTED, hideNodeOnHarvest)
end

function Hidden.HidePin(mapCache, nodeId)
	local wasHidden = mapCache:HideNode(nodeId)
	if wasHidden then
		Hidden:Debug("Hide Pin. map: %s, nodeId: %d", mapCache.map, nodeId)
		CallbackManager:FireCallbacks(Events.CHANGED_NODE_HIDDEN_STATE, mapCache.map, nodeId, wasHidden)
	end
end

function Hidden.UnhidePin(mapCache, nodeId)
	local changedState = mapCache:UnhideNode(nodeId)
	if changedState then
		Hidden:Debug("Unhide Pin. map: %s, nodeId: %d", mapCache.map, nodeId)
		local isHidden = false
		CallbackManager:FireCallbacks(Events.CHANGED_NODE_HIDDEN_STATE, mapCache.map, nodeId, isHidden)
	end
end

function Hidden.ConfigureForSettings(isHiddenTimeUsed, hiddenTimeInMinutes, hiddenOnHarvest)
	Hidden:Info("configure hidden pins for isHiddenTimeUsed %s, hiddenTimeInMinutes %d, hiddenOnHarvest %s",
		tostring(isHiddenTimeUsed), hiddenTimeInMinutes, tostring(hiddenOnHarvest))
	if hiddenTimeInMinutes > 0 and isHiddenTimeUsed then
		-- since we hide pins in the order of minutes, we can call this function very rarely
		EVENT_MANAGER:RegisterForUpdate("HarvestMap-UnhidePins", 10 * 1000, Hidden.UnhideHiddenPins)
		-- when "hidden on harvest" is enabled, then we don't hide pins near the player
		if hiddenOnHarvest then
			EVENT_MANAGER:UnregisterForUpdate("HarvestMap-HidePins")
		else
			-- this function needs to be called often, so the player doesn't "tunnel" through nodes
			EVENT_MANAGER:RegisterForUpdate("HarvestMap-HidePins", 250, Hidden.HideNearbyPins)
		end
	else
		EVENT_MANAGER:UnregisterForUpdate("HarvestMap-HidePins")
		EVENT_MANAGER:UnregisterForUpdate("HarvestMap-UnhidePins")
	end
	Hidden.hiddenTimeInMs = hiddenTimeInMinutes * 60 * 1000
end

function Hidden.HideNearbyPins()

	local x, y = Harvest.GetPlayer3DPosition()
	-- some maps don't work (ie aurbis)
	if x then
		local cache = Harvest.Data:GetCurrentZoneCache()
		if cache then
			for _, mapCache in pairs(cache.mapCaches) do
				-- for every nearby node, execute Hidden.HidePin(mapCache, nodeId)
				mapCache:ForNearbyNodes(x, y, Hidden.HidePin)
			end
		end
	end
	
end

function Hidden.UnhideHiddenPins( currentTimeInMs )
	-- check every single hidden pin, if it was hidden 'hiddenTimeInMs' ms ago
	-- if so, then unhide the pin
	local hiddenTimeInMs = Hidden.hiddenTimeInMs 
	for map, cache in pairs(Harvest.Data.mapCaches) do
		for nodeId, timeWhenHiddenInMs in pairs(cache.hiddenTime) do
			if currentTimeInMs - timeWhenHiddenInMs > hiddenTimeInMs then
				Hidden.UnhidePin(cache, nodeId)
			end
		end
	end
	
end
