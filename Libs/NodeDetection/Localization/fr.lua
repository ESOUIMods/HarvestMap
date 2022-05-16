
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {
	
	--Matériaux de forge
	["Minerai d'orichalque"] = PinTypes.BLACKSMITH,
	["Minerai d'ébonite"] = PinTypes.BLACKSMITH,
	["Minerai de calcinium"] = PinTypes.BLACKSMITH,
	["Minerai de cuprite"] = PinTypes.BLACKSMITH,
	["Minerai de fer foble"] = PinTypes.BLACKSMITH,
	["Minerai de fer"] = PinTypes.BLACKSMITH,
	["Minerai de galatite"] = PinTypes.BLACKSMITH,
	["Minerai de mercure"] = PinTypes.BLACKSMITH,
	["Minerai de pierre du vide"] = PinTypes.BLACKSMITH,
	["Minerai dwemer"] = PinTypes.BLACKSMITH,

    --Matériaux de couture
	["Coton"] = PinTypes.CLOTHING,
	["Fil d'argent"] = PinTypes.CLOTHING,
	["Fil d'ébonite"] = PinTypes.CLOTHING,
	["Fil de fer"] = PinTypes.CLOTHING,
	["Fleur du vide"] = PinTypes.CLOTHING,
	["Herbe de Fer"] = PinTypes.CLOTHING,
	["Herbe de kresh"] = PinTypes.CLOTHING,
	["Jute"] = PinTypes.CLOTHING,
	["Lin"] = PinTypes.CLOTHING,
	["Soie ancestrale"] = PinTypes.CLOTHING,
	["Soie d'araignée"] = PinTypes.CLOTHING,
	["Torn Cloth"] = PinTypes.CLOTHING,
	
	--Matériaux du travail du bois
	["Acajou"] = PinTypes.WOODWORKING,
	["Bois de nuit"] = PinTypes.WOODWORKING,
	["Bouleau"] = PinTypes.WOODWORKING,
	["Chêne"] = PinTypes.WOODWORKING,
	["Érable"] = PinTypes.WOODWORKING,
	["Frêne roux"] = PinTypes.WOODWORKING,
	["Frêne"] = PinTypes.WOODWORKING,
	["Hêtre"] = PinTypes.WOODWORKING,
	["If"] = PinTypes.WOODWORKING,
	["Noyer"] = PinTypes.WOODWORKING,
	["Scrap Wood"] = PinTypes.WOODWORKING,

	--Matières premières de joaillerie
	["Veine d'argent"] = PinTypes.BLACKSMITH,
	["Veine d'électrum"] = PinTypes.BLACKSMITH,
	["Veine d'étain"] = PinTypes.BLACKSMITH,
	["Veine de cuivre"] = PinTypes.BLACKSMITH,
	["Veine de platine"] = PinTypes.BLACKSMITH,

	--Rune d'enchantement
	["Pierre runique"] = PinTypes.ENCHANTING,
	
	--Ingrédients d'alchimie
	--Réactifs
	["Absinthe"] = PinTypes.FLOWER,
	["Ancolie"] = PinTypes.FLOWER,
	["Belladone"] = PinTypes.FLOWER,
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
	["Sacoche d'Herboriste"] = PinTypes.FLOWER,
	["Truffe de Namira"] = PinTypes.MUSHROOM,
	--Solvants
	["Eau pure"] = PinTypes.WATER,
	["Outre d'eau"] = PinTypes.WATER,
	["Potable Liquids"] = PinTypes.WATER,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
