
local Farm = Harvest.farm
Farm.generator = {}
local Generator = Farm.generator 

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Generator:Initialize()
	self.logic:Initialize()
	self:InitializeControls()
	self:InitializeReports()
	self:InitializeCallbacks()
end

function Generator:IsGeneratingTour()
	return self.logic.isGeneratingTour
end

function Generator:InitializeCallbacks()
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_FINISHED, function(event, path)
		ZO_Dialogs_ShowDialog("HARVESTFARM_RESULT", {}, { mainTextParams = { tostring(zo_round(((path.numNodes) / path.length) * 100 * 1000) / 100) } } )
	end)
	
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_UPDATED, function(event, percentage)
		self.generatorBar:SetValue(percentage)
	end)
	
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_ERROR, function(event, errorCode)
		if errorCode == 1 then
			ZO_Dialogs_ShowDialog("HARVESTFARM_INVALID_MAP", {}, { mainTextParams = {} } )
		elseif errorCode == 2 then
			ZO_Dialogs_ShowDialog("HARVESTFARM_NO_RESOURCES", {}, { mainTextParams = {} } )
		else
			ZO_Dialogs_ShowDialog("HARVESTFARM_ERROR", {}, { mainTextParams = {} } )
		end
	end)
end

function Generator:InitializeReports()
	-- register dialogs which will display the result to the user
	
	-- error message, if no tour was generated
	local pathDialog = {
		title = { text = Harvest.GetLocalization( "farmresult" ) },
		mainText = { text = Harvest.GetLocalization( "farmnotour" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_ERROR", pathDialog)
	
	-- error message, if no resources exist on the current map
	pathDialog = {
		title = { text = Harvest.GetLocalization( "farmerror" ) },
		mainText = { text = Harvest.GetLocalization( "farmnoresources" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_NO_RESOURCES", pathDialog)
	
	-- error message if the current map can not be used (i.e. there is no measurement like the Aurbis map)
	pathDialog = {
		title = { text = Harvest.GetLocalization( "farmerror" ) },
		mainText = { text = Harvest.GetLocalization( "farminvalidmap" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_INVALID_MAP", pathDialog)
	
	-- succes message which displays the resulting tour's stats (node per kilometer)
	pathDialog = {
		title = { text = Harvest.GetLocalization( "farmresult" ) },
		mainText = { text = Harvest.GetLocalization( "farmsuccess" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_RESULT", pathDialog)
end

function Generator:InitializeControls()
	-- add controls to the newly created panel
	HarvestFarmGenerator.panel = HarvestFarmGenerator
	HarvestFarmGenerator.panel.data = {}
	
	-- add the general HarvestFarm description
	local definition = {
		type = "description",
		title = "",
		text = Harvest.GetLocalization( "farmdescription" ),
	}
	local control = LAMCreateControl.description(HarvestFarmGenerator, definition)
	control:SetAnchor(TOPLEFT, HarvestFarmGenerator, TOPLEFT, 0, 0)
	local lastControl = control
	-- add the slider for the minimum route length
	local definition = {
		type = "slider",
		name = Harvest.GetLocalization( "farmminlength" ),
		tooltip =  Harvest.GetLocalization( "farmminlengthtooltip" ),
		min = 1,
		max = 10,
		getFunc = function()
			return self.logic.minLengthKM
		end,
		setFunc = function( value )
			self.logic.minLengthKM = value
		end,
		default = 3,
	}
	control = LAMCreateControl.slider(HarvestFarmGenerator, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
	local lastControl = control
	-- add description to explain what the minimum route length is for
	definition = {
		type = "description",
		title = "",
		text = Harvest.GetLocalization( "farmminlengthdescription" ),
	}
	local control = LAMCreateControl.description(HarvestFarmGenerator, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 10)
	lastControl = control
	-- add a button to start the calculation of the farming route
	control = WINDOW_MANAGER:CreateControlFromVirtual(nil, HarvestFarmGenerator, "ZO_DefaultButton")
	control:SetText( Harvest.GetLocalization( "calculatetour" ) )
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
	control:SetAnchor(TOPRIGHT, lastControl, BOTTOMRIGHT, 0, 20)
	control:SetClickSound("Click")
	control:SetHandler("OnClicked", function(button, ...)
		self.logic:Start()
	end)
	lastControl = control
	-- add a loading bar to display the process of the calculation
	control = WINDOW_MANAGER:CreateControl(nil, HarvestFarmGenerator, CT_STATUSBAR)
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 4, 20)
	control:SetAnchor(BOTTOMRIGHT, lastControl, BOTTOMRIGHT, -4, 50)
	control:SetMinMax(0,100)
	control:SetAlpha(1)
	control:SetColor(0.2,1,0.2)
	control:SetValue(0)
	lastControl = control
	self.generatorBar = control
	-- add a nice frame to make the bar appear neater :)
	control = WINDOW_MANAGER:CreateControl(nil, lastControl, CT_BACKDROP)
	control:SetCenterColor(0, 0, 0)
	control:SetAnchor(TOPLEFT, lastControl, TOPLEFT, -4, -4)
	control:SetAnchor(BOTTOMRIGHT, lastControl, BOTTOMRIGHT, 4, 4)
	control:SetEdgeTexture("EsoUI\\Art\\Tooltips\\UI-SliderBackdrop.dds", 32, 4)
end