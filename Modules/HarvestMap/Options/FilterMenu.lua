
local Settings = Harvest.settings
local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local FilterProfiles = {}
Harvest:RegisterModule("filterProfiles", FilterProfiles)

function FilterProfiles:Initialize()
	self.filterProfiles = Settings.savedVars.settings.filterProfiles
	-- sanity check. in case the chosen profile doesn't exist
	for _, displayType in pairs({"map", "compass", "world"}) do
		local tag = displayType .. "FilterProfile"
		if not self.filterProfiles[Settings.savedVars.settings[tag]] then
			self:Error("%s profile %d does not exist", displayType, Settings.savedVars.settings[tag])
			Settings.savedVars.settings[tag] = 1
		end
	end

	self.fragment = ZO_SimpleSceneFragment:New(HarvestFilter)

	HarvestFilterTitle:SetText(Harvest.GetLocalization("filtertitle"))
	HarvestFilterMapSelectLabel:SetText(Harvest.GetLocalization("filtermap"))
	HarvestFilterCompassSelectLabel:SetText(Harvest.GetLocalization("filtercompass"))
	HarvestFilterWorldSelectLabel:SetText(Harvest.GetLocalization("filterworld"))

	self:InitializeCheckBoxes()

	self:InitializeFilterDropDown(HarvestFilterProfileDropDown, self.LoadProfile)
	self:InitializeFilterDropDown(HarvestFilterMapSelectDropDown, self.SetMapProfile)
	self:InitializeFilterDropDown(HarvestFilterCompassSelectDropDown, self.SetCompassProfile)
	self:InitializeFilterDropDown(HarvestFilterWorldSelectDropDown, self.SetWorldProfile)

	self:LoadProfile(self.filterProfiles[1])

	local validSettings = {
		mapFilterProfile = true,
		compassFilterProfile = true,
		worldFilterProfile = true,
	}
	CallbackManager:RegisterForEvent(Events.SETTING_CHANGED, function(event, setting, value)
		if validSettings[setting] then self:RefreshControls() end
	end)

	CallbackManager:RegisterForEvent(Events.FILTER_PROFILE_CHANGED, function(event, profile, pinTypeId, visible)
		if profile == self.currentProfile then
			self:RefreshControls()
		end
	end)
end

