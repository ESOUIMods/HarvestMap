
local SubmoduleManager = {}
Harvest:RegisterModule("submoduleManager", SubmoduleManager)

local dataDefault = {
	dataVersion = 17,
	-- data version history:
	-- 10 = Orsinium (all nodes are saved as ACE strings)
	-- 11 = Thieves Guild (nodes can now store multiple itemIds)
	-- 12 = Trove fix
	-- 13 = DB data (removed node names, enchantment item ids, added itemid -> timestamp format)
	-- 14 = One Tamriel (changed pinTypeIds to be consecutive again)
	-- 15 = Housing (split alchemy nodes)
	-- 16 = Housing 2 (changed timestamp accuracy)
	-- 17 = changed save file structure and node structure
}

local addOnNameToPotentialSubmodule = {
	HarvestMapAD = {
		displayName = "HarvestMap-AD-Zones",
		savedVarsName = "HarvestAD_SavedVars",
		zones = {
			["auridon"] = true,
			["grahtwood"] = true,
			["greenshade"] = true,
			["malabaltor"] = true,
			["reapersmarch"] = true
		},
	},
	HarvestMapEP = {
		displayName = "HarvestMap-EP-Zones",
		savedVarsName = "HarvestEP_SavedVars",
		zones = {
			["bleakrock"] = true,
			["stonefalls"] = true,
			["deshaan"] = true,
			["shadowfen"] = true,
			["eastmarch"] = true,
			["therift"] = true
		},
	},
	HarvestMapDC = {
		displayName = "HarvestMap-DC-Zones",
		savedVarsName = "HarvestDC_SavedVars",
		zones = {
			["glenumbra"] = true,
			["stormhaven"] = true,
			["rivenspire"] = true,
			["alikr"] = true,
			["bangkorai"] = true
		},
	},
	HarvestMapDLC = {
		displayName = "HarvestMap-DLC-Zones",
		savedVarsName = "HarvestDLC_SavedVars",
		zones = {
			--imperialcity, part of cyrodiil
			["wrothgar"] = true,
			["thievesguild"] = true,
			["darkbrotherhood"] = true,
			["vvardenfell"] = true,
			["clockwork"] = true,
			["summerset"] = true,
			["murkmire"] = true,
			["elsweyr"] = true,
			["southernelsweyr"] = true,
		},
	},
	HarvestMapNF = {
		displayName = "HarvestMap-NoFaction-Zones",
		savedVarsName = "HarvestNF_SavedVars",
	},
}

function SubmoduleManager:Initialize()
	self.submodules = {}
	
	EVENT_MANAGER:RegisterForEvent("HarvestMap-Submodules", EVENT_PLAYER_ACTIVATED,
		function()
			self:InformUserAboutMissingSubmodules()
		end)
		
	EVENT_MANAGER:RegisterForEvent("HarvestMap-Submodules", EVENT_ADD_ON_LOADED,
		function(event, addOnName)
			self:TryToRegisterAddOnAsSubmodule(addOnName)
		end)
end

function SubmoduleManager:TryToRegisterAddOnAsSubmodule(addOnName)
	local submodule = addOnNameToPotentialSubmodule[addOnName]
	if not submodule then return end
	
	self.submodules[addOnName] = submodule
	
	-- load the savedVars
	_G[submodule.savedVarsName] = _G[submodule.savedVarsName] or {}
	submodule.savedVars = _G[submodule.savedVarsName]
	Harvest.CopyMissingDefaultValues(submodule.savedVars, dataDefault)
	
	self:CleanUpSavedVarsForSubmodule(submodule)
end

function SubmoduleManager:InformUserAboutMissingSubmodules()
	EVENT_MANAGER:UnregisterForEvent("HarvestMap-Submodules", EVENT_PLAYER_ACTIVATED)
	
	-- collect missing submodules
	local missingSubmodules = {}
	for addOnName, submodule in pairs(addOnNameToPotentialSubmodule) do
		if not self.submodules[addOnName] then
			missingSubmodules[submodule.displayName] = true
		end
	end
	
	if next(missingSubmodules) then -- if the table is not empty
		d(ZO_NORMAL_TEXT:Colorize("HarvestMap v" .. Harvest.displayVersion .. " initialized"))
		d(ZO_NORMAL_TEXT:Colorize("The following modules are disabled and their data was not loaded:"))
		for displayName in pairs(missingSubmodules) do
			d(ZO_NORMAL_TEXT:Colorize(displayName))
		end
	end
