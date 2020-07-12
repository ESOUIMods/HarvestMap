

local GPS = LibGPS2
local LAM = LibAddonMenu2

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local Farm = Harvest.farm
Farm.display = {}
local TourDisplay = Farm.display

function TourDisplay:Initialize()
	-- map link pool (minimap link pool is created in PositInitialize)
	self.linkPool = ZO_ControlPool:New("HarvestLink", ZO_WorldMapContainer, "Link")
	-- hack into the SetDimensions function as we need to scale the displayed path whenever the user zooms in/out
	local oldDimensions = ZO_WorldMapContainer.SetDimensions
	ZO_WorldMapContainer.SetDimensions = function(container, mapWidth, mapHeight, ...)
		local links = self.linkPool:GetActiveObjects()
		local startX, startY, endX, endY
		for _, link in pairs(links) do
			startX, startY, endX, endY = link.startX * mapWidth, link.startY * mapHeight, link.endX * mapWidth, link.endY * mapHeight
			ZO_Anchor_LineInContainer(link, nil, startX, startY, endX, endY)
		end
		oldDimensions(container, mapWidth, mapHeight, ...)
	end
	
	self:InitializeCallbacks()
end


function TourDisplay:InitializeCallbacks()
	CallbackManager:RegisterForEvent(Events.TOUR_CHANGED, function(event, path)
		self:Refresh(path, self.selectedPins, self.selectedMapCache)
	end)
	
	CallbackManager:RegisterForEvent(Events.TOUR_NODE_CLICKED, function(event, selectedPins, selectedMapCache)
		self:Refresh(self.path, selectedPins, selectedMapCache)
	end)
	
	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function() self:Refresh(self.path, self.selectedPins, self.selectedMapCache) end)
end

function TourDisplay:PostInitialize()
	if Fyr_MM_Scroll_Map then
		self.minimapPool = ZO_ControlPool:New("HarvestLink", Fyr_MM_Scroll_Map, "MiniLink")
	elseif AUI_MapContainer then
		self.minimapPool = ZO_ControlPool:New("HarvestLink", AUI_MapContainer, "MiniLink")
	end

	if Fyr_MM_Scroll_Map then
		local oldDimensionsMM = Fyr_MM_Scroll_Map.SetDimensions
		Fyr_MM_Scroll_Map.SetDimensions = function(container, mapWidth, mapHeight, ...)
			local links = self.minimapPool:GetActiveObjects()
			for _, link in pairs(links) do
				local startX, startY, endX, endY = link.startX * mapWidth, link.startY * mapHeight, link.endX * mapWidth, link.endY * mapHeight
				ZO_Anchor_LineInContainer(link, nil, startX, startY, endX, endY)
			end
			oldDimensionsMM(container, mapWidth, mapHeight, ...)
		end
	elseif AUI_MapContainer then
		local oldDimensionsMM = AUI_MapContainer.SetDimensions
		AUI_MapContainer.SetDimensions = function(container, mapWidth, mapHeight, ...)
			local links = self.minimapPool:GetActiveObjects()
			for _, link in pairs(links) do
				local startX, startY, endX, endY = link.startX * mapWidth, link.startY * mapHeight, link.endX * mapWidth, link.endY * mapHeight
				ZO_Anchor_LineInContainer(link, nil, startX, startY, endX, endY)
			end
			oldDimensionsMM(container, mapWidth, mapHeight, ...)
		end
		-- AUI's minimap doesn't seem to fire OnWorldMapChanged until the map is opened
		local oldRefresh = AUI.Minimap.Map.Refresh
		AUI.Minimap.Map.Refresh = function(...)
			self:Refresh(self.path)
			oldRefresh(...)
		end
	end
end


