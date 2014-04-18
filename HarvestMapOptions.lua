local LAM = LibStub("LibAddonMenu-1.0")
local panelID

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
			for profession = 1,10 do
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
			for profession = 1,10 do
				Harvest.settings.compassLayouts[ profession ].maxDistance  = value / 1000
			end
			COMPASS_PINS:RefreshPins()
		end,
		false, nil)
	
	-- for profession = 1,6 do
	for profession = 1,10 do
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

	LAM:AddCheckbox(panelID, "HarvestMapDebugVerbose", "Verbose debug mode", "Enable Verbose debug mode",
		function()
			return Harvest.settings.verbose
		end,
		function( value )
			Harvest.settings.verbose = value
		end,
	false, nil)

end