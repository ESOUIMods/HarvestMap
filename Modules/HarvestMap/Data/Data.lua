
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events
local SubmoduleManager = Harvest.submoduleManager
local Serialization = Harvest.serialization

local Data = {}
Harvest:RegisterModule("Data", Data)

function Data:Initialize()
	-- cache the deserialized nodes
	-- this way changing maps multiple times will create less lag
	self.mapCaches = {}
	self.numMapCaches = 0
	self.currentZoneCache = nil
	
	-- when the time setting is changed, all caches need to be reloaded
	local clearCache = function(event, setting, value)
		if setting == "applyTimeDifference" then
			self:ClearCaches()
		end
	end
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, clearCache)
	
	-- save discovered nodes
	CallbackManager:RegisterForEvent(Events.NODE_DISCOVERED,
		function(event, mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeId)
			self:SaveNode(mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeId)
		end)
	
	LibMapMetaData:RegisterCallback("HarvestMap-Database",
		function(mapMetaData, zoneMeasurement)
			self:ValidateCachesForAddedZoneMeasurement(mapMetaData, zoneMeasurement)
		end)
	
	CallbackManager:RegisterForEvent(Events.NEW_NODES_LOADED_TO_CACHE,
		function(event, mapCache, pinTypeId, numAdded)
			if numAdded <= 0 then return end
			if not self.currentZoneCache then return end
			if not self.currentZoneCache:DoesHandleMapCache(mapCache) then return end
			self.currentZoneCache:MergeNodesOfMapCacheAndPinType(mapCache, pinTypeId)
			self:AddMissingWorldCoords(mapCache)
		end)
	
	CallbackManager:RegisterForEvent(Events.MAP_ADDED_TO_ZONE,
		function(event, mapCache, currentZoneCache)
			self:AddMissingWorldCoords(mapCache)
		end)
	
	Lib3D:RegisterWorldChangeCallback("HarvestMap-Data",
		function()
			-- loading the zone cache is the last thing to complete
			-- for the data module to have finished initialization
			self.isInitialized = true
			self:RefreshZoneCacheForNewZone()
			self:RemoveOldCaches()
		end)
end

function Data:AddMissingWorldCoords(mapCache)
	if not mapCache.hasMissingWorldCoords then return end
	if not Lib3D:IsValidZone() then return end
	
	local mapMetaData = mapCache.mapMetaData
	local zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
	assert(mapMetaData:HasGivenZoneMeasurement(zoneMeasurement),
			zo_strformat("<<1>> does not have zone cache for id <<2>>", mapMetaData.map, zoneMeasurement.zoneId))
	
	for nodeId in pairs(mapCache.pinTypeId) do
		if not (mapCache.worldX[nodeId] and mapCache.worldY[nodeId]) then
			mapCache.worldX[nodeId], mapCache.worldY[nodeId] = zoneMeasurement:GlobalToWorld(
					mapMetaData:LocalToGlobal(mapCache.localX[nodeId], mapCache.localY[nodeId]))
		end
	end
	
	mapCache.hasMissingWorldCoords = nil
end

function Data:ClearCaches()
	self.currentZoneCache = nil
	self.mapCaches = {}
	self.numMapCaches = 0
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "cacheCleared")
end

-- Called when mapMetaData changes
-- This can happen when 3d measurement data is added, or when eso had a
-- zoneIndex bug that was reverted.
function Data:ValidateCachesForAddedZoneMeasurement(mapMetaData, zoneMeasurement)
	local mapCache = self.mapCaches[mapMetaData.map]
	if not mapCache then return end
	assert(mapCache.mapMetaData == mapMetaData, zo_strformat(
			"There exist two different metaData instances for the map <<1>>, <<2>>",
			mapMetaData.map, mapCache.mapMetaData.map))
	
	if not mapCache.zoneMeasurement:IsValid() then
		mapCache:RefreshZoneMeasurementDependendFields()
		CallbackManager:FireCallbacks(Events.MAP_CACHE_ZONE_MEASUREMENT_CHANGED, mapCache)
	end
	
	if self.currentZoneCache and self.currentZoneCache.zoneMeasurement == zoneMeasurement then
		if not self.currentZoneCache:DoesHandleMapCache(mapCache) then
			self.currentZoneCache:AddCache(mapCache)
			CallbackManager:FireCallbacks(Events.MAP_ADDED_TO_ZONE, mapCache, self.currentZoneCache)
		end
	end
	
