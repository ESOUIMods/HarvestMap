
local Farm = Harvest.farm
Farm.editor = {}
local Editor = Farm.editor

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Editor:Initialize(fragment)
	
	self:InitializeControls()
	
	self.clickedNodes = {}
	self.history = {}
	
	self.tourHandler = {
		name = Harvest.mapPins.nameFunction,
		callback = function(...) return self:OnPinClicked(...) end,
		show = function() return not fragment:IsHidden() end,
	}
	local n = #Harvest.mapPins.clickHandler
	for i = 1, n do
		Harvest.mapPins.clickHandler[n - i + 2] = Harvest.mapPins.clickHandler[n - i + 1]
	end
	Harvest.mapPins.clickHandler[1] = self.tourHandler
	
	fragment:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_FRAGMENT_SHOWN) then
			Harvest.farm.helper:Stop()
		elseif(newState == SCENE_FRAGMENT_HIDING) then
			local keepUndo = false
			self:Reset(keepUndo)
		end
	end)
	
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, ...)
		if setting == "mapPinTypeVisible" then
			local pinTypeId, visible = ...
			if visible then return end
			
			local keepUndo = true
			self:Reset(keepUndo)
			
			if Farm.path then
				ZO_Dialogs_ShowDialog("HARVESTFARM_PINTYPE", {pinTypeId=pinTypeId}, { mainTextParams = { Harvest.GetLocalization("pintype" .. pinTypeId) } } )
			end
		end
	end)
	CallbackManager:RegisterForEvent(Events.TOUR_GENERATION_FINISHED, function()
		local keepUndo = false
		self:Reset(keepUndo)
	end)
	
	CallbackManager:RegisterForEvent(Events.TOUR_CHANGED, function(event, path)
		CALLBACK_MANAGER:FireCallbacks("LAM-RefreshPanel", HarvestFarmEditor)
	end)
	
	CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", function()
		if next(self.clickedNodes) then
			local keepUndo = true
			self:Reset(keepUndo)
		end
	end)
	
	local pathDialog = {
		title = { text = Harvest.GetLocalization( "removepintypetitle" ) },
		mainText = { text = Harvest.GetLocalization( "removepintype" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_REMOVE),
				callback = function(dialog)
					Farm:Debug("remove tour nodes for pintype %d", pinTypeId)
					self:TrackCurrentPathInHistory()
					if Farm.path:RemoveNodesOfPinType(dialog.data.pinTypeId) then
						if Farm.path.numNodes < 3 then
							Farm:SetPath(nil)
						else
							Farm:SetPath(Farm.path)
						end
					else
						self:PopFromHistory()
					end
				end,
			},
			[2] = {
				text = GetString(SI_DIALOG_CANCEL),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_PINTYPE", pathDialog)
end

function Editor:Reset(keepUndo)
	self.clickedNodes = {}
	CallbackManager:FireCallbacks(Events.TOUR_NODE_CLICKED, self.clickedNodes, self.mapCache)
	if not keepUndo then
		for index, path in pairs(self.history) do
			path:Dispose()
		end
		self.history = {}
	end
end

function Editor:TrackCurrentPathInHistory()
	self.undoButton:SetEnabled(true)
	local path = Harvest.path:New(Farm.path.mapCache)
	path:CopyValuesFrom(Farm.path)
	table.insert(self.history, path)
end

function Editor:PopFromHistory()
	local lastPath = #self.history
	if lastPath <= 1 then
		self.undoButton:SetEnabled(false)
	end
	if lastPath > 0 then
		self.history[lastPath]:Dispose()
		self.history[lastPath] = nil
	end
end

function Editor:Undo()
	local lastPath = #self.history
	if lastPath <= 1 then
		self.undoButton:SetEnabled(false)
	end
	if lastPath > 0 then
		local path = self.history[lastPath]
		self.history[lastPath] = nil
		
		Farm:SetPath(path)
	end
end

function Editor:InitializeControls()
	HarvestFarmEditor.panel = HarvestFarmEditor
	HarvestFarmEditor.panel.data = {registerForRefresh = true}
	HarvestFarmEditor.panel.controlsToRefresh = {}
	
	local definition = {
		type = "description",
		title = "",
		text = Harvest.GetLocalization( "editordescription" ),
	}
	local control = LAMCreateControl.description(HarvestFarmEditor, definition)
	control:SetAnchor(TOPLEFT, HarvestFarmEditor, TOPLEFT, 0, 0)
	local lastControl = control
	
	definition = {
		type = "description",
		title = "",
		text = function()
			local num, length, ratio
			local path = Farm.path
			if not path then
				num = "-/-"
				length = num
				ratio = num
			else
				num = path.numNodes
				length = zo_round(path.length * 10) / 10
				ratio = zo_round(path.numNodes / path.length * 1000 * 100) / 100
			end
			return zo_strformat( Harvest.GetLocalization( "editorstats" ), num, length, ratio)
		end,
	}
	local control = LAMCreateControl.description(HarvestFarmEditor, definition)
	control:ClearAnchors()
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 10)
	lastControl = control
	
	-- revert tour button
	control = WINDOW_MANAGER:CreateControlFromVirtual(nil, HarvestFarmEditor, "ZO_DefaultButton")
	control:SetText( Harvest.GetLocalization( "reverttour" ) )
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
	control:SetAnchor(TOPRIGHT, lastControl, BOTTOMRIGHT, 0, 20)
	control:SetClickSound("Click")
	control:SetHandler("OnClicked", function()
		local path = Farm.path
		if path then
			self:TrackCurrentPathInHistory()
			path:Revert()
			CallbackManager:FireCallbacks(Events.TOUR_CHANGED, path)
		end
	end)
	self.revertButton = control
	lastControl = control
	
	-- remove tour button
	control = WINDOW_MANAGER:CreateControlFromVirtual(nil, HarvestFarmEditor, "ZO_DefaultButton")
	control:SetText( Harvest.GetLocalization( "removetour" ) )
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
	control:SetAnchor(TOPRIGHT, lastControl, BOTTOMRIGHT, 0, 20)
	control:SetClickSound("Click")
	control:SetHandler("OnClicked", function()
		local path = Farm.path
		if path then
			self:TrackCurrentPathInHistory()
			Farm:SetPath(nil)
		end
	end)
	self.removeButton = control
	lastControl = control
	
	control = WINDOW_MANAGER:CreateControlFromVirtual(nil, HarvestFarmEditor, "ZO_DefaultButton")
	control:SetText( Harvest.GetLocalization( "undo" ) )
	control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 20)
	control:SetAnchor(TOPRIGHT, lastControl, BOTTOMRIGHT, 0, 20)
	control:SetClickSound("Click")
	control:SetHandler("OnClicked", function()
		self:Undo()
	end)
	self.undoButton = control
	control:SetEnabled(false)
	lastControl = control
	
