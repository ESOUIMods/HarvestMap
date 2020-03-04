
local Notifications = {}
Harvest:RegisterModule("notifications", Notifications)

local CallbackManager = Harvest.callbackManager
local Events = Harvest.events

local MESSAGE_RATE_MS = 5 * 1000

function Notifications:Initialize()
	CallbackManager:RegisterForEvent(Events.ERROR_MODULE_NOT_LOADED, function(...) self:HandleMissingModule(...) end)
	self.lastEventForCategory = {}
	
	local errorDialog = {
		title = { text = GetString(SI_PROMPT_TITLE_ERROR) },
		mainText = { text = "<<1>>" },
		buttons = {
			[1] = {
				text = GetString(SI_DIALOG_CLOSE),
			},
		}
	}
	ZO_Dialogs_RegisterCustomDialog("HARVEST_ERROR_DIALOG", errorDialog)
end

function Notifications:HandleMissingModule(event, category, moduleName)
	if not Harvest.AreNotificationsEnabled() then return end
	local message = zo_strformat(Harvest.GetLocalization("moduleerror" .. category), moduleName)
	self:ShowNotification(category, message)
end

function Notifications:ShowNotification(category, message)
	if (self.lastEventForCategory[category] or 0) < GetGameTimeMilliseconds() - MESSAGE_RATE_MS then
		self.lastEventForCategory[category] = GetGameTimeMilliseconds()
		ZO_AlertNoSuppression(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, message)
	end
end

function Notifications:ShowErrorDialog(message)
	ZO_Dialogs_ShowDialog("HARVEST_ERROR_DIALOG", {}, { mainTextParams = { message } } )
end
