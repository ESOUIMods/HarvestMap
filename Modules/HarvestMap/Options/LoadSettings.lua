
local Settings = {}
Harvest:RegisterModule("settings", Settings)

function Settings:LoadSavedVars()
	self.savedVars = {}
	
	Harvest_SavedVars = Harvest_SavedVars or {}
	-- global settings that are computer wide (eg node/data settings)
	Harvest_SavedVars.global = Harvest_SavedVars.global or self.defaultGlobalSettings
	self.savedVars.global = Harvest_SavedVars.global
	-- fix for settings transfer addon
	-- currently it thinks the keys of the accountwide settings are characters
	-- remove the @ for the keys so this doesn't happen anymore
	if Harvest_SavedVars.account then
		for accountName, settings in pairs(Harvest_SavedVars.account) do
			if accountName:sub(1,1) == "@" then
				Harvest_SavedVars.account[accountName:sub(2,-1)] = settings
				Harvest_SavedVars.account[accountName] = nil
			end
		end
	end
	
	-- account wide settings
	local accountName = GetDisplayName():sub(2,-1)
	Harvest_SavedVars.account = Harvest_SavedVars.account or {}
	Harvest_SavedVars.account[accountName] = Harvest_SavedVars.account[accountName] or {}
	self.savedVars.account = Harvest_SavedVars.account[accountName]
	
	-- character wide settings
	local characterId = GetCurrentCharacterId()
	Harvest_SavedVars.character = Harvest_SavedVars.character or {}
	Harvest_SavedVars.character[characterId] = Harvest_SavedVars.character[characterId] or {}
	self.savedVars.character = Harvest_SavedVars.character[characterId]
	
	-- add default settings
	Harvest.CopyMissingDefaultValues(self.savedVars.character, self.defaultSettings)
	Harvest.CopyMissingDefaultValues(self.savedVars.account, self.defaultSettings)
	
	-- depending on the account wide setting, the settings may not be saved per character
	if self.savedVars.account.accountWideSettings then
		self.savedVars.settings = self.savedVars.account
	else
		self.savedVars.settings = self.savedVars.character
	end
	
	-- changed worldpinwidth/height
	if self.savedVars.settings.worldPinHeight <= 10 then
		self.savedVars.settings.worldPinHeight = self.savedVars.settings.worldPinHeight * 100
	end
	if self.savedVars.settings.worldPinWidth <= 10 then
		self.savedVars.settings.worldPinWidth = self.savedVars.settings.worldPinWidth * 100
	end
	
	-- changed hidden time from 0 to a boolean toggle
	if self.savedVars.settings.hiddenTime < 1 then
		self.savedVars.settings.hiddenTime = 1
	end
end

function Settings:FixPinLayout()
	for i, pinTypeId in pairs(Harvest.PINTYPES) do
		pinLayout = self.savedVars.settings.pinLayouts[pinTypeId]
		-- tints cannot be saved (only as rgba table) so restore these tables to tint objects
		pinLayout.tint = ZO_ColorDef:New(pinLayout.tint)
		if pinTypeId == Harvest.TOUR then
			pinLayout.level = 55
		else
			if Harvest.ArePinsAbovePOI() then
				pinLayout.level = 55
			else
				pinLayout.level = 20
			end
		end
		pinLayout.minSize = self.savedVars.settings.mapPinMinSize
	end
end

function Settings:Initialize()
	self:LoadSavedVars()
	self:FixPinLayout()
	self:InitializeLAM()
end