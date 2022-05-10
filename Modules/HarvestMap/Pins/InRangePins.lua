local Harvest = _G["Harvest"]

local PARENT = COMPASS.container
local pairs = _G["pairs"]
local zo_abs = _G["zo_abs"]
local zo_floor = _G["zo_floor"]
local pi = math.pi
local atan2 = math.atan2
local GetFrameTimeMilliseconds = _G["GetFrameTimeMilliseconds"]
local GetPlayerCameraHeading = _G["GetPlayerCameraHeading"]
local GetMapPlayerPosition = _G["GetMapPlayerPosition"]
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events
local MapCache = Harvest.MapCache

local InRangePins = {}
Harvest:RegisterModule("InRangePins", InRangePins)

function InRangePins:Initialize()
	self.lastUpdate = {}

	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, ...)
		if setting == "compassPinsVisible" then
			local visible = ...
			self.displayCompassPins = visible
			self:RefreshValidPinTypes()
			self:CheckPause()
			self:RefreshRange()
		elseif setting == "worldPinsVisible" then
			local visible = ...
			self.displayWorldPins = visible
			self:RefreshValidPinTypes()
			self:CheckPause()
			if not visible then
				self:RefreshWorldPins()
			end
			self:RefreshRange()
		elseif setting == "worldSpawnFilter" then
			self:RefreshWorldPins()
		elseif setting == "compassSpawnFilter" then
			self:RefreshCompassPins()
		elseif setting == "compassDistance" or setting == "worldDistance" then
			self:RefreshRange()
		elseif setting == "pinTypeColor" or setting == "mapPinTexture" or setting == "isSpawnFilterUsedForPinType" then
			self:RefreshAllPins()
		elseif setting == "worldPinsUseDepth" then
			local useDepth = ...
			local beam, icon
			for _, control in pairs(self.worldControlPool:GetActiveObjects()) do
				beam = control:GetNamedChild("Beam")
				icon = control:GetNamedChild("Icon")
				control:Set3DRenderSpaceUsesDepthBuffer(useDepth)
				beam:Set3DRenderSpaceUsesDepthBuffer(useDepth)
				icon:Set3DRenderSpaceUsesDepthBuffer(useDepth)
			end
			self.useDepth = useDepth
		elseif setting == "compassFilterProfile" then
			self.compassFilterProfile = Harvest.filterProfiles:GetCompassProfile()
			self:RefreshValidPinTypes()
			self:LoadPinData()
			self:RefreshCompassPins()
		elseif setting == "worldFilterProfile" then
			self.worldFilterProfile = Harvest.filterProfiles:GetWorldProfile()
			self:RefreshValidPinTypes()
			self:LoadPinData()
			self:RefreshWorldPins()
		end
	end)

	CallbackManager:RegisterForEvent(Events.FILTER_PROFILE_CHANGED,
		function(event, profile, pinTypeId, isVisible)
			if (profile ~= self.compassFilterProfile) and (profile ~= self.worldFilterProfile) then
				return
			end
			if self.zoneCache and isVisible then
				for map, mapCache in pairs(self.zoneCache.mapCaches) do
					Harvest.Data:CheckPinTypeInCache(pinTypeId, mapCache)
				end
			end
			self:RefreshValidPinTypes()
			if profile == self.compassFilterProfile then
				self:RefreshCompassPins()
			end
			if profile == self.worldFilterProfile then
				self:RefreshWorldPins()
			end
		end)

	local onNodeChanged = function(event, mapCache, nodeId)
		local map = mapCache.mapMetaData.map
		if not self.zoneCache then return end
		if not self.zoneCache:DoesHandleMapCache(mapCache) then return end
		-- the next case can happen when map is added to zone
		-- then MAP_ADDED_TO_ZONE is called for nodedetection first
		if not self.compassKeys[map] then return end

		local key = self.compassKeys[map][nodeId]
		if key then
			self.compassControlPool:ReleaseObject(key)
			self.compassKeys[map][nodeId] = nil
		end
		key = self.worldKeys[map][nodeId]
		if key then
			self.worldControlPool:ReleaseObject(key)
			self.worldKeys[map][nodeId] = nil
		end
	end
	CallbackManager:RegisterForEvent(Events.NODE_UPDATED, onNodeChanged)
	CallbackManager:RegisterForEvent(Events.NODE_DELETED, onNodeChanged)
	CallbackManager:RegisterForEvent(Events.NODE_COMPASS_LINK_CHANGED, onNodeChanged)

	CallbackManager:RegisterForEvent(Events.NEW_ZONE_ENTERED, function(event, zoneCache)
		self:Info("Entered zone. index: %d, id: %d", zoneCache.zoneIndex, zoneCache.zoneId)
		local tbl = {}
		for map, _ in pairs(zoneCache.mapCaches) do
			table.insert(tbl, map)
		end
		self:Info("maps:", unpack(tbl))

		self.zoneCache = zoneCache
		self:RefreshAllPins()
		self:LoadPinData()
	end)

	CallbackManager:RegisterForEvent(Events.MAP_ADDED_TO_ZONE, function(event, mapCache, zoneCache)
		if zoneCache ~= self.zoneCache then return end
		self:Info("added a new map to 3d/compass pins. map: %s, zoneIndex: %d", mapCache.map, zoneCache.zoneIndex)
		assert(not self.worldKeys[mapCache.map], mapCache.map)
		assert(not self.compassKeys[mapCache.map], mapCache.map)
		assert(not self.lastUpdate[mapCache.map], mapCache.map)
		self.worldKeys[mapCache.map] = {}
		self.compassKeys[mapCache.map] = {}
		self.lastUpdate[mapCache.map] = {}
		self:LoadPinData()
	end)

	self.settings = Harvest.settings.savedVars.settings

	self.compassControlPool = ZO_ControlPool:New("HM_CompassPin", PARENT, "HM_CompassPin")
	self.compassKeys = {}
	self.displayCompassPins = Harvest.AreCompassPinsVisible()
	self.compassFilterProfile = Harvest.filterProfiles:GetCompassProfile()

	self.worldControlPool = ZO_ControlPool:New("HM_WorldPin", HM_WorldPins, "HM_WorldPin")
	HM_WorldPins:Create3DRenderSpace()
	self.worldKeys = {}
	self.displayWorldPins = Harvest.AreWorldPinsVisible()
	self.worldFilterProfile = Harvest.filterProfiles:GetWorldProfile()

	self.FOV = pi * 0.6
	self.useDepth = Harvest.DoWorldPinsUseDepth()

	self.customPinCallbacks = {}
	self.customPins = {}
	self.customMap = "custom"

	self:CheckPause()
	self:RefreshRange()
	self:RefreshValidPinTypes()

	self.fragment = ZO_SimpleSceneFragment:New(HM_WorldPins)
	HUD_UI_SCENE:AddFragment(self.fragment)
	HUD_SCENE:AddFragment(self.fragment)
	LOOT_SCENE:AddFragment(self.fragment)

	EVENT_MANAGER:RegisterForEvent("HarvestMap-InRangePins", EVENT_PLAYER_ACTIVATED, function()
		self:Info("player position: %d, %d, %d, %d", GetUnitRawWorldPosition("player"))
		local worldX, worldZ, worldY = WorldPositionToGuiRender3DPosition(0,0,0)
		HM_WorldPins:Set3DRenderSpaceOrigin(worldX, worldZ, worldY)
		self:Info("world origin in render space: %f, %f, %f", worldX, worldZ, worldY)
		self:CheckPause()
	end)
