
local tonumber = _G["tonumber"]
local assert = _G["assert"]
local gmatch = string.gmatch
local tostring = _G["tostring"]
local insert = table.insert
local format = string.format
local concat = table.concat



local Serialization = {}
Harvest:RegisterModule("serialization", Serialization)
--arvest.serialization = Serialization

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events
local SubmoduleManager = Harvest.submoduleManager

function Serialization:Initialize()
	self.timestamp = {}
	self.version = {}
	self.flags = {}
end

function Serialization:LoadNodesOfPinTypeToCache(pinTypeId, mapCache)
	
	mapCache:InitializePinType(pinTypeId)
	local mapMetaData = mapCache.mapMetaData
	local map = mapMetaData.map
	local zoneId = mapMetaData.zoneId

	local submodule = SubmoduleManager:GetSubmoduleForMap(map)
	if not submodule then
		if not Harvest.mapTools:IsMapBlacklisted(map) then
			CallbackManager:FireCallbacks(Events.ERROR_MODULE_NOT_LOADED,
					"load", SubmoduleManager:GetSubmoduleDisplayNameForMap(map))
		end
		return
	end
	
	self.isMapCurrentlyViewed = (map == Harvest.mapTools:GetMap())
	
	self:Debug("filling cache for map %s, pinTypeId %d, from file %s",
			map, pinTypeId, submodule.savedVarsName)
	
	local savedVars = submodule.savedVars
	-- import old data if it exists
	if savedVars.data then 
		if savedVars.data[map] then 
			local houseZoneId = GetHouseZoneId(GetCurrentZoneHouseId())
			if houseZoneId ~= zoneId then
				-- houses have their own zone id
				-- do not import if we are in a house
				-- because the data actually belongs to the parent zone
				self:Info("moved data from map %s to zone %d", map, zoneId)
				SubmoduleManager:ImportMapDataIntoSubmodule(zoneId, map, savedVars.data[map], submodule)
				savedVars.data[map] = nil
			end
		end
	end
	
	if not savedVars[zoneId] then return end
	if not savedVars[zoneId][map] then return end
	if not savedVars[zoneId][map][pinTypeId] then return end
	self.serializedNodes = savedVars[zoneId][map][pinTypeId]
	
	ZO_ClearTable(self.timestamp)
	ZO_ClearTable(self.version)
	ZO_ClearTable(self.flags)
	
	self.mapCache = mapCache
	self.pinTypeId = pinTypeId
	
	self:Load()
end

local zoneIdToZoneName = {
	[3] = "glenumbra",
	[19] = "stormhaven",
	[20] = "rivenspire",
	[92] = "bangkorai",
	[104] = "alikr",
	
	[41] = "stonefalls",
	[57] = "deshaan",
	[117] = "shadowfen",
	[101] = "eastmarch",
	[103] = "therift",
	
	[381] = "auridon",
	[383] = "grahtwood",
	[108] = "greenshade",
	[58] = "malabaltor",
	[382] = "reapersmarch",
}

