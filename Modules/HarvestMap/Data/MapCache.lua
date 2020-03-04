
local zo_min = _G["zo_min"]
local zo_max = _G["zo_max"]
local zo_ceil = _G["zo_ceil"]
local zo_floor = _G["zo_floor"]
local pairs = _G["pairs"]
local ipairs = _G["ipairs"]

--[[
Each MapCache stores deserialized nodes for the given map.
--]]
local MapCache = ZO_Object:Subclass()
Harvest = Harvest or {}
Harvest.MapCache = MapCache

MapCache.DivisionWidthInMeters = 100
MapCache.MergeDistanceInMeters = 10

function MapCache:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function MapCache:Initialize(mapMetaData)
	self.time = GetFrameTimeSeconds()
	self.accessed = 0
	
	self.map = mapMetaData.map
	self.lastNodeId = 0
	self.mapMetaData = mapMetaData
	
	self.pinTypeId = {}
	self.nodeIndex = {} -- index of the node in the saved variables table data[map][pinTypeId][nodeIndex]
	
	self.localX = {}
	self.localY = {}

	self.worldX = {}
	self.worldY = {}
	self.worldZ = {}
	
	self.hiddenTime = {}
	self.hasCompassPin = {}
	
	self.nodesOfPinType = {}
	self.nodesOfPinTypeSize = {}
	
	self:RefreshZoneMeasurementDependendFields()
	
end

function MapCache:RefreshZoneMeasurementDependendFields()
	
	self.zoneMeasurement = self.mapMetaData.defaultZoneMeasurement
	local mapWidthInMeters = self.mapMetaData.mapMeasurement.scaleX * self.zoneMeasurement.globalToWorldFactor
	
	local mergeDistanceInLocal = self.MergeDistanceInMeters / mapWidthInMeters
	self.mergeDistanceInLocalSquared = mergeDistanceInLocal * mergeDistanceInLocal
	self.localToDivisionFactor = mapWidthInMeters / self.DivisionWidthInMeters
	
	self.numDivisions = zo_ceil(self.localToDivisionFactor)
	self.divisions = {}
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		self.divisions[pinTypeId] = {}
	end
	
	for nodeId, pinTypeId in pairs(self.pinTypeId) do
		self:InsertNodeIntoDivision(nodeId)
	end
	
end

function MapCache:Dispose()
	ZO_ClearTable(self.pinTypeId)
	ZO_ClearTable(self.nodeIndex)
	ZO_ClearTable(self.localX)
	ZO_ClearTable(self.localY)
	ZO_ClearTable(self.worldX)
	ZO_ClearTable(self.worldY)
	ZO_ClearTable(self.worldZ)
	ZO_ClearTable(self.hiddenTime)
	ZO_ClearTable(self.hasCompassPin)
	ZO_ClearTable(self.nodesOfPinTypeSize)
	for pinTypeId, list in pairs(self.nodesOfPinType) do
		ZO_ClearTable(list)
	end
	
	self.pinTypeId = nil
	self.nodeIndex = nil
	self.localX = nil
	self.localY = nil
	self.worldX = nil
	self.worldY = nil
	self.worldZ = nil
	self.hiddenTime = nil
	self.hasCompassPin = nil
	self.nodesOfPinType = nil
	self.nodesOfPinTypeSize = nil
	
	for pinTypeId, divisions in pairs(self.divisions) do
		ZO_ClearTable(divisions)
		self.divisions[pinTypeId] = nil
	end
	self.divisions = nil
end

