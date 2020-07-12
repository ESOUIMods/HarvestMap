
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
		function(event, mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeId)
			self:SaveNode(mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeId)
		end)
	
	CallbackManager:RegisterForEvent(Events.NEW_NODES_LOADED_TO_CACHE,
		function(event, mapCache, pinTypeId, numAdded)
			if numAdded <= 0 then return end
			if not self.currentZoneCache then return end
			if not self.currentZoneCache:DoesHandleMapCache(mapCache) then return end
			self.currentZoneCache:MergeNodesOfMapCacheAndPinType(mapCache, pinTypeId)
		end)
	
	Lib3D:RegisterWorldChangeCallback("HarvestMap-Data",
		function()
			-- loading the zone cache is the last thing to complete
			-- for the data module to have finished initialization
			self:Info("lib3d world change callback fired")
			self.isInitialized = true
			self:RefreshZoneCacheForNewZone()
			self:RemoveOldCaches()
		end)
end

function Data:ClearCaches()
	self:Info("clear all caches")
	self.currentZoneCache = nil
	self.mapCaches = {}
	self.numMapCaches = 0
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "cacheCleared")
end

function Data:IsNodeDataValid(mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeId)
	assert(type(worldX) == "number")
	assert(type(worldY) == "number")
	--assert(type(worldZ) == "number")
	assert(type(globalX) == "number")
	assert(type(globalY) == "number")
	assert(type(pinTypeId) == "number")
	assert(mapMetaData)
	
	if Harvest.mapTools:IsMapBlacklisted(mapMetaData.map) then
		self:Warn("Node data invalid. %s is blacklisted", map)
		return false
	end
	
	return true
end

