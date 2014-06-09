local LAM = LibStub("LibAddonMenu-1.0")
local panelID

local newPVECheckboxes = {}
local newPVPCheckboxes = {}

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

    LAM:AddCheckbox(panelID, "HarvestMapFilter"..profession, Harvest.localization[ "filter"..profession ], Harvest.localization[ "filtertooltip"..profession ],
        function()
            return Harvest.GetFilter( profession )
        end,
        function( value )
            Harvest.SetFilter( profession, value )
        end,
        false, nil)

end

local function CreateImportFilter( profession )

    LAM:AddCheckbox(panelID, "HarvestImportFilter"..profession, Harvest.localization[ "import"..profession ], Harvest.localization[ "importtooltip"..profession ],
        function()
            return Harvest.GetImportFilter( profession )
        end,
        function( value )
            Harvest.SetImportFilter( profession, value )
        end,
        false, nil)

end

local function CreateGatherFilter( profession )

    LAM:AddCheckbox(panelID, "HarvestGatherFilter"..profession, Harvest.localization[ "gather"..profession ], Harvest.localization[ "gathertooltip"..profession ],
        function()
            return Harvest.GetGatherFilter( profession )
        end,
        function( value )
            Harvest.SetGatherFilter( profession, value )
        end,
        false, nil)

end

local function CreateSizeSlider( profession )
    LAM:AddSlider(panelID, "HarvestMapSize"..profession, Harvest.localization[ "size"..profession ], Harvest.localization[ "sizetooltip"..profession ], 16, 64, 1,
        function()
            return Harvest.GetSize( profession )
        end,
        function( value )
            Harvest.SetSize( profession, value )
        end,
        false, nil)
end

local function CreateColorPicker( profession )
    LAM:AddColorPicker(panelID, "HarvestMapColor"..profession, Harvest.localization[ "color"..profession ], Harvest.localization[ "colortooltip"..profession ],
        function()
            return Harvest.GetColor( profession )
        end,
        function( r, g, b )
            Harvest.SetColor( profession, r, g, b )
        end,
        false, nil)
end

local function changeAccountWideSettings(val)
    Harvest.defaults.wideSetting = val
    ReloadUI()
end

