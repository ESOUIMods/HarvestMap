local MAJOR, MINOR = "LibAddonMenu-1.0", 6
local lam, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lam then return end	--the same or newer version of this lib is already loaded into memory 

--UPVALUES--
lam.lastAddedControl = {}
local lastAddedControl = lam.lastAddedControl
local wm = GetWindowManager()
local strformat = string.format
local tostring = tostring
local round = zo_round
local optionsWindow = ZO_OptionsWindowSettingsScrollChild

--maybe return the controls from the creation functions?

function lam:CreateControlPanel(controlPanelID, controlPanelName)
	local panelID
	
	if _G[controlPanelID] then
		panelID = _G[controlPanelID]
		return panelID
	end
	
	ZO_OptionsWindow_AddUserPanel(controlPanelID, controlPanelName)

	--disables Defaults button because we don't need it, but keybind still works :/ ...
	panelID = _G[controlPanelID]
	ZO_PreHook("ZO_OptionsWindow_ChangePanels", function(panel)
			local enable = (panel ~=  panelID)
			ZO_OptionsWindowResetToDefaultButton:SetEnabled(enable)
			ZO_OptionsWindowResetToDefaultButton:SetKeybindEnabled(enable)
		end)
	
	return panelID
end

function lam:AddHeader(panelID, controlName, text)
	local header = wm:CreateControlFromVirtual(controlName, optionsWindow, lastAddedControl[panelID] and "ZO_Options_SectionTitle_WithDivider" or "ZO_Options_SectionTitle")
	if lastAddedControl[panelID] then
		header:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 15)
	else
		header:SetAnchor(TOPLEFT)
	end
	header.controlType = OPTIONS_SECTION_TITLE
	header.panel = panelID
	header.text = text
	
	ZO_OptionsWindow_InitializeControl(header)
	
	lastAddedControl[panelID] = header
	
	return header
end


--To-Do list:
--extra sub-options window out to the right?? (or maybe addon list?)
--find alternatives to handler hooks

function lam:AddSlider(panelID, controlName, text, tooltip, minValue, maxValue, step, getFunc, setFunc, warning, warningText)
	local slider = wm:CreateControlFromVirtual(controlName, optionsWindow, "ZO_Options_Slider")
	slider:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 6)
	slider.controlType = OPTIONS_SLIDER
	slider.system = SETTING_TYPE_UI
	slider.panel = panelID
	slider.text = text
	slider.tooltipText = tooltip
	slider.showValue = true
	slider.showValueMin = minValue
	slider.showValueMax = maxValue
	local range = maxValue - minValue
	local slidercontrol = slider:GetNamedChild("Slider")
	local slidervalue = slider:GetNamedChild("ValueLabel")
	slidercontrol:SetValueStep(1/range * step)
	slider:SetHandler("OnShow", function()
			local curValue = getFunc()
			slidercontrol:SetValue((curValue - minValue)/range)
			slidervalue:SetText(tostring(curValue))
		end)
	slidercontrol:SetHandler("OnValueChanged", function (self, value)
			self:SetValue(value)
			value = round(value*range + minValue)
			slidervalue:SetText(strformat("%d", value))
		end)
	slidercontrol:SetHandler("OnSliderReleased", function(self, value)
			value = round(value*range + minValue)
			setFunc(value)
		end)
	
	if warning then
		slider.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", slider, "ZO_Options_WarningIcon")
		slider.warning:SetAnchor(RIGHT, slidercontrol, LEFT, -5, 0)
		slider.warning.tooltipText = warningText
	end
	
	ZO_OptionsWindow_InitializeControl(slider)
	
	lastAddedControl[panelID] = slider
	
	return slider
end

