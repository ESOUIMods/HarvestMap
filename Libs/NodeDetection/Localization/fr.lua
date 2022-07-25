
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {
	
	-- blacksmith nodes
	["Minerai d'orichalque"] = PinTypes.BLACKSMITH,
	["Minerai d'ébonite"] = PinTypes.BLACKSMITH,
	["Minerai de calcinium"] = PinTypes.BLACKSMITH,
	["Minerai de cuprite"] = PinTypes.BLACKSMITH,
	["Minerai de fer foble"] = PinTypes.BLACKSMITH,
	["Minerai de fer"] = PinTypes.BLACKSMITH,
	["Minerai de galatite"] = PinTypes.BLACKSMITH,
	["Minerai de mercure"] = PinTypes.BLACKSMITH,
	["Minerai de pierre du néant"] = PinTypes.BLACKSMITH,
	["Minerai dwemer"] = PinTypes.BLACKSMITH,
	
	-- clothing nodes
	["Coton"] = PinTypes.CLOTHING,
	["Fil d'ébonite"] = PinTypes.CLOTHING,
	["Fleur du vide"] = PinTypes.CLOTHING,
	["Herbe d'argent"] = PinTypes.CLOTHING,
	["Herbe de fer"] = PinTypes.CLOTHING,
	["Herbe de kresh"] = PinTypes.CLOTHING,
	["Jute"] = PinTypes.CLOTHING,
	["Lin"] = PinTypes.CLOTHING,
	["Soie ancestrale"] = PinTypes.CLOTHING,
	["Soie d'araignée"] = PinTypes.CLOTHING,
	["Tissu déchiré"] = PinTypes.CLOTHING,
	
	-- woodworking nodes
	["Acajou"] = PinTypes.WOODWORKING,
	["Bois de nuit"] = PinTypes.WOODWORKING,
	["Bois de récupération"] = PinTypes.WOODWORKING,
	["Bouleau"] = PinTypes.WOODWORKING,
	["Chêne"] = PinTypes.WOODWORKING,
	["Érable"] = PinTypes.WOODWORKING,
	["Frêne roux"] = PinTypes.WOODWORKING,
	["Frêne"] = PinTypes.WOODWORKING,
	["Hêtre"] = PinTypes.WOODWORKING,
	["If"] = PinTypes.WOODWORKING,
	["Noyer"] = PinTypes.WOODWORKING,

	-- jewelry nodes
	["Veine d'argent"] = PinTypes.BLACKSMITH,
	["Veine d'electrum"] = PinTypes.BLACKSMITH,
	["Veine d'étain"] = PinTypes.BLACKSMITH,
	["Veine de cuivre"] = PinTypes.BLACKSMITH,
	["Veine de platine"] = PinTypes.BLACKSMITH,

	-- enchanting nodes
	["Pierre runique"] = PinTypes.ENCHANTING,

	-- alchemy nodes
	-- reagents
	["Absinthe"] = PinTypes.FLOWER,
	["Ancolie"] = PinTypes.FLOWER,
	["Belladone"] = PinTypes.FLOWER,
	["Besace d'herboriste"] = PinTypes.FLOWER,
	["Bleuet"] = PinTypes.FLOWER,
	["Cardamine des prés"] = PinTypes.FLOWER,
	["Chapeau blanc"] = PinTypes.MUSHROOM,
	["Chardon béni"] = PinTypes.FLOWER,
	["Cloaque de scarabée"] = PinTypes.FLOWER,
	["Coprin violet"] = PinTypes.MUSHROOM,
	["Entoloma bleu"] = PinTypes.MUSHROOM,
	["Épine-de-dragon"] = PinTypes.FLOWER,
	["Jacinthe d'Eau"] = PinTypes.WATERPLANT,
	["Lys des cimes"] = PinTypes.FLOWER,
	["Mutinus elegans"] = PinTypes.MUSHROOM,
	["Nirnrave"] = PinTypes.WATERPLANT,
	["Nirnroot écarlate"] = PinTypes.CRIMSON,
	["Noctuelle"] = PinTypes.FLOWER,
	["Pied-de-lutin"] = PinTypes.MUSHROOM,
	["Russule phosphorescente"] = PinTypes.MUSHROOM,
	["Russule émétique"] = PinTypes.MUSHROOM,
	["Truffe de Namira"] = PinTypes.MUSHROOM,
	-- Solvents
	["Eau pure"] = PinTypes.WATER,
	["Liquides potables"] = PinTypes.WATER,
	["Outre d'eau"] = PinTypes.WATER,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
