-- lib3D2 by Shinni
-- some helper functions to be used for converting coordinate systems (local, global, world, renderspace)
-- also some functions to retrieve the camera and player position

local LIB_NAME = "Lib3D-v3"

Lib3D = {}
local lib = Lib3D

local GPS = LibStub("LibGPS2")
local LMP = LibStub("LibMapPing")

local d = function() end
if false then -- set to true for debug output
	d = _G["d"]
	function GlobalPos()
		local x, y = GetMapPlayerPosition("player")
		x, y = GPS:LocalToGlobal(x, y)
		d(x,y)
	end
end

-- control which is used to take 3d world coordinate measurements
lib.measurementControl = CreateControl(LIB_NAME .. "MeasurementControl", GuiRoot, CT_CONTROL)
lib.measurementControl:Create3DRenderSpace()

lib.zoneMeasurements = {}
lib.worldChangeCallbacks = {}

local function init(event, addon)
	if addon ~= "Lib3D" then
		return
	end
	
	lib.savedVars = Lib3D_SavedVars or {}
	Lib3D_SavedVars = lib.savedVars
end
EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, init)

-- the passed zoneId should be the player's current zoneIndex and zoneId
function lib:RefreshZoneMeasurement(zoneIndex, zoneId)
	if self.zoneMeasurements[zoneId] and self.zoneMeasurements[zoneId]:IsValid() then
		self.currentZoneMeasurement = self.zoneMeasurements[zoneId]
		return 
	end
	
	self.currentZoneMeasurement = nil
	
	local originalMapTexture = GetMapTileTexture()
	SetMapToMapListIndex(TAMRIEL_MAP_INDEX)
	
	-- save current map ping, so we can restore it later
	local hasMapPing = LMP:HasMapPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	local originalPinX, originalPinY = LMP:GetMapPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	d("original ping location", originalPinX, originalPinY)
	-- set two waypoints that are 25 km in X and Y direction apart from each other
	LMP:SuppressPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	
	local centerX, _, centerY = GuiRender3DPositionToWorldPosition(0,0,0)
	local success = SetPlayerWaypointByWorldLocation(centerX - 125000, 0, centerY - 125000)
	if success then
		local firstX, firstY = LMP:GetMapPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
		d("first ping location", firstX, firstY)
		success = SetPlayerWaypointByWorldLocation(centerX + 125000, 0, centerY + 125000)
		if success then
			local secondX, secondY = LMP:GetMapPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
			d("second ping location", secondX, secondY)
			if firstX ~= secondX and firstY ~= secondY then
				local currentGlobalToWorldFactor = 2 * 2500 / (secondX - firstX + secondY - firstY)
				local currentOriginGlobalX = (firstX + secondX) * 0.5 - centerX * 0.01 / currentGlobalToWorldFactor
				local currentOriginGlobalY = (firstY + secondY) * 0.5 - centerY * 0.01 / currentGlobalToWorldFactor
				d("global to world", currentGlobalToWorldFactor)
				d("world origin", currentOriginGlobalX, currentOriginGlobalY)
				self.currentZoneMeasurement = self:GetZoneMeasurementForZoneId(zoneId)
				local isFallbackValue = false
				self.currentZoneMeasurement:Initialize(zoneIndex, zoneId,
						currentOriginGlobalX, currentOriginGlobalY, currentGlobalToWorldFactor, isFallbackValue)
			end
		end
	end
	LMP:UnsuppressPing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	
	-- restore waypoint
	LMP:MutePing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	if hasMapPing then
		PingMap(MAP_PIN_TYPE_PLAYER_WAYPOINT, MAP_TYPE_LOCATION_CENTERED, originalPinX, originalPinY)
	else
		RemovePlayerWaypoint()
	end
	LMP:UnmutePing(MAP_PIN_TYPE_PLAYER_WAYPOINT)
	
	SetMapToPlayerLocation()
	if originalMapTexture ~= GetMapTileTexture() then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	
	if self.currentZoneMeasurement then
		self.savedVars[zoneId] = {
			self.currentZoneMeasurement.globalToWorldFactor, 
			self.currentZoneMeasurement.originGlobalX,
			self.currentZoneMeasurement.originGlobalY
		}
	end
end

local function OnPlayerDeactivated()
	lib.currentZoneIndex = nil
	lib.currentZoneId = nil
	lib.currentZoneMeasurement = nil
end

local function OnPlayerActivated()
	-- check if the player entered a new world
	local zoneIndex = GetUnitZoneIndex("player")
	local zoneId = GetZoneId(zoneIndex)
	local newWorld = (lib.currentZoneIndex ~= zoneIndex)
	
	d("activated in zone", zoneIndex, zoneId)
	
	if newWorld then
		d("new world")
		lib.currentZoneIndex = zoneIndex
		lib.currentZoneId = zoneId
		
		lib:RefreshZoneMeasurement(zoneIndex, zoneId)
		
		if not lib.currentZoneMeasurement then
			d("error, could not compute globalToWorld factor")
		else
			d("global to world factor", lib.currentZoneMeasurement.globalToWorldFactor)
		end
		
	end
	
	local validZone = lib:IsValidZone()
	for identifier, callback in pairs(lib.worldChangeCallbacks) do
		callback(identifier, zoneIndex, validZone, newWorld)
	end
