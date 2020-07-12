
-- constants/enums for the pin types
Harvest.BLACKSMITH = 1 -- also jewelry
Harvest.CLOTHING = 2
Harvest.ENCHANTING = 3 -- also psijic portals
Harvest.MUSHROOM = 4 -- used to be alchemy
Harvest.WOODWORKING = 5
Harvest.CHESTS = 6
Harvest.WATER = 7
Harvest.FISHING = 8
Harvest.HEAVYSACK = 9
Harvest.TROVE = 10
Harvest.JUSTICE = 11
Harvest.STASH = 12 -- loose panels etc
Harvest.FLOWER = 13
Harvest.WATERPLANT = 14
Harvest.CLAM = 15
-- psijic portals spawn at runestone locations
Harvest.PSIJIC = 16
-- jewelry material spawns at blacksmithing location
Harvest.JEWELRY = 17
Harvest.UNKNOWN = 18
Harvest.CRIMSON = 19

Harvest.TOUR = 100 -- pin which displays the next resource of the farming tour

-- order in which pins are displayed in the filters etc
Harvest.PINTYPES = {
	Harvest.BLACKSMITH, Harvest.CLOTHING,
	Harvest.WOODWORKING, Harvest.ENCHANTING,
	Harvest.MUSHROOM, Harvest.FLOWER,
	Harvest.WATERPLANT, Harvest.CRIMSON, Harvest.WATER, Harvest.CLAM,
	Harvest.JEWELRY, Harvest.CHESTS,
	Harvest.HEAVYSACK, Harvest.PSIJIC,
	Harvest.TROVE, Harvest.JUSTICE, Harvest.STASH,
	Harvest.FISHING, Harvest.UNKNOWN, Harvest.TOUR,
}

Harvest.ZONES_FOR_PINTYPE = {
	[Harvest.CRIMSON] = {[1161] = true}, -- blackreach
	[Harvest.CLAM] = {[1011] = true}, -- summerset
	[Harvest.STASH] = {
		[816] = true, -- hews bane
		[823] = true, -- gold coast
	},
}

-- pinTypes that can be detected via eso's MAP_PIN_TYPE_HARVEST_NODE api
Harvest.HARVEST_NODES = {
	[Harvest.BLACKSMITH] = true,
	[Harvest.CLOTHING] = true,
	[Harvest.WOODWORKING] = true,
	[Harvest.ENCHANTING] = true,
	[Harvest.MUSHROOM] = true,
	[Harvest.FLOWER] = true,
	[Harvest.WATERPLANT] = true,
	[Harvest.WATER] = true,
	[Harvest.CRIMSON] = true,
}

-- translates pintypes, e.g. LibNodeDetection.pinTypes.BLACKSMITH to Harvest.BLACKSMITH
Harvest.DETECTION_TO_HARVEST_PINTYPE = {}
if LibNodeDetection then
	for key, value in pairs(LibNodeDetection.pinTypes) do
		if type(key) == "string" and type(value) == "number" then
			Harvest.DETECTION_TO_HARVEST_PINTYPE[value] = Harvest[key]
		end
	end
end

-- pisjic portals are saved as enchanting/runestones
Harvest.PINTYPE_ALIAS = {
	[Harvest.PSIJIC] = Harvest.ENCHANTING,
	[Harvest.JEWELRY] = Harvest.BLACKSMITH,
}

-- pin types that are not displayed
Harvest.HIDDEN_PINTYPES = {
	[Harvest.TOUR] = true,
	[Harvest.PSIJIC] = true,
	[Harvest.JEWELRY] = true,
}

