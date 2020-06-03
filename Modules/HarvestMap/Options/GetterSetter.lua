
local Settings = Harvest.settings

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events


function Harvest.SetMapSpawnFilterEnabled(enabled)
	Settings.savedVars.settings.mapSpawnFilter = enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapSpawnFilter", enabled)
end

function Harvest.IsMapSpawnFilterEnabled()
	return LibNodeDetection and Settings.savedVars.settings.mapSpawnFilter
end

function Harvest.SetMinimapSpawnFilterEnabled(enabled)
	Settings.savedVars.settings.minimapSpawnFilter = enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "minimapSpawnFilter", enabled)
end

function Harvest.IsMinimapSpawnFilterEnabled()
	return LibNodeDetection and Settings.savedVars.settings.minimapSpawnFilter
end

function Harvest.SetCompassSpawnFilterEnabled(enabled)
	Settings.savedVars.settings.compassSpawnFilter = enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassSpawnFilter", enabled)
end

function Harvest.IsCompassSpawnFilterEnabled()
	return LibNodeDetection and Settings.savedVars.settings.compassSpawnFilter
end

function Harvest.SetWorldSpawnFilterEnabled(enabled)
	Settings.savedVars.settings.worldSpawnFilter = enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldSpawnFilter", enabled)
end

function Harvest.IsWorldSpawnFilterEnabled()
	return LibNodeDetection and Settings.savedVars.settings.worldSpawnFilter
end


function Harvest.AreNotificationsEnabled()
	return Settings.savedVars.settings.displayNotifications
end

function Harvest.SetNotificationsEnabled(enabled)
	Settings.savedVars.settings.displayNotifications = enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "displayNotifications", enabled)
end

function Harvest.AreAnyMapPinsVisible()
	return Settings.savedVars.settings.displayMapPins or Settings.savedVars.settings.displayMinimapPins
end

function Harvest.AreMinimapPinsVisible()
	return Settings.savedVars.settings.displayMinimapPins
end

function Harvest.SetMinimapPinsVisible( value )
	Settings.savedVars.settings.displayMinimapPins = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "minimapPinsVisible", value)
end

function Harvest.AreMapPinsVisible()
	return Settings.savedVars.settings.displayMapPins
end

function Harvest.SetMapPinsVisible( value )
	Settings.savedVars.settings.displayMapPins = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapPinsVisible", value)
end

function Harvest.IsMinimapOnly()
	return Settings.savedVars.settings.minimapOnly
end

function Harvest.SetMinimapOnly(value)
	Settings.savedVars.settings.minimapOnly = value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "minimapOnly", value)
end

function Harvest.SetMinimapCompatibilityModeEnabled(value)
	Settings.savedVars.settings.minimapCompatibility = value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "minimapCompatibility", value)
	ReloadUI("ingame")
end

function Harvest.IsMinimapCompatibilityModeEnabled()
	return false--Settings.savedVars.settings.minimapCompatibility
end

function Harvest.GetPinTypeTexture(pinTypeId)
	return Settings.savedVars.settings.pinLayouts[pinTypeId].texture
end

function Harvest.SetPinTypeTexture(pinTypeId, value)
	Settings.savedVars.settings.pinLayouts[pinTypeId].texture = value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapPinTexture", pinTypeId, value)
end

local deleteList = false
function Harvest.IsDeleteListEnabled()
	return deleteList
end

function Harvest.SetDeleteList(value)
	deleteList = value
end

function Harvest.AreDeletionsTracked()
	return Settings.savedVars.settings.trackDeletions
end

function Harvest.SetDeletionTracking(isTracked)
	Settings.savedVars.settings.trackDeletions = not not isTracked
end

function Harvest.GetMinGameVersion()
	return Settings.savedVars.global.minGameVersion
end

