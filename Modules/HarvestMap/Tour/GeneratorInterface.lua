
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
		if errorCode == 2 then
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
	local padding = 30

	-- add the general HarvestFarm description
	local control = WINDOW_MANAGER:CreateControl(nil, HarvestFarmGenerator, CT_LABEL)
	control:SetFont("ZoFontGame")
	control:SetText(Harvest.GetLocalization( "farmdescription" ))
	control:SetAnchor(TOPLEFT, HarvestFarmGenerator, TOPLEFT, 0, 0)
	control:SetWidth(HarvestFarmGenerator:GetWidth() - padding)
	local lastControl = control

	local control = WINDOW_MANAGER:CreateControl(nil, HarvestFarmGenerator, CT_LABEL)
	control:SetFont("ZoFontWinH4")
	control:SetText(Harvest.GetLocalization( "farmminlength" ))
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 10)
	local lastControl = control

	local container = WINDOW_MANAGER:CreateControl(nil, HarvestFarmGenerator, CT_CONTROL)
	container:SetAnchor(TOPLEFT, lastControl, TOPRIGHT, 4, 0)
	container:SetWidth(HarvestFarmGenerator:GetWidth() - lastControl:GetTextWidth() - padding)

	-- slider construction is based on LibAddonMenu's code for sliders
	local slider = WINDOW_MANAGER:CreateControlFromVirtual(nil, container, "ZO_Slider")
	slider:SetAnchor(TOPLEFT)
	slider:SetHeight(14)
	slider:SetAnchor(TOPRIGHT)
	local minValue = 1
	local maxValue = 10
	slider:SetMinMax(minValue, maxValue)
	slider:SetValueStep(1)

	local minText = WINDOW_MANAGER:CreateControl(nil, slider, CT_LABEL)
	minText:SetFont("ZoFontGameSmall")
	minText:SetAnchor(TOPLEFT, slider, BOTTOMLEFT)
	minText:SetText(minValue)

	local maxText = WINDOW_MANAGER:CreateControl(nil, slider, CT_LABEL)
	maxText:SetFont("ZoFontGameSmall")
	maxText:SetAnchor(TOPRIGHT, slider, BOTTOMRIGHT)
	maxText:SetText(maxValue)

	local slidervalueBG = WINDOW_MANAGER:CreateControlFromVirtual(nil, slider, "ZO_EditBackdrop")
	slidervalueBG:SetDimensions(50, 16)
	slidervalueBG:SetAnchor(TOP, slider, BOTTOM, 0, 0)

	local slidervalue = WINDOW_MANAGER:CreateControlFromVirtual(nil, slidervalueBG, "ZO_DefaultEditForBackdrop")
	slidervalue:ClearAnchors()
	slidervalue:SetAnchor(TOPLEFT, slidervalueBG, TOPLEFT, 3, 1)
	slidervalue:SetAnchor(BOTTOMRIGHT, slidervalueBG, BOTTOMRIGHT, -3, -1)
	slidervalue:SetTextType(TEXT_TYPE_NUMERIC)
	slidervalue:SetFont("ZoFontGameSmall")

	local isHandlingChange = false
	local function HandleValueChanged(value)
		if isHandlingChange then return end
		isHandlingChange = true
		value = zo_max(zo_min(maxValue, value), minValue)
		self.logic.minLengthKM = value
		slider:SetValue(value)
		slidervalue:SetText(value)
		isHandlingChange = false
	end

	slidervalue:SetHandler("OnEscape", function(control)
		HandleValueChanged(self.logic.minLengthKM)
		control:LoseFocus()
	end)
	slidervalue:SetHandler("OnEnter", function(control)
		control:LoseFocus()
	end)
	slidervalue:SetHandler("OnFocusLost", function(control)
		local value = tonumber(control:GetText())
		HandleValueChanged(value)
	end)
	slidervalue:SetHandler("OnTextChanged", function(control)
		local input = control:GetText()
		if(#input > 1 and not input:sub(-1):match("[0-9]")) then return end
		local value = tonumber(input)
		if(value) then
			HandleValueChanged(value)
		end
	end)

	slider:SetHandler("OnValueChanged", function(self, value, eventReason)
		if eventReason == EVENT_REASON_SOFTWARE then return end
		HandleValueChanged(value)
	end)

	HandleValueChanged(self.logic.minLengthKM)

	-- add description to explain what the minimum route length is for
	local control = WINDOW_MANAGER:CreateControl(nil, HarvestFarmGenerator, CT_LABEL)
	control:SetFont("ZoFontGame")
	control:SetText(Harvest.GetLocalization( "farmminlengthdescription" ))
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 10)
	control:SetWidth(HarvestFarmGenerator:GetWidth() - padding)
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