function lam:AddDropdown(panelID, controlName, text, tooltip, validChoices, getFunc, setFunc, warning, warningText)
	local dropdown = wm:CreateControlFromVirtual(controlName, optionsWindow, "ZO_Options_Dropdown")
	dropdown:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 6)
	dropdown.controlType = OPTIONS_DROPDOWN
	dropdown.system = SETTING_TYPE_UI
	dropdown.panel = panelID
	dropdown.text = text
	dropdown.tooltipText = tooltip
	dropdown.valid = validChoices
	local dropmenu = ZO_ComboBox_ObjectFromContainer(GetControl(dropdown, "Dropdown"))
	local setText = dropmenu.m_selectedItemText.SetText
	local selectedName
	ZO_PreHookHandler(dropmenu.m_selectedItemText, "OnTextChanged", function(self)
			if dropmenu.m_selectedItemData then
				selectedName = dropmenu.m_selectedItemData.name
				setText(self, selectedName)
				setFunc(selectedName)
			end
		end)
	dropdown:SetHandler("OnShow", function()
			dropmenu:SetSelectedItem(getFunc())
		end)
	
	if warning then
		dropdown.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", dropdown, "ZO_Options_WarningIcon")
		dropdown.warning:SetAnchor(RIGHT, dropdown:GetNamedChild("Dropdown"), LEFT, -5, 0)
		dropdown.warning.tooltipText = warningText
	end
	
	ZO_OptionsWindow_InitializeControl(dropdown)
	
	lastAddedControl[panelID] = dropdown

	return dropdown
end

function lam:AddCheckbox(panelID, controlName, text, tooltip, getFunc, setFunc, warning, warningText)
	local checkbox = wm:CreateControlFromVirtual(controlName, optionsWindow, "ZO_Options_Checkbox")
	checkbox:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 6)
	checkbox.controlType = OPTIONS_CHECKBOX
	checkbox.system = SETTING_TYPE_UI
	checkbox.settingId = _G[strformat("SETTING_%s", controlName)]
	checkbox.panel = panelID
	checkbox.text = text
	checkbox.tooltipText = tooltip
	
	local checkboxButton = checkbox:GetNamedChild("Checkbox")
	
	ZO_PreHookHandler(checkbox, "OnShow", function()
			checkboxButton:SetState(getFunc() and 1 or 0)
			checkboxButton:toggleFunction(getFunc())
		end)
	ZO_PreHookHandler(checkboxButton, "OnClicked", function() setFunc(not getFunc()) end)
	
	if warning then
		checkbox.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", checkbox, "ZO_Options_WarningIcon")
		checkbox.warning:SetAnchor(RIGHT, checkboxButton, LEFT, -5, 0)
		checkbox.warning.tooltipText = warningText
	end
	
	ZO_OptionsWindow_InitializeControl(checkbox)
	
	lastAddedControl[panelID] = checkbox
	
	return checkbox
end

function lam:AddColorPicker(panelID, controlName, text, tooltip, getFunc, setFunc, warning, warningText)
	local colorpicker = wm:CreateTopLevelWindow(controlName)
	colorpicker:SetParent(optionsWindow)
	colorpicker:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 10)
	colorpicker:SetResizeToFitDescendents(true)
	colorpicker:SetWidth(510)
	colorpicker:SetMouseEnabled(true)
	
	colorpicker.label = wm:CreateControl(controlName.."Label", colorpicker, CT_LABEL)
	local label = colorpicker.label
	label:SetDimensions(300, 26)
	label:SetAnchor(TOPLEFT)
	label:SetFont("ZoFontWinH4")
	label:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
	label:SetText(text)
	
	colorpicker.color = wm:CreateControl(controlName.."Color", colorpicker, CT_CONTROL)
	local color = colorpicker.color
	color:SetDimensions(200,26)
	color:SetAnchor(RIGHT)
	
	color.thumb = wm:CreateControl(controlName.."ColorThumb", color, CT_TEXTURE)
	local thumb = color.thumb
	thumb:SetDimensions(36, 18)
	thumb:SetAnchor(LEFT, color, LEFT, 4, 0)
	local r, g, b, a = getFunc()
	thumb:SetColor(r, g, b, a or 1)
	
	color.border = wm:CreateControl(controlName.."ColorBorder", color, CT_TEXTURE)
	local border = color.border
	border:SetTexture("EsoUI\\Art\\ChatWindow\\chatOptions_bgColSwatch_frame.dds")
	border:SetTextureCoords(0, .625, 0, .8125)
	border:SetDimensions(40, 22)
	border:SetAnchor(CENTER, thumb, CENTER, 0, 0)
	
	local ColorPickerCallback
	if not ColorPickerCallback then
		ColorPickerCallback = function(r, g, b, a)
			thumb:SetColor(r, g, b, a or 1)
			setFunc(r, g, b, a)
		end
	end
	
	colorpicker.controlType = OPTIONS_CUSTOM
	colorpicker.customSetupFunction = function(colorpicker)
			colorpicker:SetHandler("OnMouseUp", function(self, btn, upInside)
					if upInside then
						local r, g, b, a = getFunc()
						COLOR_PICKER:Show(ColorPickerCallback, r, g, b, a, text)
					end
				end)
		end
	colorpicker.panel = panelID
	colorpicker.tooltipText = tooltip
	colorpicker:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	colorpicker:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	if warning then
		colorpicker.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", colorpicker, "ZO_Options_WarningIcon")
		colorpicker.warning:SetAnchor(RIGHT, colorpicker:GetNamedChild("Color"), LEFT, -5, 0)
		colorpicker.warning.tooltipText = warningText
	end
	
	ZO_OptionsWindow_InitializeControl(colorpicker)
	
	lastAddedControl[panelID] = colorpicker
	
	return colorpicker
