
function Harvest.IsolateHarvestMap(para)
	if para ~= "confirm" then return end
	-- turn off all other addons, enable only harvestmap and the required libs
	local enabledAddons = {
		HarvestMap = true,
		HarvestMapAD = true,
		HarvestMapDC = true,
		HarvestMapEP = true,
		HarvestMapDLC = true,
		HarvestMapNF = true,
		LibVotansAddonList = true,
	}
	local AddOnManager = GetAddOnManager()
	-- check the libs required by harvestmap
	for addonIndex = 1, AddOnManager:GetNumAddOns() do
		local name = AddOnManager:GetAddOnInfo(addonIndex)
		if name == "HarvestMap" then
			local numDependencies = AddOnManager:GetAddOnNumDependencies(addonIndex)
			for dependencyIndex = 1, numDependencies do
				local dependencyName = AddOnManager:GetAddOnDependencyInfo(addonIndex, dependencyIndex)
				enabledAddons[dependencyName] = true
			end
		end
	end
	-- now turn on/off everything
	for addonIndex = 1, AddOnManager:GetNumAddOns() do
		local name = AddOnManager:GetAddOnInfo(addonIndex)
		AddOnManager:SetAddOnEnabled(addonIndex, enabledAddons[name] ~= nil)
	end
	-- reload ui so the addons are (un)loaded
	ReloadUI("ingame")
end

function Harvest.HardReset(para)
	if para ~= "confirm" then return end
	-- remove all settings
	local backup = Harvest_SavedVars
	Harvest_SavedVars = {backup = backup}
	Harvest.IsolateHarvestMap(para)
end
SLASH_COMMANDS["/harvestmapreset"] = Harvest.HardReset
SLASH_COMMANDS["/harvestmapisolate"] = Harvest.IsolateHarvestMap

function Harvest.GenerateSettingList()
	list = {}
	
	for key, value in pairs(Harvest.settings.defaultGlobalSettings) do
		value = Harvest.settings.savedVars.global[key]
		if type(value) ~= "table" then
			table.insert(list, key)
			table.insert(list, ":")
			table.insert(list, tostring(value))
			table.insert(list, "\n")
		end
	end
	
	for key, value in pairs(Harvest.settings.defaultSettings) do
		value = Harvest.settings.savedVars.settings[key]
		if type(value) ~= "table" then
			table.insert(list, key)
			table.insert(list, ":")
			table.insert(list, tostring(value))
			table.insert(list, "\n")
		else
			local k, v = next(value)
			if type(v) == "boolean" then
				table.insert(list, key)
				table.insert(list, ":")
				for k, v in pairs(value) do
					table.insert(list, tostring(k))
					if v then
						table.insert(list, "y")
					else
						table.insert(list, "n")
					end
				end
				table.insert(list, "\n")
			end
		end
	end
	
	-- TODO add debug output for currently active profiles
	
	return table.concat(list)
end