local versionString
function Harvest.GetDisplayedMinGameVersion()
	if versionString then
		return versionString
	end
	local versionNumber = Settings.savedVars.global.minGameVersion
	local patch = tostring(versionNumber % 100)
	local update = tostring(zo_floor(versionNumber / 100) % 100)
	local version = tostring(zo_max(zo_floor(versionNumber / 10000),1))
	return table.concat({version, update, patch},".")
end

function Harvest.SetDisplayedMinGameVersion(version)
	versionString = version
end

function Harvest.GetUIResolution()
	local width, height = GuiRoot:GetDimensions()
	d(width, height)
	if GetSetting(SETTING_TYPE_UI, UI_SETTING_USE_CUSTOM_SCALE) ~= "0" then
		local scale = tonumber(GetSetting(SETTING_TYPE_UI, UI_SETTING_CUSTOM_SCALE))
		d(scale)
		width = width * scale
		height = height * scale
	end
	width = zo_round(width)
	height = zo_round(height)
	d(width, height)
	return width, height
end

function Harvest.Get3DResolution()
	return GetSetting(SETTING_TYPE_GRAPHICS, GRAPHICS_SETTING_RESOLUTION)
end

function Harvest.GetSubSampling()
	local level = tostring(GetSetting(SETTING_TYPE_GRAPHICS, GRAPHICS_SETTING_SUB_SAMPLING, SUB_SAMPLING_MODE_NORMAL))
	return GetString(_G["SI_SUBSAMPLINGMODE" .. level])
end

function Harvest.SetToCompatibleGraphicSettings()
	local width, height = Harvest.GetUIResolution()
	SetSetting(SETTING_TYPE_GRAPHICS, GRAPHICS_SETTING_RESOLUTION, tostring(width) .. "x" .. tostring(height))
	SetSetting(SETTING_TYPE_GRAPHICS, GRAPHICS_SETTING_SUB_SAMPLING, SUB_SAMPLING_MODE_NORMAL)
end

function Harvest.GetWorldPinHeight()
	return Settings.savedVars.settings.worldPinHeight
end

function Harvest.SetWorldPinHeight(height)
	Settings.savedVars.settings.worldPinHeight = height
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldPinHeight", height)
end

function Harvest.GetWorldPinWidth()
	return Settings.savedVars.settings.worldPinWidth
end

function Harvest.SetWorldPinWidth(width)
	Settings.savedVars.settings.worldPinWidth = width
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldPinHeight", width)
end

function Harvest.DoWorldPinsUseDepth()
	return Settings.savedVars.settings.worldPinDepth
end

function Harvest.SetWorldPinsUseDepth(value)
	Settings.savedVars.settings.worldPinDepth = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldPinsUseDepth", value)
end

function Harvest.GetCompassDistance()
	return Settings.savedVars.settings.compassDistanceInMeters
end

function Harvest.SetCompassDistance( distance )
	Settings.savedVars.settings.compassDistanceInMeters = distance
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassDistance", distance)
end

function Harvest.GetWorldDistance()
	return Settings.savedVars.settings.worldDistanceInMeters
end

function Harvest.SetWorldDistance(distance)
	Settings.savedVars.settings.worldDistanceInMeters = distance
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldDistance", distance)
end

function Harvest.SetWorldPinsVisible(visible)
	Settings.savedVars.settings.displayWorldPins = not not visible
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldPinsVisible", visible)
end

function Harvest.AreWorldPinsVisible()
	return Settings.savedVars.settings.displayWorldPins
end

function Harvest.GetVisitedRangeInMeters()
	return Settings.savedVars.settings.visitedRangeInMeters
end

function Harvest.SetVisitedRangeInMeters(value)
	Settings.savedVars.settings.visitedRangeInMeters = value
end

function Harvest.IsDelayedWhenMapClosed()
	return Settings.savedVars.settings.delayUntilMapOpen
end

function Harvest.SetDelayedWhenMapClosed(delayed)
	Settings.savedVars.settings.delayUntilMapOpen = not not delayed
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "delayMapClosed", delayed)
end

