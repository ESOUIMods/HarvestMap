-- The below code is based on my other addon "TrueExploration"
-- http://www.esoui.com/downloads/info500-TrueExploration.html
HarvestHeat = {}
local HarvestHeat = _G["HarvestHeat"]
HarvestHeat.heatMap = {} -- heat map is calculated in HarvestMapHeatCalc.lua
HarvestHeat.maxHeat = 1 -- this value is calculated in HarvestMapHeatCalc.lua as well
HarvestHeat.numSubdivisions = 36 -- number
HarvestHeat.red = { 1, 0, 0, 0.5 } -- rgba format
HarvestHeat.yellow = { 1, 1, 0, 0.5 }
HarvestHeat.green = { 0, 1, 0, 0.5}
HarvestHeat.blue = { 0, 1, 0, 0} -- not blue (anymore), this variable is lying!
-- instead of displaying blue, let the green fade out so the player can see more of the map
HarvestHeat.mapTiles = {} -- list to store the heatmap tiles in
HarvestHeat.needsRefresh = true

-- The map will be divided into (numSubdivisions x numSubdivisions) sections.
-- Each section has a heat value which is stored in HarvestHeat.heatMap.
-- In order to create a gradient effect between two of such divisions, we create
-- rectangular tiles. 
-- The corners of each tile are located at the center of 4 adjacent sections.
-- This way we can create the fading effect by setting the vertex colors appropiate
-- to the corner's section's heat value.
local MapTile = ZO_Object:Subclass()
function MapTile:New( ... )
	local result = ZO_Object.New(self)
	result:Initialize( ... )
	return result
end

function MapTile:Initialize( index )
	-- the number of this tile (tiles are  numbered line-wise)
	self.index = index
	-- the texture control which will have its vertex colors manipulated
	self.control = CreateControlFromVirtual("HM_Unit"..tostring(index), ZO_WorldMapContainer, "HM_MapTile")
	-- we associate each tile with the bottom right corner's section
	-- calculate the x and y value of this associated section
	self.logicX = zo_mod(index, HarvestHeat.numSubdivisions + 1)
	self.logicY = zo_floor(index / (HarvestHeat.numSubdivisions + 1))
	-- translate this tile a bit to the left top, as each tile will display a value depending on 4 surrounding sections
	self.x = self.logicX - 0.5
	self.y = self.logicY - 0.5
	-- add the correct adjacent tiles, that change their graphic depending on this tile's section in order to create the gradient effect
	if self.y > 0 then -- the first line of tiles don't have other tiles above them, so link them with themselves instead
	self.top = HarvestHeat.mapTiles[index - HarvestHeat.numSubdivisions - 1]
	else
		self.top = self
	end
	if self.x > 0 then
		self.left = HarvestHeat.mapTiles[index - 1]
	else
		self.left = self
	end
	if self.y > 0 and self.x > 0 then
		self.topleft = HarvestHeat.mapTiles[index - HarvestHeat.numSubdivisions - 2]
	else
		self.topleft = self
	end
	-- default color. The correct color will be calculated later when it's actually needed.
	self.color = {0, 0, 0, 1}
end