local interactableName2PinTypeId = {
	["heavy sack"] = Harvest.HEAVYSACK,
	["heavy crate"] = Harvest.HEAVYSACK, -- special nodes in cold harbor
	["schwerer sack"] = Harvest.HEAVYSACK,
	["sac lourd"] = Harvest.HEAVYSACK,
	["Т�?жeлый мeшoк"] = Harvest.HEAVYSACK, -- russian
	["Тяжелый мешок"] = Harvest.HEAVYSACK, -- updated russian
	["тяжелый мешок"] = Harvest.HEAVYSACK, -- updated russian
	
	["thieves trove"] = Harvest.TROVE,
	["diebesgut"] = Harvest.TROVE,
	["trésor des voleurs"] = Harvest.TROVE,
	["Вopoвcкoй тaйник"] = Harvest.TROVE,  -- russian
	["Воровской тайник"] = Harvest.TROVE, -- updated russian
	["воровской тайник"] = Harvest.TROVE, -- updated russian
	
	["loose panel"] = Harvest.STASH,
	["loose tile"] = Harvest.STASH,
	["loose stone"] = Harvest.STASH,
	["panneau mobile"] = Harvest.STASH,
	["tuile descellée"] = Harvest.STASH,
	["pierre délogée"] = Harvest.STASH,
	["lose tafel"] = Harvest.STASH,
	["lose platte"] = Harvest.STASH,
	["loser stein"] = Harvest.STASH,
	["Податливая панель"] = Harvest.STASH, -- russian
	["Податливый камень"] = Harvest.STASH, -- loose tile is not translated in the ru.lang file of RuESO
	
	["psijic portal"] = Harvest.PSIJIC,
	["portail psijique"] = Harvest.PSIJIC,
	["psijik-portal"] = Harvest.PSIJIC,
	
	["giant clam"] = Harvest.CLAM,
	["riesenmuschel"] = Harvest.CLAM,
	["palourde géante"] = Harvest.CLAM,
}
function Harvest.IsInteractableAContainer( interactableName )
	return interactableName2PinTypeId[zo_strlower( interactableName )] ~= nil
end

-- this function returns the pinTypeId for the given item id and node name
function Harvest.GetPinTypeId( itemId, interactableName )
	-- get two pin types based on the item id and node name
	local itemIdPinTypeId = Harvest.itemId2PinType[ itemId ]
	local interactablePinTypeId = interactableName2PinTypeId[zo_strlower( interactableName )]
	-- heavy sacks can contain material for different professions
	-- so don't use the item id to determine the pin type
	return interactablePinTypeId or itemIdPinTypeId
end

