local newPVECheckboxes = {}
local newPVPCheckboxes = {}

local optionsTable = setmetatable({}, { __index = table })

function Harvest.GetFilter( profession )
    return Harvest.savedVars["settings"].filters[ profession ]
end

function Harvest.GetImportFilter( profession )
    return Harvest.savedVars["settings"].importFilters[ profession ]
end

function Harvest.GetGatherFilter( profession )
    return Harvest.savedVars["settings"].gatherFilters[ profession ]
end

function Harvest.SetFilter( profession, value )
    Harvest.savedVars["settings"].filters[ profession ] = value
    Harvest.RefreshPins( profession )
end

function Harvest.SetImportFilter( profession, value )
    Harvest.savedVars["settings"].importFilters[ profession ] = value
    -- No need to refresh pins since it happens on import
end

function Harvest.SetGatherFilter( profession, value )
    Harvest.savedVars["settings"].gatherFilters[ profession ] = value
    -- No need to refresh pins since it happens when gathering
end

function Harvest.GetSize( profession )
    return Harvest.savedVars["settings"].mapLayouts[ profession ].size
end

function Harvest.SetSize( profession, value )
    Harvest.savedVars["settings"].mapLayouts[ profession ].size = value
    Harvest.RefreshPins( profession )
end

function Harvest.GetColor( profession )
    return unpack( Harvest.savedVars["settings"].mapLayouts[ profession ].color )
end

function Harvest.SetColor( profession, r, g, b )
    Harvest.savedVars["settings"].mapLayouts[ profession ].color = { r, g, b }
    Harvest.savedVars["settings"].compassLayouts[ profession ].color = { r, g, b }
    Harvest.RefreshPins( profession )
end

-- Harvest DuplicateNode Range Checking
function Harvest.GetMinDist()
    return Harvest.defaults.minDefault
end

function Harvest.SetMinDist(value)
    Harvest.defaults.minDefault = value
end

function Harvest.GetMinReticle()
    return Harvest.defaults.minReticleover
end

function Harvest.SetMinReticle(value)
    Harvest.defaults.minReticleover = value
end

local function CreateFilter( profession )

    optionsTable:insert({
        type = "checkbox",
        name = Harvest.localization[ "filter"..profession ],
        tooltip = Harvest.localization[ "filtertooltip"..profession ],
        getFunc = function()
            return Harvest.GetFilter( profession )
        end,
        setFunc = function( value )
            Harvest.SetFilter( profession, value )
        end,
        default = Harvest.DefaultConfiguration.filters[ profession ],
    })

end

local function CreateImportFilter( profession )

    optionsTable:insert({
        type = "checkbox",
        name = Harvest.localization[ "import"..profession ],
        tooltip = Harvest.localization[ "importtooltip"..profession ],
        getFunc = function()
            Harvest.GetImportFilter( profession )
        end,
        setFunc = function( value )
            Harvest.SetImportFilter( profession, value )
        end,
        default = Harvest.DefaultConfiguration.importFilters[ profession ],
    })

end

local function CreateGatherFilter( profession )

    optionsTable:insert({
        type = "checkbox",
        name = Harvest.localization[ "gather"..profession ],
        tooltip = Harvest.localization[ "gathertooltip"..profession ],
        getFunc = function()
            Harvest.GetGatherFilter( profession )
        end,
        setFunc = function( value )
            Harvest.SetGatherFilter( profession, value )
        end,
        default = Harvest.DefaultConfiguration.gatherFilters[ profession ],
    })

end

local function CreateSizeSlider( profession )

    optionsTable:insert({
        type = "slider",
        name = Harvest.localization[ "size"..profession ],
        tooltip = Harvest.localization[ "sizetooltip"..profession ],
        min = 16,
        max = 64,
        getFunc = function()
            return Harvest.GetSize( profession )
        end,
        setFunc = function( value )
            Harvest.SetSize( profession, value )
        end,
        default = Harvest.defaultMapLayouts[ profession ].size,
    })

end