function Harvest.IsDelayedWhenInFight()
	return Settings.savedVars.settings.delayWhenInFight
end

function Harvest.SetDelayedWhenInFight(delayed)
	Settings.savedVars.settings.delayWhenInFight = not not delayed
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "delayInFight", delayed)
end

function Harvest.GetDisplaySpeed()
	return math.huge
	--return Settings.savedVars.settings.displaySpeed
end

function Harvest.SetDisplaySpeed( speed )
	Settings.savedVars.settings.displaySpeed = speed
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "displaySpeed", speed)
end

function Harvest.HasPinVisibleDistance()
	return Settings.savedVars.settings.hasMaxVisibleDistance
end

function Harvest.SetHasPinVisibleDistance( enabled )
	Settings.savedVars.settings.hasMaxVisibleDistance = not not enabled
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "hasVisibleDistance", enabled)
end

function Harvest.GetPinVisibleDistance()
	return Settings.savedVars.settings.maxVisibleDistanceInMeters
end

function Harvest.SetPinVisibleDistance(distance)
	Settings.savedVars.settings.maxVisibleDistanceInMeters = distance
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "visibleDistance", distance)
end

function Harvest.GetMaxCachedMaps()
	return 5--Settings.savedVars.settings.maxCachedMaps
end

function Harvest.SetMaxCachedMaps( num )
	Settings.savedVars.settings.maxCachedMaps = num
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "maxCachedMaps", num)
end

function Harvest.ArePinsAbovePOI()
	return Settings.savedVars.settings.pinsAbovePoi
end

function Harvest.SetPinsAbovePOI( above )
	Settings.savedVars.settings.pinsAbovePoi = not not above
	local level = 20
	if above then
		level = 55
	end
	for pinTypeId, layout in pairs(Settings.savedVars.settings.pinLayouts) do
		if pinTypeId == Harvest.TOUR then
			layout.level = level + 1
		else
			layout.level = level
		end
	end
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "pinAbovePoi", above)
end

function Harvest.IsHiddenOnHarvest()
	return Settings.savedVars.settings.hiddenOnHarvest
end

function Harvest.SetHiddenOnHarvest( hidden )
	Settings.savedVars.settings.hiddenOnHarvest = not not hidden
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "hiddenOnHarvest", hidden)
end

function Harvest.GetHiddenTime()
	return Settings.savedVars.settings.hiddenTime
end

function Harvest.SetHiddenTime(hiddenTime)
	Settings.savedVars.settings.hiddenTime = hiddenTime
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "hiddenTime", hiddenTime)
end

function Harvest.SetUseHiddenTime(value)
	Settings.savedVars.settings.useHiddenTime = value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "useHiddenTime", hiddenTime)
end

function Harvest.IsHiddenTimeUsed()
	return Settings.savedVars.settings.useHiddenTime
end

function Harvest.SetHeatmapActive( active )
	local prevValue = Settings.savedVars.settings.heatmap
	Settings.savedVars.settings.heatmap = not not active
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "heatmapActive", active)
	-- todo via callback
	HarvestHeat.RefreshHeatmap()
	if active then
		HarvestHeat.Initialize()
	else
		HarvestHeat.HideTiles()
	end
end

function Harvest.IsHeatmapActive()
	return (Settings.savedVars.settings.heatmap == true)
end

function Harvest.AreSettingsAccountWide()
	return Settings.savedVars.account.accountWideSettings
end

function Harvest.SetSettingsAccountWide( value )
	Settings.savedVars.account.accountWideSettings = value
	-- wanted to remove this, but it seems the require reload field in LAM doesn't work
	ReloadUI("ingame")
end