function Harvest.InitializeOptions()
    panelID = LAM:CreateControlPanel("HarvestMapControl", "HarvestMap")
    Harvest.panelID = panelID

    LAM:AddHeader(panelID, "HarvestMapHeader", "Compass Options")

    LAM:AddCheckbox(panelID, "HarvestMapCompass", Harvest.localization[ "compass" ], Harvest.localization[ "compasstooltip" ],
        function()
            return Harvest.savedVars["settings"].compass
        end,
        function( value )
            Harvest.savedVars["settings"].compass = value
            COMPASS_PINS:RefreshPins()
        end,
        false, nil)

    LAM:AddSlider(panelID, "HarvestMapFOV", Harvest.localization["fov"],Harvest.localization["fovtooltip"], 25, 100, 1,
        function()
            if Harvest.savedVars["settings"].compassLayouts[1].FOV then
                return ( 100 * Harvest.savedVars["settings"].compassLayouts[1].FOV / (2 * math.pi) )
            end

            return 100 * COMPASS_PINS.defaultFOV / (2 * math.pi)
        end,
        function( value )
            -- for profession = 1,6 do
            for profession = 1,8 do
                Harvest.savedVars["settings"].compassLayouts[ profession ].FOV = 2 * value * math.pi / 100
            end
            COMPASS_PINS:RefreshPins()
        end,
        false, nil)

    LAM:AddSlider(panelID, "HarvestMapDistance", Harvest.localization["distance"], Harvest.localization["distancetooltip"], 1, 100, 1,
        function()
            return Harvest.savedVars["settings"].compassLayouts[1].maxDistance * 1000
        end,
        function( value )
            -- for profession = 1,6 do
            for profession = 1,8 do
                Harvest.savedVars["settings"].compassLayouts[ profession ].maxDistance  = value / 1000
            end
            COMPASS_PINS:RefreshPins()
        end,
        false, nil)

    -- New Duplicate Node Range Check Sliders
    LAM:AddSlider(panelID, "MinimumNodeDifference", Harvest.localization["minnodedist"], Harvest.localization["nodedisttooltip"], 25, 100, 1,
        function()
            return Harvest.GetMinDist()
        end,
        function( value )
            Harvest.SetMinDist( value )
            Harvest.minDefault = 0.000001 * Harvest.defaults.minDefault
        end,
        false, nil)

    LAM:AddSlider(panelID, "MinimumReticleDifference", Harvest.localization["minreticledist"], Harvest.localization["reticledisttooltip"], 49, 100, 1,
        function()
            return Harvest.GetMinReticle()
        end,
        function( value )
            Harvest.SetMinReticle( value )
            Harvest.minReticleover = 0.000001 * Harvest.defaults.minReticleover
        end,
        false, nil)

    -- for profession = 1,6 do
    for profession = 1,8 do
        LAM:AddHeader(panelID, "HarvestMapPinHeader"..profession, Harvest.localization[ "filter"..profession ] .. " pin Options")
        CreateFilter( profession )
        CreateImportFilter( profession )
        CreateGatherFilter( profession )
        CreateSizeSlider( profession )
        CreateColorPicker( profession )
    end

    LAM:AddHeader(panelID, "HarvestDebugHeader", "Debug")

    LAM:AddCheckbox(panelID, "HarvestMapDebug", "Debug mode", "Enable debug mode",
        function()
            return Harvest.defaults.debug
        end,
        function( value )
            Harvest.defaults.debug = value
        end,
    false, nil)

    LAM:AddCheckbox(panelID, "HarvestMapDebugVerbose", "Verbose debug mode", "Enable verbose debug mode",
        function()
            return Harvest.defaults.verbose
        end,
        function( value )
            Harvest.defaults.verbose = value
        end,
    false, nil)

    LAM:AddHeader(panelID, "HarvestSettingsHeader", "Account Wide Settings")

    LAM:AddCheckbox(panelID, "HarvestMapSettings", "Account Wide Settings", "Enable account Wide Settings",
        function()
            return Harvest.defaults.wideSetting
        end,
        function( value )
            Harvest.defaults.wideSetting = value
            changeAccountWideSettings(value)
        end,
    false, nil)

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
function GetString( stringVariablePrefix, contextId )
    if stringVariablePrefix == "SI_MAPFILTER" and type(contextId) == "string" then
    --if Harvest.startsWith( contextId, Harvest.GetPinType("") ) then
        local profession = Harvest.GetNumberAfter(contextId, Harvest.GetPinType(""))
        return Harvest.localization[ "filter"..profession ]
    --end
    end
    return oldGetString( stringVariablePrefix, contextId )

end

local oldVars = WORLD_MAP_FILTERS.SetSavedVars
-- setsavedVars initializes the filter controlls for pve and pvp map type
-- after this function is called WORLD_MAP_FILTERS.pvePanel are initialized and can be manipulated
WORLD_MAP_FILTERS.SetSavedVars = function( self, savedVars )
    oldVars( self, savedVars)

    -- for i=1,6 do
    for i=1,8 do
    local profession = i
    self.pvePanel.AddPinFilterCheckBox( self.pvePanel, Harvest.GetPinType( profession ), function() Harvest.RefreshPins( profession ) end)

    newPVECheckboxes[ profession ] = self.pvePanel.pinFilterCheckBoxes[ #self.pvePanel.pinFilterCheckBoxes ]
    ZO_CheckButton_SetToggleFunction( newPVECheckboxes[ profession ], function(button, checked)
        Harvest.SetFilter( profession, checked )
    end)

    self.pvpPanel.AddPinFilterCheckBox( self.pvpPanel, Harvest.GetPinType( profession ), function() Harvest.RefreshPins( profession ) end)

    newPVPCheckboxes[ profession ] = self.pvpPanel.pinFilterCheckBoxes[ #self.pvpPanel.pinFilterCheckBoxes ]
    ZO_CheckButton_SetToggleFunction( newPVPCheckboxes[ profession ], function(button, checked)
        Harvest.SetFilter( profession, checked )
    end)

    end
end