end

function InRangePins:RegisterCustomPinCallback(pinType, callback)
	self.customPinCallbacks[pinType] = callback
end

function InRangePins:AddCustomPin(pinTag, pinTypeId, range, worldX, worldY, worldZ)
	local pin = self.customPins[pinTag] or {}
	pin.pinTypeId = pinTypeId
	pin.range2 = range * range
	pin.x, pin.y = worldX, worldY
	pin.worldZ = worldZ
	self.customPins[pinTag] = pin
end

function InRangePins:RefreshValidPinTypes()
	self.validPinTypeIds = {}
	for _, pinTypeId in pairs(Harvest.PINTYPES) do
		if self.compassFilterProfile[pinTypeId] or self.worldFilterProfile[pinTypeId] then
			table.insert(self.validPinTypeIds, pinTypeId)
		end
	end
end

function InRangePins:LoadPinData()
	if self.zoneCache then
		for map, mapCache in pairs(self.zoneCache.mapCaches) do
			for _, pinTypeId in ipairs(self.validPinTypeIds) do
				Harvest.Data:CheckPinTypeInCache(pinTypeId, mapCache)
			end
		end
	end
end

function InRangePins:RefreshAllPins()
	self:RefreshCompassPins()
	self:RefreshWorldPins()
	self:RefreshCustomPins()
	self.lastUpdate = {}
	if not self.zoneCache then return end
	for map, mapCache in pairs(self.zoneCache.mapCaches) do
		self.lastUpdate[map] = {}
	end
	self.lastUpdate[self.customMap] = {}
