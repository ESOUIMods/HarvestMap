
local zo_min = _G["zo_min"]
local zo_max = _G["zo_max"]
local zo_ceil = _G["zo_ceil"]
local zo_floor = _G["zo_floor"]
local pairs = _G["pairs"]
local ipairs = _G["ipairs"]

local MapCache = Harvest.MapCache

function MapCache:ForNearbyNodes(worldX, worldY, callback, ...)
	if self.mapMetaData.isBlacklisted then return end
	self.time = GetFrameTimeSeconds()
	
	local minDistance = Harvest.GetVisitedRangeInMeters()
	local minDistanceSquared = minDistance * minDistance
	
	local divisionX = zo_floor(worldX / self.DivisionWidthInMeters)
	local divisionY = zo_floor(worldY / self.DivisionWidthInMeters)

	local divisions, division, dx, dy

	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		divisions = self.divisions[pinTypeId]
		for i = divisionX - 1, divisionX + 1 do
			for j = divisionY - 1, divisionY + 1 do
				division = divisions[(i + j * self.numDivisions) % self.TotalNumDivisions]
				if division then
					for _, nodeId in pairs(division) do
						dx = self.worldX[nodeId] - worldX
						dy = self.worldY[nodeId] - worldY
						if dx * dx + dy * dy < minDistanceSquared then
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
		
		local maxDistance = visibleDistanceInMeters
		local maxDistanceSquared = maxDistance * maxDistance
		
		local divisionX = zo_floor(x / self.DivisionWidthInMeters)
		local divisionY = zo_floor(y / self.DivisionWidthInMeters)
		
		local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)

		local division, dx, dy, divisions
		local centerX, centerY
		local startJ = divisionY - range
		local endJ = divisionY + range
		
		divisions = self.divisions[pinTypeId]
		for i = divisionX - range, divisionX + range do
			centerX = (i+0.5) * self.DivisionWidthInMeters
			dx = centerX - x
			for j = startJ, endJ do
				centerY = (j+0.5) * self.DivisionWidthInMeters
				dy = centerY - y
				if dx * dx + dy * dy < maxDistanceSquared then
					division = divisions[(i + j * self.numDivisions) % self.TotalNumDivisions]
					if division then
						queue:AddDivision((i + j * self.numDivisions) % self.TotalNumDivisions, pinTypeId)
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
	
	local maxDistance = visibleDistanceInMeters
	local maxDistanceSquared = maxDistance * maxDistance
	
	local prevDivX = zo_floor(previousX / self.DivisionWidthInMeters)
	local prevDivY = zo_floor(previousY / self.DivisionWidthInMeters)
	local divX = zo_floor(currentX / self.DivisionWidthInMeters)
	local divY = zo_floor(currentY / self.DivisionWidthInMeters)
	if prevDivX == divX and prevDivY == divY then
		-- we did not move, so no reason to change anything
		return false
	end

	local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)

	local divisions, division, dx, dy, prevdx, prevdy, typeId
	local centerX, centerY
	local startJ = divY - range
	local endJ = divY + range
	
	for i = divX - range, divX + range do
		centerX = (i+0.5) * self.DivisionWidthInMeters
		dx = centerX - currentX
		prevdx = centerX - previousX
		for j = startJ, endJ do
			centerY = (j+0.5) * self.DivisionWidthInMeters
			dy = centerY - currentY
			prevdy = centerY - previousY
			if dx * dx + dy * dy < maxDistanceSquared then -- inside current range
				if prevdx * prevdx + prevdy * prevdy >= maxDistanceSquared then -- outside previous range
					for _, pinTypeId in ipairs(Harvest.PINTYPES) do
						division = self.divisions[pinTypeId][(i + j * self.numDivisions) % self.TotalNumDivisions]
						if division then
							if Harvest.IsMapPinTypeVisible(pinTypeId) then
								queue:AddDivision((i + j * self.numDivisions) % self.TotalNumDivisions, pinTypeId)
							end
						end
					end
				end
			end
		end
	end
	
	startJ = prevDivY - range
	endJ = prevDivY + range
	
	for i = prevDivX - range, prevDivX + range do
		centerX = (i+0.5) * self.DivisionWidthInMeters
		dx = centerX - currentX
		prevdx = centerX - previousX
		for j = startJ, endJ do
			centerY = (j+0.5) * self.DivisionWidthInMeters
			dy = centerY - currentY
			prevdy = centerY - previousY
			if dx * dx + dy * dy >= maxDistanceSquared then -- outside current range
				if prevdx * prevdx + prevdy * prevdy < maxDistanceSquared then -- inside previous range
					for _, pinTypeId in ipairs(Harvest.PINTYPES) do
						division = self.divisions[pinTypeId][(i + j * self.numDivisions) % self.TotalNumDivisions]
						if division then
							if Harvest.IsMapPinTypeVisible(pinTypeId) then
								queue:RemoveDivision((i + j * self.numDivisions) % self.TotalNumDivisions, pinTypeId)
							end
						end
					end
				end
			end
		end
	end
	return true
end

function MapCache:ForNodesInRange(worldX, worldY, heading, visibleDistanceInMeters, validPinTypes, callback, ...)
	if self.mapMetaData.isBlacklisted then return end
	if not self.zoneMeasurement then return end
	
	local maxDistance = visibleDistanceInMeters + 0.5 * self.DivisionWidthInMeters
	local maxDistanceSquared = maxDistance * maxDistance
	local distToCenter = 0.71 * self.DivisionWidthInMeters
	
	local divisionX = zo_floor(worldX / self.DivisionWidthInMeters)
	local divisionY = zo_floor(worldY / self.DivisionWidthInMeters)

	local range = zo_ceil(visibleDistanceInMeters / self.DivisionWidthInMeters)
	
	local dirX = math.sin(heading)
	local dirY = math.cos(heading)
	
	local division, dx, dy, divisions
	local centerX, centerY, index
	local startJ = divisionY - range
	local endJ = divisionY + range
	
	for i = divisionX - range, divisionX + range do
		centerX = (i+0.5) * self.DivisionWidthInMeters
		dx = centerX - worldX
		for j = startJ, endJ do
			centerY = (j+0.5) * self.DivisionWidthInMeters
			dy = centerY - worldY
			if dx * dirX + dy * dirY < distToCenter and dx * dx + dy * dy < maxDistanceSquared then
				index = (i + j * self.numDivisions) % self.TotalNumDivisions
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