end
EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_PLAYER_DEACTIVATED, OnPlayerDeactivated)
EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_PLAYER_ALIVE, OnPlayerActivated)

---
-- This function expects an identifier in addition to the callback. The identifier can be
-- used to unregister the callback.
-- The registered callback will be fired when the player enters a new 3d world. (e.g. a delve is entered)
-- The callbacks arguments are the identifier and the current 3d world's zoneIndex and zoneId
function lib:RegisterWorldChangeCallback(identifier, callback)
	self.worldChangeCallbacks[identifier] = callback
end

---
-- Unregisters the callback which belongs to the given identifier
function lib:UnregisterWorldChangeCallback(identifier)
	self.worldChangeCallbacks[identifier] = nil
end

---
-- Returns the global coordsystem to world system factor for the current zone.
-- Returns nil if the factor isn't known.
-- The 2nd return value tells you, if the value was computed or if it is a hardcoded fallback value
-- This factor can be used to convert distances between global coords to distances in meters.
function lib:GetGlobalToWorldFactor(zoneId)
	local zoneMeasurement = self.zoneMeasurements[zoneId]
	if zoneMeasurement then -- valid computation?
		return zoneMeasurement.globalToWorldFactor, not zoneMeasurement.isFallbackValue
	end
	if self.savedVars[zoneId] and self.savedVars[zoneId][1] then
		return self.savedVars[zoneId][1], true
	end
	return self.SPECIAL_GLOBAL_TO_WORLD_FACTORS[zoneId], false
end

function lib:GetWorldOriginAsGlobal(zoneId)
	local zoneMeasurement = self.zoneMeasurements[zoneId]
	if zoneMeasurement then -- valid computation?
		return zoneMeasurement.originGlobalX, zoneMeasurement.originGlobalY, not zoneMeasurement.isFallbackValue
	end
	if self.savedVars[zoneId] and self.savedVars[zoneId][1] then
		return self.savedVars[zoneId][2], self.savedVars[zoneId][3], true
	end
	return nil, nil, false
end

function lib:GetCurrentWorldOriginAsGlobal()
	return self.currentZoneMeasurement.originGlobalX,  self.currentZoneMeasurement.originGlobalY
end

function lib:GetCurrentGlobalToWorldFactor()
	return self.currentZoneMeasurement.globalToWorldFactor
end

function lib:GetZoneMeasurementForZoneId(zoneId)
	local zoneMeasurement = self.zoneMeasurements[zoneId]
	if zoneMeasurement then
		return zoneMeasurement
	end
	
	local globalToWorldFactor = self.SPECIAL_GLOBAL_TO_WORLD_FACTORS[zoneId] or self.DEFAULT_GLOBAL_TO_WORLD_FACTOR
	local originGlobalX = nil
	local originGlobalY = nil
	local isFallbackValue = true
	if self.savedVars[zoneId] and self.savedVars[zoneId][1] then
		globalToWorldFactor = self.savedVars[zoneId][1]
		originGlobalX = self.savedVars[zoneId][2]
		originGlobalY = self.savedVars[zoneId][3]
		isFallbackValue = false
	end
	zoneMeasurement = self.ZoneMeasurement:New(GetZoneIndex(zoneId), zoneId,
						originGlobalX, originGlobalY, globalToWorldFactor, isFallbackValue)
	self.zoneMeasurements[zoneId] = zoneMeasurement
	return zoneMeasurement
end

function lib:GetCurrentZoneMeasurement()
	return self.currentZoneMeasurement
end
---------------------------------------------------------------------
-- coordinate conversion functions
-- first map to world coords
-- then world coords to map coords further below
---------------------------------------------------------------------

---
-- Expects a point given in global map coordinates and returns
-- the point's world x and z coords in relation to the current world origin.
function lib:GlobalToWorld(x, y)
	return self.currentZoneMeasurement:GlobalToWorld(x, y)
end

---
-- Expects a point given in local map coordinates and returns
-- the point's world x and z coords in relation to the current world origin.
function lib:LocalToWorld(x, y)
	x, y = GPS:LocalToGlobal(x, y)
	if not x then return nil end
	return self.currentZoneMeasurement:GlobalToWorld(x, y)
end

---
-- Expects a point given in world x and z coords in relation to the current world origin
-- and returns the point in global map coordinates
function lib:WorldToGlobal(x, z)
	return self.currentZoneMeasurement:WorldToGlobal(x, z)
end

