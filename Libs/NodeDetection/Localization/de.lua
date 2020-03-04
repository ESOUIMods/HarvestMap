
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {

	["Runenstein"] = PinTypes.ENCHANTING, --18938
	
	["Benediktenkraut"] = PinTypes.FLOWER, -- 80335
	["Wermut"] = PinTypes.FLOWER,
	["Wiesenschaumkraut"] = PinTypes.FLOWER,
	["Wolfsauge"] = PinTypes.FLOWER,
	["Drachendorn"] = PinTypes.FLOWER,
	["Bergblume"] = PinTypes.FLOWER,
	["Akelei"] = PinTypes.FLOWER,
	["Kornblume"] = PinTypes.FLOWER,
	["Nirnwurz"] = PinTypes.WATERPLANT,
	["Wasserhyazinthe"] = PinTypes.WATERPLANT,
	["Stinkmorchel"] = PinTypes.MUSHROOM,
	["blauer Glöckling"] = PinTypes.MUSHROOM,
	["Brechtäubling"] = PinTypes.MUSHROOM,
	["Violetter Tintling"] = PinTypes.MUSHROOM,
	["Namiras Fäulnis"] = PinTypes.MUSHROOM,
	["Weißkappe"] = PinTypes.MUSHROOM,
	["Leuchttäubling"] = PinTypes.MUSHROOM,
	["Koboldschemel"] = PinTypes.MUSHROOM,
	
	["Nachtschatten"] = PinTypes.FLOWER, -- 89419
	
	--["Columbine"] = PinTypes.FLOWER, -- 88394
	["Eibe"] = PinTypes.WOODWORKING,
	["Ebenkraut"] = PinTypes.CLOTHING,
	["Ebenerz"] = PinTypes.BLACKSMITH,
	
	["Ahorn"] = PinTypes.WOODWORKING, -- 88405
	--["Stinkhorn"] = PinTypes.MUSHROOM,
	["Eiche"] = PinTypes.WOODWORKING,
	--["Bugloss"] = PinTypes.FLOWER,
	["Buche"] = PinTypes.WOODWORKING,
	["Hickory"] = PinTypes.WOODWORKING,
	["Eisenerz"] = PinTypes.BLACKSMITH,
	["Feineisenerz"] = PinTypes.BLACKSMITH,
	["Oreichalkoserz"] = PinTypes.BLACKSMITH,
	["Dwemererz"] = PinTypes.BLACKSMITH,
	["Jute"] = PinTypes.CLOTHING,
	["Flachs"] = PinTypes.CLOTHING,
	["Spinnennetze"] = PinTypes.CLOTHING,
	["Baumwolle"] = PinTypes.CLOTHING,
	
	["reines Wasser"] = PinTypes.WATER, -- 88434
	
	["Leerenblüte"] = PinTypes.CLOTHING, -- 89112
	["Kreshkraut"] = PinTypes.CLOTHING,
	["Silberkraut"] = PinTypes.CLOTHING,
	["Eisenkraut"] = PinTypes.CLOTHING,
	["Kalziniumerz"] = PinTypes.BLACKSMITH,
	["Galatiterz"] = PinTypes.BLACKSMITH,
	["Flinksilbererz"] = PinTypes.BLACKSMITH,
	["Leereneisenerz"] = PinTypes.BLACKSMITH,
	["Nachtholz"] = PinTypes.WOODWORKING,
	["Esche"] = PinTypes.WOODWORKING,
	["Birke"] = PinTypes.WOODWORKING,
	["Mahagoniholz"] = PinTypes.WOODWORKING,
	
	["Trinkschlauch"] = PinTypes.WATER, --89494, 89537
	
	["Rubinesche"] = PinTypes.WOODWORKING, -- 89513
	["Ahnenseide"] = PinTypes.CLOTHING,
	["Rubediterz"] = PinTypes.BLACKSMITH,
	
	--["Rubedite Ore"] = PinTypes.BLACKSMITH, -- 89734,89735,90023
	--["Water Skin"] = PinTypes.WATER, -- 89736,89737
	["Ranzen des Kräuterkenners"] = PinTypes.FLOWER, -- 89419
	["zerrissener Stoff"] = PinTypes.CLOTHING,
	["Holzreste"] = PinTypes.WOODWORKING,
	["trinkbare Flüssigkeiten"] = PinTypes.WATER, -- 89738,89739
	
	-- jewelry nodes
	["Zinnflöz"] = PinTypes.BLACKSMITH, -- 89936, 543270 ca
	["Kupferflöz"] = PinTypes.BLACKSMITH,
	["Silberflöz"] = PinTypes.BLACKSMITH,
	["Elektrumflöz"] = PinTypes.BLACKSMITH,
	["Platinflöz"] = PinTypes.BLACKSMITH,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
