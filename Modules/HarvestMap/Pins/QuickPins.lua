
local LIB_NAME = "LibQuickPin2"
local LIB_VERSION = 1
local lib = {}
assert(not _G[LIB_NAME], "QuickPins were loaded twice!")
_G[LIB_NAME] = lib

--[[
Not for general use. This lib is tailored for HarvestMap.

This lib increases the performance when displaying thousands of pins.
- creating 2000 pins is reduced from 600 ms to 10ms on live and 60ms to 7ms on PTS (Summerset)
Main technical differences:
- Each pin is only a single texture control (ZOS' pins are 3 controls) which reduces the cost when changing the offset of a pins' anchor
- No ClearAnchor() to remove the need for ZOS' internal cycle detection when re-anchoring the pins (immense cost reduction on live)
- Reusing controls of the same pinType to remove the slow calls to SetTexture(...)
- Pre-pooling/creation of controls during the loading screen, because the first creations of controls is slow, but just changing the offset of a control's anchor is fast.
]]


local QP_MapPin = ZO_Object:Subclass()
lib.QP_MapPin = QP_MapPin
QP_MapPin.pinId = 1
QP_MapPin.angle = 0

--[[
function QP_MapPin:SetRotationInfo(angle, offsetX, offsetY)
	self.angle = angle
	self.cos = math.cos(angle)
	self.sin = math.sin(angle)
	self.offsetX = offsetX
	self.offsetY = offsetY
end
]]

function QP_MapPin:New(layout)
    local pin = ZO_Object.New(self)
	
    local control = CreateControlFromVirtual("QP_MapPin" .. self.pinId, lib.container, "QP_MapPin")--CT_TEXTURE)
	control:SetPixelRoundingEnabled(false)
	--control:SetMouseEnabled(true)
	--control:SetHandler("OnMouseDown", QP_MapPin.OnMouseDown)
	--control:SetHandler("OnMouseUp", QP_MapPin.OnMouseUp)
	--control:SetHandler("OnMouseEnter", QP_MapPin.OnMouseEnter)
	--control:SetHandler("OnMouseExit", QP_MapPin.OnMouseExit)
	--control:SetAnchor(CENTER, lib.container, TOPLEFT, 0, 0)
	control.OnMouseDown = QP_MapPin.OnMouseDown
	control.OnMouseUp = QP_MapPin.OnMouseUp
	control.OnMouseEnter = QP_MapPin.OnMouseEnter
	control.OnMouseExit = QP_MapPin.OnMouseExit
		
    control.m_Pin = pin
    pin.m_Control = control
	pin.m_layout = layout
	pin:RefreshLayout()
	
    self.pinId = self.pinId + 1
	lib.numCreatedPins = lib.numCreatedPins + 1
    return pin
end

function QP_MapPin:OnMouseEnter(...)
	self.m_Pin:SetTargetScale(1.3)
end

function QP_MapPin:OnMouseExit()
	self.m_Pin:SetTargetScale(1)
end

function QP_MapPin:SetTargetScale(targetScale)
    if((self.targetScale ~= nil and targetScale ~= self.targetScale) or (self.targetScale == nil and targetScale ~= self.m_Control:GetScale())) then
        self.targetScale = targetScale
        EVENT_MANAGER:RegisterForUpdate(self.m_Control:GetName(), 0, function()
            local newScale = zo_deltaNormalizedLerp(self.m_Control:GetScale(), self.targetScale, 0.17)
            if(zo_abs(newScale - self.targetScale) < 0.01) then
                self.m_Control:SetScale(self.targetScale)
                self.targetScale = nil
                EVENT_MANAGER:UnregisterForUpdate(self.m_Control:GetName())
            else
                self.m_Control:SetScale(newScale)
            end
        end)
		
    end
end

