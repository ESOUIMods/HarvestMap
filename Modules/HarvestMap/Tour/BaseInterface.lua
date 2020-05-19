
local GPS = LibGPS2

local Farm = {}
Harvest:RegisterModule("farm", Farm)

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Farm:Initialize()
	ZO_CreateStringId("SI_HARVEST_FARM_TITLE", Harvest.GetLocalization("farmmenu"))
	
	self.iconData = {
		categoryName = SI_HARVEST_FARM_TITLE,
		descriptor = "HarvestFarmScene",
		normal = "EsoUI/Art/inventory/inventory_tabicon_crafting_up.dds",
		pressed = "EsoUI/Art/inventory/inventory_tabicon_crafting_down.dds",
		highlight = "EsoUI/Art/inventory/inventory_tabicon_crafting_over.dds",
	}
	Harvest.menu:Register(self.iconData)
	
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, ...)
		if not self.path then return end
		if setting == "cacheCleared" then
			self:SetPath(nil)
		end
	end)
	
	CallbackManager:RegisterForEvent(Events.NODE_DELETED, function(event, map, pinTypeId, nodeId)
		if not self.path then return end
		if self.path.mapCache.map ~= map then return end
		if self.path:RemoveNode(nodeId) then
			self:SetPath(self.path)
		end
	end)
	
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_FINISHED, function(event, path)
		self:SetPath(path)
		if path and Harvest.mapPins.mapCache then
			if Harvest.mapPins.mapCache.map == path.mapCache.map then
				local x, y = path:GetLocalCoords(1)
				if x and y then
					GPS:PanToMapPosition(x, y)
				end
			end
		end
	end)
	
	-- initialization which is dependant on other addons is done on EVENT_PLAYER_ACTIVATED
	-- because harvestmap might've been loaded before them
	EVENT_MANAGER:RegisterForEvent("HarvestMap-Tour", EVENT_PLAYER_ACTIVATED,
		function()
			Harvest.farm:PostInitialize()
			EVENT_MANAGER:UnregisterForEvent("HarvestMap-Tour", EVENT_PLAYER_ACTIVATED)
		end)
	
	self.filters:Initialize() -- creates the filters on the left side of the map
	self.display:Initialize()
	self:InitializeTabs() -- creates the sub menus for generating, editing, saving etc
	self:InitializeScene() -- creates the editor scene
end

function Farm:SetPath(path)
	if self.path and path ~= self.path then
		self.path:Dispose()
	end
	self.path = path
	CallbackManager:FireCallbacks(Events.TOUR_CHANGED, path)
end

function Farm:PostInitialize()
	self.display:PostInitialize()
	self.helper:PostInitialize()
end

function Farm:InitializeScene()
	self.scene = ZO_Scene:New("HarvestFarmScene", SCENE_MANAGER)
	
	local heatmap
	self.scene:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_FRAGMENT_SHOWING) then
			heatmap = Harvest.IsHeatmapActive()
			if heatmap then
				Harvest.SetHeatmapActive(false)
			end
		elseif(newState == SCENE_FRAGMENT_HIDDEN) then
			if heatmap then
				Harvest.SetHeatmapActive(heatmap)
			end
		end
	end)
	
	-- Mouse standard position and background
	self.scene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
	self.scene:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)
	
	-- worldmap to display and edit the tour
	self.scene:AddFragment(WORLD_MAP_FRAGMENT)
	
	self.scene:AddFragment(WORLD_MAP_CORNER_FRAGMENT)
	self.scene:AddFragment(WORLD_MAP_ZOOM_FRAGMENT)
	self.scene:AddFragment(MAP_WINDOW_SOUNDS)
	
	--  Background Right, it will set ZO_RightPanelFootPrint and its stuff.
	self.scene:AddFragment(WORLD_MAP_INFO_BG_FRAGMENT)
	self.scene:AddFragment(THIN_LEFT_PANEL_BG_FRAGMENT)
	
	self.filterFragment = ZO_FadeSceneFragment:New(HarvestFarmFilter)
	self.scene:AddFragment(self.filterFragment)
	
	-- many addons and the default UI use calbacks for the worldmap scene, to do certain things whenever the map is displayed
	-- as our scene will display the map as well, we should copy all these callbacks
	ZO_PreHook(WORLD_MAP_SCENE, "RegisterCallback", function(_, ...)
		self.scene:RegisterCallback(...)
	end)
	for event, entries in pairs(WORLD_MAP_SCENE.callbackRegistry) do
		for _, entry in pairs(entries) do
			self.scene:RegisterCallback(event, entry[1], entry[2], entry[3])
		end
	end
	-- remove the story fragment in the tour editor
	self.scene:RegisterCallback("StateChange", function(oldState, newState)
		if newState == SCENE_SHOWING then
			SCENE_MANAGER:RemoveFragment(WORLD_MAP_ZONE_STORY_KEYBOARD_FRAGMENT)
		end
	end)
	-- an addon might check if the worldmap is open via SCENE_MANAGER:IsShowing("worldMap")
	local old_scene_showing = SCENE_MANAGER.IsShowing
	SCENE_MANAGER.IsShowing = function(self, scene, ...)
		if scene == "worldMap" then
			return old_scene_showing(self, scene, ...) or old_scene_showing(self, "HarvestFarmScene", ...)
		end
		return old_scene_showing(self, scene, ...)
	end
	local old_map_showing = WORLD_MAP_SCENE.IsShowing
	WORLD_MAP_SCENE.IsShowing = function(...)
		return old_map_showing(...) or self.scene:IsShowing()
	end
	
	-- Add the XML to our scene
	local MAIN_WINDOW = ZO_FadeSceneFragment:New(HarvestFarmMenu)
	self.scene:AddFragment(MAIN_WINDOW)
	
	MAIN_WINDOW:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_FRAGMENT_SHOWING) then
			self.modeBar:ShowLastFragment()
		elseif(newState == SCENE_FRAGMENT_HIDDEN) then
			self.modeBar:Clear()
		end
	end)
	
	self.scene:AddFragment(MAIN_MENU_KEYBOARD.categoryBarFragment)
	self.scene:AddFragment(TOP_BAR_FRAGMENT)
	
