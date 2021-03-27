
local Path = ZO_Object:Subclass()
Harvest.path = Path

function Path:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function Path:Initialize(mapCache)
	self.mapCache = mapCache
	self.mapCache.accessed = self.mapCache.accessed + 1
	
	self.length = 0
	self.numNodes = 0
	self.nodeIndices = {}
end

function Path:Dispose()
	self.mapCache.accessed = self.mapCache.accessed - 1
	self.mapCache = nil
end

function Path:GetLocalCoords(index)
	return self.mapCache:GetLocal(self.nodeIndices[index])
end

function Path:GetWorldCoords(index)
	return self.mapCache.worldX[self.nodeIndices[index]], self.mapCache.worldY[self.nodeIndices[index]], self.mapCache.worldZ[self.nodeIndices[index]]
end

function Path:Revert()
	local newPath = {}
	for i = 1, self.numNodes do
		newPath[i] = self.nodeIndices[self.numNodes - i + 1]
	end
	self.nodeIndices = newPath
end

function Path:InsertAfter(nodeId, newNodeId)
	local index = self:GetIndex(nodeId)
	if not index then return end
	
	self.length = self.length - self:GetDistanceToPrevious(index+1)
	
	for i = 0, self.numNodes - index - 1 do
		self.nodeIndices[self.numNodes - i + 1] = self.nodeIndices[self.numNodes - i]
	end
	self.numNodes =  self.numNodes + 1
	self.nodeIndices[index+1] = newNodeId
	
	self.length = self.length + self:GetDistanceToPrevious(index+1) + self:GetDistanceToPrevious(index+2)
end

function Path:Insert(newNodeIds, endNodeId)
	local startIndex = self:GetIndex(newNodeIds[1])
	local endIndex = self:GetIndex(endNodeId)
	
	local newNodeIndices = {}
	local newNumNodes = 0
	
	if startIndex < endIndex then
		for i = 1, startIndex do
			newNumNodes = newNumNodes + 1
			newNodeIndices[newNumNodes] = self.nodeIndices[i]
		end
		
		for i = 2, (#newNodeIds) do
			newNumNodes = newNumNodes + 1
			newNodeIndices[newNumNodes] = newNodeIds[i]
		end
		
		for i = endIndex, self.numNodes do
			newNumNodes = newNumNodes + 1
			newNodeIndices[newNumNodes] = self.nodeIndices[i]
		end
	else
		for i = 1, (#newNodeIds) do
			newNumNodes = newNumNodes + 1
			newNodeIndices[newNumNodes] = newNodeIds[i]
		end
		
		for i = endIndex, startIndex-1 do
			newNumNodes = newNumNodes + 1
			newNodeIndices[newNumNodes] = self.nodeIndices[i]
		end
	end
	
	self.nodeIndices = newNodeIndices
	self.numNodes = newNumNodes
	
	self:CalculateStats()
end

function Path:RemoveNodesOfPinType(pinTypeId)
	if self.numNodes < 3 then self:Clear() end
	local nodeIndex = self.numNodes
	local removed = false
	for index = 1, self.numNodes do
		if not self.nodeIndices[nodeIndex] then break end
		if self.mapCache.pinTypeId[self.nodeIndices[nodeIndex]] == pinTypeId then
			self:Remove(nodeIndex)
			removed = true
			if self.numNodes < 3 then self:Clear() end
		end
		nodeIndex = nodeIndex - 1
	end
	return removed
end

function Path:Clear()
	self.length = 0
	self.numNodes = 0
	self.nodeIndices = {}
end

function Path:GetIndex(searchedNodeIndex)
	for index, nodeIndex in pairs(self.nodeIndices) do
		if nodeIndex == searchedNodeIndex then
			return index
		end
	end
end

function Path:RemoveNode(removeNodeIndex)
	local removeIndex = self:GetIndex(removeNodeIndex)
	if removeIndex then
		return self:Remove(removeIndex)
	end
end

function Path:Remove(removeIndex)
	self.length = self.length - self:GetDistanceToPrevious(removeIndex)
	self.length = self.length - self:GetDistanceToPrevious(removeIndex+1)
	self.numNodes = self.numNodes - 1
	for index = removeIndex, self.numNodes do
		self.nodeIndices[index] = self.nodeIndices[index + 1]
	end
	self.length = self.length + self:GetDistanceToPrevious(removeIndex)
	return true
end

function Path:GenerateFromPoints(points)
	local nodeIndex
	for _, point in ipairs(points) do
		local pinTypeId = point[6]
		Harvest.Data:CheckPinTypeInCache(pinTypeId, self.mapCache)
		nodeIndex = self.mapCache:GetMergeableNode(pinTypeId, point[1], point[2])
		if nodeIndex then
			self.numNodes = self.numNodes + 1
			self.nodeIndices[self.numNodes] = nodeIndex
			self.length = self.length + self:GetDistanceToPrevious(self.numNodes)
		end
	end
	self.length = self.length + self:GetDistanceToPrevious(1)
end

function Path:GenerateFromNodeIds(nodeIds, startIndex, endIndex)
	for i = startIndex, endIndex do
		self.numNodes = self.numNodes + 1
		self.nodeIndices[self.numNodes] = nodeIds[i]
		self.length = self.length + self:GetDistanceToPrevious(self.numNodes)
	end
	self.length = self.length + self:GetDistanceToPrevious(1)
end

function Path:GenerateFromCoordinates(pinTypes, worldXList, worldYList)
	local mapMetaData = self.mapCache.mapMetaData
	local nodeId
	for index, pinTypeId in ipairs(pinTypes) do
		Harvest.Data:CheckPinTypeInCache(pinTypeId, self.mapCache)
		nodeId = self.mapCache:GetMergeableNode(pinTypeId, worldXList[index], worldYList[index])
		if nodeId then
			self.numNodes = self.numNodes + 1
			self.nodeIndices[self.numNodes] = nodeId
		end
	end
	if self.numNodes > 2 then
		self:CalculateStats()
	end
end

function Path:CopyValuesFrom(path)
	for key, val in pairs(path) do
		if key ~= "mapCache" then
			if type(val) == "table" then
				self[key] = {}
				for i, n in ipairs(val) do
					self[key][i] = n
				end
			else
				self[key] = val
			end
		end
	end
	self.mapCache.accessed = self.mapCache.accessed - 1
	self.mapCache = path.mapCache
	self.mapCache.accessed = self.mapCache.accessed + 1
end

local sqrt = math.sqrt
function Path:GetDistanceToPrevious(index)
	index = ((index - 1) % self.numNodes) + 1
	local previousIndex = index - 1
	if previousIndex == 0 then
		previousIndex = self.numNodes
	end
	
	index = self.nodeIndices[index]
	previousIndex = self.nodeIndices[previousIndex]
	
	local dx = self.mapCache.worldX[index] - self.mapCache.worldX[previousIndex]
	local dy = self.mapCache.worldY[index] - self.mapCache.worldY[previousIndex]
	
	return (dx * dx + dy * dy)^0.5
end

function Path:CalculateStats()
	self.length = 0
	for i = 1, self.numNodes do
		self.length = self.length + self:GetDistanceToPrevious(i)
	end
end