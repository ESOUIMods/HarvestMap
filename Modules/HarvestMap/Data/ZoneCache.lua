
local ZoneCache = ZO_Object:Subclass()
Harvest.Data.ZoneCache = ZoneCache

function ZoneCache:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function ZoneCache:Initialize(zoneMeasurement)
	self.zoneMeasurement = zoneMeasurement
	self.zoneIndex = zoneMeasurement.zoneIndex
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
	local pinTypeId, globalX, globalY, otherNode
	for map, otherCache in pairs(self.mapCaches) do
		assert(cache ~= otherCache)
		local isCacheLarger = cache.mapMetaData.mapMeasurement.scaleX > otherCache.mapMetaData.mapMeasurement.scaleX
		
		for nodeId = 1, cache.lastNodeId do
			pinTypeId = cache.pinTypeId[nodeId]
			if pinTypeId then
				otherNode = otherCache:GetMergeableNode(pinTypeId, otherCache.mapMetaData:ConvertFrom(
									cache.mapMetaData, cache.localX[nodeId], cache.localY[nodeId]))
				if otherNode then
					-- nodes can be marged, delete node from ancestor map
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
	local globalX, globalY, mapMetaData, otherNode
	for map, otherCache in pairs(self.mapCaches) do
		if mapCache ~= otherCache then
			local isCacheLarger = mapCache.mapMetaData.mapMeasurement.scaleX > otherCache.mapMetaData.mapMeasurement.scaleX
			
			for _, nodeId in pairs(mapCache.nodesOfPinType[pinTypeId]) do
				otherNode = otherCache:GetMergeableNode(pinTypeId, otherCache.mapMetaData:ConvertFrom(
									mapCache.mapMetaData, mapCache.localX[nodeId], mapCache.localY[nodeId]))
				if otherNode then
					-- nodes can be marged, delete node from ancestor map
					if isCacheLarger then
						otherCache:Delete(otherNode)
					else
						mapCache:Delete(nodeId)
					end
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

function ZoneCache:DoesHandleMap(map)
	return self.mapCaches[map]
end

function ZoneCache:DoesHandleMapCache(mapCache)
	return self.mapCaches[mapCache.map]
end
