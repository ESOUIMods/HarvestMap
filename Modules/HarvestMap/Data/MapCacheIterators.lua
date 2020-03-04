
local zo_min = _G["zo_min"]
local zo_max = _G["zo_max"]
local zo_ceil = _G["zo_ceil"]
local zo_floor = _G["zo_floor"]
local pairs = _G["pairs"]
local ipairs = _G["ipairs"]

local MapCache = Harvest.MapCache

function MapCache:ForNearbyNodes(globalX, globalY, callback, ...)
	if not globalX then return end -- global coords can become nil on some maps (ie aurbis)
	if self.mapMetaData.isBlacklisted then return end
	self.time = GetFrameTimeSeconds()
	
	local globalMinDistance = self.zoneMeasurement:MetersToGlobalDistance(Harvest.GetVisitedRangeInMeters())
	local localMinDistanceSquared = globalMinDistance / self.mapMetaData.mapMeasurement.scaleX
	localMinDistanceSquared = localMinDistanceSquared * localMinDistanceSquared
	
	local localX, localY = self.mapMetaData:GlobalToLocal(globalX, globalY)
	local divisionX = zo_floor(localX * self.localToDivisionFactor)
	local divisionY = zo_floor(localY * self.localToDivisionFactor)

	local divisions, division, dx, dy

	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		divisions = self.divisions[pinTypeId]
		for i = divisionX - 1, divisionX + 1 do
			for j = divisionY - 1, divisionY + 1 do
				division = divisions[i + j * self.numDivisions]
				if division then
					for _, nodeId in pairs(division) do
						dx = self.localX[nodeId] - localX
						dy = self.localY[nodeId] - localY
						if dx * dx + dy * dy < localMinDistanceSquared then
							callback(self, nodeId, ...)
						end
					end
				end
			end
		end
	end
end

local PinQueue = ZO_Object:Subclass()
MapCache.PinQueue = PinQueue

function PinQueue:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function PinQueue:Initialize()
	
end

function PinQueue:AddDivision(divisionIndex, pinTypeId)
	error("must be implemented")
end

function PinQueue:RemoveDivision(divisionIndex, pinTypeId)
	error("must be implemented")
end

function MapCache:GetVisibleNodes(x, y, pinTypeId, visibleDistanceInMeters, queue)
	if not Harvest.AreAnyMapPinsVisible() then return end
	self.time = GetFrameTimeSeconds()
	if self.mapMetaData.isBlacklisted then return end
	
	if visibleDistanceInMeters > 0 then
		
		local maxGlobalDistance = self.zoneMeasurement:MetersToGlobalDistance(visibleDistanceInMeters)
		local maxLocalDistanceSquared = maxGlobalDistance / self.mapMetaData.mapMeasurement.scaleX
		maxLocalDistanceSquared = maxLocalDistanceSquared * maxLocalDistanceSquared
		
		local divisionX = zo_floor(x * self.localToDivisionFactor)
		local divisionY = zo_floor(y * self.localToDivisionFactor)
		
		local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)

		local division, dx, dy, divisions
		local centerX, centerY
		local startJ = zo_max(0, divisionY - range)
		local endJ = zo_min(divisionY + range, self.numDivisions-1)
		
		divisions = self.divisions[pinTypeId]
		for i = zo_max(0,divisionX - range), zo_min(divisionX + range, self.numDivisions-1)  do
			centerX = (i+0.5) / self.localToDivisionFactor
			dx = centerX - x
			for j = startJ, endJ do
				centerY = (j+0.5) / self.localToDivisionFactor
				dy = centerY - y
				if dx * dx + dy * dy < maxLocalDistanceSquared then
					division = divisions[i + j * self.numDivisions]
					if division then
						queue:AddDivision(i + j * self.numDivisions, pinTypeId)
					end
				end
			end
		end
	else
		for index in pairs(self.divisions[pinTypeId]) do
			queue:AddDivision(index, pinTypeId)
		end
	end
end


