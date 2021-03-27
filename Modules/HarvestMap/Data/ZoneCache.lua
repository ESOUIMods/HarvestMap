
local ZoneCache = ZO_Object:Subclass()
Harvest.Data.ZoneCache = ZoneCache

function ZoneCache:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function ZoneCache:Initialize(zoneIndex)
	self.zoneIndex = zoneIndex
	self.zoneId = GetZoneId(zoneIndex)
	self.mapCaches = {}
end

function ZoneCache:AddCache(cache)
	local prevCache = self.mapCaches[cache.map]
	if prevCache == cache then
		return
	end
	if prevCache then
		prevCache.accessed = prevCache.accessed - 1
		self.mapCaches[cache.map] = nil
	end
	
	-- check if some nodes exist on both caches
	local pinTypeId, otherNode
	for map, otherCache in pairs(self.mapCaches) do
		assert(cache ~= otherCache)
		local isCacheLarger = cache.lastNodeId > otherCache.lastNodeId
		
		for nodeId = 1, cache.lastNodeId do
			pinTypeId = cache.pinTypeId[nodeId]
			if pinTypeId then
				otherNode = otherCache:GetMergeableNode(pinTypeId, cache.worldX[nodeId], cache.worldY[nodeId], cache.worldZ[nodeId])
				if otherNode then
					-- nodes can be merged, delete node from ancestor map
					if isCacheLarger then
						otherCache:Delete(otherNode)
					else
						cache:Delete(nodeId)
					end
				end
			end
		end
	end
	-- TODO fire some batch deletion event when some nodes were deleted
	-- add cache
	self.mapCaches[cache.map] = cache
	cache.accessed = cache.accessed + 1
end

function ZoneCache:MergeNodesOfMapCacheAndPinType(mapCache, pinTypeId)
	assert(self.mapCaches[mapCache.map] == mapCache)
	-- todo we now have parent information to exploit!
	local otherNode
	for map, otherCache in pairs(self.mapCaches) do
		if mapCache ~= otherCache then
			local isCacheLarger = mapCache.lastNodeId > otherCache.lastNodeId
			for _, nodeId in pairs(mapCache.nodesOfPinType[pinTypeId]) do
				otherNode = otherCache:GetMergeableNode(pinTypeId, mapCache.worldX[nodeId], mapCache.worldY[nodeId])
				if otherNode then
					-- nodes can be merged, delete node from ancestor map
					--if isCacheLarger then
						otherCache:Delete(otherNode)
					--else -- this changes the nodesOfPinType array which breaks the iteration
					--	mapCache:Delete(nodeId)
					--end
				end
			end
		end
	end
end

function ZoneCache:HasMapCache()
	return (next(self.mapCaches) ~= nil)
end

function ZoneCache:ForNearbyNodes(...)
	for _, mapCache in pairs(self.mapCaches) do
		mapCache:ForNearbyNodes(...)
	end
end

function ZoneCache:ForNodesInRange(...)
	for _, mapCache in pairs(self.mapCaches) do
		mapCache:ForNodesInRange(...)
	end
end

function ZoneCache:Dispose()
	for map, mapCache in pairs(self.mapCaches) do
		mapCache.accessed = mapCache.accessed - 1
	end
	self.mapCaches = nil
end

function ZoneCache:DoesHandleMapCache(mapCache)
	return (self.mapCaches[mapCache.map] == mapCache)
end
