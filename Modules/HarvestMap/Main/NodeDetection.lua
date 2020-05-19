
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local Detection = {}
Harvest:RegisterModule("detection", Detection)

function Detection:Initialize()
	if not LibNodeDetection then
		self:Info("NodeDetection is not enabled")
		return
	end
	CallbackManager:RegisterCallback(Events.MAP_CHANGE, self.OnMapChanged)
	CallbackManager:RegisterForEvent(Events.MAP_ADDED_TO_ZONE, function(event, mapCache, zoneCache)
		self:Info("added map '%s' to zone %d. Relink spawned resources.", mapCache.map, zoneCache.zoneIndex)
		self.OnMapChanged()
	end)
	CallbackManager:RegisterForEvent(Events.NODE_DELETED, function(event, mapCache, nodeId)
		self.OnNodeDeleted(mapCache, nodeId)
	end)
	LibNodeDetection.callbackManager:RegisterCallback(
			LibNodeDetection.events.HARVEST_NODE_LOCATION_UPDATED,
			self.LinkControlWithNode)
	LibNodeDetection.callbackManager:RegisterCallback(
			LibNodeDetection.events.HARVEST_NODE_PINTYPE_UPDATED,
			self.VerifyPinType)
	LibNodeDetection.callbackManager:RegisterCallback(
			LibNodeDetection.events.HARVEST_NODE_HIDDEN,
			self.UnlinkControlWithNode)
	
end

function Detection.OnMapChanged()
	local event = nil
	for _, control in pairs(LibNodeDetection.detection.knownPositionCompassPins) do
		Detection.LinkControlWithNode(event, control)
	end
end

function Detection.VerifyPinType(event, control)
	if control.pinTypeId == LibNodeDetection.pinTypes.UNKNOWN then return end
	if control.mapCache and control.nodeId then
		local nodePinTypeId = control.mapCache.pinTypeId[control.nodeId]
		local controlPinTypeId = Harvest.DETECTION_TO_HARVEST_PINTYPE[control.pinTypeId]
		
		if nodePinTypeId ~= controlPinTypeId and nodePinTypeId ~= Harvest.UNKNOWN then
			Detection.LinkControlWithNode(event, control)
		end
	end
end

function Detection.LinkControlWithNode(event, control)
	local zoneCache = Harvest.Data:GetCurrentZoneCache()
	if not zoneCache then return end
	-- find a mapCache/node that represents the compass pin
	local nodeId, _mapCache
	for map, mapCache in pairs(zoneCache.mapCaches) do
		local worldX, worldY = control.worldX, control.worldY
		-- find a node at compass pin location
		local distance, bestNodeId
		local bestDistance = math.huge
		if control.pinTypeId ~= LibNodeDetection.pinTypes.UNKNOWN then
			local pinTypeId = Harvest.DETECTION_TO_HARVEST_PINTYPE[control.pinTypeId]
			nodeId, distance = mapCache:GetMergeableNode(pinTypeId, worldX, worldY)
		else
			for pinTypeId in pairs(Harvest.HARVEST_NODES) do
				nodeId, distance = mapCache:GetMergeableNode(pinTypeId, worldX, worldY)
				if nodeId then
					if distance < bestDistance then
						bestDistance = distance
						bestNodeId = nodeId
					end
				end
			end
			nodeId = bestNodeId
			distance = bestDistance
		end
		if nodeId then
			_mapCache = mapCache
			break
		end
	end
	local mapCache = _mapCache
	-- if new node is different from before,
	-- unlink previous pair and link the new one
	if control.mapCache ~= mapCache or nodeId ~= control.nodeId then
		-- unlink
		if control.mapCache and control.nodeId then
			control.mapCache.hasCompassPin[control.nodeId] = nil
			if control.mapCache.pinTypeId[control.nodeId] == Harvest.UNKNOWN then
				CallbackManager:FireCallbacks(Events.NODE_DELETED, control.mapCache, control.nodeId)
				control.mapCache:Delete(control.nodeId)
			end
		end
		-- link
		control.mapCache = mapCache
		control.nodeId = nodeId
		if nodeId then
			mapCache.hasCompassPin[nodeId] = true
			-- fire callback so the node is updated on the map etc
			CallbackManager:FireCallbacks(Events.NODE_COMPASS_LINK_CHANGED, mapCache, nodeId)
			return
		end
	end
	
	if mapCache == nil and nodeId == nil then
		mapCache = Harvest.mapPins.mapCache
		if not mapCache then
			Detection:Warn("no mapCache for mapPins? Is HeatMap mode active?")
			return
		end
		if not mapCache:DoesHandlePinType(Harvest.UNKNOWN) then mapCache:InitializePinType(Harvest.UNKNOWN) end
		local nodeId = mapCache:Add(Harvest.UNKNOWN, nil, control.worldX, control.worldY, nil, control.globalX, control.globalY)
		if nodeId then
			control.nodeId = nodeId
			control.mapCache = mapCache
			mapCache.hasCompassPin[nodeId] = true
			CallbackManager:FireCallbacks(Events.NODE_ADDED, mapCache, nodeId)
		end
	end
end

function Detection.UnlinkControlWithNode(event, control)
	if control.mapCache and control.nodeId then
		control.mapCache.hasCompassPin[control.nodeId] = nil
		if control.mapCache.pinTypeId[control.nodeId] == Harvest.UNKNOWN then
			CallbackManager:FireCallbacks(Events.NODE_DELETED, control.mapCache, control.nodeId)
			control.mapCache:Delete(control.nodeId)
		else
			CallbackManager:FireCallbacks(Events.NODE_COMPASS_LINK_CHANGED, control.mapCache, control.nodeId)
		end
		control.mapCache = nil
		control.nodeId = nil
	end
end

function Detection.OnNodeDeleted(mapCache, nodeId)
	local control = mapCache.hasCompassPin[nodeId]
	if not control then return end
	Detection:Warn("A node was deleted while it had a compass pin assigned!")
	
	for _, control in pairs(LibNodeDetection.detection.knownPositionCompassPins) do
		if control.mapCache == mapCache and control.nodeId == nodeId then
			control.mapCache = nil
			control.nodeId = nil
			return
		end
	end
	Detection:Error("A deleted node's hasCompassPin property was true, but no corresponding compass pin could be found!")
end

-- hide center over text for harvest nodes
local orig = ZO_CompassContainer.IsCenterOveredPinSuppressed
function ZO_CompassContainer:IsCenterOveredPinSuppressed(pinIndex, ...)
	if self:GetCenterOveredPinType(pinIndex) == MAP_PIN_TYPE_HARVEST_NODE then return true end
	return orig(self, pinIndex, ...)
end
