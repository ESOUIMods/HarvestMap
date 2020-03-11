
--[[
Author: Ayantir, Baertram
Filename: LibMainMenu.lua
Version: 9
]]--

--[[

This software is under : CreativeCommons CC BT-NC-SA
Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material
    The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
    NonCommercial — You may not use the material for commercial purposes.
    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

Please read full licence at : 
http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode

]]--
--Register LAM with LibStub
local MAJOR, MINOR = "LibMainMenu", 9
local libMainMenu, oldminor
if LibStub then
    libMainMenu, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
else
    --Check if LibMainMenu was already loaded before properly
    if LibMainMenu ~= nil and LibMainMenu.AddCategory ~= nil and LibMainMenu.wasLoadedProperly == true and LIBMAINMENU ~= nil then
        --Library was loaded properly already
        return
    else
        --Create new library instance via the global variable
        libMainMenu = {}
        libMainMenu.wasLoadedProperly = false
    end
end
if not libMainMenu then return end

LIBMAINMENU_LAYOUT_INFO = {}
local Initialized = false
libMainMenu.wasInitializedProperly = false

local function InitializeLMM()
	local LMMXML = CreateTopLevelWindow("LMMXML")
	LMMXML:SetAnchor(CENTER, GuiRoot, nil, 0, 28)
	local categoryBar = CreateControlFromVirtual("$(parent)CategoryBar", LMMXML, "ZO_MenuBarTemplate")
	categoryBar:SetAnchor(TOP)
	local sceneGroupBar = CreateControlFromVirtual("$(parent)SceneGroupBar", LMMXML, "ZO_LabelButtonBar")
	sceneGroupBar:SetAnchor(RIGHT, GuiRoot, nil, -40, -340)

	local libMainMenuSubcategoryBar = CreateControl("libMainMenuSubcategoryBar", GuiRoot, CT_CONTROL)
	local libMainMenuSubcategoryButton = CreateControl("libMainMenuSubcategoryButton", GuiRoot, CT_LABEL)
	libMainMenuSubcategoryButton:SetColor(ZO_CONTRAST_TEXT:UnpackRGBA())
	libMainMenuSubcategoryButton:SetFont("ZoFontHeader3")
	libMainMenuSubcategoryButton:SetHandler("OnMouseEnter", function(self) self:SetColor(ZO_HIGHLIGHT_TEXT:UnpackRGBA()) end)
	libMainMenuSubcategoryButton:SetHandler("OnMouseExit", function(self) self:SetColor(ZO_CONTRAST_TEXT:UnpackRGBA()) end)
	libMainMenuSubcategoryButton:SetMouseEnabled(true)

	local libMainMenuCategoryBarButton = CreateControlFromVirtual("libMainMenuCategoryBarButton", GuiRoot, "ZO_MenuBarButtonTemplate1")
	libMainMenuCategoryBarButton:SetHandler("OnMouseEnter", function(self) libMainMenuCategoryBarButton_OnMouseEnter(self) end)
	libMainMenuCategoryBarButton:SetHandler("OnMouseExit", function(self) libMainMenuCategoryBarButton_OnMouseExit(self) end)

	local indicator = CreateControlFromVirtual("$(parent)Indicator", libMainMenuCategoryBarButton, "ZO_MultiIcon")
	indicator:SetHidden(true)
	indicator:SetAnchor(CENTER, libMainMenuCategoryBarButton, nil, 0, 24)
	
	LIBMAINMENU = libMainMenu:New(LMMXML)
	
	Initialized = true
end

local function checkIfInitialized(doAbortIfNotInitialized)
    doAbortIfNotInitialized = doAbortIfNotInitialized or false
    if libMainMenu and (not LIBMAINMENU or Initialized == false) then
        if doAbortIfNotInitialized then
            d("[" .. tostring(MAJOR) .. "] Library was not initialized properly (did you forgot to call function \'AddCategory\'?).\nPlease read the library's description on www.esoui.com!")
            return
        end
        InitializeLMM()
    end