end

function InRangePins:RefreshCompassPins()
	self.compassControlPool:ReleaseAllObjects()
	self.compassKeys = {}
	if not self.zoneCache then return end
	for map, mapCache in pairs(self.zoneCache.mapCaches) do
		self.compassKeys[map] = {}
	end
	self.compassKeys[self.customMap] = {}
end

function InRangePins:RefreshWorldPins()
	self.worldControlPool:ReleaseAllObjects()
	self.worldKeys = {}
	if not self.zoneCache then return end
	for map, mapCache in pairs(self.zoneCache.mapCaches) do
		self.worldKeys[map] = {}
	end
	self.worldKeys[self.customMap] = {}
end

function InRangePins:RefreshCustomPins()
	self.customPins = {}
	if not self.zoneCache then return end
	for pinType, callback in pairs(self.customPinCallbacks) do
		callback(self, pinType)
	end
end

function InRangePins:RefreshRange()
	local range = 0
	if self.displayCompassPins then
		range = Harvest.GetCompassDistance()
	end
	if self.displayWorldPins then
		range = zo_max(range, Harvest.GetWorldDistance())
	end
	self.visibleRange = range
	self.visibleRange2 = range * range

	range = Harvest.GetCompassDistance()
	self.visibleCompassRange2 = range * range
	range = Harvest.GetWorldDistance()
	self.visibleWorldRange2 = range * range
end

function InRangePins:CheckPause()
	local paused = not (self.displayCompassPins or self.displayWorldPins)
	if paused then
		self:Info("pause inrange-pins. compass enabled %s, world enabled %s",
			tostring(self.displayCompassPins),
			tostring(self.displayWorldPins))
		EVENT_MANAGER:UnregisterForUpdate("HarvestMapInRangePinsUpdate")
		self:RefreshAllPins()
	else
		self:Info("unpause inrange-pins")
		EVENT_MANAGER:UnregisterForUpdate("HarvestMapInRangePinsUpdate")
		EVENT_MANAGER:RegisterForUpdate("HarvestMapInRangePinsUpdate", 30, InRangePins.UpdatePins )
	end
end

