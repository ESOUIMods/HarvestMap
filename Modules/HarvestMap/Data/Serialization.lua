
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
	self.nodeIndex = {}
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
	
	self.mapCache = mapCache
	self.pinTypeId = pinTypeId
	local numAddedNodes = 0
	
	local downloadedVars = submodule.downloadedVars
	if downloadedVars[zoneId] and downloadedVars[zoneId][map] and downloadedVars[zoneId][map][pinTypeId] then
		self.downloadedData = downloadedVars[zoneId][map][pinTypeId]
		numAddedNodes = numAddedNodes + self:LoadDownloadedData()
	end
	
	-- todo: memory wise it would be more efficient to first load the stored data
	local savedVars = submodule.savedVars
	if savedVars[zoneId] and savedVars[zoneId][map] and savedVars[zoneId][map][pinTypeId] then 
		self.serializedNodes = savedVars[zoneId][map][pinTypeId]
		numAddedNodes = numAddedNodes + self:LoadDiscoveredData()
		ZO_ClearTable(self.timestamp)
		ZO_ClearTable(self.version)
		ZO_ClearTable(self.nodeIndex)
	end
	
	if numAddedNodes > 0 then
		CallbackManager:FireCallbacks(Events.NEW_NODES_LOADED_TO_CACHE, mapCache, pinTypeId, numAddedNodes)
	end
end


function Serialization:LoadDownloadedData()
	
	local minDiscoveryDay = -math.huge
	if Harvest.GetMaxTimeDifference() > 0 then
		local currentDay = GetTimeStamp() / (60 * 60 * 24)
		minDiscoveryDay = currentDay - Harvest.GetMaxTimeDifference() / 24
	end
	
	local mapCache = self.mapCache
	local pinTypeId = self.pinTypeId
	
	local x1, x2, y1, y2, d1, d2
	local worldX, worldY, worldZ, discoveryDay
	
	local numAddedNodes = 0
	local downloadedData = self.downloadedData
	assert(#downloadedData % 8 == 0)
	for dataIndex = 1, #downloadedData, 8 do
		x1, x2, y1, y2, z1, z2, d1, d2 = downloadedData:byte(dataIndex, dataIndex+7)
		
		discoveryDay = d1 * 256 + d2
		if discoveryDay >= minDiscoveryDay then
			worldX = (x1 * 256 + x2) * 0.2
			worldY = (y1 * 256 + y2) * 0.2
			worldZ = (z1 * 256 + z2) * 0.2
			mapCache:Add(pinTypeId, worldX, worldY, worldZ)
			numAddedNodes = numAddedNodes + 1
		end
	end
	
	self:Debug("added %d nodes", numAddedNodes)
	
	return numAddedNodes
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

function Serialization:LoadDiscoveredData()
	
	local currentTimestamp = GetTimeStamp()
	local maxTimeDifference = Harvest.GetMaxTimeDifference() * 3600
	local mapCache = self.mapCache
	local mapMetaData = mapCache.mapMetaData
	local zoneId = mapMetaData.zoneId
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
	
	local valid, updated, skipLoad, nodeId
	local worldX, worldY, worldZ, names, timestamp, version
	-- deserialize the nodes
	for nodeIndex, node in pairs(self.serializedNodes) do
		worldX, worldY, worldZ, timestamp, version = self:Deserialize( node, pinTypeId )
		valid = true
		updated = false
		skipLoad = false
		-- remove nodes that are too old (either number of days or patch)
		if maxTimeDifference > 0 and currentTimestamp - timestamp > maxTimeDifference then
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
		
		-- remove close nodes (ie duplicates on cities)
		if valid then
			local nodeId = mapCache:GetMergeableNode(pinTypeId, worldX, worldY, worldZ)
			if nodeId then
				if (self.timestamp[nodeId] or 0) < timestamp then
					self.timestamp[nodeId] = timestamp
					self.version[nodeId] = version
					mapCache:Move(nodeId, worldX, worldY, worldZ)
					-- update the old node
					local otherNodeIndex = self.nodeIndex[nodeId]
					if otherNodeIndex then
						self.serializedNodes[otherNodeIndex] = self:Serialize(
								worldX, worldY, worldZ, timestamp, version)
						valid = false -- set this to false, so current node is deleted from savedvars
					end
				end
				self:Debug("node was merged:", map, node)
				numMerged = numMerged + 1
				skipLoad = true -- set this to true, so the node isn't added to the cache
			end
		end
		
		if valid and not skipLoad then
			nodeId = mapCache:Add(pinTypeId, worldX, worldY, worldZ)
			numAdded = numAdded + 1
			self.timestamp[nodeId] = timestamp
			self.version[nodeId] = version
			self.nodeIndex[nodeId] = nodeIndex
			if updated then
				self.serializedNodes[nodeIndex] = self:Serialize(
						worldX, worldY, worldZ, timestamp, version)
			end
		end
		
		if not valid then
			numRemoved = numRemoved + 1
			self.serializedNodes[nodeIndex] = nil
		end
	end
	
	self:Debug("added %d nodes, merged %d, removed %d (includes merged)", numAdded, numMerged, numRemoved)
	
	ZO_ClearTable(self.timestamp)
	ZO_ClearTable(self.version)
	ZO_ClearTable(self.nodeIndex)
	
	return numAdded
end


function Serialization:Deserialize(serializedData, pinTypeId)
	local worldX, worldY, worldZ, globalX, globalY, timestamp, version
	
	local getNextChunk = gmatch(serializedData, "(-?%d*%.?%d*),?")
	
	worldX = tonumber(getNextChunk())
	worldY = tonumber(getNextChunk())
	worldZ = tonumber(getNextChunk())
	timestamp = tonumber(getNextChunk()) or 0
	version = tonumber(getNextChunk()) or 0
	
	return worldX, worldY, worldZ, timestamp, version
end

local parts = {}
function Serialization:Serialize(worldX, worldY, worldZ, timestamp, version)
	ZO_ClearTable(parts)
	insert(parts, format("%.1f", worldX or 0))
	insert(parts, format("%.1f", worldY or 0))
	insert(parts, format("%.1f", worldZ or 0))
	
	insert(parts, tostring(timestamp or 0))
	insert(parts, tostring(version or 0))
	-- backwards compatibility
	insert(parts, "0.0") -- former global x
	insert(parts, "0.0") -- former global y
	insert(parts, "0") -- former flags
	
	return concat(parts, ",")
end