end

function lam:AddEditBox(panelID, controlName, text, tooltip, isMultiLine, getFunc, setFunc, warning, warningText)
	local editbox = wm:CreateTopLevelWindow(controlName)
	editbox:SetParent(optionsWindow)
	editbox:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 10)
	editbox:SetResizeToFitDescendents(true)
	editbox:SetWidth(510)
	editbox:SetMouseEnabled(true)
	
	editbox.label = wm:CreateControl(controlName.."Label", editbox, CT_LABEL)
	local label = editbox.label
	label:SetDimensions(300, 26)
	label:SetAnchor(TOPLEFT)
	label:SetFont("ZoFontWinH4")
	label:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
	label:SetText(text)
	
	editbox.bg = wm:CreateControlFromVirtual(controlName.."BG", editbox, "ZO_EditBackdrop")
	local bg = editbox.bg
	bg:SetDimensions(200,isMultiLine and 100 or 24)
	bg:SetAnchor(RIGHT)
	editbox.edit = wm:CreateControlFromVirtual(controlName.."Edit", bg, isMultiLine and "ZO_DefaultEditMultiLineForBackdrop" or "ZO_DefaultEditForBackdrop")
	editbox.edit:SetText(getFunc())
	editbox.edit:SetHandler("OnFocusLost", function(self) setFunc(self:GetText()) end)
	
	
	editbox.panel = panelID
	editbox.tooltipText = tooltip
	editbox:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	editbox:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	if warning then
		editbox.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", editbox, "ZO_Options_WarningIcon")
		editbox.warning:SetAnchor(TOPRIGHT, editbox:GetNamedChild("BG"), TOPLEFT, -5, 0)
		editbox.warning.tooltipText = warningText
	end

	ZO_OptionsWindow_InitializeControl(editbox)
	
	lastAddedControl[panelID] = editbox
	
	return editbox
end

function lam:AddButton(panelID, controlName, text, tooltip, onClick, warning, warningText)
	local button = wm:CreateTopLevelWindow(controlName)
	button:SetParent(optionsWindow)
	button:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 6)
	button:SetDimensions(510, 28)
	button:SetMouseEnabled(true)
	
	button.btn = wm:CreateControlFromVirtual(controlName.."Button", button, "ZO_DefaultButton")
	local btn = button.btn
	btn:SetAnchor(TOPRIGHT)
	btn:SetWidth(200)
	btn:SetText(text)
	btn:SetHandler("OnClicked", onClick)
	
	button.controlType = OPTIONS_CUSTOM
	button.customSetupFunction = function() end	--move handlers into this function? (since I created a function...)
	button.panel = panelID
	btn.tooltipText = tooltip
	btn:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	btn:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	if warning then
		button.warning = wm:CreateControlFromVirtual(controlName.."WarningIcon", button, "ZO_Options_WarningIcon")
		button.warning:SetAnchor(RIGHT, btn, LEFT, -5, 0)
		button.warning.tooltipText = warningText
	end
	
	ZO_OptionsWindow_InitializeControl(button)

	lastAddedControl[panelID] = button
	
	return button
