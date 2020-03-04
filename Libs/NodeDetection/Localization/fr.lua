
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {
	
	["Minerai de Fer"] = PinTypes.BLACKSMITH,
	["Minerai de Fer Noble"] = PinTypes.BLACKSMITH,
	["Minerai d'Orichalque"] = PinTypes.BLACKSMITH,
	["Minerai Dwemer"] = PinTypes.BLACKSMITH,
	["Minerai d'Ebonite"] = PinTypes.BLACKSMITH,
	["Minerai de Calcinium"] = PinTypes.BLACKSMITH,
	["Minerai de Galatite"] = PinTypes.BLACKSMITH,
	["Quicksilver Ore"] = PinTypes.BLACKSMITH,
	["Minerai de Pierre du Vide"] = PinTypes.BLACKSMITH,
	["Minerai de Cuprite"] = PinTypes.BLACKSMITH,
	
	["Coton"] = PinTypes.CLOTHING,
	["Fil d'Ebonite"] = PinTypes.CLOTHING,
	["Lin"] = PinTypes.CLOTHING,
	["Herbe de Fer"] = PinTypes.CLOTHING,
	["Jute"] = PinTypes.CLOTHING,
	["Kreshweed"] = PinTypes.CLOTHING,
	["Silverweed"] = PinTypes.CLOTHING,
	["Toile d'Araignée"] = PinTypes.CLOTHING,
	["Fleur du Vide"] = PinTypes.CLOTHING,
	["Silver Weed"] = PinTypes.CLOTHING,
	["Kresh Weed"] = PinTypes.CLOTHING,
	["Soie Ancestrale"] = PinTypes.CLOTHING,
	
	["Pierre runique"] = PinTypes.ENCHANTING,
	
	["Chardon Béni"] = PinTypes.FLOWER,
	["Entoloma Bleue"] = PinTypes.MUSHROOM,
	["Noctuelle"] = PinTypes.FLOWER,
	["Ancolie"] = PinTypes.FLOWER,
	["Bleuet"] = PinTypes.FLOWER,
	["Épine-de-Dragon"] = PinTypes.FLOWER,
	["Russule Emetique"] = PinTypes.MUSHROOM,
	["Pied-de-Lutin"] = PinTypes.MUSHROOM,
	["Cardamine des Prés"] = PinTypes.FLOWER,
	["Russule Phosphorescente"] = PinTypes.MUSHROOM,
	["Lys des Cimes"] = PinTypes.FLOWER,
	["Truffe de Namira"] = PinTypes.MUSHROOM,
	["Nirnrave"] = PinTypes.WATERPLANT,
	["Mutinus Elégans"] = PinTypes.MUSHROOM,
	["Coprin Violet"] = PinTypes.MUSHROOM,
	["Jacinthe d'Eau"] = PinTypes.WATERPLANT,
	["Chapeau Blanc"] = PinTypes.MUSHROOM,
	["Absinthe"] = PinTypes.FLOWER,
	["Belladone"] = PinTypes.FLOWER,
	["Mutinus elegans"] = PinTypes.MUSHROOM,
	
	["Frêne"] = PinTypes.WOODWORKING,
	["Hêtre"] = PinTypes.WOODWORKING,
	["Bouleau"] = PinTypes.WOODWORKING,
	["Hickory"] = PinTypes.WOODWORKING,
	["Acajou"] = PinTypes.WOODWORKING,
	["Érable"] = PinTypes.WOODWORKING,
	["Bois de Nuit"] = PinTypes.WOODWORKING,
	["Chêne"] = PinTypes.WOODWORKING,
	["If"] = PinTypes.WOODWORKING,
	["Frêne Roux"] = PinTypes.WOODWORKING,
	
	["Eau Pure"] = PinTypes.WATER,
	["Outre d'Eau"] = PinTypes.WATER,
	
	["Veine d'étain"] = PinTypes.BLACKSMITH, -- 89936, 543270 ca
	["Veine de platine"] = PinTypes.BLACKSMITH,
	["Veine de cuivre"] = PinTypes.BLACKSMITH,
	["Veine d'argent"] = PinTypes.BLACKSMITH,
	["Veine d'electrum"] = PinTypes.BLACKSMITH,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