function Serialization:Load()
	
	local currentTimestamp = GetTimeStamp()
	local maxTimeDifference = Harvest.GetMaxTimeDifference() * 3600
	local minGameVersion = Harvest.GetMinGameVersion()
	local mapCache = self.mapCache
	local mapMetaData = mapCache.mapMetaData
	local zoneId = mapMetaData.zoneId
	local mapMeasurement = mapMetaData.mapMeasurement
	local map = mapMetaData.map
	local pinTypeId = self.pinTypeId
	local numAdded, numRemoved, numMerged = 0, 0, 0
	
	-- TODO move to server file?
	local filterZoneBugNodes = false
	if zoneIdToZoneName[zoneId] then
		local zoneName = string.gsub(map, "/.*$", "" )
		if zoneName ~= zoneIdToZoneName[zoneId] then
			filterZoneBugNodes = true
		end
	end
	
	
	local valid, updated, nodeId
	local success, worldX, worldY, worldZ, names, timestamp, version, globalX, globalY, localX, localY, flags
	-- deserialize the nodes
	for nodeIndex, node in pairs(self.serializedNodes) do
		success, worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags = self:Deserialize( node, pinTypeId )
		if not success then--or not x or not y then
			self:Warn("invalid node:", worldX)
			self.serializedNodes[nodeIndex] = nil
		else
			valid = true
			updated = false
			-- remove nodes that are too old (either number of days or patch)
			if maxTimeDifference > 0 and currentTimestamp - timestamp > maxTimeDifference then
				valid = false
				self:Debug("outdated node:", map, node)
			end
			
			if minGameVersion > 0 and zo_floor(version / 1000) < minGameVersion then
				valid = false
				self:Debug("outdated node:", map, node)
			end
			
			if filterZoneBugNodes and version % 1000 < 39 then
				-- the node might have been erroneously imported
				self:Debug("removed erroneously imported node ", map, node)
				valid = false
			end
			
			if valid then
				-- remove data without world coordinates
				if worldX == nil or worldY == nil or worldZ == nil or worldX < 1 or worldY < 1 then
					self:Debug("removed node without world coords ", map, node)
					valid = false
				end
			end
			
			if valid then
				if not (globalX and globalY) then
					self:Debug("removed node without global coords ", map, node)
					valid = false
				end
			end
			
			if valid then
				if (globalX == globalY) and (pinTypeId == Harvest.FISHING) then
					self:Debug("removed bugged fishing node ", map, node)
					valid = false 
				end
			end
			
			if valid and mapMeasurement then
				localX, localY = mapMeasurement:ToLocal(globalX, globalY)
				if localX > 1 or localX < 0 or localY > 1 or localY < 0 then
					self:Debug("remove node because of local coords ", map, node)
					valid = false
				end
			end
			
			-- remove close nodes (ie duplicates on cities)
			if valid then
				local nodeId = mapCache:GetMergeableNode(pinTypeId, worldX, worldY, worldZ)
				if nodeId then
					if self.timestamp[nodeId] < timestamp then
						self.timestamp[nodeId] = timestamp
						self.version[nodeId] = version
						self.flags[nodeId] = flags
						mapCache:Move(nodeId, worldX, worldY, worldZ, globalX, globalY)
						-- update the old node
						self.serializedNodes[mapCache.nodeIndex[nodeId] ] = self:Serialize(
								worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags)
					end
					self:Debug("node was merged:", map, node)
					numMerged = numMerged + 1
					valid = false -- set this to false, so the node isn't added to the cache
				end
			end
			
			if valid then
				nodeId = mapCache:Add(pinTypeId, nodeIndex, worldX, worldY, worldZ, globalX, globalY)
				if nodeId then
					numAdded = numAdded + 1
					self.timestamp[nodeId] = timestamp
					self.version[nodeId] = version
					self.flags[nodeId] = flags
					if updated then
						self.serializedNodes[nodeIndex] = self:Serialize(
								worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags)
					end
				else -- could not add node to cache
					self:Debug("node could not be added to cache:", map, node)
					valid = false
				end
			end
			
			if not valid then
				numRemoved = numRemoved + 1
				self.serializedNodes[nodeIndex] = nil
			end
		end
	end
	
	self:Debug("added %d nodes, merged %d, removed %d (includes merged)", numAdded, numMerged, numRemoved)
	
	ZO_ClearTable(self.timestamp)
	ZO_ClearTable(self.version)
	ZO_ClearTable(self.flags)
	
	if numAdded > 0 then
		CallbackManager:FireCallbacks(Events.NEW_NODES_LOADED_TO_CACHE, mapCache, pinTypeId, numAdded)
	end
end


function Serialization:Deserialize(serializedData, pinTypeId)
	local worldX, worldY, worldZ, globalX, globalY, timestamp, version, flags
	
	local getNextChunk = gmatch(serializedData, "(-?%d*%.?%d*),?")
	
	worldX = tonumber(getNextChunk())
	worldY = tonumber(getNextChunk())
	worldZ = tonumber(getNextChunk())
	timestamp = tonumber(getNextChunk()) or 0
	version = tonumber(getNextChunk()) or 0
	globalX = tonumber(getNextChunk())
	globalY = tonumber(getNextChunk())
	flags = tonumber(getNextChunk()) or 0
	
	if worldX == 0 then worldX = nil end
	if worldY == 0 then worldY = nil end
	if worldZ == 0 then worldZ = nil end
	if globalX == 0 then globalX = nil end
	if globalY == 0 then globalY = nil end
	
	return true, worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags
end

local parts = {}
function Serialization:Serialize(worldX, worldY, worldZ, timestamp, version, globalX, globalY, flags)
	ZO_ClearTable(parts)
	insert(parts, format("%.1f", worldX or 0))
	insert(parts, format("%.1f", worldY or 0))
	insert(parts, format("%.1f", worldZ or 0))
	
	insert(parts, tostring(timestamp or 0))
	insert(parts, tostring(version or 0))
	
	insert(parts, format("%.7f", globalX or 0))
	insert(parts, format("%.7f", globalY or 0))
	
	insert(parts, tostring(flags or 0))
	
	return concat(parts, ",")
end