local difference -- temporary variable to save the new max timedifference until the apply button is hit
function Harvest.ApplyTimeDifference()
	if difference then
		Settings.savedVars.global.maxTimeDifference = difference
	end
	if versionString then
		local versionNumber = 0
		if versionString ~= "1.0.0" then
			local version, update, patch = string.match(versionString, "(%d+)%.(%d+)%.(%d+)")
			versionNumber = version * 10000 + update * 100 + patch
		end
		Settings.savedVars.global.minGameVersion = versionNumber
	end
	if difference or versionString then
		CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "applyTimeDifference", difference, versionString)
		difference = nil
		versionString = nil
	end
end

function Harvest.GetMaxTimeDifference()
	return Settings.savedVars.global.maxTimeDifference
end

function Harvest.GetDisplayedMaxTimeDifference()
	return difference or Settings.savedVars.global.maxTimeDifference
end

function Harvest.SetDisplayedMaxTimeDifference(value)
	difference = value
end

function Harvest.IsPinTypeSavedOnImport( pinTypeId )
	return true
	--return not (Settings.savedVars.settings.isPinTypeSavedOnImport[ pinTypeId ] == false)
end

function Harvest.SetPinTypeSavedOnImport( pinTypeId, value )
	Settings.savedVars.settings.isPinTypeSavedOnImport[ pinTypeId ] = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "importPinType", pinTypeId, value)
end

function Harvest.IsZoneSavedOnImport( zone )
	if Settings.savedVars.settings.isZoneSavedOnImport[ zone ] == nil then
		return true
	end
	return Settings.savedVars.settings.isZoneSavedOnImport[ zone ]
end

function Harvest.SetZoneSavedOnImport( zone, value )
	Settings.savedVars.settings.isZoneSavedOnImport[ zone ] = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "importZone", value)
end

function Harvest.AreCompassPinsVisible()
	return Settings.savedVars.settings.displayCompassPins
end

function Harvest.SetCompassPinsVisible( value )
	Settings.savedVars.settings.displayCompassPins = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassPinsVisible", value)
end

function Harvest.GetMapPinLayouts()
	return Settings.savedVars.settings.pinLayouts
end

function Harvest.GetMapPinLayout(pinTypeId)
	return Settings.savedVars.settings.pinLayouts[pinTypeId]
end

function Harvest.IsWorldFilterActive()
	return Settings.savedVars.settings.isWorldFilterActive
end

function Harvest.SetWorldFilterActive(value)
	Settings.savedVars.settings.isWorldFilterActive = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldFilterActive", value)
	CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestMapInRangeMenu.panel)
end

function Harvest.IsWorldPinTypeVisible( pinTypeId )
	return Settings.savedVars.settings.isWorldPinTypeVisible[ pinTypeId ]
end

function Harvest.SetWorldPinTypeVisible( pinTypeId, visible )
	Settings.savedVars.settings.isWorldPinTypeVisible[ pinTypeId ] = not not visible
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldPinTypeVisible", pinTypeId, visible)
end

function Harvest.IsCompassFilterActive()
	return Settings.savedVars.settings.isCompassFilterActive
end

function Harvest.SetCompassFilterActive(value)
	Settings.savedVars.settings.isCompassFilterActive = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassFilterActive", value)
	CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestMapInRangeMenu.panel)
end

function Harvest.IsCompassPinTypeVisible( pinTypeId )
	return Settings.savedVars.settings.isCompassPinTypeVisible[ pinTypeId ]
end

function Harvest.SetCompassPinTypeVisible( pinTypeId, visible )
	Settings.savedVars.settings.isCompassPinTypeVisible[ pinTypeId ] = not not visible
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassPinTypeVisible", pinTypeId, visible)
end

function Harvest.IsMapPinTypeVisible( pinTypeId )
	if Harvest.PINTYPE_ALIAS[pinTypeId] or Harvest.HIDDEN_PINTYPES[pinTypeId] then return false end
	return Settings.savedVars.settings.isPinTypeVisible[ pinTypeId ]
end