function InRangePins.UpdatePins(timeInMs)
	local self = InRangePins

	if not self.fragment:IsHidden() then
		if not self.zoneCache then return end
		self.worldX, self.worldY = Harvest.GetPlayer3DPosition()

		local heading = GetPlayerCameraHeading()
		if heading > pi then --normalize heading to [-pi,pi]
			heading = heading - 2 * pi
		end
		self.heading = heading
		self.timeInMs = timeInMs

		--for map, mapCache in pairs(self.zoneCache.mapCaches) do
		--MapCache:ForNodesInRange(self.worldX, self.worldY, heading, self.visibleRange, self.validPinTypeIds, self.pinUpdateCallback, self, self.lastUpdate[map], self.compassKeys[map], self.worldKeys[map])
		MapCache:ForNodesInRange(self.worldX, self.worldY, heading, self.visibleRange, self.pinUpdateCallback, self)
		--end


		local lastUpdate = self.lastUpdate[self.customMap]
		local compassKeys = self.compassKeys[self.customMap]
		local worldKeys = self.worldKeys[self.customMap]
		for pinTag, layout in pairs(self.customPins) do
			self:UpdateCustomPin(pinTag, layout, lastUpdate, compassKeys, worldKeys)
		end
	end
	-- some pins might be out of range and thus weren't updated by the ForNodesInRange call
	local key, compassKeys, worldKeys
	for map, lastUpdatedIds in pairs(self.lastUpdate) do
		compassKeys = self.compassKeys[map]
		worldKeys = self.worldKeys[map]
		for nodeId, time in pairs(lastUpdatedIds) do
			if time < timeInMs then
				key = compassKeys[nodeId]
				if key then
					self.compassControlPool:ReleaseObject(key)
					compassKeys[nodeId] = nil
				end
				key = worldKeys[nodeId]
				if key then
					self.worldControlPool:ReleaseObject(key)
					worldKeys[nodeId] = nil
				end
				lastUpdatedIds[nodeId] = nil
			end
		end
	end
end


function InRangePins:UpdateCustomPin(pinTag, layout, lastUpdate, compassKeys, worldKeys)
	lastUpdate[pinTag] = self.timeInMs
	local xDif = self.worldX - layout.x
	local yDif = self.worldY - layout.y
	local angle = -atan2(xDif, yDif)
	angle = (angle + self.heading)
	if angle > pi then
		angle = angle - 2 * pi
	elseif angle < -pi then
		angle = angle + 2 * pi
	end
	local normalizedDistance = (xDif * xDif + yDif * yDif) / layout.range2 / 25000
	local key
	-- first update the world pins
	local validWorldPin = self.displayWorldPins and layout.worldX
	if validWorldPin then
		key = worldKeys[pinTag]
		if normalizedDistance >= 1 then
			if key then
				self.worldControlPool:ReleaseObject(key)
				worldKeys[pinTag] = nil
			end
			key = nil
			validWorldPin = false
		end
		if validWorldPin then
			local control
			if key then
				control = self.worldControlPool:GetExistingObject(key)
			else
				control, key = self:GetNewWorldControl(layout.pinTypeId, pinTag,
					layout.x,
					layout.y,
					layout.worldZ)
				worldKeys[pinTag] = key
			end
			control:Set3DRenderSpaceOrientation(0,self.heading,0)
		end
	end

	if not self.displayCompassPins then return end

	key = compassKeys[pinTag]
	-- the pin is out of range, so remove the pin control from the compass
	if normalizedDistance >= 1 then
		if key then
			self.compassControlPool:ReleaseObject(key)
			compassKeys[pinTag] = nil
		end
		if not validWorldPin then
			lastUpdate[pinTag] = nil
		end
		return
	end

	-- normalize the angle to [-1, 1] where (-/+) 1 is the left/right edge of the compass
	local normalizedAngle = 2 * angle / self.FOV
	-- check if the bin is outside the FOV
	if zo_abs(normalizedAngle) > 1 then
		if key then
			self.compassControlPool:ReleaseObject(key)
			compassKeys[pinTag] = nil
		end
		if not validWorldPin then
			lastUpdate[pinTag] = nil
		end
		return
	end

	if key then
		control = self.compassControlPool:GetExistingObject(key)
	else
		control, key = self:GetNewCompassControl(layout.pinTypeId)
		compassKeys[pinTag] = key
		control:SetDrawLevel(2)
	end
	--control:ClearAnchors()
	control:SetAnchor(CENTER, PARENT, CENTER, 0.5 * PARENT:GetWidth() * normalizedAngle, 0)
	--control:SetHidden(false)

	--if zo_abs(normalizedAngle) > 0.25 then
	--	control:SetDimensions(36 - 16 * zo_abs(normalizedAngle), 36 - 16 * zo_abs(normalizedAngle))
	--else
		control:SetDimensions(32, 32)
	--end

	control:SetAlpha(control.maxAlpha * (1 - normalizedDistance^4))
