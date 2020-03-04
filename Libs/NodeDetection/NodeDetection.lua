
--[[
Private library for HarvestMap and CraftingCompass
--]]

LibNodeDetection = {}
local Main = LibNodeDetection
Main.modules = {}

function Main:RegisterModule(identifier, module)
	self[identifier] = module
	table.insert(self.modules, module)
end

function Main:InitializeModules()
	for _, module in pairs(self.modules) do
		if type(module.Initialize) == "function" then
			module:Initialize()
		end
	end
end

local Events = {}
LibNodeDetection.events = Events
local CallbackManager = {}
LibNodeDetection.callbackManager = CallbackManager

CallbackManager.callbacks = {}
Events.lastAddedEventId = 0
function Events:AddEvent(eventName)
	self.lastAddedEventId = self.lastAddedEventId + 1
	self[eventName] = self.lastAddedEventId
	CallbackManager.callbacks[self.lastAddedEventId] = {}
end

Events:AddEvent("HARVEST_NODE_VISIBLE")
Events:AddEvent("HARVEST_NODE_HIDDEN")
Events:AddEvent("HARVEST_NODE_PINTYPE_UPDATED")
Events:AddEvent("HARVEST_NODE_LOCATION_UPDATED")


function CallbackManager:RegisterCallback(event, callback)
	assert(callback)
	assert(event)
	table.insert(self.callbacks[event], callback)
end

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
	for _, callback in pairs(self.callbacks[event]) do
		callback(event, ...)
	end
end

local function OnAddOnLoaded(eventCode, addOnName)
	if addOnName ~= "NodeDetection" then return end
	Main:InitializeModules()
end

EVENT_MANAGER:RegisterForEvent("LibNodeDetection", EVENT_ADD_ON_LOADED, OnAddOnLoaded)
