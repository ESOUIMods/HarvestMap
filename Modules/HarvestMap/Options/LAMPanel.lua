
local LAM = LibAddonMenu2

local Settings = Harvest.settings
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events
local FilterProfiles = Harvest.filterProfiles

local function CreateSpawnFilterForPinType(pinTypeId)
	local pinTypeId = pinTypeId
	local filter = {
		type = "checkbox",
		name = Harvest.GetLocalization( "pintype" .. pinTypeId ),
		getFunc = function()
			return Settings.savedVars.settings.isSpawnFilterUsedForPinType[pinTypeId]
		end,
		setFunc = function(enabled)
			Settings.savedVars.settings.isSpawnFilterUsedForPinType[pinTypeId] = enabled
			CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "isSpawnFilterUsedForPinType", pinTypeId, enabled)
		end,
		default = Harvest.settings.defaultSettings.isSpawnFilterUsedForPinType[pinTypeId],
		disabled = (LibNodeDetection == nil),
		width = "full"
	}
	return filter
end

local function CreateIconPicker( pinTypeId )
	local pinTypeId = pinTypeId
	local filter = {
		type = "iconpicker",
		name = Harvest.GetLocalization("pintexture"),
		getFunc = function()
			return Harvest.GetPinTypeTexture(pinTypeId)
		end,
		setFunc = function(newTexture)
			Harvest.SetPinTypeTexture(pinTypeId, newTexture)
		end,
		choices = Harvest.settings.availableTextures,
		default = Harvest.settings.defaultSettings.pinLayouts[pinTypeId].texture,
	}
	return filter
end

local function CreateGatherFilter( pinTypeId )
	local pinTypeId = pinTypeId
	local gatherFilter = {
		type = "checkbox",
		name = zo_strformat( Harvest.GetLocalization( "savepin" ), Harvest.GetLocalization( "pintype" .. pinTypeId ) ),
		tooltip = Harvest.GetLocalization( "savetooltip" ),
		getFunc = function()
			return Harvest.IsPinTypeSavedOnGather( pinTypeId )
		end,
		setFunc = function( value )
			Harvest.SetPinTypeSavedOnGather( pinTypeId, value )
		end,
		default = Harvest.settings.defaultSettings.isPinTypeSavedOnGather[ pinTypeId ],
	}
	return gatherFilter
end

local function CreateSizeSlider( pinTypeId )
	local pinTypeId = pinTypeId
	local sizeSlider = {
		type = "slider",
		name = Harvest.GetLocalization("pinsize"),
		tooltip = Harvest.GetLocalization("pinsizetooltip"),
		min = 8,
		max = 64,
		getFunc = function()
			return Harvest.GetMapPinSize(pinTypeId)
		end,
		setFunc = function(newSize)
			Harvest.SetMapPinSize(pinTypeId, newSize)
		end,
		default = Harvest.settings.defaultSettings.pinLayouts[pinTypeId].size,
	}
	return sizeSlider
end

local function CreateColorPicker(pinTypeId)
	local pinTypeId = pinTypeId
	local colorPicker = {
		type = "colorpicker",
		name = Harvest.GetLocalization("pincolor"),
		tooltip = zo_strformat(Harvest.GetLocalization( "pincolortooltip" ), Harvest.GetLocalization( "pintype" .. pinTypeId)),
		getFunc = function() return Harvest.GetPinColor(pinTypeId) end,
		setFunc = function(r, g, b, a) Harvest.SetPinColor(pinTypeId, r, g, b, a) end,
		default = Harvest.settings.defaultSettings.pinLayouts[ pinTypeId ].tint,
	}
	return colorPicker
end

local function FilterSetting(pinTypeId, profileGetter, IsMapProfile)
	local setting = {
		type = "checkbox",
		name = Harvest.GetLocalization("pintype" .. pinTypeId),
		getFunc = function()
			local filterProfile = FilterProfiles[profileGetter](FilterProfiles)
			return filterProfile[pinTypeId]
		end,
		setFunc = function(isVisible)
			local filterProfile = FilterProfiles[profileGetter](FilterProfiles)
			filterProfile[pinTypeId] = isVisible
			CallbackManager:FireCallbacks(Events.FILTER_PROFILE_CHANGED, filterProfile, pinTypeId, isVisible)
		end,
		disabled = IsMapProfile,
	}
	return setting