function QP_MapPin:OnMouseDown(button, ctrl, alt, shift, command)
	if button == MOUSE_BUTTON_INDEX_LEFT then
		for i, handler in ipairs(self.m_Pin.m_layout.OnClickHandler) do
			if (not handler.show) or handler.show(self.m_Pin) then
				return
			end
		end
	end
	ZO_WorldMap_MouseDown(button, ctrl, alt, shift)
end


function QP_MapPin:OnMouseUp(button, upInside, ctrl, alt, shift, command)
	if upInside and button == MOUSE_BUTTON_INDEX_LEFT then
		for i, handler in ipairs(self.m_Pin.m_layout.OnClickHandler) do
			if (not handler.show) or handler.show(self.m_Pin) then
				handler.callback(self.m_Pin, button)
				return
			end
		end
	end
	ZO_WorldMap_MouseUp(ZO_WorldMapContainer, button, MouseIsOver(ZO_WorldMapScroll))
end

function QP_MapPin:RefreshLayout()
	local control = self.m_Control
	local layout = self.m_layout
	control:SetTexture(layout.texture)
	control:SetDrawLevel(zo_max(layout.level, 1))

	if(layout.tint) then
		control:SetColor(self.m_layout.tint:UnpackRGB())
	else
		control:SetColor(1, 1, 1, 1)
	end
end

function QP_MapPin:GetPinTypeAndTag()
	return self.m_PinType, self.m_PinTag
end

function QP_MapPin:SetData(pinType, pinTag)
	self.m_PinType = pinType
	self.m_PinTag = pinTag
end

function QP_MapPin:ClearData()
	self.m_PinType = nil
    self.m_PinTag = nil
end

local MIN_PIN_SIZE = 8
function QP_MapPin:UpdateSize()
	local size = self.m_layout.currentPinSize
	self.m_Control:SetDimensions(size, size)
	local inset = 0.25 * size
	self.m_Control:SetHitInsets(inset, inset, -inset, -inset)
end

function QP_MapPin:UpdateLocation()
	--if QP_MapPin.angle == 0 then
		self.m_Control:SetAnchor(CENTER, lib.container, TOPLEFT,
			self.normalizedX * lib.MAP_WIDTH,
			self.normalizedY * lib.MAP_HEIGHT)
	--[[else
		local x = self.normalizedX * lib.MAP_WIDTH - QP_MapPin.offsetX
		local y = self.normalizedY * lib.MAP_HEIGHT - QP_MapPin.offsetY
		local rotatedX = QP_MapPin.cos * x - QP_MapPin.sin * y --+ QP_MapPin.playerX
		local rotatedY = QP_MapPin.sin * x + QP_MapPin.cos * y --+ QP_MapPin.playerY
		self.m_Control:SetAnchor(CENTER, lib.container, TOPLEFT,
			rotatedX,
			rotatedY)
	end]]
end
QP_MapPin.OriginalUpdateLocation = QP_MapPin.UpdateLocation

function QP_MapPin:SetLocation(xLoc, yLoc)
    self.m_Control:SetHidden(false)

    self.normalizedX = xLoc
    self.normalizedY = yLoc

    self:UpdateLocation()
    self:UpdateSize()
end