local function CreateColorPicker( profession )

    optionsTable:insert({
        type = "colorpicker",
        name = Harvest.localization[ "color"..profession ],
        tooltip = Harvest.localization[ "colortooltip"..profession ],
        getFunc = function() return Harvest.GetColor( profession ) end,
        setFunc = function( r, g, b ) Harvest.SetColor( profession, r, g, b ) end,
        default = {
            r = Harvest.defaultMapLayouts[ profession ].color[1],
            g = Harvest.defaultMapLayouts[ profession ].color[2],
            b = Harvest.defaultMapLayouts[ profession ].color[3],
            a = 1,
        }
    })

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

    optionsTable:insert({
        type = "button",
        name = "Import other Accounts",
        tooltip = "Moves gathered data from other Accounts to this one. This can also restore lost data after an ESO update.",
        warning = "Please create a backup of your data first! Copy the file SavedVariables/HarvestMap.lua to somwhere else.",
        width = "half",
        func = function()
            Harvest.makeGlobal("nodes")
        end
    })
    optionsTable:insert({
	type = "button",
	name = "Reduce filesize",
	tooltip = "Transforms the data's structure to reduce the total file size. Can reduce load times.",
	warning = "Please create a backup of your data first! Copy the file SavedVariables/HarvestMap.lua to somwhere else.",
	width = "half",
	func = function()
            Harvest.updateHarvestNodes("nodes")
	    Harvest.updateHarvestNodes("mapinvalid")
            Harvest.updateHarvestNodes("esonodes")
            Harvest.updateHarvestNodes("esoinvalid")
	end
    })
    optionsTable:insert({
        type = "header",
        name = "Compass Options",
    })

    optionsTable:insert({
        type = "checkbox",
        name = Harvest.localization[ "compass" ],
        tooltip = Harvest.localization[ "compasstooltip" ],
        getFunc = function() return Harvest.defaults.compass end,
        setFunc = function( value )
            Harvest.defaults.compass = value
            COMPASS_PINS:RefreshPins()
        end,
        default = Harvest.DefaultSettings.compass,
    })

    optionsTable:insert({
        type = "slider",
        name = Harvest.localization["fov"],
        tooltip = Harvest.localization["fovtooltip"],
        min = 25,
        max = 100,
        getFunc = function()
            local FOV = Harvest.savedVars["settings"].compassLayouts[1].FOV or COMPASS_PINS.defaultFOV
            return 100 *  FOV / (2 * math.pi)
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
        name = Harvest.localization["distance"],
        tooltip = Harvest.localization["distancetooltip"],
        min = 1,
        max = 100,
        getFunc = function()
            return Harvest.savedVars["settings"].compassLayouts[1].maxDistance * 1000
        end,
        setFunc = function( value )
            for profession = 1, 8 do
                Harvest.savedVars["settings"].compassLayouts[ profession ].maxDistance  = value / 1000
            end
            COMPASS_PINS:RefreshPins()
        end,
        default = Harvest.defaultCompassLayouts[1].maxDistance * 1000
    })

    -- New Duplicate Node Range Check Sliders
    optionsTable:insert({
        type = "slider",
        name = Harvest.localization["minnodedist"],
        tooltip = Harvest.localization["nodedisttooltip"],
        min = 25,
        max = 100,
        getFunc = function()
            return Harvest.GetMinDist()
        end,
        setFunc = function( value )
            Harvest.SetMinDist( value )
            Harvest.minDefault = 0.000001 * Harvest.defaults.minDefault
        end,
        default = Harvest.DefaultSettings.minDefault,
    })

    optionsTable:insert({
        type = "slider",
        name = Harvest.localization["minreticledist"],
        tooltip = Harvest.localization["reticledisttooltip"],
        min = 49,
        max = 100,
        getFunc = function()
            return Harvest.GetMinReticle()
        end,
        setFunc = function( value )
            Harvest.SetMinReticle( value )
            Harvest.minReticleover = 0.000001 * Harvest.defaults.minReticleover
        end,
        default = Harvest.DefaultSettings.minReticleover,
    })

    for profession = 1, 8 do
        optionsTable:insert({
            type = "header",
            name = Harvest.localization[ "filter"..profession ] .. " pin Options",
        })
        CreateFilter( profession )
        CreateImportFilter( profession )
        CreateGatherFilter( profession )
        CreateSizeSlider( profession )
        CreateColorPicker( profession )
    end

    optionsTable:insert({
        type = "header",
        name = "Aldmeri Dominion Map Filters",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Auridon Map Filter",
        tooltip = "Enable filtering for Auridon",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "auridon" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "auridon" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "auridon" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Grahtwood Map Filter",
        tooltip = "Enable filtering for Grahtwood",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "grahtwood" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "grahtwood" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "grahtwood" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Greenshade Map Filter",
        tooltip = "Enable filtering for Greenshade",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "greenshade" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "greenshade" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "greenshade" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Malabal Tor Map Filter",
        tooltip = "Enable filtering for Malabal Tor",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "malabaltor" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "malabaltor" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "malabaltor" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Reaper's March Tor Map Filter",
        tooltip = "Enable filtering for Reaper's March",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "reapersmarch" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "reapersmarch" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "reapersmarch" ],
    })

    optionsTable:insert({
        type = "header",
        name = "Daggerfall Covenant Map Filters",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Alik'r Desert Filter",
        tooltip = "Enable filtering for Alik'r Desert",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "alikr" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "alikr" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "alikr" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Bangkorai Map Filter",
        tooltip = "Enable filtering for Bangkorai",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "bangkorai" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "bangkorai" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "bangkorai" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Glenumbra Map Filter",
        tooltip = "Enable filtering for Glenumbra",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "glenumbra" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "glenumbra" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "glenumbra" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Rivenspire Map Filter",
        tooltip = "Enable filtering for Rivenspire",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "rivenspire" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "rivenspire" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "rivenspire" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Stormhaven Map Filter",
        tooltip = "Enable filtering for Stormhaven",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "stormhaven" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "stormhaven" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "stormhaven" ],
    })

    optionsTable:insert({
        type = "header",
        name = "Ebonheart Pact Map Filters",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Deshaan Map Filter",
        tooltip = "Enable filtering for Deshaan",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "deshaan" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "deshaan" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "deshaan" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Eastmarch Map Filter",
        tooltip = "Enable filtering for Eastmarch",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "eastmarch" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "eastmarch" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "eastmarch" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Shadowfen Map Filter",
        tooltip = "Enable filtering for Shadowfen",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "shadowfen" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "shadowfen" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "shadowfen" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Stonefalls Map Filter",
        tooltip = "Enable filtering for Stonefalls",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "stonefalls" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "stonefalls" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "stonefalls" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "The Rift Map Filter",
        tooltip = "Enable filtering for The Rift",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "therift" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "therift" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "therift" ],
    })

    optionsTable:insert({
        type = "header",
        name = "Other Map Filters",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Craglorn Map Filter",
        tooltip = "Enable filtering for Craglorn",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "craglorn" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "craglorn" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "craglorn" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Coldharbor Map Filter",
        tooltip = "Enable filtering for Coldharbor",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "coldharbor" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "coldharbor" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "coldharbor" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Cyrodiil Map Filter",
        tooltip = "Enable filtering for Cyrodiil",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "cyrodiil" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "cyrodiil" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "cyrodiil" ],
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Cities Map Filters",
        tooltip = "Enable filtering for City Maps",
        getFunc = function()
            return Harvest.savedVars["settings"].mapnameFilters[ "cities" ]
        end,
        setFunc = function( value )
            Harvest.savedVars["settings"].mapnameFilters[ "cities" ] = value
        end,
        default = Harvest.DefaultConfiguration.mapnameFilters[ "cities" ],
    })

    optionsTable:insert({
        type = "header",
        name = "Debug",
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Debug mode",
        tooltip = "Enable debug mode",
        getFunc = function()
            return Harvest.defaults.debug
        end,
        setFunc = function( value )
            Harvest.defaults.debug = value
        end,
        default = Harvest.DefaultSettings.debug,
    })
    optionsTable:insert({
        type = "checkbox",
        name = "Verbose debug mode",
        tooltip = "Enable verbose debug mode",
        getFunc = function()
            return Harvest.defaults.verbose
        end,
        setFunc = function( value )
            Harvest.defaults.verbose = value
        end,
        default = Harvest.DefaultSettings.verbose,
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
            return Harvest.defaults.wideSetting
        end,
        setFunc = function( value )
            Harvest.defaults.wideSetting = value
            changeAccountWideSettings(value)
        end,
        default = Harvest.DefaultSettings.wideSetting,
    })

    local LAM = LibStub("LibAddonMenu-2.0")
    LAM:RegisterAddonPanel("HarvestMapControl", panelData)
    LAM:RegisterOptionControls("HarvestMapControl", optionsTable)

    --pvepanel has no mode if the character starts his session on a pvp map
    WORLD_MAP_FILTERS.pvePanel:SetMapMode(2) -- prevents crashing on GetPinFilter in above case