-- sets the layout of this tile's texture
-- sets, position, width, height and the correct parent (needed for minimap - worldmap transition, though that's not fully implemented yet!)
function MapTile:SetLayout( width, height, parent )
	self.control:SetAnchor(TOPLEFT, parent, TOPLEFT, self.x * width, self.y * height)
	self.control:SetParent(parent)
	self.control:SetDimensions(width, height)
	self.control:SetTextureCoords(self.x / HarvestHeat.numSubdivisions,
		(self.x+1) / HarvestHeat.numSubdivisions,
		self.y / HarvestHeat.numSubdivisions,
		(self.y+1) / HarvestHeat.numSubdivisions)
end

-- refreshes this tile's color value depending on the associated section's heat value
function MapTile:RefreshColor()
	local heat = self:GetHeat()
	if heat > HarvestHeat.GetRedThreshold() then
		self.color = HarvestHeat.red
	elseif heat > HarvestHeat.GetYellowThreshold() then
		self.color = HarvestHeat.yellow
	elseif heat > HarvestHeat.GetGreenThreshold() then
		self.color = HarvestHeat.green
	else
		self.color = HarvestHeat.blue
	end
end

function HarvestHeat.GetRedThreshold()
	return 0.75
end

function HarvestHeat.GetYellowThreshold()
	return 0.5
end

function HarvestHeat.GetGreenThreshold()
	return 0.25
end

-- returns the heat value of this tile's associated section's heat value
function MapTile:GetHeat()
	return ((HarvestHeat.heatMap[self.logicX] or {})[self.logicY] or 0) / HarvestHeat.maxHeat
end

-- Sets the color/opacity of the 4 corners of this tile's texture
-- The color is used from the MapTile.color field and should be calculated earlier!
-- Call MapTile:RefreshColor() before this method!
function MapTile:SetTileColor()
	-- color of the associated section
	self.control:SetVertexColors(VERTEX_POINTS_BOTTOMRIGHT , unpack(self.color) )
	-- color of the neigbors for gradient effect
	self.control:SetVertexColors(VERTEX_POINTS_BOTTOMLEFT , unpack(self.left.color) )
	self.control:SetVertexColors(VERTEX_POINTS_TOPRIGHT , unpack(self.top.color) )
	self.control:SetVertexColors(VERTEX_POINTS_TOPLEFT , unpack(self.topleft.color) )
end

-- set all tiles as hidden
function HarvestHeat.HideTiles()
	if not HarvestHeat.initialized then
		return
	end
	for _, control in pairs( HarvestHeat.mapTiles ) do
		control.control:SetHidden(true)
	end
end

-- hides/shows the heatmap tiles and recalculates their color value if they are shown
function HarvestHeat.RefreshTiles()
	if not HarvestHeat.initialized then
		return
	end
	if not Harvest.IsHeatmapActive() then
		HarvestHeat.HideTiles()
		return
	end
	if HarvestHeat.needsRefresh then
		HarvestHeat.CalculateHeatMap()
	end
	HarvestHeat.UpdateTiles()
end

-- update all MapTiles' data and visuals
function HarvestHeat.UpdateTiles()
	-- update the color field of all the map tiles
	for _, control in pairs( HarvestHeat.mapTiles ) do
		control.control:SetHidden(false)
		control:RefreshColor()
	end
	-- adopt the color for all MapTile's textures
	for _, control in pairs( HarvestHeat.mapTiles ) do
		control:SetTileColor()
	end
end

-- only refreshes the heatmap if it is currently viewed (the map is open)
-- otherwise mark the heatmap as outdated so it will be refreshed when the map is opened
function HarvestHeat.RefreshHeatmap()
	if not Harvest.IsHeatmapActive() then
		return
	end
	HarvestHeat.needsRefresh = true
	if not ZO_WorldMap:IsHidden() then --ZO_WorldMap_IsWorldMapShowing() then
		HarvestHeat.RefreshTiles()
	end
end

function HarvestHeat.Initialize()
	if HarvestHeat.initialized then
		return
	end
	local function OnNodeChanged(event, mapCache, nodeId)
		if mapCache.pinTypeId[nodeId] == Harvest.UNKNOWN then return end
		HarvestHeat.RefreshHeatmap()
	end
	CALLBACK_MANAGER:RegisterCallback( "OnWorldMapChanged", HarvestHeat.RefreshHeatmap)
	Harvest.callbackManager:RegisterForEvent(Harvest.events.NODE_ADDED, OnNodeChanged)
	Harvest.callbackManager:RegisterForEvent(Harvest.events.NODE_UPDATED, OnNodeChanged)
	Harvest.callbackManager:RegisterForEvent(Harvest.events.NODE_DELETED, OnNodeChanged)
	Harvest.callbackManager:RegisterForEvent(Harvest.events.FILTER_PROFILE_CHANGED, function(event, profile)
		if profile == Harvest.mapPins.filterProfile then
			HarvestHeat.RefreshHeatmap()
		end
	end)
	-- the fade in animation of the world map messes up the alpha values of the heat map
	-- so display the heatmap after the map finished its fade in animation
	local mapscene = SCENE_MANAGER:GetScene("worldMap")
	mapscene:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_SHOWN) then -- when the map has finished fading in
			HarvestHeat.RefreshTiles()
		elseif newState == SCENE_HIDING then
			HarvestHeat.HideTiles()
		end
	end)
	-- again, this time for the gamepad
	mapscene = SCENE_MANAGER:GetScene("gamepad_worldMap")
	mapscene:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_SHOWN) then -- when the map has finished fading in
			HarvestHeat.RefreshTiles()
		elseif newState == SCENE_HIDING then
			HarvestHeat.HideTiles()
		end
	end)
	-- update the size of the tiles when the map is zoomed
	local oldDimensions = ZO_WorldMapContainer.SetDimensions
	ZO_WorldMapContainer.SetDimensions = function(self, mapWidth, mapHeight, ...)
		local tileWidth = mapWidth / HarvestHeat.numSubdivisions
		local tileHeight = mapHeight / HarvestHeat.numSubdivisions
		local x, y
		for index = 0, ((HarvestHeat.numSubdivisions+1)*(HarvestHeat.numSubdivisions+1) - 1) do
			HarvestHeat.mapTiles[index]:SetLayout( tileWidth, tileHeight, self )
		end
		oldDimensions(self, mapWidth, mapHeight, ...)
	end
	-- create the tiles
	for index = 0, ((HarvestHeat.numSubdivisions+1)*(HarvestHeat.numSubdivisions+1) - 1) do
		HarvestHeat.mapTiles[index] = MapTile:New( index )
	end
	local mapWidth, mapHeight = ZO_WorldMapContainer:GetDimensions()
	local tileWidth = mapWidth / HarvestHeat.numSubdivisions
	local tileHeight = mapHeight / HarvestHeat.numSubdivisions
	local x, y
	for index = 0, ((HarvestHeat.numSubdivisions+1)*(HarvestHeat.numSubdivisions+1) - 1) do
		HarvestHeat.mapTiles[index]:SetLayout( tileWidth, tileHeight, ZO_WorldMapContainer )
	end
	HarvestHeat.initialized = true
	HarvestHeat.HideTiles()
	-- when the color is set immediately, the alpha value might get replaced by the control initialization
	-- delay the color refresh until the next frame to prevent this
	zo_callLater(HarvestHeat.RefreshHeatmap, 500)
end