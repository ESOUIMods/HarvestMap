---
-- Contains names of events which used by Harvest and its submodules.
--

Harvest.events = {}
Harvest.callbackManager = {}
local Events = Harvest.events
local CallbackManager = Harvest.callbackManager
local EventQueue = { startIndex = 1, endIndex = 0 }

local lastId = 0

-- helper function to add new events more easily
-- added events can be accessed via Harvest.events.eventName
local function AddEvent(eventName)
	lastId = lastId + 1
	Events[eventName] = lastId
end

-- event which will be used in the future to track pins hidden by the respawn timer
AddEvent("CHANGED_NODE_HIDDEN_STATE")
-- database result events
AddEvent("NODE_DELETED")
AddEvent("NODE_UPDATED")
AddEvent("NODE_ADDED")
AddEvent("NODE_COMPASS_LINK_CHANGED")
AddEvent("NODE_HARVESTED")
AddEvent("NEW_NODES_LOADED_TO_CACHE")

AddEvent("FILTER_PROFILE_CHANGED")

AddEvent("FARMED_ITEM")

AddEvent("SETTING_CHANGED")

AddEvent("CACHE_CREATED")
AddEvent("NEW_ZONE_ENTERED")
AddEvent("MAP_ADDED_TO_ZONE")
AddEvent("MAP_REMOVED_FROM_ZONE")

AddEvent("MAP_CHANGE")

AddEvent("TOUR_GENERATION_STARTED")
AddEvent("TOUR_GENERATION_FINISHED")
AddEvent("TOUR_GENERATION_UPDATED")
AddEvent("TOUR_GENERATION_ERROR")
AddEvent("TOUR_CHANGED")
AddEvent("TOUR_NODE_CLICKED")

AddEvent("NODE_DISCOVERED")

AddEvent("MAP_MODE_CHANGED")
AddEvent("PIN_QUEUE_EMPTY")

AddEvent("ERROR_MODULE_NOT_LOADED")


CallbackManager.callbacks = {}
for eventName, eventId in pairs(Events) do
	CallbackManager.callbacks[eventId] = {}
end

function CallbackManager:RegisterCallback(event, callback)
	assert(callback)
	table.insert(self.callbacks[event], callback)
end

-- RegisterForEvent is the function for the EVENT_MANAGER and RegisterCallback is used for the CALLBACK_MANAGER.
-- I can never remember which function name I used for my own callbackmanager, so let's just allow both.
CallbackManager.RegisterForEvent = CallbackManager.RegisterCallback

function CallbackManager:UnregisterCallback(event, callback)
	for index, entry in pairs(self.callbacks[event]) do
		if entry == callback then
			self.callbacks[event][index] = nil
			return true
		end
	end
	return false
end

function CallbackManager:FireCallbacks(event, ...)
	for index, callback in pairs(self.callbacks[event]) do
		callback(event, ...)
	end
end