end

function InRangePins.pinUpdateCallback(divisionIndex, self)
	local lastUpdate, compassKeys, worldKeys

	for map, mapCache in pairs(self.zoneCache.mapCaches) do
		lastUpdate = self.lastUpdate[map]
		compassKeys = self.compassKeys[map]
		worldKeys = self.worldKeys[map]
		for _, pinTypeId in pairs(self.validPinTypeIds) do
			division = mapCache.divisions[pinTypeId][divisionIndex]
			if division then
				for _, nodeId in pairs(division) do
					if not mapCache.hiddenTime[nodeId] then
						self:UpdatePin(mapCache, nodeId, lastUpdate, compassKeys, worldKeys)
					end
				end
			end
		end
	end
end

function InRangePins:UpdatePin(mapCache, nodeId, lastUpdate, compassKeys, worldKeys)
	lastUpdate[nodeId] = self.timeInMs
	if not mapCache.worldX[nodeId] then return end -- todo
	local pinTypeId = mapCache.pinTypeId[nodeId]
	local xDif = (self.worldX - mapCache.worldX[nodeId])
	local yDif = (self.worldY - mapCache.worldY[nodeId])
	local angle = -atan2(xDif, yDif)
	angle = (angle + self.heading)
	if angle > pi then
		angle = angle - 2 * pi
	elseif angle < -pi then
		angle = angle + 2 * pi
	end
	local worldDistance = (xDif * xDif + yDif * yDif)
	local normalizedDistance = worldDistance / self.visibleCompassRange2
	local normalizedWorldDistance = worldDistance / self.visibleWorldRange2
	--worldDistance = worldDistance -- distance in meters squared

	local key, control
	-- first update the world pins
	local validWorldPin = self.displayWorldPins and self.worldFilterProfile[pinTypeId] and mapCache.worldZ[nodeId]
	if validWorldPin then
		if LibNodeDetection and self.settings.worldSpawnFilter and self.settings.isSpawnFilterUsedForPinType[pinTypeId] then--IsWorldSpawnFilterEnabled() then
			if Harvest.HARVEST_NODES[pinTypeId] and not mapCache.hasCompassPin[nodeId] then
				validWorldPin = false
			end
		end
	end
	if validWorldPin then

		key = worldKeys[nodeId]
		if normalizedWorldDistance >= 1 then
			if key then
				self.worldControlPool:ReleaseObject(key)
				worldKeys[nodeId] = nil
			end
			key = nil
			validWorldPin = false
		end
		if validWorldPin then
			if key then
				control = self.worldControlPool.m_Active[key]--:GetExistingObject(key)
			else
				control, key = self:GetNewWorldControl(
					pinTypeId,
					mapCache.worldX[nodeId],
					mapCache.worldY[nodeId],
					mapCache.worldZ[nodeId])
				worldKeys[nodeId] = key
			end
			control:Set3DRenderSpaceOrientation(0, self.heading, 0)
			--d(worldDistance)
			if worldDistance < 9 then
				control.beam:SetAlpha(control.maxAlpha * zo_min(worldDistance * 0.25, 1))
			end
		end
	end

	if not self.displayCompassPins then return end

	if not self.compassFilterProfile[pinTypeId] then return end
	if LibNodeDetection and self.settings.compassSpawnFilter and self.settings.isSpawnFilterUsedForPinType[pinTypeId] then--IsCompassSpawnFilterEnabled() then
		if Harvest.HARVEST_NODES[pinTypeId] and not mapCache.hasCompassPin[nodeId] then
			return
		end
	end

	key = compassKeys[nodeId]
	-- the pin is out of range, so remove the pin control from the compass
	if normalizedDistance >= 1 then
		if key then
			self.compassControlPool:ReleaseObject(key)
			compassKeys[nodeId] = nil
		end
		if not validWorldPin then
			lastUpdate[nodeId] = nil
		end
		return
	end

	-- normalize the angle to [-1, 1] where (-/+) 1 is the left/right edge of the compass
	local normalizedAngle = 2 * angle / self.FOV
	-- check if the bin is outside the FOV
	if zo_abs(normalizedAngle) > 1 then
		if key then
			self.compassControlPool:ReleaseObject(key)
			compassKeys[nodeId] = nil
		end
		if not validWorldPin then
			lastUpdate[nodeId] = nil
		end
		return
	end

	if key then
		control = self.compassControlPool.m_Active[key]--:GetExistingObject(key)
	else
		control, key = self:GetNewCompassControl(pinTypeId)
		compassKeys[nodeId] = key
	end
	--control:ClearAnchors()
	control:SetAnchor(CENTER, PARENT, CENTER, 0.5 * PARENT:GetWidth() * normalizedAngle, 0)
	--control:SetHidden(false)

	--if zo_abs(normalizedAngle) > 0.25 then
	--	control:SetDimensions(36 - 16 * zo_abs(normalizedAngle), 36 - 16 * zo_abs(normalizedAngle))
	--else
	--	control:SetDimensions(32, 32)
	--end

	control:SetAlpha(control.maxAlpha * (1 - normalizedDistance^4))
