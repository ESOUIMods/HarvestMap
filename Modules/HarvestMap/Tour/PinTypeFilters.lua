
local Farm = Harvest.farm
Farm.filters = {}
local Filters = Farm.filters
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Filters:Initialize()
	self:InitializeControls()
	self:InitializeCallbacks()
end

local function NewSetColor(self, r, g, b, a, ...)
	local layout = Harvest.GetMapPinLayout(self.pinTypeId)
	local newText = layout.tint:Colorize(zo_iconFormatInheritColor(layout.texture, 20, 20))
	newText = newText .. string.format("|c%.2x%.2x%.2x%s|r", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255), self.labelText)
	self:SetText(newText)
end

function Filters:InitializeCheckboxForPinType(checkbox, pinTypeId)
	local labelText = Harvest.GetLocalization("pintype" .. pinTypeId)
	ZO_CheckButton_SetLabelText(checkbox, labelText)
	-- on mouse over the color is switched to "highlight"
	-- this removed the color of the texture, so we have to change the setColor behaviour
	local label = checkbox.label
	label.labelText = labelText
	label.SetColor = NewSetColor
	label.pinTypeId = pinTypeId
	checkbox.pinTypeId = pinTypeId

	ZO_CheckButton_SetToggleFunction(checkbox, function(button, isChecked)
		local filterProfile = Harvest.mapPins.filterProfile
		filterProfile[pinTypeId] = isChecked
		CallbackManager:FireCallbacks(Events.FILTER_PROFILE_CHANGED, filterProfile, pinTypeId, isChecked)
	end)
	ZO_CheckButtonLabel_ColorText(label, false)

	return checkbox
end

function Filters:InitializeControls()
	HarvestFarmFilterPaneScrollChild:SetWidth(HarvestFarmFilterPane:GetWidth()*2)
	local padding = 30

	local control = WINDOW_MANAGER:CreateControl(nil, HarvestFarmFilterPaneScrollChild, CT_LABEL)
	control:SetFont("ZoFontWinH2")
	control:SetText(Harvest.GetLocalization( "resourcetypes" ))
	control:SetAnchor(TOPLEFT, HarvestFarmFilterPaneScrollChild, TOPLEFT, padding, 0)
	control:SetWidth(HarvestFarmFilterPaneScrollChild:GetWidth() - padding)
	control:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)

	local filterProfile = Harvest.mapPins.filterProfile
	self.filterControls = {}
	local previousBox = control
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] and not (pinTypeId == Harvest.UKNOWN) then
			local box = WINDOW_MANAGER:CreateControlFromVirtual("HMeditorfilter" .. tostring(pinTypeId), HarvestFarmFilterPaneScrollChild, "ZO_CheckButton")
			box:SetAnchor(TOPLEFT, previousBox, BOTTOMLEFT, 0, 5)
			self:InitializeCheckboxForPinType(box, pinTypeId)
			previousBox = box
			self.filterControls[pinTypeId] = box
			ZO_CheckButton_SetCheckState(box, filterProfile[pinTypeId])
		end
	end
	--Farm.generator:IsGeneratingTour()
end

function Filters:InitializeCallbacks()
	-- disable the filter settings if a tour is being generated
	local callback = function()
		local filterProfile = Harvest.mapPins.filterProfile
		for pinTypeId, control in pairs(self.filterControls) do
			control:SetEnabled(not Farm.generator:IsGeneratingTour())
			ZO_CheckButton_SetCheckState(control, filterProfile[pinTypeId])
		end
	end
	-- if some other interface (i.e. the map's filter tab) changed the visibility setting, we have to refresh the filter controls
	CallbackManager:RegisterForEvent(Events.FILTER_PROFILE_CHANGED,
		function(event, profile, pinTypeId, visible)
			if profile == Harvest.mapPins.filterProfile then
				callback()
			end
		end)

	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED,
		function(event, setting)
			if setting ~= "mapFilterProfile" then return end
			callback()
		end)

	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_STARTED, callback)
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_FINISHED, callback)
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_ERROR, callback)
end