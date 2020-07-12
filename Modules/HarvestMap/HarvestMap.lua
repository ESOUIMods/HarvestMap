
Harvest = {}

local logFunctions = {}
if LibDebugLogger then
	Harvest.logger = LibDebugLogger("HarvestMap")
	local logFunctionNames = {"Verbose", "Debug", "Info", "Warn", "Error"}
	for _, logFunctionName in pairs(logFunctionNames) do
		logFunctions[logFunctionName] = function(self, ...) return self.logger[logFunctionName](self.logger, ...) end
	end
else
	local logFunctionNames = {"Verbose", "Debug", "Info", "Warn", "Error"}
	for _, logFunctionName in pairs(logFunctionNames) do
		logFunctions[logFunctionName] = function(...) end
	end
end
	
Harvest.modules = {}
function Harvest:RegisterModule(moduleName, moduleTable)
	self[moduleName] = moduleTable
	if Harvest.logger then
		moduleTable.logger = Harvest.logger:Create(moduleName)
	end
	for logFunctionName, logFunction in pairs(logFunctions) do
		moduleTable[logFunctionName] = logFunction
	end
	table.insert(self.modules, moduleTable)
end

function Harvest:InitializeModules()
	for _, moduleTable in ipairs(self.modules) do
		moduleTable:Initialize()
	end
	for _, moduleTable in ipairs(self.modules) do
		if moduleTable.Finalize then
			moduleTable:Finalize()
		end
	end
end

function Harvest.OnLoad(eventCode, addOnName)
		
	if addOnName ~= "HarvestMap" then
		return
	end
	

	if HarvestImport then
		Harvest.notifications:Initialize()
		Harvest.notifications:ShowErrorDialog(
[[The HarvestMap-Import addon was not updated since December 2016.
It is not compatible with HarvestMap, please uninstall the HarvestMap-Import addon.
(To uninstall the addon you must remove the HarvestMapImport folder from Documents/Elder Scrolls Online/live/AddOns/ )
]])
		return
	end
	
	Harvest:InitializeModules()
	
	Harvest.logger:Info(Harvest.GenerateSettingList())
	
	-- initialize bonus features
	if Harvest.IsHeatmapActive() then
		HarvestHeat.Initialize()
	end
	
end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, Harvest.OnLoad)
