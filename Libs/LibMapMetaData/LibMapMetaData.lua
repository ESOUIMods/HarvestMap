
local LIB_NAME = "LibMapMetaData"
LibMapMetaData = {}

local GPS = LibStub("LibGPS2")

local lib = LibMapMetaData

function lib:RegisterCallback(...)
	LibMapMetaData.MapMetaData:RegisterCallback(...)
end

local function ComputeMapMetaData()
	local zoneMeasurement = nil
	local x, y = GetMapPlayerPosition("player")
	if DoesCurrentMapMatchMapForPlayerLocation() then--and 0 < x and x < 1 and 0 < y and y < 1 then
		zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
	end
	local tileTexture = GetMapTileTexture()
	local measurement = GPS:GetCurrentMapMeasurements()
	
	if lib.mapMetaData[tileTexture] then
		return lib.mapMetaData[tileTexture]
	end
	
	local parentMapMetaData
	if MapZoomOut() == SET_MAP_RESULT_MAP_CHANGED then
		parentMapMetaData = ComputeMapMetaData()
	end
	local mapMetaData = lib.MapMetaData:New(
			tileTexture, measurement,
			parentMapMetaData, Lib3D.defaultZoneMeasurement)
	lib.mapMetaData[tileTexture] = mapMetaData
	if zoneMeasurement then
		mapMetaData:AddZoneMeasurement(zoneMeasurement)
	end
	return mapMetaData
end

local function HasMetaData()
	local mapMetaData = lib.mapMetaData[GetMapTileTexture()]
	if mapMetaData then
		local x, y = GetMapPlayerPosition("player")
		if DoesCurrentMapMatchMapForPlayerLocation() then--and 0 < x and x < 1 and 0 < y and y < 1 then
			local zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
			if zoneMeasurement and not mapMetaData:HasGivenZoneMeasurement(zoneMeasurement) then
				mapMetaData:AddZoneMeasurement(zoneMeasurement)
			end
		end
		return true
	end
end
	
local function ConstructMetaDataForCurrentMap(parentMapMetaData)
	local tileTexture = GetMapTileTexture()
	local zoneMeasurement = nil
	if DoesCurrentMapMatchMapForPlayerLocation() then
		zoneMeasurement = Lib3D:GetCurrentZoneMeasurement()
	end
	local measurement = GPS:GetCurrentMapMeasurements()
	local mapMetaData = lib.MapMetaData:New(
			tileTexture, measurement,
			parentMapMetaData, Lib3D.defaultZoneMeasurement)
	lib.mapMetaData[tileTexture] = mapMetaData
	if zoneMeasurement then
		mapMetaData:AddZoneMeasurement(zoneMeasurement)
	end
end

local function HookSetMapToFunction(funcName)
	local origFunction = _G[funcName]
	_G[funcName] = function(...)
		local result = origFunction(...)
		
		if HasMetaData() then return result end
		
		local mapMetaData = ComputeMapMetaData()
		
		origFunction(...)
		return result
	end
end

local function HookSetMapToPlayerLocation()
	local origSetMapToPlayerLocation = SetMapToPlayerLocation
	SetMapToPlayerLocation = function(...)
		local result = origSetMapToPlayerLocation(...)
		
		if HasMetaData() then return result end
		
		local mapMetaData = ComputeMapMetaData()
		
		origSetMapToPlayerLocation(...)
		return result
	end
end

local function HookProcessMapClick()
	origProcessMapClick = ProcessMapClick
	ProcessMapClick = function(...)
		local parentMapMetaData = lib:GetCurrentMapMetaData()
		local result = origProcessMapClick(...)
		
		if HasMetaData() then return result end
		
		if result == SET_MAP_RESULT_MAP_CHANGED then
			ConstructMetaDataForCurrentMap(parentMapMetaData)
		end
		return result
	end
end

local function HookProcessMapClick()
	origProcessMapClick = ProcessMapClick
	ProcessMapClick = function(...)
		local parentMapMetaData = lib:GetCurrentMapMetaData()
		local result = origProcessMapClick(...)
		
		if HasMetaData() then return result end
		
		if result == SET_MAP_RESULT_MAP_CHANGED then
			ConstructMetaDataForCurrentMap(parentMapMetaData)
		end
		return result
	end
end

local function HookSetMapFloor()
	origSetMapFloor = SetMapFloor
	SetMapFloor = function(...)
		local parentMapMetaData = lib:GetCurrentMapMetaData().parentMetaData
		local result = origSetMapFloor(...)
		if HasMetaData() then return result end
		
		if result == SET_MAP_RESULT_MAP_CHANGED then
			ConstructMetaDataForCurrentMap(parentMapMetaData)
		end
		return result
	end
end

function lib:GetCurrentMapMetaData()
	local mapMetaData = self.mapMetaData[GetMapTileTexture()]
	if not mapMetaData then -- no idea how this happens. Maybe if an addon has a local reference?
		GPS:PushCurrentMap()
		mapMetaData = ComputeMapMetaData()
		GPS:PopCurrentMap()
	end
	return mapMetaData
end

local function OnAddOnLoaded(_, addOnName)
	if addOnName ~= LIB_NAME then return end
	
    HookSetMapToFunction("SetMapToMapListIndex")
	HookSetMapToFunction("SetMapToQuestCondition")
	HookSetMapToFunction("SetMapToQuestStepEnding")
	HookSetMapToFunction("SetMapToQuestZone")
	HookSetMapToFunction("SetMapToPlayerLocation")
	HookSetMapToFunction("SetMapToAutoMapNavigationTargetPosition")
	HookSetMapFloor()
	HookProcessMapClick()
	--HookSetMapToPlayerLocation()--Function("SetMapToPlayerLocation")
	
	lib.mapMetaData = {}
	if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	
	-- set the map once, to get some zone information
	Lib3D:RegisterWorldChangeCallback(LIB_NAME, function()
		if SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED then
			CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
		end
	end)
end

EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
