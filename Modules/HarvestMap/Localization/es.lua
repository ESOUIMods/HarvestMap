
Harvest.localizedStrings = {} -- todo, translate the english terms

local interactableName2PinTypeId = {
	["saco pesado"] = Harvest.HEAVYSACK,
	-- special nodes in cold harbor with the same loot as heavy sacks
	["caja pesada"] = Harvest.HEAVYSACK,
	["Tesoro de los ladrones"] = Harvest.TROVE,
	["Panel suelto"] = Harvest.STASH,
	["Baldosa suelta"] = Harvest.STASH,
	["Piedra suelta"] = Harvest.STASH,
	["portal psijic"] = Harvest.PSIJIC,
	["almeja gigante"] = Harvest.CLAM,
}
-- convert to lower case. zos sometimes changes capitalization so it's safer to just do all the logic in lower case
Harvest.interactableName2PinTypeId = Harvest.interactableName2PinTypeId or {}
local globalList = Harvest.interactableName2PinTypeId
for name, pinTypeId in pairs(interactableName2PinTypeId) do
	globalList[zo_strlower(name)] = pinTypeId
end