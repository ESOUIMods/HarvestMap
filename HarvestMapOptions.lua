local LMP = LibStub("LibMapPins-1.0")

if not Harvest then
    Harvest = {}
end

function Harvest.IsPinTypeSavedOnImport( pinTypeId )
    return Harvest.savedVars["settings"].isPinTypeSavedOnImport[ pinTypeId ]
end

function Harvest.SetPinTypeSavedOnImport( pinTypeId, value )
    Harvest.savedVars["settings"].isPinTypeSavedOnImport[ pinTypeId ] = value
end

function Harvest.IsZoneSavedOnImport( zone )
    return Harvest.savedVars["settings"].isZoneSavedOnImport[ zone ]
end

function Harvest.SetZoneSavedOnImport( zone, value )
    Harvest.savedVars["settings"].isZoneSavedOnImport[ zone ] = value
end

function Harvest.AreCompassPinsVisible()
    return Harvest.savedVars["settings"].isCompassVisible
end

function Harvest.SetCompassPinsVisible( value )
    Harvest.savedVars["settings"].isCompassVisible = value
end

function Harvest.GetCompassLayouts()
    return Harvest.savedVars["settings"].compassLayouts
end

function Harvest.GetCompassPinLayout( pinTypeId )
    return Harvest.savedVars["settings"].compassLayouts[ pinTypeId ]
end

function Harvest.GetMapLayouts()
    return Harvest.savedVars["settings"].mapLayouts
end

function Harvest.GetMapPinLayout( pinTypeId )
    return Harvest.savedVars["settings"].mapLayouts[ pinTypeId ]
end

function Harvest.IsPinTypeVisible( pinTypeId )
    return Harvest.savedVars["settings"].isPinTypeVisible[ Harvest.GetPinType(pinTypeId) ]
end

function Harvest.IsPinTypeVisible_string( pinType )
    return Harvest.savedVars["settings"].isPinTypeVisible[ pinType ]
end

function Harvest.SetPinTypeVisible( pinTypeId, value )
    Harvest.savedVars["settings"].isPinTypeVisible[ Harvest.GetPinType( pinTypeId ) ] = value
    LMP:SetEnabled( Harvest.GetPinType( pinTypeId ), value )
end

function Harvest.IsDebugEnabled()
    return Harvest.savedVars["settings"].isPinTypeVisible[ Harvest.GetPinType( "Debug" ) ]
end

function Harvest.SetDebugEnabled( value )
    Harvest.savedVars["settings"].isPinTypeVisible[ Harvest.GetPinType( "Debug" ) ] = value
    LMP:SetEnabled(  Harvest.GetPinType( "Debug" ), value )
end

function Harvest.AreDebugMessagesEnabled()
    return Harvest.savedVars["settings"].debug
end

function Harvest.SetDebugMessagesEnabled( value )
    Harvest.savedVars["settings"].debug = value
end

function Harvest.IsPinTypeSavedOnGather( pinTypeId )
    return Harvest.savedVars["settings"].isPinTypeSavedOnGather[ pinTypeId ]
end

function Harvest.SetPinTypeSavedOnGather( pinTypeId, value )
    Harvest.savedVars["settings"].isPinTypeSavedOnGather[ pinTypeId ] = value
end

function Harvest.GetMinDistanceBetweenPins()
    return Harvest.savedVars["settings"].minDistanceBetweenPins
end

function Harvest.SetMinDistanceBetweenPins( value )
    Harvest.savedVars["settings"].minDistanceBetweenPins = value
end

function Harvest.GetMapPinSize( pinTypeId )
    return Harvest.savedVars["settings"].mapLayouts[ pinTypeId ].size
end

function Harvest.SetMapPinSize( pinTypeId, value )
    Harvest.savedVars["settings"].mapLayouts[ pinTypeId ].size = value
    LMP:SetLayoutKey( Harvest.GetPinType( pinTypeId ), "size", value )
    Harvest.RefreshPins( pinTypeId )