function TourDisplay:Refresh(path, selectedPins, selectedMapCache)
	self.path = path
	self.selectedPins = selectedPins
	self.selectedMapCache = selectedMapCache
	-- remove the displayed path and only draw a new one, if one was discovered
	self.linkPool:ReleaseAllObjects()
	if self.minimapPool then
		self.minimapPool:ReleaseAllObjects()
	end
	
	if selectedPins then
		local linkControl, nodeId, startX, startY, endX, endY
		local lastNodeId = selectedPins[1]
		local mapWidth, mapHeight = ZO_WorldMapContainer:GetDimensions()
		for index = 2, #selectedPins do
			nodeId = selectedPins[index]
			linkControl = self.linkPool:AcquireObject()
			linkControl.startX, linkControl.startY = GPS:GlobalToLocal(selectedMapCache.globalX[nodeId], selectedMapCache.globalY[nodeId])
			linkControl.endX, linkControl.endY = GPS:GlobalToLocal(selectedMapCache.globalX[lastNodeId], selectedMapCache.globalY[lastNodeId])
			if linkControl.startX < linkControl.endX then
				linkControl:SetTexture("HarvestMap/Textures/Map/tour_r.dds")
			else
				linkControl:SetTexture("HarvestMap/Textures/Map/tour_l.dds")
			end
			linkControl:SetColor(0,1,0,1)
			linkControl:SetDrawLevel(10)
			lastNodeId = nodeId
			
			startX, startY = linkControl.startX * mapWidth, linkControl.startY * mapHeight
			endX, endY = linkControl.endX * mapWidth, linkControl.endY * mapHeight
			ZO_Anchor_LineInContainer(linkControl, nil, startX, startY, endX, endY)
		end
	end
	
	if not path then
		return
	end
	-- check if we calculated the path for the currently displayed map
	if path.mapCache.map == Harvest.mapTools:GetMap() then
		-- create the line sections of the path
		-- each line section combines two points, so we need the previous point as well
		-- the "previous" point of the first point is the very last point of our tour.
		local lastIndex = path.numNodes
		local linkControl, startX, startY, endX, endY
		local mapWidth, mapHeight = ZO_WorldMapContainer:GetDimensions()
		for index = 1, path.numNodes do
			linkControl = self.linkPool:AcquireObject()
			linkControl.startX, linkControl.startY = path:GetLocalCoords(index)
			linkControl.endX, linkControl.endY = path:GetLocalCoords(lastIndex)
			if linkControl.startX < linkControl.endX then
				linkControl:SetTexture("HarvestMap/Textures/Map/tour_r.dds")
			else
				linkControl:SetTexture("HarvestMap/Textures/Map/tour_l.dds")
			end
			linkControl:SetColor(1,0,0,1)
			linkControl:SetDrawLevel(10)
			lastIndex = index
			
			startX, startY = linkControl.startX * mapWidth, linkControl.startY * mapHeight
			endX, endY = linkControl.endX * mapWidth, linkControl.endY * mapHeight
			ZO_Anchor_LineInContainer(linkControl, nil, startX, startY, endX, endY)
		end
		
		if self.minimapPool then
			for index = 1, path.numNodes do
				linkControl = self.minimapPool:AcquireObject()
				linkControl.startX, linkControl.startY = path:GetLocalCoords(index)
				linkControl.endX, linkControl.endY = path:GetLocalCoords(lastIndex)
				if linkControl.startX < linkControl.endX then
					linkControl:SetTexture("HarvestMap/Textures/Map/tour_r.dds")
				else
					linkControl:SetTexture("HarvestMap/Textures/Map/tour_l.dds")
				end
				linkControl:SetColor(1,0,0,1)
				linkControl:SetDrawLevel(10)
				lastIndex = index
			end
			
			if Fyr_MM_Scroll_Map then
				mapWidth, mapHeight = Fyr_MM_Scroll_Map:GetDimensions()
			else
				mapWidth, mapHeight = AUI_MapContainer:GetDimensions()
			end
			links = self.minimapPool:GetActiveObjects()
			for _, link in pairs(links) do
				local startX, startY, endX, endY = link.startX * mapWidth, link.startY * mapHeight, link.endX * mapWidth, link.endY * mapHeight
				ZO_Anchor_LineInContainer(link, nil, startX, startY, endX, endY)
			end
		end
	end
end