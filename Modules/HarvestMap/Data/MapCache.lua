
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
Harvest.MapCache = MapCache

MapCache.DivisionWidthInMeters = 100
MapCache.numDivisions = 40
MapCache.TotalNumDivisions = MapCache.numDivisions * MapCache.numDivisions
MapCache.MergeDistanceInMeters = 7

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
	
	self.globalX = {}
	self.globalY = {}

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
	
	self.zoneMeasurement = self.mapMetaData.zoneMeasurement
	self.mergeDistanceSquared = self.MergeDistanceInMeters * self.MergeDistanceInMeters
	
	self.divisions = {}
	for _, pinTypeId in pairs(Harvest.PINTYPES) do
		self.divisions[pinTypeId] = {}
	end
	
	for nodeId, pinTypeId in pairs(self.pinTypeId) do
		self:InsertNodeIntoDivision(nodeId)
	end
	
end

function MapCache:Dispose()
	ZO_ClearTable(self.pinTypeId)
	ZO_ClearTable(self.nodeIndex)
	ZO_ClearTable(self.globalX)
	ZO_ClearTable(self.globalY)
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
	self.globalX = nil
	self.globalY = nil
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
	local worldX, worldY = self.worldX[nodeId], self.worldY[nodeId]
		
	local index = (zo_floor(worldX / self.DivisionWidthInMeters) + zo_floor(worldY / self.DivisionWidthInMeters) * self.numDivisions) % self.TotalNumDivisions
	local division = self.divisions[pinTypeId][index] or {}
	self.divisions[pinTypeId][index] = division
	division[#division+1] = nodeId
end

function MapCache:RemoveNodeFromDivision(nodeId)
	local pinTypeId = self.pinTypeId[nodeId]
	local worldX, worldY = self.worldX[nodeId], self.worldY[nodeId]
		
	local index = (zo_floor(worldX / self.DivisionWidthInMeters) + zo_floor(worldY / self.DivisionWidthInMeters) * self.numDivisions) % self.TotalNumDivisions
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

function MapCache:Add(pinTypeId, nodeIndex, worldX, worldY, worldZ, globalX, globalY)
	
	self.lastNodeId = self.lastNodeId + 1
	local nodeId = self.lastNodeId

	local pinTypeSize = self.nodesOfPinTypeSize[pinTypeId] + 1
	self.nodesOfPinTypeSize[pinTypeId] = pinTypeSize
	self.nodesOfPinType[pinTypeId][pinTypeSize] = nodeId
	
	self.pinTypeId[nodeId] = pinTypeId
	self.nodeIndex[nodeId] = nodeIndex
	self.globalX[nodeId] = globalX
	self.globalY[nodeId] = globalY
	self.worldX[nodeId] = worldX
	self.worldY[nodeId] = worldY
	self.worldZ[nodeId] = worldZ
	
	self:InsertNodeIntoDivision(nodeId)

	return nodeId
end

function MapCache:Delete(nodeId)
	assert(self.pinTypeId[nodeId])
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
	self.globalX[nodeId] = nil
	self.globalY[nodeId] = nil
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
function MapCache:Move(nodeId, worldX, worldY, worldZ, globalX, globalY)
	local oldWorldX, oldWorldY = self.worldX[nodeId], self.worldY[nodeId]
	local oldDivisionIndex = zo_floor(oldWorldX / self.DivisionWidthInMeters)
	oldDivisionIndex = oldDivisionIndex + zo_floor(oldWorldY / self.DivisionWidthInMeters) * self.numDivisions
	oldDivisionIndex = oldDivisionIndex % self.TotalNumDivisions
	local newDivisionIndex = zo_floor(worldX / self.DivisionWidthInMeters)
	newDivisionIndex = newDivisionIndex + zo_floor(worldY / self.DivisionWidthInMeters) * self.numDivisions
	newDivisionIndex = newDivisionIndex % self.TotalNumDivisions
	local didDvisionChange = (oldDivisionIndex ~= newDivisionIndex)
	
	if didDvisionChange then
		self:RemoveNodeFromDivision(nodeId)
	end
		
	self.globalX[nodeId] = globalX
	self.globalY[nodeId] = globalY
	self.worldX[nodeId] = worldX
	self.worldY[nodeId] = worldY
	self.worldZ[nodeId] = worldZ
		
	if didDvisionChange then
		self:InsertNodeIntoDivision(nodeId)
	end
	
end

function MapCache:GetMergeableNode(pinTypeId, worldX, worldY, worldZ)
	self.time = GetFrameTimeSeconds()
	
	local useWorldZ = 1
	if not worldZ then
		worldZ = 0
		useWorldZ = 0
	end
	
	local divisionX = zo_floor(worldX / self.DivisionWidthInMeters)
	local divisionY = zo_floor(worldY / self.DivisionWidthInMeters)
	local divisions = self.divisions[pinTypeId]
	if not divisions then return end
	
	local division, dx, dy, dz, distance
	local startJ = divisionY - 1
	local endJ = divisionY + 1
	
	local bestDistance = math.huge
	local bestNodeId = nil
	
	for i = divisionX - 1, divisionX + 1 do
		for j = startJ, endJ do
			division = divisions[(i + j * self.numDivisions) % self.TotalNumDivisions]
			if division then
				for _, nodeId in pairs(division) do
					dx = self.worldX[nodeId] - worldX
					dy = self.worldY[nodeId] - worldY
					dz = self.worldZ[nodeId] - worldZ
					distance = dx * dx + dy * dy + dz * dz * useWorldZ
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
	if bestDistance < self.mergeDistanceSquared then
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
