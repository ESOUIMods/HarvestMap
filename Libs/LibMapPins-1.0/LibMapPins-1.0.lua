-------------------------------------------------------------------------------
-- LibMapPins-1.0
-------------------------------------------------------------------------------
--
-- Copyright (c) 2014 Ales Machat (Garkin)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-------------------------------------------------------------------------------
local MAJOR, MINOR = "LibMapPins-1.0", 5

local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

-------------------------------------------------------------------------------
lib.version = MINOR
lib.updateFrom = lib.updateFrom or oldminor
lib.hookVersions = lib.hookVersions or setmetatable({}, { __index = function() return 0 end })
lib.filters = lib.filters or {}

if not lib.pinManager then
   local pinType = "LibMapPins_Hack_to_get_PinManager"
   ZO_WorldMap_AddCustomPin(pinType, function(pinManager) lib.pinManager = pinManager end)
   ZO_WorldMap_SetCustomPinEnabled(_G[pinType], true)
   ZO_WorldMap_RefreshCustomPinsOfType(_G[pinType])
   lib.pinManager.customPins[_G[pinType]] = nil
   lib.pinManager.m_keyToPinMapping[_G[pinType]] = nil
   _G[pinType] = nil
end

--EMM support
lib.EMM = lib.EMM or { mapping = {}, tasks = {} }

function lib.EMM.AddCustomPinType(pinTypeId, pinLayoutData, pinTypeAddCallback, pinTooltipCreator)
   local EMM_pinTypeId = E_MM.Pin.AddCustomPinType(pinLayoutData, pinTypeAddCallback, pinTooltipCreator)
   lib.EMM.mapping[pinTypeId] = EMM_pinTypeId
end

function lib.EMM.DoTasks()
   if E_MM_IsInit() then
      EVENT_MANAGER:UnregisterForUpdate("EMM_OnInit")
      for id, tasks in ipairs(lib.EMM.tasks) do
         for funcName, funcArgs in pairs(tasks) do
            lib.EMM[funcName](unpack(funcArgs))
         end
         lib.EMM.tasks[id] = nil
      end
      lib.EMM.queued = nil
   end
end