Harvest.itemId2PinType = {
	[808] = Harvest.BLACKSMITH,
	[4482] = Harvest.BLACKSMITH,
	[4995] = Harvest.BLACKSMITH,
	[5820] = Harvest.BLACKSMITH,
	[23103] = Harvest.BLACKSMITH,
	[23104] = Harvest.BLACKSMITH,
	[23105] = Harvest.BLACKSMITH,
	[23133] = Harvest.BLACKSMITH,
	[23134] = Harvest.BLACKSMITH,
	[23135] = Harvest.BLACKSMITH,
	[71198] = Harvest.BLACKSMITH,
	[114889] = Harvest.BLACKSMITH, -- regulus

	[812] = Harvest.CLOTHING,
	[4464] = Harvest.CLOTHING,
	[23129] = Harvest.CLOTHING,
	[23130] = Harvest.CLOTHING,
	[23131] = Harvest.CLOTHING,
	[33217] = Harvest.CLOTHING,
	[33218] = Harvest.CLOTHING,
	[33219] = Harvest.CLOTHING,
	[33220] = Harvest.CLOTHING,
	[71200] = Harvest.CLOTHING,
	[114890] = Harvest.CLOTHING, -- bast

	[45806] = Harvest.ENCHANTING,
	[45807] = Harvest.ENCHANTING,
	[45808] = Harvest.ENCHANTING,
	[45809] = Harvest.ENCHANTING,
	[45810] = Harvest.ENCHANTING,
	[45811] = Harvest.ENCHANTING,
	[45812] = Harvest.ENCHANTING,
	[45813] = Harvest.ENCHANTING,
	[45814] = Harvest.ENCHANTING,
	[45815] = Harvest.ENCHANTING,
	[45816] = Harvest.ENCHANTING,
	[45817] = Harvest.ENCHANTING,
	[45818] = Harvest.ENCHANTING,
	[45819] = Harvest.ENCHANTING,
	[45820] = Harvest.ENCHANTING,
	[45821] = Harvest.ENCHANTING,
	[45822] = Harvest.ENCHANTING,
	[45823] = Harvest.ENCHANTING,
	[45824] = Harvest.ENCHANTING,
	[45825] = Harvest.ENCHANTING,
	[45826] = Harvest.ENCHANTING,
	[45827] = Harvest.ENCHANTING,
	[45828] = Harvest.ENCHANTING,
	[45829] = Harvest.ENCHANTING,
	[45830] = Harvest.ENCHANTING,
	[45831] = Harvest.ENCHANTING,
	[45832] = Harvest.ENCHANTING,
	[45833] = Harvest.ENCHANTING,
	[45834] = Harvest.ENCHANTING,
	[45835] = Harvest.ENCHANTING,
	[45836] = Harvest.ENCHANTING,
	[45837] = Harvest.ENCHANTING,
	[45838] = Harvest.ENCHANTING,
	[45839] = Harvest.ENCHANTING,
	[45840] = Harvest.ENCHANTING,
	[45841] = Harvest.ENCHANTING,
	[45842] = Harvest.ENCHANTING,
	[45843] = Harvest.ENCHANTING,
	[45844] = Harvest.ENCHANTING,
	[45845] = Harvest.ENCHANTING,
	[45846] = Harvest.ENCHANTING,
	[45847] = Harvest.ENCHANTING,
	[45848] = Harvest.ENCHANTING,
	[45849] = Harvest.ENCHANTING,
	[45850] = Harvest.ENCHANTING,
	[45851] = Harvest.ENCHANTING,
	[45852] = Harvest.ENCHANTING,
	[45853] = Harvest.ENCHANTING,
	[45854] = Harvest.ENCHANTING,
	[45855] = Harvest.ENCHANTING,
	[45856] = Harvest.ENCHANTING,
	[45857] = Harvest.ENCHANTING,
	[54248] = Harvest.ENCHANTING,
	[54253] = Harvest.ENCHANTING,
	[54289] = Harvest.ENCHANTING,
	[54294] = Harvest.ENCHANTING,
	[54297] = Harvest.ENCHANTING,
	[54299] = Harvest.ENCHANTING,
	[54306] = Harvest.ENCHANTING,
	[54330] = Harvest.ENCHANTING,
	[54331] = Harvest.ENCHANTING,
	[54342] = Harvest.ENCHANTING,
	[54373] = Harvest.ENCHANTING,
	[54374] = Harvest.ENCHANTING,
	[54375] = Harvest.ENCHANTING,
	[54481] = Harvest.ENCHANTING,
	[54482] = Harvest.ENCHANTING,
	[64509] = Harvest.ENCHANTING,
	[68341] = Harvest.ENCHANTING,
	[64508] = Harvest.ENCHANTING,
	[68340] = Harvest.ENCHANTING,
	[68342] = Harvest.ENCHANTING,
	[114892] = Harvest.ENCHANTING, -- mundane rune

	[30148] = Harvest.MUSHROOM,
	[30149] = Harvest.MUSHROOM,
	[30151] = Harvest.MUSHROOM,
	[30152] = Harvest.MUSHROOM,
	[30153] = Harvest.MUSHROOM,
	[30154] = Harvest.MUSHROOM,
	[30155] = Harvest.MUSHROOM,
	[30156] = Harvest.MUSHROOM,
	[30157] = Harvest.FLOWER,
	[30158] = Harvest.FLOWER,
	[30159] = Harvest.FLOWER,
	[30160] = Harvest.FLOWER,
	[30161] = Harvest.FLOWER,
	[30162] = Harvest.FLOWER,
	[30163] = Harvest.FLOWER,
	[30164] = Harvest.FLOWER,
	[30165] = Harvest.WATERPLANT,
	[30166] = Harvest.WATERPLANT,
	[77590] = Harvest.FLOWER, -- Nightshade, added in DB

	[521] = Harvest.WOODWORKING,
	[802] = Harvest.WOODWORKING,
	[818] = Harvest.WOODWORKING,
	[4439] = Harvest.WOODWORKING,
	[23117] = Harvest.WOODWORKING,
	[23118] = Harvest.WOODWORKING,
	[23119] = Harvest.WOODWORKING,
	[23137] = Harvest.WOODWORKING,
	[23138] = Harvest.WOODWORKING,
	[71199] = Harvest.WOODWORKING,
	[114895] = Harvest.WOODWORKING, -- heartwood

	[883] = Harvest.WATER,
	[1187] = Harvest.WATER,
	[4570] = Harvest.WATER,
	[23265] = Harvest.WATER,
	[23266] = Harvest.WATER,
	[23267] = Harvest.WATER,
	[23268] = Harvest.WATER,
	[64500] = Harvest.WATER,
	[64501] = Harvest.WATER,
	
	[135137] = Harvest.JEWELRY,
	[135139] = Harvest.JEWELRY,
	[135141] = Harvest.JEWELRY,
	[135143] = Harvest.JEWELRY,
	[135145] = Harvest.JEWELRY,
	-- upgrade materials
	[135151] = Harvest.JEWELRY,
	[135152] = Harvest.JEWELRY,
	[135153] = Harvest.JEWELRY,
	[135154] = Harvest.JEWELRY,
	-- trait and other items
	[135155] = Harvest.JEWELRY,
	[135156] = Harvest.JEWELRY,
	[135157] = Harvest.JEWELRY,
	[135158] = Harvest.JEWELRY,
	[135159] = Harvest.JEWELRY,
	[135160] = Harvest.JEWELRY,
	[135161] = Harvest.JEWELRY,
	
	[150672] = Harvest.CRIMSON,
}