end

function Editor:AlreadyClicked(nodeId)
	for index, node in ipairs(self.clickedNodes) do
		if node == nodeId then
			return index
		end
	end
	return nil
end

function Editor:OnPinClicked(pin)
	if Farm.generator:IsGeneratingTour() then return end
	
	local pinType, nodeId = pin:GetPinTypeAndTag()
	self.mapCache = Harvest.mapPins.mapCache
	
	local path = Farm.path
	-- the player creates a new tour from scratch
	if not path then
		local index = self:AlreadyClicked(nodeId)
		if index then
			if #self.clickedNodes - index + 1 > 2 then
				path = Harvest.path:New(Harvest.mapPins.mapCache)
				path:GenerateFromNodeIds(self.clickedNodes, index, #self.clickedNodes)
				Farm:SetPath(path)
				local keepUndo = true
				self:Reset(keepUndo)
				return true
			end
		else
			table.insert(self.clickedNodes, nodeId)
			CallbackManager:FireCallbacks(Events.TOUR_NODE_CLICKED, self.clickedNodes, self.mapCache)
		end
		return true
	end
	
	-- the player edits an existing tour
	local index = self:AlreadyClicked(nodeId)
	if index then
		for i = index + 1, #self.clickedNodes do
			self.clickedNodes[i] = nil
		end
		CallbackManager:FireCallbacks(Events.TOUR_NODE_CLICKED, self.clickedNodes, self.mapCache)
	else
		local path = Harvest.farm.path
		index = path:GetIndex(nodeId)
		if index then
			if self.clickedNodes[1] then
				self:TrackCurrentPathInHistory()
				path:Insert(self.clickedNodes, nodeId)
				if path.numNodes < 3 then
					Farm:SetPath(nil)
				else
					CallbackManager:FireCallbacks(Events.TOUR_CHANGED, path)
				end
				local keepUndo = true
				self:Reset(keepUndo)
				return true
			else
				self.clickedNodes[1] = nodeId
				CallbackManager:FireCallbacks(Events.TOUR_NODE_CLICKED, self.clickedNodes, self.mapCache)
			end
		else
			if self.clickedNodes[1] then
				table.insert(self.clickedNodes, nodeId)
				CallbackManager:FireCallbacks(Events.TOUR_NODE_CLICKED, self.clickedNodes, self.mapCache)
			end
		end
	end
	return true
end