end

function libMainMenu:New(control)
    local manager = ZO_Object.New(self)
    manager:Initialize(control)
    return manager
end

function libMainMenu:Initialize(control)

    self.control = control
	
    self.categoryBar = GetControl(self.control, "CategoryBar")
    --ZO_MenuBar_ClearClickSound(self.categoryBar)
    self.categoryBarFragment = ZO_FadeSceneFragment:New(self.categoryBar)

    self.sceneGroupBar = GetControl(self.control, "SceneGroupBar")
    self.sceneGroupBarLabel = GetControl(self.control, "SceneGroupBarLabel")

    self.tabPressedCallback =   function(control)
                                    if control.sceneGroupName then
                                        self:OnSceneGroupTabClicked(control.sceneGroupName)
                                    end
                                end

    self.sceneShowCallback =   function(oldState, newState)
                                    if(newState == SCENE_SHOWING) then
                                        local sceneGroupInfo = self.sceneGroupInfo[self.sceneShowGroupName] 
                                        self:SetupSceneGroupBar(sceneGroupInfo.category, self.sceneShowGroupName)
                                        local scene = SCENE_MANAGER:GetCurrentScene()
                                        scene:UnregisterCallback("StateChange", self.sceneShowCallback)
                                    end
                                end

    self.lastCategory = MENU_CATEGORY_INVENTORY
	
    self.categoryInfo = {}
    self.sceneInfo = {}
    self.sceneGroupInfo = {}
    self.categoryAreaFragments = {}
	
end

function libMainMenu:SetupSceneGroupBar(category, sceneGroupName)
    checkIfInitialized(true)

    if self.sceneGroupInfo[sceneGroupName] then
        -- This is a scene group
        ZO_MenuBar_ClearButtons(self.sceneGroupBar)

        local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneGroupName)
        local menuBarIconData = self.sceneGroupInfo[sceneGroupName].menuBarIconData
        for i, layoutData in ipairs(menuBarIconData) do
            local sceneName = layoutData.descriptor
            layoutData.callback = function()
                if not self.ignoreCallbacks then
                    sceneGroup:SetActiveScene(sceneName)
                    self:Update(category, sceneName)
                end 
            end
            ZO_MenuBar_AddButton(self.sceneGroupBar, layoutData)
            ZO_MenuBar_SetDescriptorEnabled(self.sceneGroupBar, layoutData.descriptor, (layoutData.enabled == nil or layoutData.enabled == true))
        end

        local activeSceneName = sceneGroup:GetActiveScene()
        local layoutData
        for i = 1, #menuBarIconData do
            if(menuBarIconData[i].descriptor == activeSceneName) then
                layoutData = menuBarIconData[i]
                break
            end
        end

        self.ignoreCallbacks = true

        if(layoutData) then
            if not ZO_MenuBar_SelectDescriptor(self.sceneGroupBar, activeSceneName) then
                self.ignoreCallbacks = false
                ZO_MenuBar_SelectFirstVisibleButton(self.sceneGroupBar, true)
            end

            self.sceneGroupBarLabel:SetHidden(false)
            self.sceneGroupBarLabel:SetText(GetString(layoutData.categoryName))
        end

        self.ignoreCallbacks = false
    end
end

