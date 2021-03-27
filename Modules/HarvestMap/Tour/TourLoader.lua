
local Farm = Harvest.farm
Farm.loader = {}
local Loader = Farm.loader 

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

function Loader:Initialize(fragment)
	
	fragment:RegisterCallback("StateChange", function(oldState, newState)
		if(newState == SCENE_FRAGMENT_SHOWING) then
			self:BuildTourList()
		end
	end)
	
	CallbackManager:RegisterCallback(Events.MAP_CHANGE, function()
		if fragment:IsHidden() then return end
		self:BuildTourList()
	end)
	
	HarvestFarmLoaderSaveTitle:SetText(GetString(SI_SAVE))
	HarvestFarmLoaderNameTitle:SetText(Harvest.GetLocalization( "tourname" ))
	HarvestFarmLoaderNameField:SetText(Harvest.GetLocalization( "defaultname" ))
	HarvestFarmLoaderSaveButton:SetText(GetString(SI_SAVE))
	HarvestFarmLoaderLoadTitle:SetText(Harvest.GetLocalization( "savedtours" ))
	HarvestFarmLoaderNoTour:SetText(Harvest.GetLocalization( "notourformap" ))
	
	Harvest_SavedVars.tours = Harvest_SavedVars.tours or {}
	self.savedVars = Harvest_SavedVars.tours
	
	local pathDialog = {
		title = { text = GetString(SI_PROMPT_TITLE_ERROR) },
		mainText = { text = Harvest.GetLocalization( "savenotour" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_SAVE_ERROR", pathDialog)
	
	pathDialog = {
		title = { text = Harvest.GetLocalization( "saveexiststitle" ) },
		mainText = { text = Harvest.GetLocalization( "saveexists" ) },
		buttons = {
			[1] = {
				text = GetString(SI_SAVE),
				callback = function()
					self:ConfirmSave()
				end,
			},
			[2] = {
				text = GetString(SI_CANCEL),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_SAVE_CONFIRM", pathDialog)
	
	pathDialog = {
		title = { text = GetString(SI_PROMPT_TITLE_ERROR) },
		mainText = { text = Harvest.GetLocalization( "loaderror" ) },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVESTFARM_LOAD_ERROR", pathDialog)
	
	
	self.loadFunction = function(button)
		local parent = button
		while not parent.tourName do
			parent = parent:GetParent()
		end
		self:Load(parent.tourName)
		self:BuildTourList()
	end
	
	self.deleteFunction = function(button)
		local parent = button
		while not parent.tourName do
			parent = parent:GetParent()
		end
		local tours = self:GetSavedTours()
		tours[parent.tourName] = nil
		self:BuildTourList()
	end
	
	self.entryPool = ZO_ControlPool:New("SaveEntry", HarvestFarmLoaderPaneScrollChild, "Entry")
end

function Loader:Save()
	if not Farm.path or (Farm.path.mapCache.map ~= Harvest.mapTools:GetMap()) then
		ZO_Dialogs_ShowDialog("HARVESTFARM_SAVE_ERROR", {}, { mainTextParams = {} } )
		return
	end
	
	local savedTours = self:GetSavedTours()
	local tourName = HarvestFarmLoaderNameField:GetText()
	if savedTours[tourName] then
		ZO_Dialogs_ShowDialog("HARVESTFARM_SAVE_CONFIRM", {}, { mainTextParams = {tourName} } )
		return
	end
	self:ConfirmSave()
end

function Loader:ConfirmSave()
	local tour = {}
	local path = Farm.path
	
	local result = {{}}
	local counter = 1
	local format = string.format
	local tostring = _G["tostring"]
	for index, nodeId in ipairs(path.nodeIndices) do
		table.insert(result[counter], tostring(path.mapCache.pinTypeId[nodeId]))
		table.insert(result[counter], format("%.5f", path.mapCache.worldX[nodeId]))
		table.insert(result[counter], format("%.5f", path.mapCache.worldY[nodeId]))
		if index % 20 == 0 then
			counter = counter + 1
			result[counter] = {}
		end
	end
	for index, entry in pairs(result) do
		result[index] = table.concat(entry, ",")
	end
	
	tour.nodes = result
	tour.numNodes = path.numNodes
	tour.length = path.length
	tour.ratio = zo_round(path.numNodes / path.length * 1000 * 100) / 100
	tour.worldCoords = true
	
	local savedTours = self:GetSavedTours()
	local tourName = HarvestFarmLoaderNameField:GetText()
	savedTours[tourName] = tour
	self:BuildTourList()
end

function Loader:Load(tourName)
	HarvestFarmLoaderNameField:SetText(tourName)
	local savedTours = self:GetSavedTours()
	local tour = savedTours[tourName]
	
	local loadError = false
	local iter
	local pinTypes = {}
	local xList = {}
	local yList = {}
	local num = 1
	for i, nodes in ipairs(tour.nodes) do
		iter = string.gmatch(nodes, "(%d*),(%d*%.%d*),(%d*%.%d*)")
		for pinType, x, y in iter do
			pinTypes[num] = tonumber(pinType)
			xList[num] = tonumber(x)
			yList[num] = tonumber(y)
			num = num + 1
		end
	end
	
	if not tour.worldCoords then
		loadError = true
	end
	
	if not loadError then
		local path = Harvest.path:New(Harvest.mapPins.mapCache)
		path:GenerateFromCoordinates(pinTypes, xList, yList)
		if path.numNodes > 2 then
			tour.numNodes = path.numNodes
			tour.length = path.length
			tour.ratio = zo_round(path.numNodes / path.length * 1000 * 100) / 100
			Farm:SetPath(path)
		else
			loadError = true
		end
	end
	if loadError then
		ZO_Dialogs_ShowDialog("HARVESTFARM_LOAD_ERROR", {}, { mainTextParams = {} } )
	end
end

function Loader:GetSavedTours()
	local tours = self.savedVars[Harvest.mapPins.mapCache.map]
	if not tours then
		tours = {}
		self.savedVars[Harvest.mapPins.mapCache.map] = tours
	end
	return tours
end

function Loader:BuildTourList()
	self.entryPool:ReleaseAllObjects()
	self.numEntries = 0
	
	local lastControl
	local control
	for tourName, tour in pairs(self:GetSavedTours()) do
		control = self.entryPool:AcquireObject()
		if lastControl then
			control:SetAnchor(TOPLEFT, lastControl, BOTTOMLEFT, 0, 10)
		else
			control:SetAnchor(TOPLEFT, HarvestFarmLoaderPaneScrollChild, TOPLEFT, 0, 0)
		end
		control.tourName = tourName
		
		control:GetNamedChild("Name"):SetText(Harvest.GetLocalization("tourname") .. tourName)
		control:GetNamedChild("Stats"):SetText(zo_strformat( Harvest.GetLocalization( "editorstats" ), tour.numNodes, tour.length, tour.ratio))
		control:GetNamedChild("LoadButton"):SetText( Harvest.GetLocalization( "load" ) )
		control:GetNamedChild("LoadButton"):SetHandler("OnClicked", self.loadFunction)
		control:GetNamedChild("DeleteButton"):SetText( Harvest.GetLocalization( "delete" ) )
		control:GetNamedChild("DeleteButton"):SetHandler("OnClicked", self.deleteFunction)
		lastControl = control
		self.numEntries = self.numEntries + 1
	end
	
	HarvestFarmLoaderNoTour:SetHidden(self.numEntries > 0)
	
end