local MAIN_MAP_MODE = {
	Activate = function(self)
		lib.container:ClearAnchors()
		lib.container:SetAnchor(TOPLEFT, ZO_WorldMapContainer, TOPLEFT, 0, 0)
		lib.container:SetParent(ZO_WorldMapContainer)
		QP_MapPin.UpdateLocation = QP_MapPin.OriginalUpdateLocation
	end,
	GetDimensions = function(self)
		return ZO_WorldMapContainer:GetDimensions()
	end,
}
local NO_MAP_MODE = {
	Activate = function(self) end,
	GetDimensions = function(self)
		return ZO_WorldMapContainer:GetDimensions()
	end,
}
local FYR_MODE
FYR_MODE = {
	Activate = function(self)
		if FyrMM.SV.WheelMap then
			lib.container:SetParent(lib.scroll)
			lib.scroll:SetParent(Fyr_MM_Scroll_CW_Map_Pins)
			lib.scroll:SetAnchor(TOPLEFT, Fyr_MM_Scroll_WheelCenter, TOPLEFT, 0, 0)
			lib.scroll:SetAnchor(BOTTOMRIGHT, Fyr_MM_Scroll_WheelCenter, BOTTOMRIGHT, 0, 0)
		else
			lib.container:SetParent(Fyr_MM_Scroll_Map)
		end
		if FyrMM.SV.RotateMap then
			lib.container:ClearAnchors()
			lib.container:SetAnchor(CENTER, Fyr_MM_Scroll, CENTER, 0, 0)
			QP_MapPin.UpdateLocation = self.UpdateLocation
			if FyrMM.currentMap.Heading then
				FYR_MODE.cos = math.cos(-FyrMM.currentMap.Heading)
				FYR_MODE.sin = math.sin(-FyrMM.currentMap.Heading)
				FYR_MODE.offsetX = FyrMM.currentMap.PlayerX
				FYR_MODE.offsetY = FyrMM.currentMap.PlayerY
			else
				FYR_MODE.cos = 0
				FYR_MODE.sin = 0
				FYR_MODE.offsetX = 0
				FYR_MODE.offsetY = 0
			end
		else
			lib.container:ClearAnchors()
			lib.container:SetAnchor(TOPLEFT, Fyr_MM_Scroll_Map, TOPLEFT, 0, 0)
			QP_MapPin.UpdateLocation = QP_MapPin.OriginalUpdateLocation
		end
	end,
	GetDimensions = function(self)
		return Fyr_MM_Scroll_Map:GetDimensions()
	end,
	UpdateLocation = function(self)
		local x = self.normalizedX * lib.MAP_WIDTH - FYR_MODE.offsetX
		local y = self.normalizedY * lib.MAP_HEIGHT - FYR_MODE.offsetY
		local rotatedX = FYR_MODE.cos * x - FYR_MODE.sin * y
		local rotatedY = FYR_MODE.sin * x + FYR_MODE.cos * y
		self.m_Control:SetAnchor(CENTER, lib.container, TOPLEFT,
			rotatedX,
			rotatedY)
	end,
}
local AUI_MODE
AUI_MODE = {
	Activate = function(self)

		lib.container:SetParent(AUI_MapContainer)
		if AUI.Settings.Minimap.rotate then
			lib.container:ClearAnchors()
			lib.container:SetAnchor(CENTER, AUI_Minimap_Map_Scroll, CENTER, 0, 0)
			QP_MapPin.UpdateLocation = self.UpdateLocation
			if AUI.MapData.heading then
				AUI_MODE.cos = math.cos(-AUI.MapData.heading)
				AUI_MODE.sin = math.sin(-AUI.MapData.heading)
				AUI_MODE.offsetX = AUI.MapData.mapContainerSize * AUI.MapData.playerX
				AUI_MODE.offsetY = AUI.MapData.mapContainerSize * AUI.MapData.playerY
			else
				AUI_MODE.cos = 0
				AUI_MODE.sin = 0
				AUI_MODE.offsetX = 0
				AUI_MODE.offsetY = 0
			end
		else
			lib.container:ClearAnchors()
			lib.container:SetAnchor(TOPLEFT, AUI_MapContainer, TOPLEFT, 0, 0)
			QP_MapPin.UpdateLocation = QP_MapPin.OriginalUpdateLocation
		end
		
	end,
	GetDimensions = function(self)
		return AUI_MapContainer:GetDimensions()
	end,
	UpdateLocation = function(self)
		local x = self.normalizedX * lib.MAP_WIDTH - AUI_MODE.offsetX
		local y = self.normalizedY * lib.MAP_HEIGHT - AUI_MODE.offsetY
		local rotatedX = AUI_MODE.cos * x - AUI_MODE.sin * y
		local rotatedY = AUI_MODE.sin * x + AUI_MODE.cos * y
		self.m_Control:SetAnchor(CENTER, lib.container, TOPLEFT,
			rotatedX,
			rotatedY)
	end,
}
local VOTAN_MODE = {
	Activate = function(self)
		lib.container:SetAnchor(TOPLEFT, ZO_WorldMapContainer, TOPLEFT, 0, 0)
		lib.container:SetParent(ZO_WorldMapContainer)
	end,
	GetDimensions = function(self)
		return ZO_WorldMapContainer:GetDimensions()
	end,
}


