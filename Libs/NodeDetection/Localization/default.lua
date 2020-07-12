
-- some strings are not translated in the custom localizations (some are WIP)
-- so always load the english defaults

local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalizationDefault", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {

	["Runestone"] = PinTypes.ENCHANTING, --18938
	
	["Blessed Thistle"] = PinTypes.FLOWER, -- 80335
	["Wormwood"] = PinTypes.FLOWER,
	["Lady's Smock"] = PinTypes.FLOWER,
	["Bugloss"] = PinTypes.FLOWER,
	["Dragonthorn"] = PinTypes.FLOWER,
	["Mountain Flower"] = PinTypes.FLOWER,
	["Columbine"] = PinTypes.FLOWER,
	["Corn Flower"] = PinTypes.FLOWER,
	["Nirnroot"] = PinTypes.WATERPLANT,
	["Water Hyacinth"] = PinTypes.WATERPLANT,
	["Stinkhorn"] = PinTypes.MUSHROOM,
	["Blue Entoloma"] = PinTypes.MUSHROOM,
	["Emetic Russula"] = PinTypes.MUSHROOM,
	["Violet Coprinus"] = PinTypes.MUSHROOM,
	["Namira's Rot"] = PinTypes.MUSHROOM,
	["White Cap"] = PinTypes.MUSHROOM,
	["Luminous Russula"] = PinTypes.MUSHROOM,
	["Imp Stool"] = PinTypes.MUSHROOM,
	
	["Nightshade"] = PinTypes.FLOWER, -- 89419
	
	--["Columbine"] = PinTypes.FLOWER, -- 88394
	["Yew"] = PinTypes.WOODWORKING,
	["Ebonthread"] = PinTypes.CLOTHING,
	["Ebony Ore"] = PinTypes.BLACKSMITH,
	
	["Maple"] = PinTypes.WOODWORKING, -- 88405
	--["Stinkhorn"] = PinTypes.MUSHROOM,
	["Oak"] = PinTypes.WOODWORKING,
	--["Bugloss"] = PinTypes.FLOWER,
	["Beech"] = PinTypes.WOODWORKING,
	["Hickory"] = PinTypes.WOODWORKING,
	["Iron Ore"] = PinTypes.BLACKSMITH,
	["High Iron Ore"] = PinTypes.BLACKSMITH,
	["Orichalcum Ore"] = PinTypes.BLACKSMITH,
	["Dwarven Ore"] = PinTypes.BLACKSMITH,
	["Jute"] = PinTypes.CLOTHING,
	["Flax"] = PinTypes.CLOTHING,
	["Spidersilk"] = PinTypes.CLOTHING,
	["Cotton"] = PinTypes.CLOTHING,
	
	["Pure Water"] = PinTypes.WATER, -- 88434
	
	["Void Bloom"] = PinTypes.CLOTHING, -- 89112
	["Kreshweed"] = PinTypes.CLOTHING,
	["Silverweed"] = PinTypes.CLOTHING,
	["Ironweed"] = PinTypes.CLOTHING,
	["Calcinium Ore"] = PinTypes.BLACKSMITH,
	["Galatite Ore"] = PinTypes.BLACKSMITH,
	["Quicksilver Ore"] = PinTypes.BLACKSMITH,
	["Voidstone Ore"] = PinTypes.BLACKSMITH,
	["Nightwood"] = PinTypes.WOODWORKING,
	["Ash"] = PinTypes.WOODWORKING,
	["Birch"] = PinTypes.WOODWORKING,
	["Mahogany"] = PinTypes.WOODWORKING,
	
	["Water Skin"] = PinTypes.WATER, --89494, 89537
	
	["Ruby Ash Wood"] = PinTypes.WOODWORKING, -- 89513
	["Ancestor Silk"] = PinTypes.CLOTHING,
	["Rubedite Ore"] = PinTypes.BLACKSMITH,
	
	--["Rubedite Ore"] = PinTypes.BLACKSMITH, -- 89734,89735,90023
	--["Water Skin"] = PinTypes.WATER, -- 89736,89737
	["Herbalist's Satchel"] = PinTypes.FLOWER, -- 89419
	["Torn Cloth"] = PinTypes.CLOTHING,
	["Scrap Wood"] = PinTypes.WOODWORKING,
	["Potable Liquids"] = PinTypes.WATER, -- 89738,89739
	
	-- jewelry nodes
	["Pewter Seam"] = PinTypes.BLACKSMITH, -- 89936
	["Platinum Seam"] = PinTypes.BLACKSMITH,
	["Copper Seam"] = PinTypes.BLACKSMITH,
	["Silver Seam"] = PinTypes.BLACKSMITH,
	["Electrum Seam"] = PinTypes.BLACKSMITH,
	
	["Crimson Nirnroot"] = PinTypes.CRIMSON,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