function MapCache:InsertNodeIntoDivision(nodeId)
	local pinTypeId = self.pinTypeId[nodeId]
	local localX, localY = self.localX[nodeId], self.localY[nodeId]
		
	local index = zo_floor(localX * self.localToDivisionFactor) + zo_floor(localY * self.localToDivisionFactor) * self.numDivisions
	local division = self.divisions[pinTypeId][index] or {}
	self.divisions[pinTypeId][index] = division
	division[#division+1] = nodeId
end

function MapCache:RemoveNodeFromDivision(nodeId)
	local pinTypeId = self.pinTypeId[nodeId]
	local localX, localY = self.localX[nodeId], self.localY[nodeId]
		
	local index = zo_floor(localX * self.localToDivisionFactor) + zo_floor(localY * self.localToDivisionFactor) * self.numDivisions
	local division = self.divisions[pinTypeId][index]
	
	local wasNodeRemoved = false
	for i, nId in pairs(division) do
		if nId == nodeId then
			division[i] = nil
			wasNodeRemoved = true
			break
		end
	end
	assert(wasNodeRemoved)
end

function MapCache:InitializePinType(pinTypeId)
	self.nodesOfPinTypeSize[pinTypeId] = self.nodesOfPinTypeSize[pinTypeId] or 0
	self.nodesOfPinType[pinTypeId] = self.nodesOfPinType[pinTypeId] or {}
end

function MapCache:DoesHandlePinType(pinTypeId)
	return (self.nodesOfPinTypeSize[pinTypeId] ~= nil)
end

-----------------------------------------------------------
-- Methods to add, delete and update data in the cache
-----------------------------------------------------------

function MapCache:Add(pinTypeId, nodeIndex, worldX, worldY, worldZ, localX, localY)
	if localX <= 0 or localX >= 1 or localY <= 0 or localY >= 1 then
		return
	end
	
	self.lastNodeId = self.lastNodeId + 1
	local nodeId = self.lastNodeId

	local pinTypeSize = self.nodesOfPinTypeSize[pinTypeId] + 1
	self.nodesOfPinTypeSize[pinTypeId] = pinTypeSize
	self.nodesOfPinType[pinTypeId][pinTypeSize] = nodeId
	
	self.pinTypeId[nodeId] = pinTypeId
	self.nodeIndex[nodeId] = nodeIndex
	self.localX[nodeId] = localX
	self.localY[nodeId] = localY
	self.worldX[nodeId] = worldX
	self.worldY[nodeId] = worldY
	self.worldZ[nodeId] = worldZ
	
	self:InsertNodeIntoDivision(nodeId)

	return nodeId
end

function MapCache:Delete(nodeId)
	
	local pinTypeId = self.pinTypeId[nodeId]
	if not pinTypeId then
		return false
	end
	local nodesOfPinType = self.nodesOfPinType[pinTypeId]
	local nodesOfPinTypeSize = self.nodesOfPinTypeSize[pinTypeId]
	for i = 1, nodesOfPinTypeSize do
		if nodesOfPinType[i] == nodeId then
			-- move last node to deleted position
			-- this way we don't get any "holes"
			nodesOfPinType[i] = nodesOfPinType[nodesOfPinTypeSize]
			nodesOfPinType[nodesOfPinTypeSize] = nil
			self.nodesOfPinTypeSize[pinTypeId] = nodesOfPinTypeSize - 1
			break
		end
	end

	self:RemoveNodeFromDivision(nodeId)

	self.pinTypeId[nodeId] = nil
	self.nodeIndex[nodeId] = nil
	self.localX[nodeId] = nil
	self.localY[nodeId] = nil
	self.worldX[nodeId] = nil
	self.worldY[nodeId] = nil
	self.worldZ[nodeId] = nil
	self.hiddenTime[nodeId] = nil
	self.hasCompassPin[nodeId] = nil
	
	return true
end

-- merges the node corresponding to the nodeId with the given data
-- returns the nodes data after merging
-- the returned data may be the original data, if the given input data is too old or invalid
function MapCache:Move(nodeId, worldX, worldY, worldZ, localX, localY)
	local oldLocalX, oldLocalY = self.localX[nodeId], self.localY[nodeId]
	local oldDivisionIndex = zo_floor(oldLocalX * self.localToDivisionFactor)
	oldDivisionIndex = oldDivisionIndex + zo_floor(oldLocalY * self.localToDivisionFactor) * self.numDivisions
	local newDivisionIndex = zo_floor(localX * self.localToDivisionFactor)
	newDivisionIndex = newDivisionIndex + zo_floor(localY * self.localToDivisionFactor) * self.numDivisions
	local didDvisionChange = (oldDivisionIndex ~= newDivisionIndex)
	
	if didDvisionChange then
		self:RemoveNodeFromDivision(nodeId)
	end
		
	self.localX[nodeId] = localX
	self.localY[nodeId] = localY
	self.worldX[nodeId] = worldX
	self.worldY[nodeId] = worldY
	self.worldZ[nodeId] = worldZ or self.worldZ[nodeId]
		
	if didDvisionChange then
		self:InsertNodeIntoDivision(nodeId)
	end
	
end

function MapCache:GetMergeableNode(pinTypeId, localX, localY)
	self.time = GetFrameTimeSeconds()
	
	local divisionX = zo_floor(localX * self.localToDivisionFactor)
	local divisionY = zo_floor(localY * self.localToDivisionFactor)
	local divisions = self.divisions[pinTypeId]
	if not divisions then return end
	
	local division, dx, dy, distance
	local startJ = zo_max(0, divisionY - 1)
	local endJ = zo_min(divisionY + 1, self.numDivisions-1)
	
	local bestDistance = math.huge
	local bestNodeId = nil
	
	for i = zo_max(0, divisionX - 1), zo_min(divisionX + 1, self.numDivisions-1) do
		for j = startJ, endJ do
			division = divisions[i + j * self.numDivisions]
			if division then
				for _, nodeId in pairs(division) do
					dx = self.localX[nodeId] - localX
					dy = self.localY[nodeId] - localY
					distance = dx * dx + dy * dy
					--d(distance)
					--if distance < self.mergeDistanceInLocalSquared then
						if distance < bestDistance then
							bestNodeId = nodeId
							bestDistance = distance
						end
						--return nodeId
					--end
				end
			end
		end
	end
	
	--d(bestDistance)
	if bestDistance < self.mergeDistanceInLocalSquared then
		return bestNodeId, bestDistance
	end
	
	return nil--bestNodeId
end

-- hide pin and returns true, if the the pin was hidden
-- false if no change was perfomed (i.e. it was already hidden)
function MapCache:HideNode(nodeId)
	local wasHidden = (self.hiddenTime[nodeId] ~= nil)
	self.hiddenTime[nodeId] = GetFrameTimeMilliseconds()
	return (not wasHidden)
end

-- remove hidden state and returns true, if the state was changed
function MapCache:UnhideNode(nodeId)
	local wasHidden = (self.hiddenTime[nodeId] ~= nil)
	self.hiddenTime[nodeId] = nil
	return wasHidden
end

function MapCache:IsHidden(nodeId)
	return self.hiddenTime[nodeId]
end