end

function lam:AddDescription(panelID, controlName, text, titleText)
	local textBox = wm:CreateTopLevelWindow(controlName)
	textBox:SetParent(optionsWindow)
	textBox:SetAnchor(TOPLEFT, lastAddedControl[panelID], BOTTOMLEFT, 0, 10)
	textBox:SetResizeToFitDescendents(true)
	textBox:SetWidth(510)
	
	if titleText then
		textBox.title = wm:CreateControl(controlName.."Title", textBox, CT_LABEL)
		local title = textBox.title
		title:SetWidth(510)
		title:SetAnchor(TOPLEFT, textBox, TOPLEFT)
		title:SetFont("ZoFontWinH4")
		title:SetText(titleText)
	end
	
	textBox.desc = wm:CreateControl(controlName.."Text", textBox, CT_LABEL)
	local desc = textBox.desc
	desc:SetWidth(510)
	if titleText then
		desc:SetAnchor(TOPLEFT, textBox.title, BOTTOMLEFT)
	else
		desc:SetAnchor(TOPLEFT)
	end
	desc:SetVerticalAlignment(TEXT_ALIGN_TOP)
	desc:SetFont("ZoFontGame")
	desc:SetText(text)
	
	textBox.controlType = OPTIONS_CUSTOM
	textBox.panel = panelID
	
	ZO_OptionsWindow_InitializeControl(textBox)

	lastAddedControl[panelID] = textBox
	
	return textBox
end


--test controls & examples--
--[[local controlPanelID = lam:CreateControlPanel("ZAM_ADDON_OPTIONS", "ZAM Addons")
lam:AddHeader(controlPanelID, "ZAM_Addons_TESTADDON", "TEST ADDON")
lam:AddDescription(controlPanelID, "ZAM_Addons_TESTDESC", "This is a test description.", "Header")
lam:AddSlider(controlPanelID, "ZAM_TESTSLIDER", "Test slider", "Adjust the slider.", 1, 10, 1, function() return 7 end, function(value) end, true, "needs UI reload")
lam:AddDropdown(controlPanelID, "ZAM_TESTDROPDOWN", "Test Dropdown", "Pick something!", {"thing 1", "thing 2", "thing 3"}, function() return "thing 2" end, function(self,valueString) print(valueString) end)
local checkbox1 = true
lam:AddCheckbox(controlPanelID, "ZAM_TESTCHECKBOX", "Test Checkbox", "On or off?", function() return checkbox1 end, function(value) checkbox1 = not checkbox1 print(value, checkbox1) end)
lam:AddColorPicker(controlPanelID, "ZAM_TESTCOLORPICKER", "Test color picker", "What's your favorite color?", function() return 1, 1, 0 end, function(r,g,b) print(r,g,b) end)
lam:AddEditBox(controlPanelID, "ZAM_TESTEDITBOX", "Test Edit Box", "This is a tooltip!", false, function() return "hi" end, function(text) print(text) end)
lam:AddHeader(controlPanelID, "ZAM_Addons_TESTADDON2", "TEST ADDON 2")
local checkbox2 = false
lam:AddCheckbox(controlPanelID, "ZAM_TESTCHECKBOX2", "Test Checkbox 2", "On or off?", function() return checkbox2 end, function(value) checkbox2 = not checkbox2 print(value, checkbox2) end)
lam:AddButton(controlPanelID, "ZAM_TESTBUTTON", "Test Button", "Click me", function() print("hi") end, true, "oh noez!")
lam:AddEditBox(controlPanelID, "ZAM_TESTEDITBOX2", "Test Edit Box 2", "This is a tooltip!", true, function() return "hi" end, function(text) print(text) end, true, "warning text")
lam:AddSlider(controlPanelID, "ZAM_TESTSLIDER2", "Test slider 2", "Adjust the slider.", 50, 100, 10, function() return 80 end, function(value) end)
lam:AddDropdown(controlPanelID, "ZAM_TESTDROPDOWN2", "Test Dropdown 2", "Pick something!", {"thing 4", "thing 5", "thing 6"}, function() return "thing 6" end, function(self,valueString) print(valueString) end)
]]--