-- this function tries to save the given data
-- this function is only used by the harvesting part of HarvestMap
function Data:SaveNode(mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeId)
	local pinTypeIdAlias = Harvest.PINTYPE_ALIAS[pinTypeId]
	if pinTypeIdAlias then
		self:SaveNode(mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeIdAlias)
	end
	
	self:Info("attempt to save node ", mapMetaData.map, mapMetaData.zoneId, 
		worldX, worlY, worldZ, globalX, globalY, pinTypeId)
	
	if not self:IsNodeDataValid(mapMetaData, worldX, worldY, worldZ, globalX, globalY, pinTypeId) then return end
	if not Harvest.IsPinTypeSavedOnGather(pinTypeId) then return end
	if mapMetaData.zoneIndex ~= GetUnitZoneIndex("player") then
		self:Warn("tried to save node in wrong zone: %d, %d, %s", 
				GetZoneId(GetUnitZoneIndex("player")), mapMetaData.zoneId, mapMetaData.map)
		return
	end
	
	local map = mapMetaData.map
	local zoneId = mapMetaData.zoneId
	local submodule = SubmoduleManager:GetSubmoduleForMap(map)
	if not submodule then
		if not Harvest.mapTools:IsMapBlacklisted(map) then
			self:Info("could not save node; container missing")
			CallbackManager:FireCallbacks(Events.ERROR_MODULE_NOT_LOADED, "save", SubmoduleManager:GetSubmoduleDisplayNameForMap(map))
		end
		return
	end
	
	local savedVars = submodule.savedVars
	savedVars[zoneId] = savedVars[zoneId] or {}
	savedVars[zoneId][map] = savedVars[zoneId][map] or {}
	savedVars[zoneId][map][pinTypeId] = savedVars[zoneId][map][pinTypeId] or {}

	local mapCache = self:GetMapCache(mapMetaData)
	assert(mapCache)
	
	-- additional serialized data
	local timestamp = GetTimeStamp()
	local version = Harvest.nodeVersion
	local flags = 0
	local serializedNode = Serialization:Serialize(
			worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags)
	
	-- if the pintype is not already in the cache, just add the node to the savedVars
	-- it will be merged the next time the pin type is loaded to the cache
	local doesMapCacheHandlePinType = mapCache:DoesHandlePinType(pinTypeId)
	if doesMapCacheHandlePinType then
		-- If we have found this node already then we don't need to save it again
		local nodeId = mapCache:GetMergeableNode(pinTypeId, worldX, worldY, worldZ)
		if nodeId then
			mapCache:Move(nodeId, worldX, worldY, worldZ, globalX, globalY)
			-- serialize the node for the save file
			local nodeIndex = mapCache.nodeIndex[nodeId]
			savedVars[zoneId][map][pinTypeId][nodeIndex] = serializedNode
			self:Info("data was merged with a previous node. nodeId: %d", nodeId)
			
			CallbackManager:FireCallbacks(Events.NODE_UPDATED, mapCache, nodeId)
			CallbackManager:FireCallbacks(Events.NODE_HARVESTED, mapCache, nodeId)
			return
		end
	end
	
	-- we need to save the data in serialized form in the save file,
	-- but also as deserialized table in the cache table for faster access.
	local nodeIndex = (#savedVars[zoneId][map][pinTypeId]) + 1
	savedVars[zoneId][map][pinTypeId][nodeIndex] = serializedNode
	self:Info("data was added to savedVariables. nodeindex: %d, savedVar: %s", nodeIndex, submodule.displayName)
	
	if doesMapCacheHandlePinType then
		local nodeId = mapCache:Add(pinTypeId, nodeIndex, worldX, worldY, worldZ, globalX, globalY)
		assert(nodeId, "could not save node to cache")
		CallbackManager:FireCallbacks(Events.NODE_ADDED, mapCache, nodeId)
		CallbackManager:FireCallbacks(Events.NODE_HARVESTED, mapCache, nodeId)
		self:Info("data was added to cache. nodeid: %d, map: %s", nodeId, mapCache.map)
	end
end

function Data:RemoveOldCaches()
	--if self.numMapCaches <= 5 then return end
	self:Info("remove old caches")
	local oldestCache
	local oldestTime = math.huge
	while true do
		for mapMetaData, cache in pairs(self.mapCaches) do
			if cache.time < oldestTime and cache.accessed == 0 then
				oldestCache = cache
				oldestTime = cache.time
			end
		end
		
		if not oldestCache then break end
		
		self:Info("Clear cache for map ", oldestCache.map)
		oldestCache:Dispose()
		self.mapCaches[oldestCache.mapMetaData] = nil
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
	self.mapCaches[mapMetaData] = cache
	self.numMapCaches = self.numMapCaches + 1
	self:Info("new map cache for map", mapMetaData.map, mapMetaData.zoneId)
	
	if self.currentZoneCache and mapMetaData.zoneId == self.currentZoneCache.zoneId then
		self:Info("add map cache to current zone cache with zone id ", self.currentZoneCache.zoneId)
		self.currentZoneCache:AddCache(cache)
		CallbackManager:FireCallbacks(Events.MAP_ADDED_TO_ZONE, cache, self.currentZoneCache)
	end
	
	return cache
end


-- loads the nodes to cache and returns them
function Data:GetMapCache(mapMetaData)
	if not self.isInitialized then return end
	-- if the current map isn't in the cache, create the cache
	local mapCache = self.mapCaches[mapMetaData]
	if not mapCache then
		mapCache = self:CreateNewCache(mapMetaData)
		self.mapCaches[mapMetaData] = mapCache
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
		return
	end

	if self.currentZoneCache then
		self.currentZoneCache:Dispose()
	end
	
	local zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
	assert(zoneMeasurement, "no zone measurement for zone " .. tostring(GetZoneId(zoneIndex)))
	self.currentZoneCache = self.ZoneCache:New(zoneMeasurement)
	self:Info("new zone cache for zone id ", zoneMeasurement.zoneId)
	
	-- add already loaded data, if it belongs to this zone
	for mapMetaData, mapCache in pairs(self.mapCaches) do
		if mapMetaData.zoneId == zoneMeasurement.zoneId then
			self.currentZoneCache:AddCache(mapCache)
			self:Info("add map to zone cache ", mapCache.map)
		end
	end
	
	-- load data for current map
	local mapMetaData = Harvest.mapTools:GetPlayerMapMetaDataAndGlobalPosition()
	self:GetMapCache(mapMetaData)
	
	-- try to load data for other maps in this zone
	local submodule = SubmoduleManager:GetSubmoduleForMap(mapMetaData.map)
	if not submodule then
		local map = mapMetaData.map
		if not Harvest.mapTools:IsMapBlacklisted(map) then
			self:Info("container for current zone is not enabled")
			CallbackManager:FireCallbacks(Events.ERROR_MODULE_NOT_LOADED, "load", SubmoduleManager:GetSubmoduleDisplayNameForMap(map))
		end
	else
		local data = submodule.savedVars[mapMetaData.zoneId]
		if data then
			for map in pairs(data) do
				self:GetMapCache(Harvest.mapTools:GetMapMetaDataForZoneIndexAndMap(mapMetaData.zoneIndex, map))
			end
		end
	end
	
	-- inform other modules about the new zone cache
	CallbackManager:FireCallbacks(Events.NEW_ZONE_ENTERED, self.currentZoneCache)
end

function Data:CheckPinTypeInCache(pinTypeId, mapCache)
	if not mapCache:DoesHandlePinType(pinTypeId) then
		Serialization:LoadNodesOfPinTypeToCache(pinTypeId, mapCache)
	end
end
