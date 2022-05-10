
local function CopyMissingDefaultValues(result, template)
	for key, value in pairs(template) do
		if type(value) == "table" then
			result[key] = result[key] or {}
			CopyMissingDefaultValues(result[key], value)
		else
			if result[key] == nil then
				result[key] = result[key] or value
			end
		end
	end
end

Harvest.CopyMissingDefaultValues = CopyMissingDefaultValues

-- construct display version based on manifest addon version
local AddOnManager = GetAddOnManager()
Harvest.displayVersion = ""
for addonIndex = 1, AddOnManager:GetNumAddOns() do
	local name = AddOnManager:GetAddOnInfo(addonIndex)
	if name == "HarvestMap" then
		local versionInt = AddOnManager:GetAddOnVersion(addonIndex)
		local rev = versionInt % 1000
		local version = zo_floor(versionInt / 1000) % 100
		local major = zo_floor(versionInt / 100000) % 100
		Harvest.displayVersion = string.format("%d.%d.%d", major, version, rev)
	end
end

function Harvest.GetPlayer3DPosition()
	local _, worldX, worldZ, worldY = GetUnitRawWorldPosition("player")
	return worldX/100, worldY/100, worldZ/100
end

-- control which is used to take 3d world coordinate measurements
local measurementControl = CreateControl("HarvestMapMeasurementControl", GuiRoot, CT_CONTROL)
measurementControl:Create3DRenderSpace()

function Harvest.GetCamera3DPosition()
	Set3DRenderSpaceToCurrentCamera(measurementControl:GetName())
	local worldX, worldZ, worldY = measurementControl:Get3DRenderSpaceOrigin()
	worldX, worldZ, worldY = GuiRender3DPositionToWorldPosition(worldX, worldZ, worldY)
	return worldX/100, worldY/100, worldZ/100
end