function libMainMenu:AddCategory(data)
    --Create the instance of the LibMainMenu object and assign it to global variable LIBMAINMENU within function InitializeLMM()
    checkIfInitialized(false)

	table.insert(LIBMAINMENU_LAYOUT_INFO, data)
	LIBMAINMENU_LAYOUT_INFO[#LIBMAINMENU_LAYOUT_INFO].descriptor = #LIBMAINMENU_LAYOUT_INFO
	
	--[[
	local categoryBarData =
    {
        buttonPadding = 16,
        normalSize = 51,
        downSize = 64,
        animationDuration = DEFAULT_SCENE_TRANSITION_TIME,
        buttonTemplate = "LibMainmenuCategoryBarButton",
    }
	]]--
	
    --ZO_MenuBar_SetData(self.categoryBar, categoryBarData)
	
	--local categoryLayoutInfo = LIBMAINMENU_LAYOUT_INFO[i]
	--categoryLayoutInfo.callback = function() self:OnCategoryClicked(i) end
	--ZO_MenuBar_AddButton(self.categoryBar, categoryLayoutInfo)

	local subcategoryBar = CreateControl("libMainMenuSubcategoryBar" .. #LIBMAINMENU_LAYOUT_INFO, self.control, CT_CONTROL)
	--subcategoryBar:SetAnchor(TOP, LIBMAINMENU.categoryBar, BOTTOM, 0, 7)
	local subcategoryBarFragment = ZO_FadeSceneFragment:New(subcategoryBar)
	LIBMAINMENU.categoryInfo[#LIBMAINMENU_LAYOUT_INFO] =
	{
		barControls = {},
		subcategoryBar = subcategoryBar,
		subcategoryBarFragment = subcategoryBarFragment,
	}

    self:RefreshCategoryIndicators()
    self:AddCategoryAreaFragment(LIBMAINMENU.categoryBarFragment)
	
	return #LIBMAINMENU_LAYOUT_INFO
	
end

function libMainMenu:RefreshCategoryIndicators()
    checkIfInitialized(true)

    for i, categoryLayoutData in ipairs(LIBMAINMENU_LAYOUT_INFO) do
        local indicators = categoryLayoutData.indicators
        if indicators then
            local buttonControl = ZO_MenuBar_GetButtonControl(self.categoryBar, categoryLayoutData.descriptor)
            if buttonControl then
                local indicatorTexture = buttonControl:GetNamedChild("Indicator")
                local textures
                if type(indicators) == "table" then
                    textures = indicators
                elseif type(indicators) == "function" then
                    textures = indicators()
                end
                if textures and #textures > 0 then
                    indicatorTexture:ClearIcons()
                    for _, texture in ipairs(textures) do
                        indicatorTexture:AddIcon(texture)
                    end
                    indicatorTexture:Show()
                else
                    indicatorTexture:Hide()
                end
            end
        end
    end
end

function libMainMenu:AddCategoryAreaFragment(fragment)
    checkIfInitialized(true)

    LIBMAINMENU.categoryAreaFragments[#LIBMAINMENU.categoryAreaFragments + 1] = fragment
end

function libMainMenu:OnCategoryClicked(category)
    checkIfInitialized(true)

    if(not self.ignoreCallbacks) then
        self:ShowCategory(category)
    end
end

function libMainMenu:ShowCategory(category)
    checkIfInitialized(true)

    local categoryLayoutInfo = LIBMAINMENU_LAYOUT_INFO[category]
	local categoryInfo = self.categoryInfo[category]
	if(categoryInfo.lastSceneName) then
		self:ShowScene(categoryInfo.lastSceneName)
	else
		self:ShowSceneGroup(categoryInfo.lastSceneGroupName)
	end
end

function libMainMenu:ShowScene(sceneName)
    checkIfInitialized(true)

    local sceneInfo = self.sceneInfo[sceneName]
    if sceneInfo.sceneGroupName then
        self:ShowSceneGroup(sceneInfo.sceneGroupName, sceneName)
    else
        self:Update(sceneInfo.category, sceneName)
    end
end

function libMainMenu:ShowSceneGroup(sceneGroupName, specificScene)
    checkIfInitialized(true)

    local sceneGroupInfo = self.sceneGroupInfo[sceneGroupName]
    if(not specificScene) then
        local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneGroupName)
        specificScene = sceneGroup:GetActiveScene()
    end

    self:Update(sceneGroupInfo.category, specificScene)
end

function libMainMenu:Update(category, sceneName)
    checkIfInitialized(true)

    self.ignoreCallbacks = true

    local categoryInfo = LIBMAINMENU.categoryInfo[category]
    
    -- This is a scene
    local sceneInfo = LIBMAINMENU.sceneInfo[sceneName]
    local skipAnimation = not self:IsShowing()
    ZO_MenuBar_SelectDescriptor(LIBMAINMENU.categoryBar, category, skipAnimation)
    LIBMAINMENU.lastCategory = category

    self:SetLastSceneName(categoryInfo, sceneName)
    
    if sceneInfo.sceneGroupName then
        -- This scene is part of a scene group, need to update the selected
        local scene = SCENE_MANAGER:GetScene(sceneName)
        LIBMAINMENU.sceneShowGroupName = sceneInfo.sceneGroupName
        scene:RegisterCallback("StateChange", LIBMAINMENU.sceneShowCallback)
        local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneInfo.sceneGroupName)
        sceneGroup:SetActiveScene(sceneName)
        self:SetLastSceneGroupName(categoryInfo, sceneInfo.sceneGroupName)
    end

    SCENE_MANAGER:Show(sceneName)
	
    self.ignoreCallbacks = false
end

function libMainMenu:SetLastSceneName(categoryInfo, sceneName)
    checkIfInitialized(true)

    categoryInfo.lastSceneName = sceneName
    categoryInfo.lastSceneGroupName = nil
end

function libMainMenu:SetLastSceneGroupName(categoryInfo, sceneGroupName)
    checkIfInitialized(true)

    categoryInfo.lastSceneGroupName = sceneGroupName
    categoryInfo.lastSceneName = nil
end

function libMainMenu:IsShowing()
    checkIfInitialized(true)

    return LIBMAINMENU.categoryBarFragment:IsShowing()
end

function libMainMenu:AddSceneGroup(category, sceneGroupName, menuBarIconData)
    checkIfInitialized(true)

	local categoryInfo = LIBMAINMENU.categoryInfo[category]
	local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneGroupName)
	
	for i=1, sceneGroup:GetNumScenes() do
		local sceneName = sceneGroup:GetSceneName(i)
		local scene = libMainMenu:AddRawScene(sceneName, category, categoryInfo, sceneGroupName)
	end

	if(not self:HasLast(categoryInfo)) then
		self:SetLastSceneGroupName(categoryInfo, sceneGroupName)
	end

	local sceneGroupBarFragment = ZO_FadeSceneFragment:New(LIBMAINMENU.sceneGroupBar)
	for i=1, #menuBarIconData do
		local sceneName = menuBarIconData[i].descriptor
		local scene = SCENE_MANAGER:GetScene(sceneName)
		scene:AddFragment(sceneGroupBarFragment)
	end
	
	LIBMAINMENU.sceneGroupInfo[sceneGroupName] =
	{
		menuBarIconData = menuBarIconData,
		category = category,
		sceneGroupBarFragment = sceneGroupBarFragment,
	}
	
end

function libMainMenu:HasLast(categoryInfo)
    checkIfInitialized(true)

    return categoryInfo.lastSceneName ~= nil or categoryInfo.lastSceneGroupName ~= nil
end

function libMainMenu:AddRawScene(sceneName, category, categoryInfo, sceneGroupName)
    checkIfInitialized(true)

    local scene = SCENE_MANAGER:GetScene(sceneName)
    --scene:AddFragment(categoryInfo.subcategoryBarFragment)

    local hideCategoryBar = LIBMAINMENU.categoryInfo[category].hideCategoryBar
    if hideCategoryBar == nil or hideCategoryBar == false then
        for i, categoryAreaFragment in ipairs(LIBMAINMENU.categoryAreaFragments) do
            scene:AddFragment(categoryAreaFragment)
        end
    end

    local sceneInfo =
    {
        category = category,
        sceneName = sceneName,
        sceneGroupName = sceneGroupName,
    }
	
    LIBMAINMENU.sceneInfo[sceneName] = sceneInfo

    return scene
end

function libMainMenu:ToggleCategory(category)
    checkIfInitialized(true)

	local categoryLayoutInfo = LIBMAINMENU_LAYOUT_INFO[category]
	local categoryInfo = LIBMAINMENU.categoryInfo[category]
	if(categoryInfo.lastSceneName) then
		self:ToggleScene(categoryInfo.lastSceneName)
	else
		self:ToggleSceneGroup(categoryInfo.lastSceneGroupName)
	end
end

function libMainMenu:ToggleSceneGroup(sceneGroupName, specificScene)
    checkIfInitialized(true)

    local sceneGroupInfo = LIBMAINMENU.sceneGroupInfo[sceneGroupName]
    if(not specificScene) then
        local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneGroupName)
        specificScene = sceneGroup:GetActiveScene()
    end

    if self:IsShowing() and LIBMAINMENU.lastCategory == sceneGroupInfo.category then
        SCENE_MANAGER:ShowBaseScene()
    else
        self:Update(sceneGroupInfo.category, specificScene)
    end