function Harvest.IsInRangePinTypeVisible( pinTypeId )
	if Harvest.PINTYPE_ALIAS[pinTypeId] or Harvest.HIDDEN_PINTYPES[pinTypeId] then return false end
	local checkMap = not Harvest.IsCompassFilterActive() or not Harvest.IsWorldFilterActive()
	if Harvest.IsCompassFilterActive() and Harvest.IsCompassPinTypeVisible( pinTypeId ) then
		return true
	end
	if Harvest.IsWorldFilterActive() and Harvest.IsWorldPinTypeVisible( pinTypeId ) then
		return true
	end
	return checkMap and Harvest.IsMapPinTypeVisible( pinTypeId )
end

function Harvest.IsPinTypeVisible( pinTypeId )
	if Harvest.PINTYPE_ALIAS[pinTypeId] or Harvest.HIDDEN_PINTYPES[pinTypeId] then return false end
	if Harvest.IsMapPinTypeVisible( pinTypeId ) then
		return true
	end
	if Harvest.IsCompassFilterActive() and Harvest.IsCompassPinTypeVisible( pinTypeId ) then
		return true
	end
	return Harvest.IsWorldFilterActive() and Harvest.IsWorldPinTypeVisible( pinTypeId )
end

function Harvest.SetMapPinTypeVisible( pinTypeId, visible )
	Settings.savedVars.settings.isPinTypeVisible[ pinTypeId ] = not not visible
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapPinTypeVisible", pinTypeId, visible)
	-- todo via callback
	HarvestHeat.RefreshHeatmap()
end

local debugEnabled = false
function Harvest.IsPinDeletionEnabled()
	return debugEnabled
end

function Harvest.SetPinDeletionEnabled( value )
	debugEnabled = value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "debugModeEnabled", value)
end

function Harvest.AreDebugMessagesEnabled()
	return false --Settings.savedVars.settings.showDebugOutput
end

function Harvest.SetDebugMessagesEnabled( value )
	Settings.savedVars.settings.showDebugOutput = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "debugMsgEnabled", value)
end

function Harvest.IsPinTypeSavedOnGather( pinTypeId )
	--return true
	return not (Settings.savedVars.settings.isPinTypeSavedOnGather[ pinTypeId ] == false)
	-- nil is interpreted as true too
end

function Harvest.SetPinTypeSavedOnGather( pinTypeId, value )
	Settings.savedVars.settings.isPinTypeSavedOnGather[ pinTypeId ] = not not value
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "savePinType", pinTypeId, value)
end

function Harvest.SetMapPinMinSize(value)
	Settings.savedVars.settings.mapPinMinSize = value
	for pinTypeId, layout in pairs(Settings.savedVars.settings.pinLayouts) do
		layout.minSize = value
	end
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapPinMinSize", value)
end

function Harvest.GetMapPinMinSize()
	return Settings.savedVars.settings.mapPinMinSize
end

function Harvest.GetMapPinSize( pinTypeId )
	if pinTypeId == 0 then
		return Settings.savedVars.settings.minimapPinSize
	end
	return Settings.savedVars.settings.pinLayouts[ pinTypeId ].size
end

function Harvest.SetMapPinSize( pinTypeId, value )
	if pinTypeId == 0 then
		Settings.savedVars.settings.minimapPinSize = value
	else
		Settings.savedVars.settings.pinLayouts[ pinTypeId ].size = value
	end
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "pinTypeSize", pinTypeId, value)
end

function Harvest.GetPinColor( pinTypeId )
	return Settings.savedVars.settings.pinLayouts[ pinTypeId ].tint:UnpackRGBA()
end

function Harvest.SetPinColor( pinTypeId, r, g, b, a )
	Settings.savedVars.settings.pinLayouts[ pinTypeId ].tint:SetRGBA( r, g, b, a )
	CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "pinTypeColor", pinTypeId, r, g, b, a)
end