end

local lastContext
function Harvest.RefreshFilterCheckboxes()
    --check which checkboxes will be shown, so you do not need to update everything
    local context = GetMapContentType() == MAP_CONTENT_AVA --true if pvp context
    local checkboxes = context and newPVPCheckboxes or newPVECheckboxes
    --do not refresh checkboxes if map context is not changed
    if context ~= lastContext then
        lastContext = context
        for profession = 1, 8 do
            ZO_CheckButton_SetCheckState(checkboxes[profession], Harvest.GetFilter(profession))
        end
    end
end
CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", Harvest.RefreshFilterCheckboxes)

function Harvest.GetNumberAfter( str, start )
    if string.sub(str,1,string.len(start)) == start then
        return tonumber(string.sub(str, string.len(start)+1, -1))
    end
    return nil
end

local oldGetString = GetString
-- the filter checkboxes display the localization string, retrieved by this function
-- since there is no API to the filters, I had to hack a bit, to display my own strings :)
function GetString( stringVariablePrefix, contextId, ... )
    if stringVariablePrefix == "SI_MAPFILTER" and type(contextId) == "string" then
    --if Harvest.startsWith( contextId, Harvest.GetPinType("") ) then
        local profession = Harvest.GetNumberAfter(contextId, Harvest.GetPinType(""))
        return Harvest.localization[ "filter"..profession ]
    --end
    end
    return oldGetString( stringVariablePrefix, contextId, ... )