function FilterProfiles:InitializeCheckBoxes()
	self.checkboxes = {}
	local checkboxParent = WINDOW_MANAGER:CreateControl(nil, HarvestFilter, CT_CONTROL)
	checkboxParent:SetAnchor(TOPLEFT, HarvestFilterDivider, BOTTOMLEFT, 85, 0)

	local maxWidth = 240

	local previousBox = checkboxParent
	for i = 1, zo_floor(#Harvest.PINTYPES/2)-1 do
		local pinTypeId = Harvest.PINTYPES[i]
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			local box = WINDOW_MANAGER:CreateControlFromVirtual("HarvestFilterCheckbox" .. pinTypeId, HarvestFilter, "ZO_CheckButton")
			box:SetAnchor(TOPLEFT, previousBox, BOTTOMLEFT, 0, 5)
			self:InitializeCheckboxForPinType(box, pinTypeId)
			previousBox = box
			maxWidth = zo_max(maxWidth, box:GetNamedChild("Label"):GetTextWidth())
			table.insert(self.checkboxes, box)
		end
	end

	local checkboxParent = WINDOW_MANAGER:CreateControl(nil, HarvestFilter, CT_CONTROL)
	checkboxParent:SetAnchor(TOPLEFT, HarvestFilterDivider, BOTTOMLEFT, 85 + 32 + maxWidth, 0)
	local maxWidth2 = 0
	local previousBox = checkboxParent
	for i = zo_floor(#Harvest.PINTYPES/2), #Harvest.PINTYPES do
		local pinTypeId = Harvest.PINTYPES[i]
		if not Harvest.HIDDEN_PINTYPES[pinTypeId] then
			local box = WINDOW_MANAGER:CreateControlFromVirtual("HarvestFilterCheckbox" .. pinTypeId, HarvestFilter, "ZO_CheckButton")
			box:SetAnchor(TOPLEFT, previousBox, BOTTOMLEFT, 0, 5)
			self:InitializeCheckboxForPinType(box, pinTypeId)
			previousBox = box
			maxWidth2 = zo_max(maxWidth2, box:GetNamedChild("Label"):GetTextWidth())
			table.insert(self.checkboxes, box)
		end
	end
	HarvestFilter:SetWidth(zo_max(HarvestFilter:GetWidth(), 64 + maxWidth + maxWidth2))
end

local function NewSetColor(self, r, g, b, a, ...)
	local layout = Harvest.GetMapPinLayout(self.pinTypeId)
	local newText = layout.tint:Colorize(zo_iconFormatInheritColor(layout.texture, 20, 20))
	newText = newText .. string.format("|c%.2x%.2x%.2x%s|r", zo_round(r * 255), zo_round(g * 255), zo_round(b * 255), self.labelText)
	self:SetText(newText)
end

function FilterProfiles:Show()
	if self.currentProfile == nil then
		self:LoadProfile(self:GetMapProfile())
	else
		self:LoadProfile(self.currentProfile)
	end
	HarvestFilter:SetHidden(false)
	SCENE_MANAGER:SetInUIMode(true)
	--if not IsGameCameraUIModeActive() then
	--	SCENE_MANAGER:Show("hudui")
	--end
	--SCENE_MANAGER:AddFragment(self.fragment)
	--SCENE_MANAGER:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
end

function FilterProfiles:InitializeCheckboxForPinType(checkbox, pinTypeId)
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
		self.currentProfile[pinTypeId] = isChecked
		CallbackManager:FireCallbacks(Events.FILTER_PROFILE_CHANGED, self.currentProfile, pinTypeId, isChecked)
	end)
	ZO_CheckButtonLabel_ColorText(label, false)

	return checkbox
end

function FilterProfiles:InitializeFilterDropDown(control, topCallback)
	local comboBox = ZO_ComboBox_ObjectFromContainer(control)
	control.comboBox = comboBox
	comboBox.profileToComboboxEntry = {}
	comboBox.topCallback = topCallback
	for index, filterProfile in ipairs(self.filterProfiles) do
		local callback = function() comboBox.topCallback(self, filterProfile) end
		local entry = comboBox:CreateItemEntry(filterProfile.name, callback)
		comboBox.profileToComboboxEntry[filterProfile] = entry
	end
end

function FilterProfiles:LoadProfile(filterProfile)
	self.currentProfile = filterProfile
	self:RefreshControls()
end

function FilterProfiles:RebuildDroplist(comboBox)
	comboBox:ClearItems()
	for index, filterProfile in ipairs(self.filterProfiles) do
		if not comboBox.profileToComboboxEntry[filterProfile] then
			local callback = function() comboBox.topCallback(self, filterProfile) end
			local entry = comboBox:CreateItemEntry(filterProfile.name, callback)
			comboBox.profileToComboboxEntry[filterProfile] = entry
		end
		comboBox.profileToComboboxEntry[filterProfile].name = filterProfile.name
		comboBox:AddItem(comboBox.profileToComboboxEntry[filterProfile])
	end
end

function FilterProfiles:RefreshComboboxControlForSelectedProfile(comboboxControl, selectedProfile)
	local combobox = ZO_ComboBox_ObjectFromContainer(comboboxControl)
	self:RebuildDroplist(combobox)
	combobox:SetSelectedItemText(selectedProfile.name)
end

function FilterProfiles:RefreshControls()
	if self.currentProfile == nil then return end

	self:RefreshComboboxControlForSelectedProfile(
		HarvestFilterMapSelectDropDown, self:GetMapProfile())

	self:RefreshComboboxControlForSelectedProfile(
		HarvestFilterCompassSelectDropDown, self:GetCompassProfile())

	self:RefreshComboboxControlForSelectedProfile(
		HarvestFilterWorldSelectDropDown, self:GetWorldProfile())

	self:RefreshComboboxControlForSelectedProfile(
		HarvestFilterProfileDropDown, self.currentProfile)

	HarvestFilterRenameEdit:SetText(self.currentProfile.name)
	HarvestFilterDelete:SetEnabled(#self.filterProfiles > 1)

	-- filter checkboxes
	for _, checkbox in pairs(self.checkboxes) do
		ZO_CheckButton_SetCheckState(checkbox, self.currentProfile[checkbox.pinTypeId])
	end

end

function FilterProfiles:RenameCurrentProfile(newName)
	if newName == "" then
		newName = Harvest.GetLocalization("unnamedfilterprofile")
	elseif newName == self.currentProfile.name then
		return
	end
	self.currentProfile.name = newName
	self:RefreshControls()
end

function FilterProfiles:GetMapProfile()
	return self.filterProfiles[Settings.savedVars.settings.mapFilterProfile]
end

function FilterProfiles:SetMapProfile(profile)
	for index, filterProfile in pairs(self.filterProfiles) do
		if filterProfile == profile then
			Settings.savedVars.settings.mapFilterProfile = index
			CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "mapFilterProfile", index)
			return
		end
	end
end

function FilterProfiles:GetCompassProfile()
	return self.filterProfiles[Settings.savedVars.settings.compassFilterProfile]
end

function FilterProfiles:SetCompassProfile(profile)
	for index, filterProfile in pairs(self.filterProfiles) do
		if filterProfile == profile then
			Settings.savedVars.settings.compassFilterProfile = index
			CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "compassFilterProfile", index)
			return
		end
	end