end

local function ProfileDropdown(defaultProfileName, ProfileGetter, ProfileSetter)
	local option = {
		type = "dropdown",
		name = Harvest.GetLocalization("visiblepintypes"),
		choices = {
			Harvest.GetLocalization("same_as_map"),
			Harvest.GetLocalization("custom")
		},
		choicesValues = {"map", "custom"},
		getFunc = function()
			if FilterProfiles:GetMapProfile() == FilterProfiles[ProfileGetter](FilterProfiles) then
				return "map"
			else
				return "custom"
			end
		end,
		setFunc = function(value)
			if value == "map" then
				FilterProfiles[ProfileSetter](FilterProfiles, Harvest.filterProfiles:GetMapProfile())
				return
			end
			if FilterProfiles:GetMapProfile() == FilterProfiles[ProfileGetter](FilterProfiles) then
				local profile = FilterProfiles:FindProfileWithName(defaultProfileName)
				if not profile then
					profile = FilterProfiles:ConstructNewProfile()
					profile.name = defaultProfileName
				end
				FilterProfiles[ProfileSetter](FilterProfiles, profile)
			end
		end,
	}
	return option
end

function Settings:InitializeLAM()
	-- first LAM stuff, at the end of this function we will also create
	-- a custom checkbox in the map's filter menu for the heat map
	local panelData = {
		type = "panel",
		name = "HarvestMap",
		displayName = ZO_HIGHLIGHT_TEXT:Colorize("HarvestMap"),
		author = "Shinni",
		version = Harvest.displayVersion,
		registerForRefresh = true,
		registerForDefaults = true,
		website = "http://www.esoui.com/downloads/info57",
	}

	local optionsTable = setmetatable({}, { __index = table })

	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("esouidescription"),
		width = "full",
	})

	optionsTable:insert({
		type = "button",
		name = Harvest.GetLocalization("openesoui"),
		func = function() RequestOpenUnsafeURL("http://www.esoui.com/downloads/info57") end,
		width = "half",
	})

	optionsTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("exchangedescription2"),
		width = "full",
	})

	optionsTable:insert({
		type = "header",
		name = "",
	})

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("outdateddata"),
		controls = submenuTable,
	})

	submenuTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("outdateddatainfo")
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("timedifference"),
		tooltip = Harvest.GetLocalization("timedifferencetooltip"),
		min = 0,
		max = 712,
		getFunc = function()
			return Harvest.GetDisplayedMaxTimeDifference() / 24
		end,
		setFunc = function( value )
			Harvest.SetDisplayedMaxTimeDifference(value * 24)
		end,
		width = "half",
		default = 0,
	})

	submenuTable:insert({
		type = "button",
		name = GetString(SI_APPLY),
		func = Harvest.ApplyTimeDifference,
		width = "half",
		warning = Harvest.GetLocalization("applywarning")
	})

	optionsTable:insert({
		type = "header",
		name = "",
	})

	optionsTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("account"),
		tooltip = Harvest.GetLocalization("accounttooltip"),
		getFunc = Harvest.AreSettingsAccountWide,
		setFunc = Harvest.SetSettingsAccountWide,
		width = "full",
		warning = Harvest.GetLocalization("accountwarning"),
		--requireReload = true, -- doesn't work?
	})

	optionsTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("notifications"),
		tooltip = Harvest.GetLocalization("notificationstooltip"),
		getFunc = Harvest.AreNotificationsEnabled,
		setFunc = Harvest.SetNotificationsEnabled,
		width = "full",
	})

	--[[
	#####
	#####  MAP
	#####
	--]]

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("mapheader"),
		controls = submenuTable,
	})

	local function IsMapDisabled() return not Harvest.AreAnyMapPinsVisible() end

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("mappins"),
		--tooltip = Harvest.GetLocalization("mappinstooltip"),
		getFunc = Harvest.AreMapPinsVisible,
		setFunc = Harvest.SetMapPinsVisible,
		default = Harvest.settings.defaultSettings.displayMapPins,
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("minimappins"),
		tooltip = Harvest.GetLocalization("minimappinstooltip"),
		getFunc = Harvest.AreMinimapPinsVisible,
		setFunc = Harvest.SetMinimapPinsVisible,
		default = Harvest.settings.defaultSettings.displayMinimapPins,
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("hasdrawdistance"),
		tooltip = Harvest.GetLocalization("hasdrawdistancetooltip"),
		warning = Harvest.GetLocalization("hasdrawdistancewarning"),
		getFunc = Harvest.HasPinVisibleDistance,
		setFunc = Harvest.SetHasPinVisibleDistance,
		default = Harvest.settings.defaultSettings.hasMaxVisibleDistance,
		disabled = IsMapDisabled,
		width = "half",
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("drawdistance"),
		tooltip = Harvest.GetLocalization("drawdistancetooltip"),
		warning = Harvest.GetLocalization("drawdistancewarning"),
		min = 100,
		max = 1000,
		getFunc = Harvest.GetPinVisibleDistance,
		setFunc = Harvest.SetPinVisibleDistance,
		default = Harvest.settings.defaultSettings.maxVisibleDistanceInMeters,
		width = "half",
		disabled = function()
			if IsMapDisabled() then return true end
			if Harvest.HasPinVisibleDistance() then
				return false
			end
			if FyrMM or (AUI and AUI.Minimap:IsEnabled()) or VOTANS_MINIMAP then
				return false
			end
			return true
		end,
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("level"),
		--tooltip = Harvest.GetLocalization("leveltooltip"),
		getFunc = Harvest.ArePinsAbovePOI,
		setFunc = Harvest.SetPinsAbovePOI,
		default = Harvest.settings.defaultSettings.pinsAbovePoi,
		disabled = IsMapDisabled,
		--width = "half",
	})

	local filterTable = setmetatable({}, { __index = table })
	submenuTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("visiblepintypes"),
		controls = filterTable,
	})

	--[[
	filterTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("mapvisiblepintypedescription"),
		width = "full",
	})
	--]]

	local NeverDisabled = function() return false end
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			filterTable:insert(FilterSetting(pinTypeId, "GetMapProfile", NeverDisabled))
		end
	end

	--[[
	#####
	#####  COMPASS
	#####
	--]]

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("compassheader"),
		controls = submenuTable,
	})

	local function IsCompassDisabled() return not Harvest.AreCompassPinsVisible() end

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("compass"),
		--tooltip = Harvest.GetLocalization("compasstooltip"),
		getFunc = Harvest.AreCompassPinsVisible,
		setFunc = function(...)
			Harvest.SetCompassPinsVisible(...)
		end,
		default = Harvest.settings.defaultSettings.displayCompassPins,
		width = "full",
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("compassdistance"),
		tooltip = Harvest.GetLocalization("compassdistancetooltip"),
		min = 50,
		max = 250,
		getFunc = Harvest.GetCompassDistance,
		setFunc = Harvest.SetCompassDistance,
		default = Harvest.settings.defaultSettings.compassDistanceInMeters,
		disabled = IsCompassDisabled,
	})

	local filterTable = setmetatable({}, { __index = table })
	submenuTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("visiblepintypes"),
		controls = filterTable,
	})

	filterTable:insert(ProfileDropdown("Compass Profile", "GetCompassProfile", "SetCompassProfile"))

	local IsMapProfile = function()
		return (FilterProfiles:GetMapProfile() == FilterProfiles:GetCompassProfile())
	end
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			filterTable:insert(FilterSetting(pinTypeId, "GetCompassProfile", IsMapProfile))
		end
	end

	--[[
	#####
	#####  WORLD
	#####
	--]]

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("worldpinsheader"),
		controls = submenuTable,
	})

	local function IsWorldDisabled() return not Harvest.AreWorldPinsVisible() end

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("worldpins"),
		--tooltip = Harvest.GetLocalization("worldpinstooltip"),
		getFunc = Harvest.AreWorldPinsVisible,
		setFunc = function(...)
			Harvest.SetWorldPinsVisible(...)
		end,
		default = Harvest.settings.defaultSettings.displayWorldPins,
		width = "full",
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worlddistance"),
		tooltip = Harvest.GetLocalization("worlddistancetooltip"),
		min = 50,
		max = 250,
		getFunc = Harvest.GetWorldDistance,
		setFunc = Harvest.SetWorldDistance,
		default = Harvest.settings.defaultSettings.worldDistanceInMeters,
		disabled = IsWorldDisabled,
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worldpinwidth"),
		tooltip = Harvest.GetLocalization("worldpinwidthtooltip"),
		min = 50,
		max = 300,
		getFunc = Harvest.GetWorldPinWidth,
		setFunc = Harvest.SetWorldPinWidth,
		default = Harvest.settings.defaultSettings.worldPinWidth,
		disabled = IsWorldDisabled,
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("worldpinheight"),
		tooltip = Harvest.GetLocalization("worldpinheighttooltip"),
		min = 100,
		max = 600,
		getFunc = Harvest.GetWorldPinHeight,
		setFunc = Harvest.SetWorldPinHeight,
		default = Harvest.settings.defaultSettings.worldPinHeight,
		disabled = IsWorldDisabled,
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("worldpinsdepth"),
		tooltip = Harvest.GetLocalization("worldpinsdepthtooltip"),
		warning = Harvest.GetLocalization("worldpinsdepthwarning"),
		getFunc = Harvest.DoWorldPinsUseDepth,
		setFunc = Harvest.SetWorldPinsUseDepth,
		default = Harvest.settings.defaultSettings.worldPinDepth,
		disabled = IsWorldDisabled,
	})

	local filterTable = setmetatable({}, { __index = table })
	submenuTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("visiblepintypes"),
		controls = filterTable,
	})

	filterTable:insert(ProfileDropdown("3D Profile", "GetWorldProfile", "SetWorldProfile"))

	local IsMapProfile = function()
		return (FilterProfiles:GetMapProfile() == FilterProfiles:GetWorldProfile())
	end
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			filterTable:insert(FilterSetting(pinTypeId, "GetWorldProfile", IsMapProfile))
		end
	end

	--[[
	#####
	#####  SPAWN FILTER
	#####
	--]]

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("spawnfilter"),
		controls = submenuTable,
	})

	local description = Harvest.GetLocalization("spawnfilterdescription")
	if not LibNodeDetection then
		description = ZO_ERROR_COLOR:Colorize(Harvest.GetLocalization("nodedetectionmissing")) .. "\n" .. description
	end
	submenuTable:insert({
		type = "description",
		title = nil,
		text = description,
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("spawnfilter_map"),
		setFunc = Harvest.SetMapSpawnFilterEnabled,
		getFunc = Harvest.IsMapSpawnFilterEnabled,
		default = Harvest.settings.defaultSettings.mapSpawnFilter,
		disabled = (LibNodeDetection == nil),
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("spawnfilter_minimap"),
		setFunc = Harvest.SetMinimapSpawnFilterEnabled,
		getFunc = Harvest.IsMinimapSpawnFilterEnabled,
		default = Harvest.settings.defaultSettings.minimapSpawnFilter,
		disabled = (LibNodeDetection == nil),
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("spawnfilter_compass"),
		getFunc = Harvest.IsCompassSpawnFilterEnabled,
		setFunc = Harvest.SetCompassSpawnFilterEnabled,
		default = Harvest.settings.defaultSettings.compassSpawnFilter,
		disabled = (LibNodeDetection == nil),
		width = "full",
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("spawnfilter_world"),
		setFunc = Harvest.SetWorldSpawnFilterEnabled,
		getFunc = Harvest.IsWorldSpawnFilterEnabled,
		default = Harvest.settings.defaultSettings.worldSpawnFilter,
		disabled = (LibNodeDetection == nil),
		width = "full",
	})

	submenuTable:insert({
		type = "header",
		name = Harvest.GetLocalization( "spawnfilter_pintype" )
	})

	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if Harvest.HARVEST_NODES[pinTypeId] then
			submenuTable:insert(CreateSpawnFilterForPinType(pinTypeId))
		end
	end

	--[[
	#####
	#####  FARMING HELPER
	#####
	--]]

	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("visitednodes"),
		controls = submenuTable,
	})

	local function IsTimerDisabled() return not Harvest.IsHiddenTimeUsed() end

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("rangemultiplier"),
		tooltip = Harvest.GetLocalization("rangemultipliertooltip"),
		min = 5,
		max = 20,
		getFunc = Harvest.GetVisitedRangeInMeters,
		setFunc = Harvest.SetVisitedRangeInMeters,
		default = Harvest.settings.defaultSettings.visitedRangeInMeters,
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("usehiddentime"),
		tooltip = Harvest.GetLocalization("usehiddentimetooltip"),
		getFunc = Harvest.IsHiddenTimeUsed,
		setFunc = Harvest.SetUseHiddenTime,
		default = Harvest.settings.defaultSettings.useHiddenTime,
	})

	submenuTable:insert({
		type = "slider",
		name = Harvest.GetLocalization("hiddentime"),
		tooltip = Harvest.GetLocalization("hiddentimetooltip"),
		min = 1,
		max = 20,
		getFunc = Harvest.GetHiddenTime,
		setFunc = Harvest.SetHiddenTime,
		default = Harvest.settings.defaultSettings.hiddenTime,
		disabled = IsTimerDisabled,
	})

	submenuTable:insert({
		type = "checkbox",
		name = Harvest.GetLocalization("hiddenonharvest"),
		tooltip = Harvest.GetLocalization("hiddenonharvesttooltip"),
		getFunc = Harvest.IsHiddenOnHarvest,
		setFunc = Harvest.SetHiddenOnHarvest,
		default = Harvest.settings.defaultSettings.hiddenOnHarvest,
		disabled = IsTimerDisabled,
	})

	--[[
	#####
	#####  PIN OPTIONS
	#####
	--]]


	local submenuTable = setmetatable({}, { __index = table })
	optionsTable:insert({
		type = "submenu",
		name = Harvest.GetLocalization("pinoptions"),
		controls = submenuTable,
	})

	--[[
	submenuTable:insert({
		type = "description",
		title = nil,
		text = Harvest.GetLocalization("filterprofiledescription"),
		width = "full",
	})
	-- todo: remove extended pin option and pin filter
	-- and instead add reference to filter profiles
	submenuTable:insert({
		type = "button",
		name = Harvest.GetLocalization("filterprofilebutton"),
		func = function()
			Harvest.filterProfiles:Show()
			SCENE_MANAGER:Show("hud")
		end,
		width = "half",
	})
	--]]
	for _, pinTypeId in ipairs( Harvest.PINTYPES ) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			submenuTable:insert({
				type = "header",
				name = Harvest.GetLocalization( "pintype" .. pinTypeId )
			})
			if pinTypeId ~= Harvest.UNKNOWN then
				submenuTable:insert( CreateGatherFilter( pinTypeId ) )
			end
			submenuTable:insert( CreateColorPicker( pinTypeId ) )
			submenuTable:insert( CreateIconPicker( pinTypeId ) )
			submenuTable:insert( CreateSizeSlider( pinTypeId ) )
		end
	end

	Harvest.optionsPanel = LAM:RegisterAddonPanel("HarvestMapControl", panelData)
	LAM:RegisterOptionControls("HarvestMapControl", optionsTable)
	self.optionsTable = optionsTable

	CallbackManager:RegisterForEvent(Events.FILTER_PROFILE_CHANGED, function(event, profile, pinTypeId, visible)
		CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", Harvest.optionsPanel)
	end)

	local settingsForRefresh = {
		compassFilterProfile = true,
		worldFilterProfile = true,
	}
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, value)
		if settingsForRefresh[setting] then
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", Harvest.optionsPanel)
		end
	end)
end