end

local oldVars = WORLD_MAP_FILTERS.SetSavedVars
-- setsavedVars initializes the filter controlls for pve and pvp map type
-- after this function is called WORLD_MAP_FILTERS.pvePanel are initialized and can be manipulated
WORLD_MAP_FILTERS.SetSavedVars = function( self, savedVars, ... )
    oldVars( self, savedVars, ... )

    for i=1,8 do
        local profession = i

        self.pvePanel.AddPinFilterCheckBox( self.pvePanel, Harvest.GetPinType( profession ), function() Harvest.RefreshPins( profession ) end)
        newPVECheckboxes[ profession ] = self.pvePanel.pinFilterCheckBoxes[ #self.pvePanel.pinFilterCheckBoxes ]
        ZO_CheckButton_SetToggleFunction( newPVECheckboxes[ profession ], function(button, checked) Harvest.SetFilter( profession, checked ) end)

        self.pvpPanel.AddPinFilterCheckBox( self.pvpPanel, Harvest.GetPinType( profession ), function() Harvest.RefreshPins( profession ) end)
        newPVPCheckboxes[ profession ] = self.pvpPanel.pinFilterCheckBoxes[ #self.pvpPanel.pinFilterCheckBoxes ]
        ZO_CheckButton_SetToggleFunction( newPVPCheckboxes[ profession ], function(button, checked) Harvest.SetFilter( profession, checked ) end)
    end
end