end

function InRangePins:GetNewCompassControl(pinTypeId)
	local pin, pinKey = self.compassControlPool:AcquireObject()

	layout = Harvest.GetMapPinLayout(pinTypeId)
	pin:SetTexture(layout.texture)
	pin:SetColor(layout.tint:UnpackRGB())
	pin.maxAlpha = 1--layout.tint.a
	pin:SetDimensions(32, 32)
	pin:SetDrawLevel(1)

	return pin, pinKey
end

function InRangePins:GetNewWorldControl(pinTypeId, worldX, worldY, worldZ)
	if not worldZ then return end

	local pin, pinKey = self.worldControlPool:AcquireObject()

	local beam = pin:GetNamedChild("Beam")
	pin.beam = beam
	local icon = pin:GetNamedChild("Icon")
	pin.icon = icon
	if not pin:Has3DRenderSpace()  then
		pin:Create3DRenderSpace()
		beam:Create3DRenderSpace()
		beam:SetTexture("HarvestMap/Textures/worldMarker.dds")
		icon:Create3DRenderSpace()
	end
	pin:Set3DRenderSpaceUsesDepthBuffer(self.useDepth)
	beam:Set3DRenderSpaceUsesDepthBuffer(self.useDepth)
	icon:Set3DRenderSpaceUsesDepthBuffer(self.useDepth)

	local width = Harvest.GetWorldPinWidth() * 0.01
	local height = Harvest.GetWorldPinHeight() * 0.01
	icon:Set3DRenderSpaceOrigin(0, height + 0.125 * height + 0.25, 0)
	icon:Set3DLocalDimensions(0.25 * height + 0.5, 0.25 * height + 0.5)
	beam:Set3DRenderSpaceOrigin(0, 0.5 * height, 0)
	beam:Set3DLocalDimensions(width, height)

	layout = Harvest.GetMapPinLayout(pinTypeId)
	icon:SetTexture(layout.texture)

	beam:SetColor(layout.tint:UnpackRGBA())
	icon:SetColor(layout.tint:UnpackRGBA())
	pin.maxAlpha = layout.tint.a

	pin:Set3DRenderSpaceOrigin(worldX, worldZ, worldY)

	return pin, pinKey
end