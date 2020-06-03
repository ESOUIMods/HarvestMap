
local PinTypes = {}
LibNodeDetection:RegisterModule("pinTypes", PinTypes)

-- constants/enums for the pin types
PinTypes.BLACKSMITH = 1
PinTypes.CLOTHING = 2
PinTypes.WOODWORKING = 3
PinTypes.ENCHANTING = 4
PinTypes.MUSHROOM = 5
PinTypes.FLOWER = 6
PinTypes.WATERPLANT = 7
PinTypes.WATER = 8
PinTypes.CRIMSON = 9

PinTypes.UNKNOWN = 100

PinTypes.ALL_PINTYPES = {
	PinTypes.UNKNOWN,
	PinTypes.BLACKSMITH, PinTypes.CLOTHING,
	PinTypes.WOODWORKING, PinTypes.ENCHANTING,
	PinTypes.MUSHROOM, PinTypes.FLOWER,
	PinTypes.WATERPLANT, PinTypes.CRIMSON,
	PinTypes.WATER,
}

-- returns the pin type based on the interactable name
-- for example "Ancestor Silk" will return CLOTHING
function PinTypes:GetPinTypeIdFromInteractableName( interactableName )
	-- this table is defined in the localization file
	return self.interactableName2PinTypeId[zo_strlower( interactableName )]
end