end

function Farm:InitializeTabs()
	local function CreateButtonData(normal, pressed, highlight)
		return {
			normal = normal,
			pressed = pressed,
			highlight = highlight,
		}
	end
	
	self.modeBar = ZO_SceneFragmentBar:New(HarvestFarmMenu:GetNamedChild("MenuBar"))
	
	-- generator
	-- add the generator icon the the button list
	local buttonData = {
		normal = "EsoUI/Art/TradingHouse/tradinghouse_browse_tabIcon_up.dds",
		pressed = "EsoUI/Art/TradingHouse/tradinghouse_browse_tabIcon_down.dds",
		disabled = "EsoUI/Art/TradingHouse/tradinghouse_browse_tabIcon_disabled.dds",
		highlight = "EsoUI/Art/TradingHouse/tradinghouse_browse_tabIcon_over.dds",
	}
	local farmFragment = ZO_FadeSceneFragment:New(HarvestFarmGenerator)
	self.modeBar:Add(HARVESTFARM_GENERATOR, {farmFragment}, buttonData)
	-- add this as the default tab
	self.modeBar:SetStartingFragment(HARVESTFARM_GENERATOR)
	self.generator:Initialize(farmFragment)
	
	-- edit
	buttonData = {
		normal = "EsoUI/Art/Crafting/smithing_tabIcon_research_up.dds",
		pressed = "EsoUI/Art/Crafting/smithing_tabIcon_research_down.dds",
		highlight = "EsoUI/Art/Crafting/smithing_tabIcon_research_over.dds",
		disabled = "EsoUI/Art/Crafting/smithing_tabIcon_research_disabled.dds",
	}
	farmFragment = ZO_FadeSceneFragment:New(HarvestFarmEditor)
	self.modeBar:Add(HARVESTFARM_EDITOR, {farmFragment}, buttonData)
	self.editor:Initialize(farmFragment)
	
	-- helper
	buttonData = {
		normal = "EsoUI/Art/TradingHouse/tradinghouse_listings_tabIcon_up.dds",
		pressed = "EsoUI/Art/TradingHouse/tradinghouse_listings_tabIcon_down.dds",
		disabled = "EsoUI/Art/TradingHouse/tradinghouse_listings_tabIcon_disabled.dds",
		highlight = "EsoUI/Art/TradingHouse/tradinghouse_listings_tabIcon_over.dds",
	}
	farmFragment = ZO_FadeSceneFragment:New(HarvestFarmHelper)
	--self.modeBar:Add(HARVESTFARM_HELPER, {farmFragment}, buttonData)
	self.helper:Initialize(farmFragment)
	
	-- save/load
	buttonData = {
		normal = "EsoUI/Art/Guild/tabIcon_history_up.dds",
		pressed = "EsoUI/Art/Guild/tabIcon_history_down.dds",
		disabled = "EsoUI/Art/Guild/tabIcon_history_disabled.dds",
		highlight = "EsoUI/Art/Guild/tabIcon_history_over.dds",
	}
	farmFragment = ZO_FadeSceneFragment:New(HarvestFarmLoader)
	self.modeBar:Add(HARVESTFARM_SAVE, {farmFragment}, buttonData)
	self.loader:Initialize(farmFragment)
	
end



