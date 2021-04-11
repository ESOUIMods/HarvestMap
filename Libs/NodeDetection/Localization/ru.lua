-- Provided by mychaelo
local PinTypeLocalization = {}
LibNodeDetection:RegisterModule("pinTypeLocalization", PinTypeLocalization)

local PinTypes = LibNodeDetection.pinTypes

local interactableName2PinTypeId = {

	["Рунный камень"] = PinTypes.ENCHANTING,
	
	["Кникус"] = PinTypes.FLOWER,
	["Полынь"] = PinTypes.FLOWER,
	["Луговой сердечник"] = PinTypes.FLOWER,
	["Воловик"] = PinTypes.FLOWER,
	["Драконий шип"] = PinTypes.FLOWER,
	["Горноцвет"] = PinTypes.FLOWER,
	["Водосбор"] = PinTypes.FLOWER,
	["Василек"] = PinTypes.FLOWER,
	["Корень Нирна"] = PinTypes.WATERPLANT,
	["Водный гиацинт"] = PinTypes.WATERPLANT,
	["Цветохвостник"] = PinTypes.MUSHROOM,
	["Голубая энтолома"] = PinTypes.MUSHROOM,
	["Жгучеедкая сыроежка"] = PinTypes.MUSHROOM,
	["Лиловый копринус"] = PinTypes.MUSHROOM,
	["Гниль Намиры"] = PinTypes.MUSHROOM,
	["Белянка"] = PinTypes.MUSHROOM,
	["Светящаяся сыроежка"] = PinTypes.MUSHROOM,
	["Бесовский гриб"] = PinTypes.MUSHROOM,
	
	["Паслен"] = PinTypes.FLOWER,
	
	["Тис"] = PinTypes.WOODWORKING,
	["Эбеновое волокно"] = PinTypes.CLOTHING,
	["Эбонитовая руда"] = PinTypes.BLACKSMITH,
	
	["Клен"] = PinTypes.WOODWORKING,
	["Дуб"] = PinTypes.WOODWORKING,
	["Бук"] = PinTypes.WOODWORKING,
	["Орешник"] = PinTypes.WOODWORKING,
	["Железная руда"] = PinTypes.BLACKSMITH,
	["Высокожелезистая руда"] = PinTypes.BLACKSMITH,
	["Орихалковая руда"] = PinTypes.BLACKSMITH,
	["Двемерская руда"] = PinTypes.BLACKSMITH,
	["Джут"] = PinTypes.CLOTHING,
	["Лен"] = PinTypes.CLOTHING,
	["Паучий шелк"] = PinTypes.CLOTHING,
	["Хлопок"] = PinTypes.CLOTHING,
	
	["Чистая вода"] = PinTypes.WATER,
	
	["Пустоцвет"] = PinTypes.CLOTHING,
	["Креш-трава"] = PinTypes.CLOTHING,
	["Серебряная трава"] = PinTypes.CLOTHING,
	["Железная трава"] = PinTypes.CLOTHING,
	["Кальциновая руда"] = PinTypes.BLACKSMITH,
	["Галатитовая руда"] = PinTypes.BLACKSMITH,
	["Ртутная руда"] = PinTypes.BLACKSMITH,
	["Пустотная руда"] = PinTypes.BLACKSMITH,
	["Черное дерево"] = PinTypes.WOODWORKING,
	["Ясень"] = PinTypes.WOODWORKING,
	["Береза"] = PinTypes.WOODWORKING,
	["Красное дерево"] = PinTypes.WOODWORKING,
	
	["Мех для воды"] = PinTypes.WATER,
	
	["Багряный ясень"] = PinTypes.WOODWORKING,
	["Шелк предков"] = PinTypes.CLOTHING,
	["Рубедитовая руда"] = PinTypes.BLACKSMITH,
	
	["Сумка травника"] = PinTypes.FLOWER,
	["Обрывок ткани"] = PinTypes.CLOTHING,
	["Деревянные обломки"] = PinTypes.WOODWORKING,
	["Питьевая жидкость"] = PinTypes.WATER,
	
	["Оловянный пласт"] = PinTypes.BLACKSMITH,
	["Платиновый пласт"] = PinTypes.BLACKSMITH,
	["Медный пласт"] = PinTypes.BLACKSMITH,
	["Серебряный пласт"] = PinTypes.BLACKSMITH,
	["Электрумный пласт"] = PinTypes.BLACKSMITH,
	
	["Алый корень Нирна"] = PinTypes.CRIMSON,
}

function PinTypeLocalization:Initialize()
	PinTypes.interactableName2PinTypeId = PinTypes.interactableName2PinTypeId or {}
	for name, pinTypeId in pairs(interactableName2PinTypeId) do
		PinTypes.interactableName2PinTypeId[zo_strlower(name)] = pinTypeId
	end
end
