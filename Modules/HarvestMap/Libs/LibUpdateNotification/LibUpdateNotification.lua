
local LIB_NAME = "LibUpdateNotification"
local VERSION = 3

if LibUpdateNotification then
	if LibUpdateNotification.version < VERSION then
		LibUpdateNotification:Unload()
	else
		return
	end
end
LibUpdateNotification = {version = VERSION}

local g_guildId = nil
local g_guildAvailable = false
local g_playerActivated = false

local GUILD_IDS = {
	["EU Megaserver"] = 555448,
	["NA Megaserver"] = 643073,
}

local TITLE = "Update Notification"
local NOTIFICATION =
[[There is an update available for the add-on |cffffff<<1>>|r (Version |cffffff<<2>>|r).
]]

local AUTO_CLOSE_MS = 10 * 1000
local BASE_TUTORIAL_HEIGHT = 170

local function addons(str)
	return str:gmatch("([^\n]-) ([^\n]-) ([^\n]*)")
end


local function ConstructAddOnVersionTable()
	local addOnVersions = {}
	local addOnManager = GetAddOnManager()
	for id = 1, addOnManager:GetNumAddOns() do
		local name = addOnManager:GetAddOnInfo(id)
		local version = addOnManager:GetAddOnVersion(id)
		addOnVersions[name] = version
	end
	return addOnVersions
end

local function CheckUpdateInformation()
	if not (g_guildAvailable and g_playerActivated) then return end
	
	local guildData = GUILD_BROWSER_MANAGER:GetGuildData(g_guildId)
	if not guildData then return end
	
	local message = guildData.recruitmentMessage
	local addOnVersions = ConstructAddOnVersionTable()
	
	text = ""
	for addOnName, addOnVersion, version in addons(message) do
		if (addOnVersions[addOnName] or 0) < (tonumber(addOnVersion) or 0) then
			text = text .. zo_strformat(NOTIFICATION, addOnName, version)
		end
	end
	if text ~= "" then
		TUTORIAL_SYSTEM.tutorialHandlers[TUTORIAL_TYPE_HUD_INFO_BOX]:DisplayText(TITLE, text)
	end
end

local function OnGuildDataReady(guildId)
	if g_guildId == guildId then
		g_guildAvailable = true
		CheckUpdateInformation()
	end
end

local function OnPlayerActivated()
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED)
	g_playerActivated = true
	CheckUpdateInformation()
end

local function OnAddOnLoaded(_, addOnName)
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED)
	
	function ZO_HudInfoTutorial:DisplayText(title, text)
		local isInGamepadMode = IsInGamepadPreferredMode()
		if isInGamepadMode then
			self.tutorial = self.tutorialGamepad
			self.tutorialAnimation = self.tutorialAnimationGamepad
		else
			self.tutorial = self.tutorialKeyboard
			self.tutorialAnimation = self.tutorialAnimationKeyboard
		end

		local hasHelp = false
		self.tutorial.title:SetText(title)
		self.tutorial.description:SetText(text)
		
		local showHelpLabel = hasHelp and not isInGamepadMode
		self.tutorial.helpLabel:SetHidden(not showHelpLabel)
		self.tutorial.helpKey:SetHidden(not showHelpLabel)

		if not isInGamepadMode then
			local textHeight = self.tutorial.description:GetTextHeight()
			if hasHelp then
				textHeight = textHeight + self.tutorial.helpLabel:GetHeight()
			end
			self.tutorial:SetHeight(BASE_TUTORIAL_HEIGHT + textHeight)
		end

		self.tutorialAnimation:PlayBackward()
		self:SetHiddenForReason("inactive", false)
		local tutorialIndex = -1
		self:SetCurrentlyDisplayedTutorialIndex(tutorialIndex)
		self.currentlyDisplayedTutorialTimeLeft = AUTO_CLOSE_MS

		PlaySound(SOUNDS.TUTORIAL_INFO_SHOWN)
	end
	
	
	g_guildId = GUILD_IDS[GetWorldName()]
	if not g_guildId then return end -- eg PTS server
	--assert(g_guildId, "No guild provided for world " .. tostring(GetWorldName()))
	
	GUILD_BROWSER_MANAGER:RegisterCallback("OnGuildDataReady", OnGuildDataReady)
	if GUILD_BROWSER_MANAGER:GetGuildData(g_guildId) then
		OnGuildDataReady(g_guildId)
	else
		GUILD_BROWSER_MANAGER:RequestGuildData(g_guildId)
	end
end

EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

function LibUpdateNotification:Unload()
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
	EVENT_MANAGER:UnregisterForEvent(LIB_NAME, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
end