end

function Harvest.GetPinColor( pinTypeId )
    return Harvest.savedVars["settings"].mapLayouts[ pinTypeId ].tint:UnpackRGB()
end

function Harvest.SetPinColor( pinTypeId, r, g, b )
    Harvest.savedVars["settings"].mapLayouts[ pinTypeId ].tint:SetRGB( r, g, b )
    Harvest.savedVars["settings"].compassLayouts[ pinTypeId ].color = { r, g, b }
    LMP:GetLayoutKey( Harvest.GetPinType( pinTypeId ), "tint" ):SetRGB( r, g, b )
    Harvest.RefreshPins( pinTypeId )
end

local function CreateFilter( pinTypeId )

    local pinTypeId = pinTypeId

    local filter = {
        type = "checkbox",
        name = Harvest.GetLocalizedPinFilter( pinTypeId ),
        tooltip = Harvest.GetLocalizedPinFilterTooltip( pinTypeId ),
        getFunc = function()
            return Harvest.IsPinTypeVisible( pinTypeId )
        end,
        setFunc = function( value )
            Harvest.SetPinTypeVisible( pinTypeId, value )
        end,
        default = Harvest.defaultSettings.isPinTypeVisible[ pinTypeId ],
    }

    return filter

end

local function CreateGatherFilter( pinTypeId )

    local pinTypeId = pinTypeId

    local gatherFilter = {
        type = "checkbox",
        name = Harvest.GetLocalizedGatherFilter( pinTypeId ),
        tooltip = Harvest.GetLocalizedGatherFilterTooltip( pinTypeId ),
        getFunc = function()
            return Harvest.IsPinTypeSavedOnGather( pinTypeId )
        end,
        setFunc = function( value )
            Harvest.SetPinTypeSavedOnGather( pinTypeId, value )
        end,
        default = Harvest.defaultSettings.isPinTypeSavedOnGather[ pinTypeId ],
    }

    return gatherFilter

end

local function CreateSizeSlider( pinTypeId )

    local pinTypeId = pinTypeId

    local sizeSlider = {
        type = "slider",
        name = Harvest.GetLocalizedMapPinSize( pinTypeId ),
        tooltip =  Harvest.GetLocalizedMapPinSizeTooltip( pinTypeId ),
        min = 16,
        max = 64,
        getFunc = function()
            return Harvest.GetMapPinSize( pinTypeId )
        end,
        setFunc = function( value )
            Harvest.SetMapPinSize( pinTypeId, value )
        end,
        default = Harvest.defaultSettings.mapLayouts[ pinTypeId ].size,
    }

    return sizeSlider

end

local function CreateColorPicker( pinTypeId )

    local pinTypeId = pinTypeId

    local colorPicker = {
        type = "colorpicker",
        name = Harvest.GetLocalizedPinColor( pinTypeId ),
        tooltip = Harvest.GetLocalizedPinColorTooltip( pinTypeId ),
        getFunc = function() return Harvest.GetPinColor( pinTypeId ) end,
        setFunc = function( r, g, b ) Harvest.SetPinColor( pinTypeId, r, g, b ) end,
        default = Harvest.defaultSettings.mapLayouts[ pinTypeId ].tint,
    }
     
    return colorPicker

end

local function changeAccountWideSettings(val)
    Harvest.defaults.wideSetting = val
    ReloadUI("ingame")
end

