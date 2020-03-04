
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local MapMode = {}
Harvest:RegisterModule("mapMode", MapMode)

local MINIMAP = "minimap"
local WORLDMAP = "worldmap"
local NO_MAP = "no map"

function MapMode:Initialize()

	self.currentMode = MINIMAP
	
	local previousOnHideHandler = ZO_WorldMap:GetHandler("OnHide")
	local previousOnShowHandler = ZO_WorldMap:GetHandler("OnShow")
	ZO_WorldMap:SetHandler("OnHide", function(...)
		self:CheckModeAndNotifty()
		if previousOnHideHandler then previousOnHideHandler(...) end
	end)
	ZO_WorldMap:SetHandler("OnShow", function(...)
		self:CheckModeAndNotifty()
		if previousOnShowHandler then previousOnShowHandler(...) end
	end)
	
	local stateChangeCallback = function(oldState, newState)
		if newState == SCENE_SHOWING then
			self:CheckModeAndNotifty()
		elseif newState == SCENE_HIDING then
			self:CheckModeAndNotifty()
		end
	end 
	WORLD_MAP_SCENE:RegisterCallback("StateChange", stateChangeCallback)
	GAMEPAD_WORLD_MAP_SCENE:RegisterCallback("StateChange", stateChangeCallback)
end

function MapMode:CheckModeAndNotifty()
	local isMinimap = self:IsInMinimapMode()
	local currentMode = NO_MAP
	if isMinimap then
		currentMode = MINIMAP
	elseif not ZO_WorldMap:IsHidden() then
		currentMode = WORLDMAP
	end
	if currentMode ~= self.currentMode then
		self.currentMode = currentMode
		self:Debug("new map mode:", currentMode)
		CallbackManager:FireCallbacks(Events.MAP_MODE_CHANGED, currentMode)
	end
end

function MapMode:IsInMinimapMode()
	local isMinimap = false
	if not ZO_WorldMap_IsWorldMapShowing() then -- minimap
		isMinimap = FyrMM or (AUI and AUI.Minimap:IsEnabled()) or VOTANS_MINIMAP
	end
	return isMinimap
end