function lib:GetUnusedPin(layout)
	local index = lib.unusedPins.index
	if index > 0 then
		lib.unusedPins.index = index - 1
		local pin = lib.unusedPins[index]
		pin.m_layout = layout
		pin:RefreshLayout()
		return pin
	end
end

QP_WorldMapPins = ZO_ObjectPool:Subclass()

function QP_WorldMapPins:New(layout)
    local factory = function(pool) return lib:GetUnusedPin(layout) or QP_MapPin:New(layout) end
    local reset = function(pin)
		pin:ClearData()
		pin.m_Control:SetHidden(true)
	end
	local pinManager = ZO_ObjectPool.New(self, factory, reset)
	pinManager.m_Layout = layout
	pinManager:UpdateSize()
    return pinManager
end

function QP_WorldMapPins:UpdateSize()
	local layout = self.m_Layout
	local minSize = layout.minSize or MIN_PIN_SIZE
	local zoom = lib.zoom:GetCurrentCurvedZoom() / lib.maxZoom
	local scale = 1
	if not ZO_WorldMap_IsWorldMapShowing() then -- minimap
		if FyrMM then
			scale = FyrMM.pScalePercent
		end
		if AUI and AUI.Minimap:IsEnabled() then
			zoom = AUI.Minimap.GetCurrentZoomValue() / 15
		end
		if VOTANS_MINIMAP and VOTANS_MINIMAP.scale then
			scale = VOTANS_MINIMAP.scale
		end
	end
	local size = zo_max(layout.size * (0.4 * zoom + 0.6) / GetUICustomScale(), minSize)
	size = size * scale
	layout.currentPinSize = size
end

function lib:SetMode(mode)
	local previousMode = self.activeMode
	self.activeMode = mode
	if self.activeMode ~= previousMode then
		self.activeMode:Activate()
	end
end

function lib:CheckMapMode()
	local mode = MAIN_MAP_MODE
	if not ZO_WorldMap_IsWorldMapShowing() then -- minimap
		mode = NO_MAP_MODE
		if FyrMM then
			mode = FYR_MODE
		end
		if (AUI and AUI.Minimap:IsEnabled()) then
			mode = AUI_MODE
		end
		if VOTANS_MINIMAP then
			mode = VOTAN_MODE
		end
	end
	self:SetMode(mode)
end

function lib:UpdatePinsForMapSizeChange(width, height)
	assert(width and height)
	self.MAP_WIDTH, self.MAP_HEIGHT = width, height
	
	self:CheckMapMode()
	
	for pinType, pinManager in pairs(self.pinManagers) do
		pinManager:UpdateSize()
		local pins = pinManager:GetActiveObjects()
		for pinKey, pin in pairs(pins) do
			pin:UpdateLocation()
			pin:UpdateSize()
		end
	end
	
end

function lib.RedrawPins()
	for pinType, callback in pairs(lib.PIN_CALLBACKS) do
		lib:RedrawPinsOfPinType(pinType)
	end
end

function lib:RefreshPinsOfPinType(pinType)
	if not self.PIN_CALLBACKS[pinType] then return end
	self:RemovePinsOfPinType(pinType)
	local pinManager = self.pinManagers[pinType]
	if pinManager then
		pinManager:UpdateSize()
		for pinKey, pin in pairs(pinManager.m_Free) do
			pin:RefreshLayout()
		end
	end
	self.PIN_CALLBACKS[pinType]()
end

