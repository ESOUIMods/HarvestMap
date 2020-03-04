
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {
	
	["Железная руда"] = PinTypes.BLACKSMITH,
	["Высокожелезистая руда"] = PinTypes.BLACKSMITH,
	["Orichalc Ore"] = PinTypes.BLACKSMITH,
	["Орихалковая руда"] = PinTypes.BLACKSMITH,
	["Двемерская руда"] = PinTypes.BLACKSMITH,
	["Эбонитовая руда"] = PinTypes.BLACKSMITH,
	["Кальциновая руда"] = PinTypes.BLACKSMITH,
	["Галатитовая руда"] = PinTypes.BLACKSMITH,
	["� тутная руда"] = PinTypes.BLACKSMITH,
	["Пустотная руда"] = PinTypes.BLACKSMITH,
	["� убедитовая руда"] = PinTypes.BLACKSMITH,
	
	["Хлопок"] = PinTypes.CLOTHING,
	["Эбеновое волокно"] = PinTypes.CLOTHING,
	["Лен"] = PinTypes.CLOTHING,
	["Железная трава"] = PinTypes.CLOTHING,
	["Джут"] = PinTypes.CLOTHING,
	["Трава креша"] = PinTypes.CLOTHING,
	["Серебряная трава"] = PinTypes.CLOTHING,
	["Паучий шелк"] = PinTypes.CLOTHING,
	["Пустоцвет"] = PinTypes.CLOTHING,
	["Silver Weed"] = PinTypes.CLOTHING,
	["Kresh Weed"] = PinTypes.CLOTHING,
	["Шелк предков"] = PinTypes.CLOTHING,
	
	["� унный камень"] = PinTypes.ENCHANTING,
	
	["Благословенный чертополох"] = PinTypes.FLOWER,
	["Энтолома"] = PinTypes.MUSHROOM,
	["Воловик"] = PinTypes.FLOWER,
	["Водосбор"] = PinTypes.FLOWER,
	["Василек"] = PinTypes.FLOWER,
	["Драконий шип"] = PinTypes.FLOWER,
	["Жгучеедкая сыроежка"] = PinTypes.MUSHROOM,
	["Бесовский гриб"] = PinTypes.MUSHROOM,
	["Луговой сердечник"] = PinTypes.FLOWER,
	["Светящаяся сыроежка"] = PinTypes.MUSHROOM,
	["Горноцвет"] = PinTypes.FLOWER,
	["Гниль Намиры"] = PinTypes.MUSHROOM,
	["Корень Нирна"] = PinTypes.WATERPLANT,
	["Цветохвостник веретеновидный"] = PinTypes.MUSHROOM,
	["Лиловый копринус"] = PinTypes.MUSHROOM,
	["Violet Copninus"] = PinTypes.MUSHROOM,
	["Водный гиацинт"] = PinTypes.WATERPLANT,
	["Белянка"] = PinTypes.MUSHROOM,
	["Полынь"] = PinTypes.FLOWER,
	["Паслен"] = PinTypes.FLOWER,
	
	["Ashtree"] = PinTypes.WOODWORKING,
	["Бук"] = PinTypes.WOODWORKING,
	["Береза"] = PinTypes.WOODWORKING,
	["Гикори"] = PinTypes.WOODWORKING,
	["Красное дерево"] = PinTypes.WOODWORKING,
	["Клен"] = PinTypes.WOODWORKING,
	["Ночное дерево"] = PinTypes.WOODWORKING,
	["Дуб"] = PinTypes.WOODWORKING,
	["Тис"] = PinTypes.WOODWORKING,
	["� убиновый ясень"] = PinTypes.WOODWORKING,
	
	["Чистая вода"] = PinTypes.WATER,
	["Мешок с водой"] = PinTypes.WATER,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
