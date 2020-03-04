
local MapMetaData = ZO_Object:Subclass()
LibMapMetaData.MapMetaData = MapMetaData

local mapsWithoutMeasurement = {
	["Art/maps/tamriel/mundus_base_0.dds"] = true,
	[""] = true,
}

local lastMap, lastMapTexture
local function GetMap(mapTileTexture)
	if lastMapTileTexture ~= mapTileTexture then
		lastMapTileTexture = mapTileTexture
		mapTileTexture = string.lower(mapTileTexture)
		mapTileTexture = string.gsub(mapTileTexture, "^.*maps/", "")
		mapTileTexture = string.gsub(mapTileTexture, "_%d+%.dds$", "")

		if mapTileTexture == "eyevea_base" then
			mapTileTexture = "eyevea/" .. mapTileTexture
		end

		lastMap = mapTileTexture
	end
	return lastMap
end

function MapMetaData:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function MapMetaData:Initialize(mapTileTexture, mapMeasurement, parentMetaData, defaultZoneMeasurement)
	assert(mapTileTexture)
	assert(mapMeasurement or mapsWithoutMeasurement[mapTileTexture],
			"map measurement missing: " .. mapTileTexture)
	assert(defaultZoneMeasurement)
	
	self.map = GetMap(mapTileTexture)
	self.mapTileTexture = mapTileTexture
	self.mapMeasurement = mapMeasurement
	self.parentMetaData = parentMetaData
	self.defaultZoneMeasurement = defaultZoneMeasurement
	self.zoneMeasurements = {}
	
end

function MapMetaData:Notify(zoneMeasurement)
	for identifier, callback in pairs(MapMetaData.registeredCallbacks) do
		callback(self, zoneMeasurement)
	end
end

MapMetaData.registeredCallbacks = {}
function MapMetaData:RegisterCallback(identifier, callback)
	MapMetaData.registeredCallbacks[identifier] = callback
end

function MapMetaData:HasZoneMeasurement()
	return (next(self.zoneMeasurements) ~= nil)
end

function MapMetaData:HasGivenZoneMeasurement(zoneMeasurement)
	-- comparison with true, so nil becomes false
	return (self.zoneMeasurements[zoneMeasurement] == true)
end

function MapMetaData:AddZoneMeasurement(zoneMeasurement)
	assert(zoneMeasurement:IsValid())
	-- the different zones this map can belong to, should be somewhat similar
	--[[
	removed as this can actually happen: example the vulkhel guard map coresponds
	to both Temple of Auri-El and Auridon. these two zones have different measurements
	for previousZoneMeasurement in pairs(self.zoneMeasurements) do
	local errorString = zo_strformat("zone measurement are too different for a single map <<1>>, <<2>>, <<3>>, ",
				self.mapTileTexture, zoneMeasurement.zoneId, previousZoneMeasurement.zoneId)
		local dif
		dif = zo_abs(previousZoneMeasurement.globalToWorldFactor - zoneMeasurement.globalToWorldFactor)
		assert(dif < 10, errorString .. dif)
		dif = zo_abs(previousZoneMeasurement.originGlobalX - zoneMeasurement.originGlobalX)
		assert(dif < 0.01, errorString .. dif)
		dif = zo_abs(previousZoneMeasurement.originGlobalY - zoneMeasurement.originGlobalY)
		assert(dif < 0.01, errorString .. dif)
	end
	]]
	
	self.zoneMeasurements[zoneMeasurement] = true
	if not self:HasValidZoneMeasurement() then
		self.defaultZoneMeasurement = zoneMeasurement
	end
	if self.parentMetaData and self.parentMetaData.mapMeasurement then
		if self.parentMetaData.mapMeasurement.zoneIndex == zoneMeasurement.zoneIndex then
			self.parentMetaData:AddZoneMeasurement(zoneMeasurement)
		end
	end
	self:Notify(zoneMeasurement)
end


function MapMetaData:HasValidZoneMeasurement()
	return self.defaultZoneMeasurement:IsValid()
end

function MapMetaData:LocalDistanceInMeters(x1, y1, x2, y2)
	x1, y1 = self:LocalToGlobal(x1, y1)
	x2, y2 = self:LocalToGlobal(x2, y2)
	return self:GlobalDistanceInMeters(x1, y1, x2, y2)
end

local zoneMeasurementFunctions = {
	"GlobalToWorld", "WorldToGlobal", "GlobalDistanceInMeters", "MetersToGlobalDistance"
}
for _, funcName in pairs(zoneMeasurementFunctions) do
	local f = funcName
	MapMetaData[f] = function(self, ...)
		return self.defaultZoneMeasurement[f](self.defaultZoneMeasurement, ...)
	end
end

function MapMetaData:LocalToGlobal(localX, localY)
	local measurement = self.mapMeasurement
	local globalX = localX * measurement.scaleX + measurement.offsetX
	local globalY = localY * measurement.scaleY + measurement.offsetY
	return globalX, globalY
end

function MapMetaData:GlobalToLocal(globalX, globalY)
	local measurement = self.mapMeasurement
	local localX = (globalX - measurement.offsetX) / measurement.scaleX
	local localY = (globalY - measurement.offsetY) / measurement.scaleY
	return localX, localY
end

function MapMetaData:ConvertFrom(otherMetaData, localX, localY)
	return self:GlobalToLocal(otherMetaData:LocalToGlobal(localX, localY))
end