function lib:RedrawPinsOfPinType(pinType)
	if not self.PIN_CALLBACKS[pinType] then return end
	self:RemovePinsOfPinType(pinType)
	local pinManager = self.pinManagers[pinType]
	if pinManager then
		pinManager:UpdateSize()
	end
	self.PIN_CALLBACKS[pinType]()
end

function lib:RemovePinsOfPinType(pinType)
	if not self.pinManagers[pinType] then return end
	self.pinManagers[pinType]:ReleaseAllObjects()
	ZO_ClearTable(self.lookUpTable[pinType])-- = {}
end

function lib:RegisterPinType(pinType, callback, layout)
	assert(self.PIN_LAYOUTS[pinType] == nil)
	self.PIN_LAYOUTS[pinType] = layout
	self.PIN_CALLBACKS[pinType] = callback
	self.lookUpTable[pinType] = {}
	if layout then
		local pinManager = QP_WorldMapPins:New(layout)
		--if layout.expectedPinCount then
		--	for i = 1, layout.expectedPinCount do
		--		pinManager:AcquireObject()
		--	end
		--	pinManager:ReleaseAllObjects()
		--end
		self.pinManagers[pinType] = pinManager
	end
end

function lib:CreatePin(pinType, pinTag, x, y)
	assert(self.pinManagers[pinType], pinType)
	--if not (x and y) then 
	--	local texture = GetMapTileTexture()
	--	error("no x or y given on map " .. texture)
	--end
	local pin, pinKey = self.pinManagers[pinType]:AcquireObject()
	local lookup = self.lookUpTable[pinType]
	if lookup[pinTag] then
		self.pinManagers[pinType]:ReleaseObject(lookup[pinTag])
	end
	lookup[pinTag] = pinKey
	pin:SetData(pinType, pinTag)
	pin:SetLocation(x, y)
	return pin
end

function lib:RemovePin(pinType, pinTag)
	self.pinManagers[pinType]:ReleaseObject(self.lookUpTable[pinType][pinTag])
	self.lookUpTable[pinType][pinTag] = nil
end
-- same syntax as LMP
lib.RemoveCustomPin = lib.RemovePin
lib.FindCustomPin = function() end

function lib.Init()
	
	if lib.initialized then return end
	lib.initialized = true
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED)
	
	
	ZO_PreHook(ZO_WorldMapPins, "UpdatePinsForMapSizeChange", function() lib:UpdatePinsForMapSizeChange(ZO_WorldMapContainer:GetDimensions()) end)
	ZO_PreHook("ZO_WorldMap_UpdateMap", lib.RedrawPins)
	ZO_PreHook(lib.zoom, "SetZoomMinMax", function(self, min, max)
		--d("set min max", min, max)
		--d("cur dimensions", ZO_WorldMapContainer:GetDimensions())
		lib.minZoom = min
		lib.maxZoom = max
		lib:UpdatePinsForMapSizeChange(ZO_WorldMapContainer:GetDimensions())
	end)
	
end

function lib:HookMinimap(minimapContainer)

	WORLD_MAP_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
		if newState == SCENE_FRAGMENT_HIDDEN then
			self:CheckMapMode()
			local width, height = self.activeMode:GetDimensions()
			if self.MAP_WIDTH ~= width or self.MAP_HEIGHT ~= height then
				lib:UpdatePinsForMapSizeChange(width, height)
			end
		end
	end)
			
	local oldDimensions = minimapContainer.SetDimensions
	minimapContainer.SetDimensions = function(self, width, height, ...)
		if not ZO_WorldMap_IsWorldMapShowing() then
			lib:UpdatePinsForMapSizeChange(width, height)
		end
		oldDimensions(self, width, height, ...)
	end
	
end

