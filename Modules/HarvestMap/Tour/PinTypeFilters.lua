
local LAM = LibAddonMenu2

local Farm = Harvest.farm
Farm.filters = {}
local Filters = Farm.filters
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Filters:Initialize()
	self:InitializeControls()
	self:InitializeCallbacks()
end

function Filters:InitializeControls()
	HarvestFarmFilterPaneScrollChild:SetWidth(HarvestFarmFilterPane:GetWidth()*2)
	HarvestFarmFilterPaneScrollChild.panel = HarvestFarmFilterPaneScrollChild
	HarvestFarmFilterPaneScrollChild.panel.data = {registerForRefresh = true}
	HarvestFarmFilterPaneScrollChild.panel.controlsToRefresh = {}

	definition = {
		type = "header",
		name = Harvest.GetLocalization( "resourcetypes" ),
	}
	local control = LAMCreateControl.header(HarvestFarmFilterPaneScrollChild, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, HarvestFarmFilterPaneScrollChild, TOPLEFT, 0, 0)
	lastControl = control
	
	self.filterControls = {}
	local disabledFunction = function() return Farm.generator:IsGeneratingTour() end
	for _, pinTypeId in ipairs(Harvest.PINTYPES) do
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			definition = {
				type = "checkbox",
				name = Harvest.GetLocalization( "pintype" .. pinTypeId ),
				getFunc = function()
					local filterProfile = Harvest.mapPins.filterProfile
					return filterProfile[pinTypeId]
				end,
				setFunc = function( value )
					local filterProfile = Harvest.mapPins.filterProfile
					filterProfile[pinTypeId] = value
					CallbackManager:FireCallbacks(Events.FILTER_PROFILE_CHANGED, filterProfile, pinTypeId, value)
				end,
				disabled = disabledFunction,
				width = "half",
			}
			local control = LAMCreateControl.checkbox(HarvestFarmFilterPaneScrollChild, definition)
			control:ClearAnchors()
			control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
			lastControl = control
			self.filterControls[pinTypeId] = control
		end
	end
end

function Filters:InitializeCallbacks()
	-- disable the filter settings if a tour is being generated
	local callback = function()
		for pinTypeId, control in pairs(self.filterControls) do
			if control then
				control:UpdateValue()--LAM.util.RequestRefreshIfNeeded(control)
				control:UpdateDisabled()
			end
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