end

function Data:IsNodeDataValid(mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeId)
	assert(type(worldX) == "number")
	assert(type(worldY) == "number")
	--assert(type(worldZ) == "number")
	assert(type(localX) == "number")
	assert(type(localY) == "number")
	assert(type(pinTypeId) == "number")
	assert(mapMetaData)
	
	if Harvest.mapTools:IsMapBlacklisted(mapMetaData.map) then
		self:Warn("Node data invalid. %s is blacklisted", map)
		return false
	end
	if localX <= 0 or localX >= 1 or localY <= 0 or localY >= 1 then
		self:Warn("Node data invalid. Coords %f, %f are outside of the map", localX, localY)
		return false
	end
	return true
end

-- this function tries to save the given data
-- this function is only used by the harvesting part of HarvestMap
function Data:SaveNode(mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeId)
	local pinTypeIdAlias = Harvest.PINTYPE_ALIAS[pinTypeId]
	if pinTypeIdAlias then
		self:SaveNode(mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeIdAlias)
	end
	
	
	if not self:IsNodeDataValid(mapMetaData, worldX, worldY, worldZ, localX, localY, pinTypeId) then return end
	if not Harvest.IsPinTypeSavedOnGather(pinTypeId) then return end
	
	local map = mapMetaData.map
	local submodule = SubmoduleManager:GetSubmoduleForMap(map)
	if not submodule then
		if not Harvest.mapTools:IsMapBlacklisted(map) then
			CallbackManager:FireCallbacks(Events.ERROR_MODULE_NOT_LOADED, "save", SubmoduleManager:GetSubmoduleDisplayNameForMap(map))
		end
		return
	end
	
	local savedVars = submodule.savedVars
	savedVars.data[map] = savedVars.data[map] or {}
	savedVars.data[map][pinTypeId] = savedVars.data[map][pinTypeId] or {}

	local mapCache = self:GetMapCache(mapMetaData)
	if not mapCache then return end
	
	-- additional serialized data
	local timestamp = GetTimeStamp()
	local version = Harvest.nodeVersion
	local globalX, globalY = mapMetaData:LocalToGlobal(localX, localY)
	local flags = 0
	local serializedNode = Serialization:Serialize(
			worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags)
	
	-- if the pintype is not already in the cache, just add the node to the savedVars
	-- it will be merged the next time the pin type is loaded to the cache
	local doesMapCacheHandlePinType = mapCache:DoesHandlePinType(pinTypeId)
	if doesMapCacheHandlePinType then
		-- If we have found this node already then we don't need to save it again
		local nodeId = mapCache:GetMergeableNode(pinTypeId, localX, localY)
		if nodeId then
			mapCache:Move(nodeId, worldX, worldY, worldZ, localX, localY)
			-- serialize the node for the save file
			local nodeIndex = mapCache.nodeIndex[nodeId]
			savedVars.data[map][pinTypeId][nodeIndex] = serializedNode
			self:Info("data was merged with a previous node. nodeId: %d", nodeId)
			
			CallbackManager:FireCallbacks(Events.NODE_UPDATED, mapCache, nodeId)
			CallbackManager:FireCallbacks(Events.NODE_HARVESTED, mapCache, nodeId)
			return
		end
	end
	
	-- we need to save the data in serialized form in the save file,
	-- but also as deserialized table in the cache table for faster access.
	local nodeIndex = (#savedVars.data[map][pinTypeId]) + 1
	savedVars.data[map][pinTypeId][nodeIndex] = serializedNode
	self:Info("data was added to savedVariables. nodeindex: %d, savedVar: %s", nodeIndex, submodule.displayName)
	
	if doesMapCacheHandlePinType then
		local nodeId = mapCache:Add(pinTypeId, nodeIndex, worldX, worldY, worldZ, localX, localY)
		assert(nodeId, "could not save node to cache")
		CallbackManager:FireCallbacks(Events.NODE_ADDED, mapCache, nodeId)
		CallbackManager:FireCallbacks(Events.NODE_HARVESTED, mapCache, nodeId)
		self:Info("data was added to cache. nodeid: %d, map: %s", nodeId, mapCache.map)
	end
end

function Data:RemoveOldCaches()
	--if self.numMapCaches <= 5 then return end
	
	local oldestCache
	local oldestTime = math.huge
	while true do
		for map, cache in pairs(self.mapCaches) do
			if cache.time < oldestTime and cache.accessed == 0 then
				oldestCache = cache
				oldestTime = cache.time
			end
		end
		
		if not oldestCache then break end
		
		self:Info("Clear cache for map ", oldestCache.map)
		oldestCache:Dispose()
		self.mapCaches[oldestCache.map] = nil
		self.numMapCaches = self.numMapCaches - 1
		oldestCache = nil
		oldestTime = math.huge
	end
	collectgarbage()
	collectgarbage() -- somehow the first sweep doesn't clear everything
end

function Data:CreateNewCache(mapMetaData)
	
	--if self.numMapCaches > 10 then
	--	self:RemoveOldCaches()
	--end
	
	local cache = Harvest.MapCache:New(mapMetaData)	
	self.mapCaches[mapMetaData.map] = cache
	self.numMapCaches = self.numMapCaches + 1
	self:Info("new map cache for map", mapMetaData.map)
	
	if self.currentZoneCache and mapMetaData:HasGivenZoneMeasurement(self.currentZoneCache.zoneMeasurement) then
		self.currentZoneCache:AddCache(cache)
		CallbackManager:FireCallbacks(Events.MAP_ADDED_TO_ZONE, cache, self.currentZoneCache)
	end
	
	return cache
end


-- loads the nodes to cache and returns them
function Data:GetMapCache(mapMetaData)
	if not self.isInitialized then return end
	if not mapMetaData.mapMeasurement then return end
	-- if the current map isn't in the cache, create the cache
	local map = mapMetaData.map
	local mapCache = self.mapCaches[map]
	if not mapCache then
		mapCache = self:CreateNewCache(mapMetaData)
		self.mapCaches[map] = mapCache
	end
	
	assert(mapCache.mapMetaData == mapMetaData, "MapMetaData of the zone cache does not match!")
	
	-- make sure all the neccesary data exists
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if Harvest.IsPinTypeVisible(pinTypeId) then
			self:CheckPinTypeInCache(pinTypeId, mapCache)
		end
	end

	return mapCache
end

function Data:GetCurrentZoneCache()
	return self.currentZoneCache
end

function Data:RefreshZoneCacheForNewZone()
	local zoneIndex = GetUnitZoneIndex("player")
	if self.currentZoneCache and self.currentZoneCache.zoneIndex == zoneIndex then
		self:Info("Player did not enter a new zone (%d)", zoneIndex)
		for map, mapCache in pairs(self.currentZoneCache.mapCaches) do
			self:AddMissingWorldCoords(mapCache)
		end
		return
	end

	if self.currentZoneCache then
		self.currentZoneCache:Dispose()
	end
	
	local zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
	assert(zoneMeasurement, "no zone measurement for zone " .. tostring(GetZoneId(zoneIndex)))
	self.currentZoneCache = self.ZoneCache:New(zoneMeasurement)
	
	-- add already loaded data, if it belongs to this zone
	local addedMaps = {}
	for map, mapCache in pairs(self.mapCaches) do
		if mapCache.mapMetaData:HasGivenZoneMeasurement(zoneMeasurement) then
			self.currentZoneCache:AddCache(mapCache)
			table.insert(addedMaps, map)
		end
	end
	if next(addedMaps) then
		self:Info("Added maps to zone", tostring(zoneIndex), unpack(addedMaps))
	else
		self:Info("No current map known for this zone", tostring(zoneIndex))
	end
	
	-- load data of the player's current map
	local mapMetaData, localX, localY = Harvest.mapTools:GetPlayerMapMetaDataAndLocalPosition()
	self:GetMapCache(mapMetaData)
	
	-- load data of parent maps
	while mapMetaData.parentMetaData do
		mapMetaData = mapMetaData.parentMetaData
		if mapMetaData:HasGivenZoneMeasurement(zoneMeasurement) then
			self:GetMapCache(mapMetaData)
		else
			break
		end
	end
	
	CallbackManager:FireCallbacks(Events.NEW_ZONE_ENTERED, self.currentZoneCache)
end

function Data:CheckPinTypeInCache(pinTypeId, mapCache)
	if not mapCache:DoesHandlePinType(pinTypeId) then
		Serialization:LoadNodesOfPinTypeToCache(pinTypeId, mapCache)
	end
end