---
-- used for the nearby map pins display
-- updates the position, adds newly visible pins to the output-queue and
-- removes newly out of range pins from the output-queue
function MapCache:SetPrevAndCurVisibleNodesToTable(previousX, previousY, currentX, currentY, visibleDistanceInMeters, queue)
	if not Harvest.AreAnyMapPinsVisible() then return end
	self.time = GetFrameTimeSeconds()
	if self.mapMetaData.isBlacklisted then return end
	
	local maxGlobalDistance = self.zoneMeasurement:MetersToGlobalDistance(visibleDistanceInMeters)
	
	local maxLocalDistanceSquared = maxGlobalDistance / self.mapMetaData.mapMeasurement.scaleX
	maxLocalDistanceSquared = maxLocalDistanceSquared * maxLocalDistanceSquared
	
	local prevDivX = zo_floor(previousX * self.localToDivisionFactor)
	local prevDivY = zo_floor(previousY * self.localToDivisionFactor)
	local divX = zo_floor(currentX * self.localToDivisionFactor)
	local divY = zo_floor(currentY * self.localToDivisionFactor)
	if prevDivX == divX and prevDivY == divY then
		-- we did not move, so no reason to change anything
		return false
	end

	local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)

	local divisions, division, dx, dy, prevdx, prevdy, typeId
	local centerX, centerY
	local startJ = zo_max(0,divY - range)
	local endJ = zo_min(divY + range, self.numDivisions-1)
	
	for i = zo_max(0,divX - range), zo_min(divX + range, self.numDivisions-1)  do
		centerX = (i+0.5) / self.localToDivisionFactor
		dx = centerX - currentX
		prevdx = centerX - previousX
		for j = startJ, endJ do
			centerY = (j+0.5) / self.localToDivisionFactor
			dy = centerY - currentY
			prevdy = centerY - previousY
			if dx * dx + dy * dy < maxLocalDistanceSquared then -- inside current range
				if prevdx * prevdx + prevdy * prevdy >= maxLocalDistanceSquared then -- outside previous range
					for _, pinTypeId in ipairs(Harvest.PINTYPES) do
						division = self.divisions[pinTypeId][i + j * self.numDivisions]
						if division then
							if Harvest.IsMapPinTypeVisible(pinTypeId) then
								queue:AddDivision(i + j * self.numDivisions, pinTypeId)
							end
						end
					end
				end
			end
		end
	end
	
	startJ = zo_max(0,prevDivY - range)
	endJ = zo_min(prevDivY + range, self.numDivisions-1)
	
	for i = zo_max(0,prevDivX - range), zo_min(prevDivX + range, self.numDivisions-1)  do
		centerX = (i+0.5) / self.localToDivisionFactor
		dx = centerX - currentX
		prevdx = centerX - previousX
		for j = startJ, endJ do
			centerY = (j+0.5) / self.localToDivisionFactor
			dy = centerY - currentY
			prevdy = centerY - previousY
			if dx * dx + dy * dy >= maxLocalDistanceSquared then -- outside current range
				if prevdx * prevdx + prevdy * prevdy < maxLocalDistanceSquared then -- inside previous range
					for _, pinTypeId in ipairs(Harvest.PINTYPES) do
						division = self.divisions[pinTypeId][i + j * self.numDivisions]
						if division then
							if Harvest.IsMapPinTypeVisible(pinTypeId) then
								queue:RemoveDivision(i + j * self.numDivisions, pinTypeId)
							end
						end
					end
				end
			end
		end
	end
	return true
end

function MapCache:ForNodesInRange(globalX, globalY, heading, visibleDistanceInMeters, validPinTypes, callback, ...)
	if self.mapMetaData.isBlacklisted then return end
	if not self.zoneMeasurement then return end
	
	local localX, localY = self.mapMetaData:GlobalToLocal(globalX, globalY)
	local maxGlobalDistance = self.zoneMeasurement:MetersToGlobalDistance(visibleDistanceInMeters)
	
	local distToCenter = 0.71 / self.localToDivisionFactor
	
	local maxLocalDistanceSquared = maxGlobalDistance / self.mapMetaData.mapMeasurement.scaleX + distToCenter
	maxLocalDistanceSquared = maxLocalDistanceSquared * maxLocalDistanceSquared
	
	local divisionX = zo_floor(localX * self.localToDivisionFactor)
	local divisionY = zo_floor(localY * self.localToDivisionFactor)

	local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)
	
	local dirX = math.sin(heading)
	local dirY = math.cos(heading)
	
	local division, dx, dy, divisions
	local centerX, centerY, index
	local startJ = zo_max(0,divisionY - range)
	local endJ = zo_min(divisionY + range, self.numDivisions-1)
	
	for i = zo_max(0,divisionX - range), zo_min(divisionX + range, self.numDivisions-1)  do
		centerX = (i+0.5) / self.localToDivisionFactor
		dx = centerX - localX
		for j = startJ, endJ do
			centerY = (j+0.5) / self.localToDivisionFactor
			dy = centerY - localY
			if dx * dirX + dy * dirY < distToCenter and dx * dx + dy * dy < maxLocalDistanceSquared then
				index = i + j * self.numDivisions
				for _, pinTypeId in pairs(validPinTypes) do
					division = self.divisions[pinTypeId][index]
					if division then
						for _, nodeId in pairs(division) do
							if (not self.hiddenTime[nodeId]) then
								callback(self, nodeId, ...)
							end
						end
					end
				end
			end
		end
	end
end
