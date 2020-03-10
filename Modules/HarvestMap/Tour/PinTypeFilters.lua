
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
					--d(pinTypeId, Harvest.IsMapPinTypeVisible(pinTypeId))
					return Harvest.IsMapPinTypeVisible(pinTypeId)
				end,
				setFunc = function( value )
					Harvest.SetMapPinTypeVisible(pinTypeId, value)
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
	-- if some other interface (i.e. the map's filter tab) changed the visibility setting, we have to refresh the filter controls
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, ...)
		if setting ~= "mapPinTypeVisible" then return end
		local pinTypeId, visible = ...
		local control = self.filterControls[pinTypeId]
		if control then
			LAM.util.RequestRefreshIfNeeded(control)
			CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestFarmFilterPaneScrollChild)
		end
	end)
	
	-- disable the filter settings if a tour is being generated
	local callback = function(event, ...)
		CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestFarmFilterPaneScrollChild)
		--[[
		for pinTypeId, control in pairs(self.filterControls) do
			if control then
				LAM.util.RequestRefreshIfNeeded(control)
			end
		end
		--]]
	end
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_STARTED, callback)
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_FINISHED, callback)
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_ERROR, callback)
end