end

-- returns the correct table for the map (HarvestMap, HarvestMapAD/DC/EP save file tables)
-- may return nil if the submodule for the given map is not loaded
function SubmoduleManager:GetSubmoduleForMap(map)
	
	-- split of the zone prefic of the given map name
	local zoneName = string.gsub(map, "/.*$", "" )
	
	-- check if the zone belongs to one of the submodules
	for addOnName, submodule in pairs(addOnNameToPotentialSubmodule) do
		if submodule.zones and submodule.zones[zoneName] then
			-- the module does match the given map, however it might not be loaded
			-- so we need to additionally check if there exist savedVars for that module
			if submodule.savedVars then
				return submodule
			else
				return nil
			end
		end
	end
	
	-- otherwise return the NF module
	-- note that this may be nil if the NF module is not loaded
	return self.submodules["HarvestMapNF"]
	
end

-- imports all the nodes on 'map' from the table 'data' into the save file table 'saveFile'
-- if checkPinType is true, data will be skipped if Harvest.IsPinTypeSavedOnImport(pinTypeId) returns false
function SubmoduleManager:ImportMapDataIntoSubmodule(zoneId, map, newMapData, submodule)
	
	submodule.savedVars[zoneId] = submodule.savedVars[zoneId] or {}
	local existingData = submodule.savedVars[zoneId]
	-- nothing to merge, data can simply be copied
	if not existingData[map] then
		existingData[map] = newMapData
		return
	end
	local existingMapData = existingData[map]
	
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if newMapData[pinTypeId] then
			if existingMapData[pinTypeId] then
				local existingPinTypeData = existingMapData[pinTypeId]
				for nodeIndex, serializedNode in pairs(newMapData[pinTypeId]) do
					table.insert(existingPinTypeData, serializedNode)
				end
			else
				-- nothing to merge for this pin type, just copy the data
				existingMapData[pinTypeId] = newMapData[pinTypeId]
			end
		end
	end
	
end

function SubmoduleManager:CleanUpSavedVarsForSubmodule(submodule)
	-- when a new zone is released, the new zone may sometimes be saved in
	-- HarvestMap-NF until HarvestMap is updated
	-- Here we move old data from NF to the correct submodule
	if not HarvestNF_SavedVars then return end -- NF might be deactivated
	
	if submodule.savedVars == HarvestNF_SavedVars then
		-- move data from newly loaded NF module to previously loaded modules
		for zoneId, zoneData in pairs(HarvestNF_SavedVars) do
			if type(zoneId) == "number" then
				for map, mapData in pairs(zoneData) do
					local submodule = self:GetSubmoduleForMap(map)
					if submodule and submodule.savedVars ~= HarvestNF_SavedVars then
						self:ImportMapDataIntoSubmodule(zoneId, map, mapData, submodule)
						HarvestNF_SavedVars[zoneId][map] = nil
					end
				end
			end
		end
		if HarvestNF_SavedVars.data then
			local zoneId = "data"
			for map, mapData in pairs(HarvestNF_SavedVars.data) do
				local submodule = self:GetSubmoduleForMap(map)
				if submodule and submodule.savedVars ~= HarvestNF_SavedVars then
					self:ImportMapDataIntoSubmodule(zoneId, map, mapData, submodule)
					HarvestNF_SavedVars[zoneId][map] = nil
				end
			end
		end
	elseif submodule.zones then
		-- move data from previously loaded NF module to newly loaded module
		for zoneId, zoneData in pairs(HarvestNF_SavedVars) do
			if type(zoneId) == "number" then
				for map, mapData in pairs(zoneData) do
					local zoneName = string.gsub(map, "/.*$", "")
					if submodule.zones[zoneName] then
						self:ImportMapDataIntoSubmodule(zoneId, map, mapData, submodule)
						HarvestNF_SavedVars[zoneId][map] = nil
					end
				end
			end
		end
	end
end

function SubmoduleManager:GetSubmoduleDisplayNameForMap(map)
	local zoneName = string.gsub( map, "/.*$", "" )
	for addOnName, submodule in pairs(addOnNameToPotentialSubmodule) do
		if submodule.zones and submodule.zones[zoneName] then
			return submodule.displayName
		end
	end
	return addOnNameToPotentialSubmodule["HarvestMapNF"].displayName
end