end

function libMainMenu:ShowSceneGroup(sceneGroupName, specificScene)
    checkIfInitialized(true)

    local sceneGroupInfo = LIBMAINMENU.sceneGroupInfo[sceneGroupName]
    if(not specificScene) then
        local sceneGroup = SCENE_MANAGER:GetSceneGroup(sceneGroupName)
        specificScene = sceneGroup:GetActiveScene()
    end

    self:Update(sceneGroupInfo.category, specificScene)
end

function libMainMenu:ShowScene(sceneName)
    checkIfInitialized(true)

    local sceneInfo = LIBMAINMENU.sceneInfo[sceneName]
    if sceneInfo.sceneGroupName then
        self:ShowSceneGroup(sceneInfo.sceneGroupName, sceneName)
    else
        self:Update(sceneInfo.category, sceneName)
    end
end

function libMainMenu:ToggleScene(sceneName)
    checkIfInitialized(true)

    local sceneInfo = LIBMAINMENU.sceneInfo[sceneName]
    if(SCENE_MANAGER:IsShowing(sceneName)) then
        SCENE_MANAGER:ShowBaseScene()
    else
        self:ShowScene(sceneName)
    end
end

-- XML

function LibMainMenuCategoryBarButton_OnMouseEnter(self)
	--[[
    ZO_MenuBarButtonTemplate_OnMouseEnter(self)
    InitializeTooltip(InformationTooltip, self:GetParent(), LEFT, 15, 2)

    local buttonData = ZO_MenuBarButtonTemplate_GetData(self)
    local bindingString = ZO_Keybindings_GetHighestPriorityBindingStringFromAction(buttonData.binding)
    local button = self.m_object.m_menuBar:ButtonObjectForDescriptor(buttonData.descriptor)
    
    local tooltipText = GetString(SI_MAIN_MENU_TOOLTIP_DISABLED_BUTTON)
    if (button.m_state ~= BSTATE_DISABLED) then
        tooltipText = zo_strformat(SI_MAIN_MENU_KEYBIND, GetString(buttonData.categoryName), bindingString or GetString(SI_ACTION_IS_NOT_BOUND))
    end
    
    SetTooltipText(InformationTooltip, tooltipText)
	]]--
end

function LibMainMenuCategoryBarButton_OnMouseExit(self)
    --[[
	ZO_MenuBarButtonTemplate_OnMouseExit(self)
    ClearTooltip(InformationTooltip)
	]]--
end

--Finished loading of the library properly
-->Attention: The global variable LIBMAINMENU wil be first created as you use the function LibMainMenu:AddCategory (upon initialization)!
libMainMenu.wasLoadedProperly = true
LibMainMenu = libMainMenu