-------------------------------------------------------------------------------
-- Library Functions ----------------------------------------------------------
-------------------------------------------------------------------------------
-- Arguments used by most of the functions:
--
-- pinType:       either pinTypeId or pinTypeString, you can use both
-- pinTypeString: unique string name of your choice (it will be used as a name
--                for global variable)
-- pinTypeId:     unique number code for your pin type, return value from lib:AddPinType
--                ( local pinTypeId = _G[pinTypeString] )
-- pinLayoutData: table which can contain the following keys:
--    level =     number > 2, pins with higher level are drawn on the top of pins
--                with lower level.
--                Examples: Points of interest 50, quests 110, group members 130,
--                wayshrine 140, player 160.
--    texture =   string of function(pin). Function can return just one texture
--                or overlay, pulse and glow textures.
--    size =      texture will be resized to size*size, if not specified size is 20.
--    color =     table {r,g,b,a} or function(pin). If defined, color of background
--                texture is set to this color.
--    grayscale = true/false, could be function(pin). If defined and not false,
--                background texure will be converted to grayscale (http://en.wikipedia.org/wiki/Colorfulness)
--    insetX =    size of transparent texture border, used to handle mouse clicks
--    insetY =    dtto
--    minSize =   if not specified, default value is 18
--    minAreaSize = used for area pins
--    showsPinAndArea = true/false
--    isAnimated = true/false
--
-------------------------------------------------------------------------------
-- lib:AddPinType(pinTypeString, pinTypeAddCallback, pinTypeOnResizeCallback, pinLayoutData, pinTooltipCreator)
-------------------------------------------------------------------------------
-- Adds custom pin type
-- returns: pinTypeId
--
-- pinTypeString: string
-- pinTypeAddCallback: function(pinManager), will be called every time when map
--                is changed. It should create pins on the current map using the
--                lib:CreatePin(...) function.
-- pinTypeOnResizeCallback: (nilable) function(pinManager, mapWidth, mapHeight),
--                is called when map is resized (zoomed).
-- pinLayoutData:  (nilable) table, details above
-- pinTooltipCreator: (nilable) table with the following keys:
--    creator =   function(pin) that creates tooltip - or I should say function
--                that will be called when mouse is over the pin, it does not
--                need to create tooltip.
--    tooltip =   (nilable) tooltip control you want to use.
--    hasTooltip = (optional), function(pin) which returns true/false to
--                enable/disable tooltip.
--
--If used tooltip is InformationTooltip, ZO_KeepTooltip or ZO_MapLocationTooltip,
--it will be properly initialized before creator is called and after that will be
--tooltip anchored to the pinControl. If you use any other tooltip, you have to
--handle initialization and anchoring in creator or hasTooltip functions.
-------------------------------------------------------------------------------
function lib:AddPinType(pinTypeString, pinTypeAddCallback, pinTypeOnResizeCallback, pinLayoutData, pinTooltipCreator)
   if type(pinTypeString) ~= "string" or _G[pinTypeString] ~= nil or type(pinTypeAddCallback) ~= "function" then return end

   if pinLayoutData == nil then
      pinLayoutData = { level = 40, texture = "EsoUI/Art/Inventory/newitem_icon.dds" }
   end

   if type(pinTooltipCreator) == "string" then
      local text = pinTooltipCreator
      pinTooltipCreator = { creator = function(pin) SetTooltipText(InformationTooltip, text) end, tooltip = InformationTooltip }
   elseif pinTooltipCreator ~= nil and type(pinTooltipCreator) ~= "table" then
      return
   end

   local pinTypeId

   if E_MM and E_MM.Pin and E_MM.Pin.CreateCustomPin then
      self.pinManager:AddCustomPin(pinTypeString, function() end, pinTypeOnResizeCallback, pinLayoutData, pinTooltipCreator)
      pinTypeId = _G[pinTypeString]
      if not E_MM_IsInit() then
         table.insert(self.EMM.tasks, {["AddCustomPinType"] = {pinTypeId, pinLayoutData, pinTypeAddCallback, pinTooltipCreator}})
         if not self.EMM.queued then
            EVENT_MANAGER:RegisterForUpdate("EMM_OnInit", 0, self.EMM.DoTasks)
            self.EMM.queued = true
         end
      else
         self.EMM.AddCustomPinType(pinTypeId, pinLayoutData, pinTypeAddCallback, pinTooltipCreator)
      end
   else
      self.pinManager:AddCustomPin(pinTypeString, pinTypeAddCallback, pinTypeOnResizeCallback, pinLayoutData, pinTooltipCreator)
      pinTypeId = _G[pinTypeString]
   end

   self.pinManager:SetCustomPinEnabled(pinTypeId, true)
   self.pinManager:RefreshCustomPins(pinTypeId)

   return pinTypeId
end

-------------------------------------------------------------------------------
-- lib:CreatePin(pinType, pinTag, locX, locY, areaRadius)
-------------------------------------------------------------------------------
-- create single pin on the current map, primary use is from pinTypeAddCallback
--
-- pinType:       pinTypeId or pinTypeString
-- pinTag:        can be anything, but I recommend using table or string with
--                additional pin details. You can use it later in code.
--                ( local pinTypeId, pinTag = pin:GetPinTypeAndTag() )
--                Argument pinTag is used as an id for functions
--                lib:RemoveCustomPin(...) and lib:FindCustomPin(...).
-- locX, locY:    normalized position on the current map
-- areaRadius:    (nilable)
-------------------------------------------------------------------------------
function lib:CreatePin(pinType, pinTag, locX, locY, areaRadius)
   if pinTag == nil or type(locX) ~= "number" or type(locY) ~= "number" then return end

   local pinTypeId, pinTypeString
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
      pinTypeString = pinType
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      if E_MM and E_MM.Pin and E_MM.Pin.CreateCustomPin then
         local isEnabled = self:IsEnabled(pinTypeId)
         if isEnabled then
            if not pinTypeString then
               local pinData = self.pinManager.customPins[pinTypeId]
               if not pinData then return end
               pinTypeString = pinData.pinTypeString
            end
            local mapIndex = E_MM.Minimap.GetCurrentMapIndex()
            local pinName = pinTypeString .. E_MM.Pin.GetCustomPinCount() + 1
            E_MM.Pin.CreateCustomPin(pinName, self.EMM.mapping[pinTypeId], pinTag, mapIndex, locX, locY, areaRadius)

            if ZO_WorldMap:IsHidden() == false then
               self.pinManager:CreatePin(pinTypeId, pinTag, locX, locY, areaRadius)
            end
         end
      else
         self.pinManager:CreatePin(pinTypeId, pinTag, locX, locY, areaRadius)
      end
   end
end

-------------------------------------------------------------------------------
-- lib:GetLayoutData(pinType)
-------------------------------------------------------------------------------
-- Gets reference to pinLayoutData table
-- returns: pinLayoutData
--
-- pinType:       pinTypeId or pinTypeString
-------------------------------------------------------------------------------
function lib:GetLayoutData(pinType)
   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      return ZO_MapPin.PIN_DATA[pinTypeId]
   end
end

-------------------------------------------------------------------------------
-- lib:GetLayoutKey(pinType, key)
-------------------------------------------------------------------------------
-- Gets a single key from pinLayoutData table
-- returns: pinLayoutData[key]
--
-- pinType:       pinTypeId or pinTypeString
-- key:           key name in pinLayoutData table
-------------------------------------------------------------------------------
function lib:GetLayoutKey(pinType, key)
   if type(key) ~= "string" then return end

   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil and ZO_MapPin.PIN_DATA[pinTypeId] then
      return ZO_MapPin.PIN_DATA[pinTypeId][key]
   end
end

-------------------------------------------------------------------------------
-- lib:SetLayoutData(pinType, pinLayoutData)
-------------------------------------------------------------------------------
-- Replace whole pinLayoutData table
--
-- pinType:       pinTypeId or pinTypeString
-- pinLayoutData: table
-------------------------------------------------------------------------------
function lib:SetLayoutData(pinType, pinLayoutData)
   if type(pinLayoutData) ~= "table" then return end

   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      pinLayoutData.level = pinLayoutData.level or 30
      pinLayoutData.texture = pinLayoutData.texture or "EsoUI/Art/Inventory/newitem_icon.dds"

      ZO_MapPin.PIN_DATA[pinTypeId] = {}
      for k,v in pairs(pinLayoutData) do
         ZO_MapPin.PIN_DATA[pinTypeId][k] = v
      end

      if EMM_PIN_DATA then
         local EMM_pinTypeId = self.EMM.mapping[pinTypeId]
         EMM_PIN_DATA[EMM_pinTypeId] = {}
         for k,v in pairs(pinLayoutData) do
            EMM_PIN_DATA[EMM_pinTypeId][k] = v
         end
      end
   end
end

-------------------------------------------------------------------------------
-- lib:SetLayoutKey(pinType, key, data)
-------------------------------------------------------------------------------
-- change a single key in the pinLayoutData table
--
-- pinType:       pinTypeId or pinTypeString
-- key:           key name in pinLayoutData table
-- data:          data to be stored in pinLayoutData[key]
-------------------------------------------------------------------------------
function lib:SetLayoutKey(pinType, key, data)
   if type(key) ~= "string" then return end

   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      ZO_MapPin.PIN_DATA[pinTypeId][key] = data

      if EMM_PIN_DATA then
         local EMM_pinTypeId = self.EMM.mapping[pinTypeId]
         if EMM_pinTypeId and EMM_PIN_DATA[EMM_pinTypeId] then
            EMM_PIN_DATA[EMM_pinTypeId][key] = data
         end
      end
   end
end

-------------------------------------------------------------------------------
-- lib:SetClickHandlers(pinType, LMB_handler, RMB_handler)
-------------------------------------------------------------------------------
-- Adds click handlers for pins of given pinType, if handler is nil, any existing
-- handler will be removed.
--
-- pinType:       pinTypeId or pinTypeString
--
-- LMB_handler:   hadler for left mouse button
-- RMB_handler:   handler for right mouse button
--
-- handler = {
--    {
--       name = string or function(pin) end  --required
--       callback = function(pin) end        --required
--       show = function(pin) end, (optional) default is true. Callback function
--                is called only when show returns true.
--       duplicates = function(pin1, pin2) end, (optional) default is true.
--                What happens when mouse lick hits more than one pin. If true,
--                pins are considered to be duplicates and just one callback
--                function is called.
--    },
-- }
-- One handler can have defined more actions, with different conditions in show
-- function. First action with true result from show function will be used.
-- handler = {
--    {name = "name1", callback = callback1, show = show1},
--    {name = "name2", callback = callback2, show = show2},
--     ...
-- }
-------------------------------------------------------------------------------
function lib:SetClickHandlers(pinType, LMB_handler, RMB_handler)
   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId == nil then return end

   if type(LMB_handler) == "table" or LMB_handler == nil then
      ZO_MapPin.PIN_CLICK_HANDLERS[1][pinTypeId] = LMB_handler
   end
   if type(RMB_handler) == "table" or RMB_handler == nil then
      ZO_MapPin.PIN_CLICK_HANDLERS[2][pinTypeId] = RMB_handler
   end
end

-------------------------------------------------------------------------------
-- lib:RefreshPins(pinType)
-------------------------------------------------------------------------------
-- Refreshes pins. If pinType is nil, refreshes all custom pins
--
-- pinType:       pinTypeId or pinTypeString
-------------------------------------------------------------------------------
function lib:RefreshPins(pinType)
   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if E_MM and E_MM.Pin and E_MM.Pin.RefreshCustomPinsByType then
      if pinTypeId ~= nil then
         local EMM_pinTypeId = self.EMM.mapping[pinTypeId]
         local pinTypeString = self.pinManager.customPins[pinTypeId].pinTypeString
         self.pinManager:RemovePins(pinTypeString)
         E_MM.Pin.RefreshCustomPinsByType(EMM_pinTypeId)
      else
         for pinTypeId, EMM_pinTypeId in pairs(self.EMM.mapping) do
         local pinTypeString = self.pinManager.customPins[pinTypeId].pinTypeString
         self.pinManager:RemovePins(pinTypeString)
         E_MM.Pin.RefreshCustomPinsByType(EMM_pinTypeId)
         end
      end
   else
      self.pinManager:RefreshCustomPins(pinTypeId)
   end
end

-------------------------------------------------------------------------------
-- lib:RemoveCustomPin(pinType, pinTag)
-------------------------------------------------------------------------------
-- Removes custom pin. If pinTag is nil, all pins of the given pinType are removed.
--
-- pinType:       pinTypeId or pinTypeString
-- pinTag:        id assigned to the pin by function lib:CreatePin(...)
-------------------------------------------------------------------------------
function lib:RemoveCustomPin(pinType, pinTag)
   local pinTypeString, pinTypeId
   if type(pinType) == "string" then
      pinTypeString = pinType
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
      local pinData = self.pinManager.customPins[pinTypeId]
      if not pinData then return end
      pinTypeString = pinData.pinTypeString
   end

   if pinTypeId ~= nil then
      self.pinManager:RemovePins(pinTypeString, pinTypeId, pinTag)

      if E_MM and E_MM.Pin and E_MM.Pin.RemoveCustomPinsByType then
         if pinTypeId ~= nil then
            local EMM_pinTypeId = self.EMM.mapping[pinTypeId]
            E_MM.Pin.RemoveCustomPinsByType(EMM_pinTypeId)
         else
            for pinTypeId, EMM_pinTypeId in pairs(self.EMM.mapping) do
               E_MM.Pin.RemoveCustomPinsByType(EMM_pinTypeId)
            end
         end
      end
    end
end

-------------------------------------------------------------------------------
-- lib:FindCustomPin(pinType, pinTag)
-------------------------------------------------------------------------------
-- Returns pin.
--
-- pinType:       pinTypeId or pinTypeString
-- pinTag:        id assigned to the pin by function lib:CreatePin(...)
-------------------------------------------------------------------------------
function lib:FindCustomPin(pinType, pinTag)
   if pinTag == nil then return end

   local pinTypeString, pinTypeId
   if type(pinType) == "string" then
      pinTypeString = pinType
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
      local pinData = self.pinManager.customPins[pinTypeId]
      if not pinData then return end
      pinTypeString = pinData.pinTypeString
   end

   if pinTypeId ~= nil then
      return self.pinManager:FindPin(pinTypeString, pinTypeId, pinTag)
   end
end

-------------------------------------------------------------------------------
-- lib:SetAddCallback(pinType, pinTypeAddCallback)
-------------------------------------------------------------------------------
-- Set add callback
--
-- pinType:       pinTypeId or pinTypeString
-- pinTypeAddCallback: function(pinManager)
-------------------------------------------------------------------------------
function lib:SetAddCallback(pinType, pinTypeAddCallback)
   if type(pinTypeAddCallback) ~= "function" then return end

   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      if EMM_PIN_DATA then
         local EMM_pinTypeId = self.EMM.mapping[pinTypeId]
         EMM_PIN_DATA[EMM_pinTypeId].callback = pinTypeAddCallback
      else
         self.pinManager.customPins[pinTypeId].layoutCallback = pinTypeAddCallback
      end
   end
end

-------------------------------------------------------------------------------
-- lib:SetResizeCallback(pinType, pinTypeOnResizeCallback)
-------------------------------------------------------------------------------
-- Set OnResize callback
--
-- pinType:       pinTypeId or pinTypeString
-- pinTypeOnResizeCallback: function(pinManager, mapWidth, mapHeight)
-------------------------------------------------------------------------------
function lib:SetResizeCallback(pinType, pinTypeOnResizeCallback)
   if type(pinTypeOnResizeCallback) ~= "function" then return end

   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      self.pinManager.customPins[pinTypeId].resizeCallback = pinTypeOnResizeCallback
   end
end

-------------------------------------------------------------------------------
-- lib:IsEnabled(pinType)
-------------------------------------------------------------------------------
-- Checks if pins are enabled
-- returns: true/false
--
-- pinType:       pinTypeId or pinTypeString
-------------------------------------------------------------------------------
function lib:IsEnabled(pinType)
   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId ~= nil then
      return self.pinManager:IsCustomPinEnabled(pinTypeId)
   end
end

-------------------------------------------------------------------------------
-- lib:SetEnabled(pinType, state)
-------------------------------------------------------------------------------
-- Set enabled/disabled state of the given pinType. It will also update state
-- of world map filter checkbox.
--
-- pinType:       pinTypeId or pinTypeString
-- state:         true/false, as false is considered nil, false or 0. All other
--                values are true.
-------------------------------------------------------------------------------
function lib:SetEnabled(pinType, state)
   local pinTypeId
   if type(pinType) == "string" then
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
   end

   if pinTypeId == nil then return end

   local enabled
   if type(state) == "number" then
      enabled = state ~= 0
   else
      enabled = state and true or false
   end

   local needsRefresh = self.pinManager:IsCustomPinEnabled(pinTypeId) ~= enabled
   local filter = self.filters[pinTypeId]
   if filter then
      ZO_CheckButton_SetCheckState((GetMapContentType() == MAP_CONTENT_AVA) and filter.pvp or filter.pve, enabled)
   end

   self.pinManager:SetCustomPinEnabled(pinTypeId, enabled)

   if needsRefresh then
      self:RefreshPins(pinType)
   end
end

-------------------------------------------------------------------------------
-- lib:Enable(pinType)
-------------------------------------------------------------------------------
-- Enables pins of the given pinType
--
-- pinType:       pinTypeId or pinTypeString
-------------------------------------------------------------------------------
function lib:Enable(pinType)
   self:SetEnabled(pinType, true)
end

-------------------------------------------------------------------------------
-- lib:Disable(pinType)
-------------------------------------------------------------------------------
-- Disables pins of the given pinType
--
-- pinType:       pinTypeId or pinTypeString
-------------------------------------------------------------------------------
function lib:Disable(pinType)
   self:SetEnabled(pinType, false)
end

-------------------------------------------------------------------------------
-- lib:AddPinFilter(pinType, pinCheckboxText, separate, savedVars, savedVarsPveKey, savedVarsPvpKey)
-------------------------------------------------------------------------------
-- Adds filter checkboxes to the world map.
-- Returns: pveCheckbox, pvpCheckbox
-- (newly created checkbox controls for PvE and PvP context of the world map)
--
-- pinType:       pinTypeId or pinTypeString
-- pinCheckboxText: (nilable), description displayed next to the checkbox, if nil
--                pinCheckboxText = pinTypeString
-- separate:      (nilable), if false or nil, checkboxes for PvE and PvP context
--                will be linked together. If savedVars argument is nil, separate
--                is ignored and checkboxes will be linked together.
-- savedVars:     (nilable), table where you store filter settings
-- savedVarsPveKey: (nilable), key in the savedVars table where you store filter
--                state for PvE context. If savedVars table exists but this key
--                is nil, state will be stored in savedVars[pinTypeString].
-- savedVarsPvpKey: (nilable), key in the savedVars table where you store filter
--                state for PvP context, used only if separate is true. If separate
--                is true, savedVars exists but this argument is nil, state will
--                be stored in savedVars[pinTypeString .. "_pvp"].
-------------------------------------------------------------------------------
function lib:AddPinFilter(pinType, pinCheckboxText, separate, savedVars, savedVarsPveKey, savedVarsPvpKey)
   local pinTypeString, pinTypeId
   if type(pinType) == "string" then
      pinTypeString = pinType
      pinTypeId = _G[pinType]
   elseif type(pinType) == "number" then
      pinTypeId = pinType
      local pinData = self.pinManager.customPins[pinTypeId]
      if not pinData then return end
      pinTypeString = pinData.pinTypeString
   end

   if pinTypeId == nil or self.filters[pinTypeId] then return end

   self.filters[pinTypeId] = {}
   local filter = self.filters[pinTypeId]

   if type(savedVars) == "table" then
      filter.vars = savedVars
      filter.pveKey = savedVarsPveKey or pinTypeString
      if separate then
         filter.pvpKey = savedVarsPvpKey or pinTypeString .. "_pvp"
      else
         filter.pvpKey = filter.pveKey
      end
   end

   if type(pinCheckboxText) ~= "string" then
      pinCheckboxText = pinTypeString
   end

   local function AddCheckbox(panel, pinCheckboxText)
      local checkbox = panel.checkBoxPool:AcquireObject()
      ZO_CheckButton_SetLabelText(checkbox, pinCheckboxText)
      panel:AnchorControl(checkbox)
      return checkbox
   end

   filter.pve = AddCheckbox(WORLD_MAP_FILTERS.pvePanel, pinCheckboxText)
   filter.pvp = AddCheckbox(WORLD_MAP_FILTERS.pvpPanel, pinCheckboxText)

   if filter.vars ~= nil then
      ZO_CheckButton_SetToggleFunction(filter.pve,
         function(button, state)
            filter.vars[filter.pveKey] = state
            self:SetEnabled(pinTypeId, state)
         end)
      ZO_CheckButton_SetToggleFunction(filter.pvp,
         function(button, state)
            filter.vars[filter.pvpKey] = state
            self:SetEnabled(pinTypeId, state)
         end)
      self:SetEnabled(pinTypeId, (GetMapContentType() == MAP_CONTENT_AVA) and filter.vars[filter.pvpKey] or filter.vars[filter.pveKey])
   else
      ZO_CheckButton_SetToggleFunction(filter.pve,
         function(button, state)
            self:SetEnabled(pinTypeId, state)
         end)
      ZO_CheckButton_SetCheckState(filter.pve, self:IsEnabled(pinTypeId))
      ZO_CheckButton_SetToggleFunction(filter.pvp,
         function(button, state)
            self:SetEnabled(pinTypeId, state)
         end)
      ZO_CheckButton_SetCheckState(filter.pvp, self:IsEnabled(pinTypeId))
   end

   return filter.pve, filter.pvp
end

-------------------------------------------------------------------------------
-- lib:GetZoneAndSubzone(alternativeFormat)
-------------------------------------------------------------------------------
-- Returns zone and subzone derived from map texture.

-- You can select from 2 formats:
-- 1: "zone", "subzone"    (that's what I use in my addons)
-- 2: "zone/subzone"       (this format is used by HarvestMap)
-- If argument is nil or false, function returns first format
-------------------------------------------------------------------------------
function lib:GetZoneAndSubzone(alternative)
   if alternative then
      return select(3,(GetMapTileTexture()):lower():find("maps/([%w%-]+/[%w%-]+_[%w%-]+)"))
   end

   return select(3,(GetMapTileTexture()):lower():find("maps/([%w%-]+)/([%w%-]+_[%w%-]+)"))
end


-------------------------------------------------------------------------------
-- Callbacks ------------------------------------------------------------------
-------------------------------------------------------------------------------
--refresh checkbox state for world map filters
function lib.OnMapChanged()
   local context = GetMapContentType() == MAP_CONTENT_AVA and "pvp" or "pve"
   if lib.context ~= context then
      lib.context = context
      local filterKey = context .. "Key"
      for pinTypeId, filter in pairs(lib.filters) do
         if filter.vars then
            local state = filter.vars[filter[filterKey]]
            lib:SetEnabled(pinTypeId, state)
         else
            ZO_CheckButton_SetCheckState(filter[context], lib:IsEnabled(pinTypeId))
         end
      end
   end
end

if not oldminor then
   CALLBACK_MANAGER:RegisterCallback("OnWorldMapChanged", lib.OnMapChanged)
end

-------------------------------------------------------------------------------
-- Hooks ----------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Hooks has to be versioned, so if I make any change to the hook, old hook will
-- be disabled. It's not possible to use backup of the original function as it
-- can break other addons
-------------------------------------------------------------------------------
--support for "color" and "grayscale" in pinLayoutData
if lib.hookVersions.ZO_MapPin_SetData < 1 then
   ZO_PreHook(ZO_MapPin, "SetData",
      function(self, pinTypeId)
         --check hook version
         if lib.hookVersions.ZO_MapPin_SetData ~= 1 then return end
         local control = GetControl(self:GetControl(), "Background")
         local color = ZO_MapPin.PIN_DATA[pinTypeId].color
         local grayscale = ZO_MapPin.PIN_DATA[pinTypeId].grayscale
         if color ~= nil then
            if type(color) == "table" then
               control:SetColor(unpack(color))
            elseif type(color) == "function" then
               control:SetColor(color(self))
            end
         end
         if grayscale ~= nil then
            control:SetDesaturation((type(grayscale) == "function" and grayscale(self) or grayscale) and 1 or 0)
         end
      end)

   --set hook version
   lib.hookVersions.ZO_MapPin_SetData = 1
end
if lib.hookVersions.ZO_MapPin_ClearData < 1 then
   ZO_PreHook(ZO_MapPin, "ClearData",
      function(self, ...)
         --check hook version
         if lib.hookVersions.ZO_MapPin_ClearData ~= 1 then return end
         local control = GetControl(self:GetControl(), "Background")
         control:SetColor(1, 1, 1, 1)
         control:SetDesaturation(0)
      end)

   --set hook version
   lib.hookVersions.ZO_MapPin_ClearData = 1
end

-------------------------------------------------------------------------------
-- Useful methods for pins:
-------------------------------------------------------------------------------
--
-- pin:GetControl()
-- pin:GetPinType()
-- pin:GetPinTypeAndTag()
-- pin:GetLevel()
-- pin:GetNormalizedPosition()
-- pin:SetData(pinType, pinTag)
-- pin:SetLocation(xLoc, yLoc, raduis)
-- pin:SetRotation(angle)
-- pin:UpdateLocation()
-------------------------------------------------------------------------------


--[[---------------------------------------------------------------------------
-- Sample code:
-------------------------------------------------------------------------------
-- MapPinTest/MapPintest.txt
-------------------------------------------------------------------------------
## Title: MapPinTest
## APIVersion: 100008
## SavedVariables: MapPinTest_SavedVariables

Libs/LibStub/LibStub.lua
Libs/LibMapPins-1.0/LibMapPins-1.0.lua

MapPinTest.lua

-------------------------------------------------------------------------------
-- MapPinTest/MapPinTest.lua
-------------------------------------------------------------------------------
local LMP = LibStub("LibMapPins-1.0")

local pinType1 = "My_unique_name"
local pinType2 = "My_even_more_unique_name"
local pinTypeId1, pinTypeId2

--sample data
local pinData = {
   ["auridon/auridon_base"] = {
      { x = 0.5432, y = 0.6789 },
   },
   ["alikr/alikr_base"] = {
      { x = 0.4343, y = 0.5353 },
   },
}

--sample layout
local pinLayoutData  = {
   level = 50,
   texture = "EsoUI/Art/MapPins/hostile_pin.dds",
   size = 30,
}

--tooltip creator
local pinTooltipCreator = {
   creator = function(pin)
      local locX, locY = pin:GetNormalizedPosition()
      InformationTooltip:AddLine(zo_strformat("Position of my pin is: <<1>>•<<2>>", ("%05.02f"):format(locX*100), ("%05.02f"):format(locY*100)))
   end,
   tooltip = InformationTooltip,
}

--click handlers
local LMB_handler = {
   {
      name = "LMB action 1",
      callback = function(pin) d("LMB action 1!") end,
      show = function(pin) return pin:GetControl():GetHeight() == 30 end,
   },
   {
      name = "LMB action 2",
      callback = function(pin) d("LMB action 2!") end,
      show = function(pin) return pin:GetControl():GetHeight() == 20 end,
   },
}
local RMB_handler = {
   {
      name = "RMB action",
      callback = function(pin) d("RMB action!") end,
   },
}

--add callback function
local pinTypeAddCallback = function(pinManager)
   --do not create pins if your pinType is not enabled
   if not LMP:IsEnabled(pinType1) then return end
   --do not create pins on world, alliance and cosmic maps
   if (GetMapType() > MAPTYPE_ZONE) then return end

   local mapname = LMP:GetZoneAndSubzone(true)
   local pins = pinData[mapname]
   --return if no data for the current map
   if not pins then return end

   for _, pinInfo in ipairs(pins) do
      LMP:CreatePin(pinType1, pinInfo, pinInfo.x, pinInfo.y)
   end
end

--resize callback function (usually just nil)
local pinTypeOnResizeCallback = function(pinManager, mapWidth, mapHeight)
   local visibleWidth, visibleHeight = ZO_WorldMapScroll:GetDimensions()
   local currentZoom = mapWidth / visibleWidth

   if currentZoom < 1.5 then
      LMP:SetLayoutData(pinType1, pinLayoutData)
      LMP:RefreshPins(pinType1)
   else
      LMP:SetLayoutData(pinType1, {})
      LMP:RefreshPins(pinType1)
   end
end

local function OnLoad(eventCode, name)
   if name ~= "MapPinTest" then return end

   --saved variables
   savedVars = ZO_SavedVars:New("MapPinTest_SavedVariables", 1, nil, { filters = true })
   --initialize map pins
   pinTypeId1 = LMP:AddPinType(pinType1, pinTypeAddCallback, pinTypeOnResizeCallback, pinLayoutData, pinTooltipCreator)
   pinTypeId2 = LMP:AddPinType(pinType2, function() d("refresh") end)
   --set click handlers
   LMP:SetClickHandlers(pinTypeId1, LMB_handler, RMB_handler)
   --add pin filters to the world map
   LMP:AddPinFilter(pinTypeId1, "MapPinTest's pins", false, savedVars, "filters")
   LMP:AddPinFilter(pinTypeId2, nil, nil, savedVars)

   EVENT_MANAGER:UnregisterForEvent("MapPinTest_OnLoad", eventCode)
end

EVENT_MANAGER:RegisterForEvent("MapPinTest_OnLoad", EVENT_ADD_ON_LOADED, OnLoad)
-------------------------------------------------------------------------------
-- END of sample code
--]]---------------------------------------------------------------------------
