
local GPS = LibStub("LibGPS2")
local MapTools = {}
Harvest:RegisterModule("mapTools", MapTools)

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function MapTools:Initialize()
	self.mapBlacklist = {
		["tamriel/tamriel"] = true,
		["tamriel/mundus_base"] = true,
	}
end

function MapTools:GetMap()
	local textureName = GetMapTileTexture()
	if self.lastMapTexture ~= textureName then
		self.lastMapTexture = textureName
		textureName = string.lower(textureName)
		textureName = string.gsub(textureName, "^.*maps/", "")
		textureName = string.gsub(textureName, "_%d+%.dds$", "")

		if textureName == "eyevea_base" then
			textureName = "eyevea/" .. textureName
		end

		self.lastMap = textureName
	end
	return self.lastMap
end

function MapTools:IsMapBlacklisted( map )
	return self.mapBlacklist[map]
end

function MapTools:SetMapToPlayerLocation()
	--[[
	There is a bug that can happen when you traverse city/zone borders.
	Reproduction:
	Login in city. View map and zoom out to zone. Close map. Leave city.
	Next SetMapToPlayerLocation will move the map to city instead of the zone.
	This function is to fix that issue...
	]]
	SetMapToPlayerLocation()
	local localX, localY, heading = GetMapPlayerPosition("player")
	local playerZoneIndex = GetUnitZoneIndex("player")
	local mapZoneIndex = GetCurrentMapZoneIndex()
	
	-- if we can click on the player location, then we are probably erroneously viewing a zone map
	-- (exception is hew's bane where we can click outside of abahs landing and it will open abahs landing)
	if WouldProcessMapClick(localX, localY) then
		self:Warn("Had to perform a map click: %s, %f, %f", GetMapTileTexture(), localX, localY )
		ProcessMapClick(localX, localY)
		localX, localY, heading = GetMapPlayerPosition("player")
	end
	
	if localX < 0 or localX > 1 or localY < 0 or localY > 1 then
		self:Warn("Player coordinates out of bound: %s, %f, %f", GetMapTileTexture(), localX, localY )
		-- the player is not visible on the current map,
		-- then we should use the parent map
		if MapZoomOut() == SET_MAP_RESULT_MAP_CHANGED then
			-- if the currently viewed map zone index is identical to neither
			-- the original map zone index or the player's zone index, then
			-- it probably has nothing to do with the player location
			-- so just use SetMapToPlayerLocation() instead
			local newMapZoneIndex = GetCurrentMapZoneIndex()
			if newMapZoneIndex ~= mapZoneIndex or newMapZoneIndex ~= playerZoneIndex then
				self:Warn("Reset player location. mapZoneIndices: %d, %d, playerZoneIndex: %d.",
						newMapZoneIndex, mapZoneIndex, playerZoneIndex )
				SetMapToPlayerLocation()
			end
		end
	end
end

function MapTools:GetPlayerMapMetaDataAndLocalPosition()
	local originalMap = GetMapTileTexture()

	self:SetMapToPlayerLocation()
	local mapMetaData, localX, localY, heading = self:GetViewedMapMetaDataAndPlayerLocalPosition()

	if GetMapTileTexture() ~= originalMap then
		CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
	end
	
	return mapMetaData, localX, localY, heading
end

function MapTools:GetViewedMapMetaDataAndPlayerLocalPosition()
	
	local localX, localY, heading = GetMapPlayerPosition("player")
	local mapMetaData = LibMapMetaData:GetCurrentMapMetaData()
	
	return mapMetaData, localX, localY, heading
end
