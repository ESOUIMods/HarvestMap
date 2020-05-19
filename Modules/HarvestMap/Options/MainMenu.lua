local LMM = LibMainMenu
if not LMM.AddCategory then
	-- an outdated version has overridden the new one
	LMM = LibStub("LibMainMenu")
end

local Menu = {}
Harvest:RegisterModule("menu", Menu)


function Menu:Initialize()
	-- Set Title
	ZO_CreateStringId("SI_HARVEST_MAIN_MENU_TITLE", Harvest.GetLocalization("menu"))
	
	-- button data for the main menu (top bar with inventory, map, journal etc)
	self.BASE_MENU_DATA =
	{
		binding = "HARVEST_SHOW_PANEL",
		categoryName = SI_HARVEST_MAIN_MENU_TITLE,
		descriptor = 18,--"HarvestSceneGroup",
		normal = "EsoUI/Art/Inventory/inventory_tabicon_quest_up.dds",
		pressed = "EsoUI/Art/Inventory/inventory_tabicon_quest_down.dds",
		highlight = "EsoUI/Art/Inventory/inventory_tabicon_quest_over.dds",
		callback = function()
			local viaButton = true
			self:Show(viaButton) -- the top bar button was pressed (i.e. not the keybind), show the scene
		end,
	}
	
	self.BASE_MENU = LMM:AddCategory(self.BASE_MENU_DATA)
	
	self.iconData = {}
	self.scenes = {}
end

-- called after all submenues have registered themselves
-- creates the final menu with all registered entries
function Menu:Finalize()
	-- Register Scenes and the group name
	self.sceneGroup = ZO_SceneGroup:New(unpack(self.scenes))
        SCENE_MANAGER:AddSceneGroup("HarvestSceneGroup", self.sceneGroup)
        -- Register the group and add the buttons
        LMM:AddSceneGroup(self.BASE_MENU, "HarvestSceneGroup", self.iconData)
	-- add a button to the main menu
	self.mainMenuButton = ZO_MenuBar_AddButton(MAIN_MENU_KEYBOARD.categoryBar, self.BASE_MENU_DATA)
end

---
-- registers the given button data to the menu
function Menu:Register(iconEntry)
	table.insert(self.iconData, iconEntry)
	table.insert(self.scenes, iconEntry.descriptor)
end

---
-- display the menu
function Menu:Show(viaButton)
	if not self.sceneGroup:IsShowing() then
		LMM:ToggleCategory(self.BASE_MENU, viaButton)
	end
end

---
-- toggles the menu
function Menu:Toggle(viaButton)
	LMM:ToggleCategory(self.BASE_MENU)
	if not viaButton then
		-- when opening the menu via the keybind, we have to reset the main menu buttons
		ZO_MenuBar_ClearSelection(MAIN_MENU_KEYBOARD.categoryBar)
	end
end