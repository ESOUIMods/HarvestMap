
local QuickPin = LibQuickPin2
local GPS = LibGPS2

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local PinQueue = {mapPins = Harvest.mapPins}
Harvest.mapPins.queue = PinQueue

local TYPES = {
	ADD_DIVISION = 1,
	ADD_NODE = 2,
	REM_DIVISION = 3,
	REM_NODE = 4,
}
PinQueue.TYPES = TYPES 

PinQueue.commands = {length=0, index=1}

function PinQueue:Clear()
	self.commands.length = 0
	self.commands.index = 1
end

function PinQueue:Add(Type, id, pinTypeId)
	local n = self.commands.length
	self.commands[n+1] = Type
	self.commands[n+2] = id
	self.commands[n+3] = pinTypeId
	self.commands.length = self.commands.length + 3
end

function PinQueue:AddDivision(divisionId, pinTypeId)
	self:Add(TYPES.ADD_DIVISION, divisionId, pinTypeId)
end

function PinQueue:RemoveDivision(divisionId, pinTypeId)
	self:Add(TYPES.REM_DIVISION, divisionId, pinTypeId)
end

function PinQueue:AddNode(nodeId, pinTypeId)
	--self:Add(TYPES.ADD_NODE, nodeId, pinTypeId or 0)
	pinTypeId = pinTypeId or 0
	local mapCache = self.mapPins.mapCache
	local shouldRenderUnspawnedNodes = not Harvest.IsMapSpawnFilterEnabled()
	if Harvest.mapMode:IsInMinimapMode() then
		shouldRenderUnspawnedNodes = not Harvest.IsMinimapSpawnFilterEnabled()
	end
	if shouldRenderUnspawnedNodes or mapCache.hasCompassPin[nodeId] or not Harvest.HARVEST_NODES[pinTypeId] then
		if not mapCache.hiddenTime[nodeId] then
			x = mapCache.globalX[nodeId]
			y = mapCache.globalY[nodeId]
			--if x and y then -- eg pin is added and then removed whle map is closed
				x, y = GPS:GlobalToLocal(x,y)
				QuickPin:CreatePin(pinTypeId, nodeId, x, y)
			--end
		end
	end	
end

function PinQueue:RemoveNode(nodeId, pinTypeId)
	--self:Add(TYPES.REM_NODE, nodeId, pinTypeId or 0)
	pinTypeId = pinTypeId or 0
	QuickPin:RemovePin(pinTypeId, nodeId)
end

function PinQueue:IsEmpty()
	return (self.commands.index >= self.commands.length)
end

function PinQueue:HasEntries()
	return (self.commands.index < self.commands.length)
end


local GetGameTimeMilliseconds = GetGameTimeMilliseconds
local GetFrameTimeMilliseconds = GetFrameTimeMilliseconds
-- Creates and removes a bunch of queued pins.
function PinQueue:PerformActions()
	
	local GetGameTimeMilliseconds = GetGameTimeMilliseconds
	local FrameTime = GetFrameTimeMilliseconds()
	local commands = self.commands
	local mapCache = self.mapPins.mapCache
	
	local Type, id, x, y, defaultPinTypeId, pinTypeName, pin, index, pinManager, pinType
	index = commands.index
	pinManager = QuickPin
	
	if index > commands.length then
		self:Clear()
		CallbackManager:FireCallbacks(Events.PIN_QUEUE_EMPTY)
		return
	end
	
	-- perform the update until timeout, but at least 10 entries from the queue
	local shouldRenderUnspawnedNodes = not Harvest.IsMapSpawnFilterEnabled()
	if Harvest.mapMode:IsInMinimapMode() then
		shouldRenderUnspawnedNodes = not Harvest.IsMinimapSpawnFilterEnabled()
	end
	local counter = 10
	while counter > 0 or GetGameTimeMilliseconds() - FrameTime < 40 do
		-- retrieve data for the current command
		Type, id, pinTypeId = commands[index], commands[index+1], commands[index+2]
		index = index + 3
		--[[
		if Type == TYPES.ADD_NODE then
			if shouldRenderUnspawnedNodes or mapCache.hasCompassPin[id] or not Harvest.HARVEST_NODES[pinTypeId] then
				if not mapCache.hiddenTime[id] then
					x = mapCache.globalX[id]
					y = mapCache.globalY[id]
					if x and y then -- eg pin is added and then removed whle map is closed
						x, y = GPS:GlobalToLocal(x,y)
						pinManager:CreatePin(pinTypeId, id, x, y)
					end
				end
			end	
		elseif Type == TYPES.REM_NODE then
			pinManager:RemovePin(pinTypeId, id)
			
		elseif Type == TYPES.ADD_DIVISION then]]
		if Type == TYPES.ADD_DIVISION then
			for _, nodeId in pairs(mapCache.divisions[pinTypeId][id]) do
				if shouldRenderUnspawnedNodes or mapCache.hasCompassPin[nodeId] or not Harvest.HARVEST_NODES[pinTypeId] then
					if not mapCache.hiddenTime[nodeId] then
						x = mapCache.globalX[nodeId]
						y = mapCache.globalY[nodeId]
						x, y = GPS:GlobalToLocal(x,y)
						pinManager:CreatePin(pinTypeId, nodeId, x, y)
					end
				end
			end
			
		elseif Type == TYPES.REM_DIVISION then
			for _, nodeId in pairs(mapCache.divisions[pinTypeId][id]) do
				pinManager:RemovePin(pinTypeId, nodeId)
			end
		end
		
		if index > commands.length then
			self:Clear()
			CallbackManager:FireCallbacks(Events.PIN_QUEUE_EMPTY)
			return
		end
		counter = counter - 1
	end
	commands.index = index
end