function Harvest.InitializeOptions()
    local panelData = {
        type = "panel",
        name = "HarvestMap",
        displayName = ZO_HIGHLIGHT_TEXT:Colorize("HarvestMap"),
        author = "Shinni & Sharlikran",
        version = Harvest.displayVersion,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsTable = setmetatable({}, { __index = table })

    -- New Duplicate Node Range Check Sliders
    optionsTable:insert({
        type = "slider",
        name = Harvest.GetLocalizedMinDistance(),
        tooltip = Harvest.GetLocalizedMinDistanceTooltip(),
        min = 25,
        max = 100,
        getFunc = function()
            return Harvest.savedVars["settings"].minDistanceBetweenPins * 1000000
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].minDistanceBetweenPins = 0.000001 * value
        end,
        default = Harvest.defaultSettings.minDistanceBetweenPins * 1000000,
    })

    optionsTable:insert({
        type = "header",
        name = "Compass Options",
    })

    optionsTable:insert({
        type = "checkbox",
        name = Harvest.GetLocalizedCompass(),
        tooltip = Harvest.GetLocalizedCompassTooltip(),
        getFunc = function() return Harvest.AreCompassPinsVisible() end,
        setFunc = function( value )
            Harvest.SetCompassPinsVisible( value )
            COMPASS_PINS:RefreshPins()
        end,
        default = Harvest.defaultSettings.isCompassVisible,
    })

    optionsTable:insert({
        type = "slider",
        name = Harvest.GetLocalizedFOV(),
        tooltip = Harvest.GetLocalizedFOVTooltip(),
        min = 25,
        max = 100,
        getFunc = function()
            local FOV = Harvest.savedVars["settings"].compassLayouts[1].FOV or COMPASS_PINS.defaultFOV
            return zo_round(100 *  FOV / (2 * math.pi))
        end,
        setFunc = function( value )
            for profession = 1,8 do
                Harvest.savedVars["settings"].compassLayouts[ profession ].FOV = 2 * value * math.pi / 100
            end
            COMPASS_PINS:RefreshPins()
        end,
        default = 100 * COMPASS_PINS.defaultFOV / (2 * math.pi)
    })

    optionsTable:insert({
        type = "slider",
        name = Harvest.GetLocalizedCompassDistance(),
        tooltip = Harvest.GetLocalizedCompassDistanceTooltip(),
        min = 1,
        max = 100,
        getFunc = function()
            return Harvest.savedVars["settings"].compassLayouts[1].maxDistance * 1000
        end,
        setFunc = function( value )
            for _, pinTypeId in pairs( Harvest.PINTYPES ) do
                Harvest.savedVars["settings"].compassLayouts[ pinTypeId ].maxDistance  = value / 1000
            end
            COMPASS_PINS:RefreshPins()
        end,
        default = Harvest.defaultSettings.compassLayouts[1].maxDistance * 1000
    })

    for _, pinTypeId in pairs( Harvest.PINTYPES ) do
        optionsTable:insert({
            type = "header",
            name = Harvest.GetLocalizedPinFilter( pinTypeId ) .. " Options",
        })
        optionsTable:insert( CreateFilter( pinTypeId ) )
        --optionsTable:insert( CreateImportFilter( pinTypeId ) )
        optionsTable:insert( CreateGatherFilter( pinTypeId ) )
        optionsTable:insert( CreateSizeSlider( pinTypeId ) )
        optionsTable:insert( CreateColorPicker( pinTypeId ) )
    end

    optionsTable:insert({
        type = "header",
        name = "Debug",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Display debug messages",
        tooltip = "Enable to display debug messages in the chat.",
        getFunc = Harvest.AreDebugMessagesEnabled,
        setFunc = Harvest.SetDebugMessagesEnabled,
        default = Harvest.defaultSettings.debug,
    })

    optionsTable:insert({
        type = "header",
        name = "Account Wide Settings",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Account Wide Settings",
        tooltip = "Enable account Wide Settings",
        getFunc = function()
            return Harvest.savedVars["global"].accountWideSettings
        end,
        setFunc = function( value )
            Harvest.savedVars["global"].accountWideSettings = value
            ReloadUI("ingame")
        end,
        width = "full",
        warning = "Will reload the UI.",
        --default = Harvest.defaultGlobalSettings.accountWideSettings,
    })

    local LAM = LibStub("LibAddonMenu-2.0")
    LAM:RegisterAddonPanel("HarvestMapControl", panelData)
    LAM:RegisterOptionControls("HarvestMapControl", optionsTable)

end
