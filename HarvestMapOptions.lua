local LAM = LibStub("LibAddonMenu-1.0")
local panelID

local newPVECheckboxes = {}
local newPVPCheckboxes = {}

function Harvest.GetFilter( profession )
    return Harvest.settings.filters[ profession ]
end

function Harvest.SetFilter( profession, value )
    Harvest.settings.filters[ profession ] = value
    Harvest.RefreshPins( profession )
end

function Harvest.GetSize( profession )
    return Harvest.settings.mapLayouts[ profession ].size
end

function Harvest.SetSize( profession, value )
    Harvest.settings.mapLayouts[ profession ].size = value
    Harvest.RefreshPins( profession )
end

function Harvest.GetColor( profession )
    return unpack( Harvest.settings.mapLayouts[ profession ].color )
end

function Harvest.SetColor( profession, r, g, b )
    Harvest.settings.mapLayouts[ profession ].color = { r, g, b }
    Harvest.settings.compassLayouts[ profession ].color = { r, g, b }
    Harvest.RefreshPins( profession )
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

function Harvest.InitializeOptions()
	panelID = LAM:CreateControlPanel("HarvestMapControl", "HarvestMap")

	LAM:AddHeader(panelID, "HarvestMapHeader", "Compass Options")
	
	LAM:AddCheckbox(panelID, "HarvestMapCompass", Harvest.localization[ "compass" ], Harvest.localization[ "compasstooltip" ],
		function()
			return Harvest.settings.compass
		end,
		function( value )
			Harvest.settings.compass = value
			COMPASS_PINS:RefreshPins()
		end,
		false, nil)
	
	LAM:AddSlider(panelID, "HarvestMapFOV", Harvest.localization["fov"],Harvest.localization["fovtooltip"], 25, 100, 1,
		function()
			if Harvest.settings.compassLayouts[1].FOV then
				return ( 100 * Harvest.settings.compassLayouts[1].FOV / (2 * math.pi) )
			end
			
			return 100 * COMPASS_PINS.defaultFOV / (2 * math.pi)
		end,
		function( value )
            -- for profession = 1,6 do
            for profession = 1,8 do
				Harvest.settings.compassLayouts[ profession ].FOV = 2 * value * math.pi / 100
			end
			COMPASS_PINS:RefreshPins()
		end,
		false, nil)
	
	LAM:AddSlider(panelID, "HarvestMapDistance", Harvest.localization["distance"],Harvest.localization["distancetooltip"], 1, 100, 1,
		function()
			return Harvest.settings.compassLayouts[1].maxDistance * 1000
		end,
		function( value )
            -- for profession = 1,6 do
            for profession = 1,8 do
				Harvest.settings.compassLayouts[ profession ].maxDistance  = value / 1000
			end
			COMPASS_PINS:RefreshPins()
		end,
		false, nil)
	
    -- for profession = 1,6 do
    for profession = 1,8 do
		LAM:AddHeader(panelID, "HarvestMapPinHeader"..profession, Harvest.localization[ "filter"..profession ] .. " pin Options")
		CreateFilter( profession )
		CreateSizeSlider( profession )
		CreateColorPicker( profession )
	end
	
	LAM:AddHeader(panelID, "HarvestDebugHeader", "Debug")
	
	LAM:AddCheckbox(panelID, "HarvestMapDebug", "Debug mode", "Enable debug mode",
		function()
			return Harvest.settings.debug
		end,
		function( value )
			Harvest.settings.debug = value
		end,
	false, nil)
	
    LAM:AddCheckbox(panelID, "HarvestMapDebugVerbose", "Verbose debug mode", "Enable verbose debug mode",
        function()
            return Harvest.settings.verbose
        end,
        function( value )
            Harvest.settings.verbose = value
        end,
    false, nil)

	--pvepanel has no mode if the character starts his session on a pvp map
	WORLD_MAP_FILTERS.pvePanel:SetMapMode(2) -- prevents crashing on GetPinFilter in above case
	
	local refreshCheckbox = function()
		for i=1,6 do
			local profession = i
			newPVECheckboxes[ profession ]:SetState(Harvest.GetFilter( profession ) and 1 or 0)
			newPVECheckboxes[ profession ]:toggleFunction(Harvest.GetFilter( profession ))
			
			newPVPCheckboxes[ profession ]:SetState(Harvest.GetFilter( profession ) and 1 or 0)
			newPVPCheckboxes[ profession ]:toggleFunction(Harvest.GetFilter( profession ))
		end
	end
	local oldHidden = WORLD_MAP_FILTERS.control.SetHidden
	WORLD_MAP_FILTERS.control.SetHidden = function (self, value)
		refreshCheckbox()
		oldHidden(self, value)
	end
	
	local oldpveHidden = WORLD_MAP_FILTERS.pvePanel.SetHidden
	local oldpvpHidden = WORLD_MAP_FILTERS.pvpPanel.SetHidden
	
	WORLD_MAP_FILTERS.pvePanel.SetHidden = function( self, value )
		refreshCheckbox()
		oldpveHidden(self, value)
	end
	WORLD_MAP_FILTERS.pvpPanel.SetHidden = function( self, value )
		refreshCheckbox()
		oldpvpHidden(self, value)
	end
end

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
    
    for i=1,6 do
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