---
-- Expects a point given in world x and z coords in relation to the current world origin
-- and returns the point in local map coordinates
function lib:WorldToLocal(x, z)
	x, z = self.currentZoneMeasurement:WorldToGlobal(x, z)
	x, z = GPS:GlobalToLocal(x, z)
	return x, z
end

function lib:LocalDistance2InMeters(x1, y1, x2, y2)
	local measurements = GPS:GetCurrentMapMeasurements()
	if not measurements then return nil end
	x1 = (x1 - x2) * measurements.scaleX
	y1 = (y1 - y2) * measurements.scaleY
	return (x1*x1 + y1*y1) * self.currentZoneMeasurement.globalToWorldFactor * self.currentZoneMeasurement.globalToWorldFactor
end

function lib:LocalDistanceInMeters(x1, y1, x2, y2)
	local measurements = GPS:GetCurrentMapMeasurements()
	if not measurements then return nil end
	x1 = (x1 - x2) * measurements.scaleX
	y1 = (y1 - y2) * measurements.scaleY
	return (x1*x1 + y1*y1)^0.5 * self.currentZoneMeasurement.globalToWorldFactor
end

function lib:GlobalDistance2InMeters(x1, y1, x2, y2)
	x1 = x1 - x2
	y1 = y1 - y2
	return (x1*x1 + y1*y1) * self.currentZoneMeasurement.globalToWorldFactor * self.currentZoneMeasurement.globalToWorldFactor
end

function lib:GlobalDistanceInMeters(...)
	return self.currentZoneMeasurement:GlobalDistanceInMeters(...)
end

---
-- Returns the camera position in render space coordinates
function lib:GetCameraRenderSpacePosition()
	Set3DRenderSpaceToCurrentCamera(self.measurementControl:GetName())
	return self.measurementControl:Get3DRenderSpaceOrigin()
end

---
-- Returns position, and the three basis vectors of the camera's render space (forward, right, up)
function lib:GetCameraRenderSpace()
	local measurementControl = self.measurementControl
	Set3DRenderSpaceToCurrentCamera(measurementControl:GetName())
	local x, y, z = measurementControl:Get3DRenderSpaceOrigin()
	local forwardX, forwardY, forwardZ = measurementControl:Get3DRenderSpaceForward()
	local rightX, rightY, rightZ = measurementControl:Get3DRenderSpaceRight()
	local upX, upY, upZ = measurementControl:Get3DRenderSpaceUp()
	return x, y, z, forwardX, forwardY, forwardZ, rightX, rightY, rightZ, upX, upY, upZ
end

function lib:ComputePlayerRenderSpacePosition()
	-- with the wrathstone update, the following api function was added
	local _, worldX, worldY, worldZ = GetUnitWorldPosition("player")
	worldX, worldY, worldZ = WorldPositionToGuiRender3DPosition(worldX, worldY, worldZ)
	return worldX, worldY, worldZ
end

---
-- Returns an approximation of the player's current world coordinates in relation to the current world origin
-- The returned values are the position of the first person camera.
-- If the toggle between first and third person camera doesn't work (i.e the player is mounted), then the third person camera's cooridnates are returned.
-- Note that calling this function will toggle the camera twice, which can result in screen flickering when called outside of a key <Down> or <Up> callback.
-- Use with care!
function lib:GetFirstPersonRenderSpacePosition()
	if IsMounted() then return end
	
	Set3DRenderSpaceToCurrentCamera(measurementControl:GetName())
	local preToggleX, preToggleY, preToggleZ = measurementControl:Get3DRenderSpaceOrigin()
	ToggleGameCameraFirstPerson()
	Set3DRenderSpaceToCurrentCamera(measurementControl:GetName())
	local toggledX, toggledY, toggledZ = measurementControl:Get3DRenderSpaceOrigin()
	ToggleGameCameraFirstPerson()
	Set3DRenderSpaceToCurrentCamera(measurementControl:GetName())
	local reToggleX, reToggleY, reToggleZ = measurementControl:Get3DRenderSpaceOrigin()
	
	local resultX, resultY, resultZ
	-- unfortunately there is no api function to get the current camera state (first person or third person)
	-- but for some reason the distance between the camera position before the first toggle and after the 2nd toggle
	-- is only zero, if the camera toggled from first person to third person to first person
	if preToggleX == reToggleX and preToggleY == reToggleY and preToggleZ == reToggleZ then
		-- the camera toggled from first person to third person to first person
		resultX, resultY, resultZ = preToggleX, preToggleY, preToggleZ -- first person coords
	else
		-- the camera toggled from third person to first person to third person
		resultX, resultY, resultZ = toggledX, toggledY, toggledZ -- first person coords
	end
	
	return resultX, resultY, resultZ
end

---
-- Returns true if the library can be used for the current zone
function lib:IsValidZone()
	return (self.currentZoneMeasurement ~= nil and self.currentZoneMeasurement:IsValid())
end
