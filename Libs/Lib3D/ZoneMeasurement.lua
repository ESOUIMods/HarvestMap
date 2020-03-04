
local ZoneMeasurement = ZO_Object:Subclass()
Lib3D.ZoneMeasurement = ZoneMeasurement

function ZoneMeasurement:New(...)
	local obj = ZO_Object.New(self)
	obj:Initialize(...)
	return obj
end

function ZoneMeasurement:Initialize(zoneIndex, zoneId, originGlobalX, originGlobalY, globalToWorldFactor, isFallbackValue)
	assert(globalToWorldFactor, "No global to world factor given")
	self.zoneIndex = zoneIndex
	self.zoneId = zoneId
	self.originGlobalX = originGlobalX
	self.originGlobalY = originGlobalY
	self.globalToWorldFactor = globalToWorldFactor
	self.worldToGlobalFactor = 1 / globalToWorldFactor
	self.isFallbackValue = isFallbackValue
end

function ZoneMeasurement:IsValid()
	return (self.originGlobalX ~= nil and self.originGlobalY ~= nil and self.globalToWorldFactor ~= nil)
end

function ZoneMeasurement:GlobalDistanceInMeters(x1, y1, x2, y2)
	x1 = x1 - x2
	y1 = y1 - y2
	return (x1 * x1 + y1 * y1)^0.5 * self.globalToWorldFactor
end

function ZoneMeasurement:MetersToGlobalDistance(meters)
	return meters * self.worldToGlobalFactor
end

function ZoneMeasurement:GlobalToWorld(globalX, globalY)
	local worldX = (globalX - self.originGlobalX) * self.globalToWorldFactor
	local worldZ = (globalY - self.originGlobalY) * self.globalToWorldFactor
	return worldX, worldZ
end

function ZoneMeasurement:WorldToGlobal(worldX, worldZ)
	local globalX = worldX * self.worldToGlobalFactor + self.originGlobalX
	local globalY = worldZ * self.worldToGlobalFactor + self.originGlobalY
	return globalX, globalY
end

Lib3D.defaultZoneMeasurement = ZoneMeasurement:New(nil, nil, nil, nil, Lib3D.DEFAULT_GLOBAL_TO_WORLD_FACTOR, true )