local layout = { texture="", level = 0 }
function lib.OnUpdate()
	local numMissingPins = lib.numRequestedPins - lib.numCreatedPins
	if numMissingPins <= 0 then
		EVENT_MANAGER:UnregisterForUpdate(LIB_NAME)
		return
	end
	local num = numMissingPins--zo_min(numMissingPins, 100)
	for i = lib.unusedPins.index + 1, lib.unusedPins.index + num do
		lib.unusedPins[i] = QP_MapPin:New(layout)
	end
	lib.unusedPins.index = lib.unusedPins.index + num
end

function lib:PreloadControls(num)
	self.numRequestedPins = num
	--EVENT_MANAGER:UnregisterForUpdate(LIB_NAME)
	--EVENT_MANAGER:RegisterForUpdate(LIB_NAME, 0, self.OnUpdate)
	lib.OnUpdate()--
end

function lib:Unload()
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED)
end

function lib:Load()
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED)
	EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED, lib.Init)
	
	self.numCreatedPins = 0
	self.numRequestedPins = 0
	
	self.MAP_WIDTH = 0
	self.MAP_HEIGHT = 0
	
	self.PIN_LAYOUTS = self.PIN_LAYOUTS or {}
	self.PIN_CALLBACKS = self.PIN_CALLBACKS or {}
	self.lookUpTable = {}
	self.pinManagers = {} -- todo implement a way to retrieve the previous pinmanager
	
	self.scroll = CreateControl("QP_Scroll" , ZO_WorldMap, CT_SCROLL)
	self.scroll:SetAnchor(TOPLEFT, ZO_WorldMapScroll, TOPLEFT, 0, 0)
	self.scroll:SetAnchor(BOTTOMRIGHT, ZO_WorldMapScroll, BOTTOMRIGHT, 0, 0)
	
	self.container = CreateControl("QP_Container" , self.scroll, CT_CONTROL)
	self.container:SetAnchor(TOPLEFT, ZO_WorldMapContainer, TOPLEFT, 0, 0)
	
	if Fyr_MM then
		self:HookMinimap(Fyr_MM_Scroll_Map)
		
		local orig = FyrMM.UpdateMapTiles
		function FyrMM.UpdateMapTiles(...)
			orig(...)
			if self.activeMode == FYR_MODE and FyrMM.SV.RotateMap and FyrMM.currentMap.Heading then
				
				FYR_MODE.cos = math.cos(-FyrMM.currentMap.Heading)
				FYR_MODE.sin = math.sin(-FyrMM.currentMap.Heading)
				FYR_MODE.offsetX = FyrMM.currentMap.PlayerX
				FYR_MODE.offsetY = FyrMM.currentMap.PlayerY
				--[[
				for pinType, pinManager in pairs(self.pinManagers) do
					local pins = pinManager:GetActiveObjects()
					for pinKey, pin in pairs(pins) do
						pin:UpdateLocation()
					end
				end
				]]
			end
		end
	end
	if AUI and AUI.Minimap then
		self:HookMinimap(AUI_MapContainer)
		
		ZO_PreHook(AUI.Minimap.Pin, "UpdateAllLocations", function()
			if self.activeMode == AUI_MODE and AUI.Settings.Minimap.rotate then
				AUI_MODE.cos = math.cos(-AUI.MapData.heading)
				AUI_MODE.sin = math.sin(-AUI.MapData.heading)
				AUI_MODE.offsetX = AUI.MapData.mapContainerSize * AUI.MapData.playerX
				AUI_MODE.offsetY = AUI.MapData.mapContainerSize * AUI.MapData.playerY
				for pinType, pinManager in pairs(self.pinManagers) do
					local pins = pinManager:GetActiveObjects()
					for pinKey, pin in pairs(pins) do
						pin:UpdateLocation()
					end
				end
			end
		end)
	end
	
	self.zoom = ZO_WorldMap_GetPanAndZoom()
	lib.minZoom, lib.maxZoom = self.zoom.minZoom, self.zoom.maxZoom
	
	self.unusedPins = {}
	self.unusedPins.index = 0
end

if lib.version and lib.version < LIB_VERSION then
	lib:Unload()
else
	lib:Load()
end