end

function FilterProfiles:GetWorldProfile()
	return self.filterProfiles[Settings.savedVars.settings.worldFilterProfile]
end

function FilterProfiles:SetWorldProfile(profile)
	for index, filterProfile in pairs(self.filterProfiles) do
		if filterProfile == profile then
			Settings.savedVars.settings.worldFilterProfile = index
			CallbackManager:FireCallbacks(Events.SETTING_CHANGED, "worldFilterProfile", index)
			return
		end
	end
end

function FilterProfiles:ConstructNewProfile()
	local newProfile = {}
	Harvest.CopyMissingDefaultValues(newProfile, Settings.defaultFilterProfile)
	newProfile.name = "Unnamed Profile"
	table.insert(Settings.savedVars.settings.filterProfiles, newProfile)
	return newProfile
end

function FilterProfiles:FindProfileWithName(name)
	for index, filterProfile in pairs(self.filterProfiles) do
		if filterProfile.name == name then
			return filterProfile
		end
	end
end

function FilterProfiles:AddNewProfile()
	local newProfile = self:ConstructNewProfile()
	self:LoadProfile(newProfile)
end

function FilterProfiles:DeleteCurrentProfile()
	if #self.filterProfiles <= 1 then return end

	local deletedProfile = self.currentProfile
	local deletedProfileIndex = nil
	for index, filterProfile in ipairs(self.filterProfiles) do
		if filterProfile == deletedProfile then
			table.remove(self.filterProfiles, index)
			deletedProfileIndex = index
			break
		end
	end
	assert(deletedProfileIndex)

	self.currentProfile = nil

	for _, displayType in pairs({"map", "compass", "world"}) do
		local tag = displayType .. "FilterProfile"
		if Settings.savedVars.settings[tag] == deletedProfileIndex then
			Settings.savedVars.settings[tag] = 1
			CallbackManager:FireCallbacks(Events.SETTING_CHANGED, tag, 1)
		end
	end


	self:LoadProfile(self.filterProfiles[1])
end
