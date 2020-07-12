
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
		local rev = versionInt % 100
		local version = zo_floor(versionInt / 100) % 100
		local major = zo_floor(versionInt / 10000) % 100
		Harvest.displayVersion = string.format("%d.%d.%d", major, version, rev)
	end
end

function Harvest.GetPlayer3DPosition()
	local _, worldX, worldZ, worldY = GetUnitWorldPosition("player")
	return worldX/100, worldY/100, worldZ/100
end

function Harvest.GetCamera3DPosition()
	local worldX, worldZ, worldY = Lib3D:GetCameraRenderSpacePosition()
	worldX, worldZ, worldY = GuiRender3DPositionToWorldPosition(worldX, worldZ, worldY)
	return worldX/100, worldY/100, worldZ/100
end
