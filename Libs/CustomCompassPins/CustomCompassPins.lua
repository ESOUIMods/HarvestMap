-- CustomCompassPins by Shinni
local version = 1.24
local onlyUpdate = false

if COMPASS_PINS and COMPASS_PINS.version then
   if COMPASS_PINS.version >= version then
      return
   end
   onlyUpdate = true
else
   COMPASS_PINS = {}
end

local PARENT = COMPASS.container
local FOV = math.pi * 0.6
local coefficients = {0.16, 1.08, 1.32, 1.14, 1.14, 1.23, 1.16, 1.24, 1.33, 1.00, 1.12, 1.00, 1.00, 0.89, 1.00, 1.37, 1.20, 4.27, 2.67, 3.20, 5.00, 8.45, 0.89, 0.10, 1.14}

--
-- Base class, can be accessed via COMPASS_PINS
--
local CompassPinManager = ZO_ControlPool:Subclass()

function COMPASS_PINS:New(...)
   if onlyUpdate then
      self:UpdateVersion()
   else
      self:Initialize(...)
   end

   self.control:SetHidden(false)

   self.version = version
   self.defaultFOV = FOV
   self:RefreshDistanceCoefficient()

   local lastUpdate = 0
   self.control:SetHandler("OnUpdate",
      function()
         local now = GetFrameTimeMilliseconds()
         if (now - lastUpdate) >= 20 then
            self:Update()
            lastUpdate = now
         end
      end)

   if _G["CustomCompassPins_MapChangeDetector"] == nil then
      self:SetupCallbacks()
   end

   return result
end

function COMPASS_PINS:UpdateVersion()
   local data = self.pinManager.pinData
   self.pinManager = CompassPinManager:New()
   if data then
      self.pinManager.pinData = data
   end

   if self.version == 1.21 then
      WORLD_MAP_SCENE:RegisterCallback("StateChange",
         function(oldState, newState)
            if newState == SCENE_HIDDEN then
               if(SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED) then
                  CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
               end
            end
         end)
   elseif self.version == 1.22 then
      WORLD_MAP_SCENE:RegisterCallback("StateChange",
         function(oldState, newState)
            if newState == SCENE_HIDDEN then
               CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
            end
         end)
   end
end

function COMPASS_PINS:Initialize(...)
   --can't create OnUpdate handler on via CreateControl, so i'll have to create somethin else via virtual
   self.control = WINDOW_MANAGER:CreateControlFromVirtual( nil, GuiRoot, "ZO_MapPin")
   self.pinCallbacks = {}
   self.pinLayouts = {}
   self.pinManager = CompassPinManager:New()
   self:SetupCallbacks()
end

function COMPASS_PINS:SetupCallbacks()
   ZO_WorldMap_AddCustomPin("CustomCompassPins_MapChangeDetector",
      function()
         local currentMap = select(3,(GetMapTileTexture()):lower():find("maps/([%w%-]+/[%w%-]+_%w+)"))
         CALLBACK_MANAGER:FireCallbacks("CustomCompassPins_MapChanged", currentMap)
      end)
   ZO_WorldMap_SetCustomPinEnabled(_G["CustomCompassPins_MapChangeDetector"], true)

   local function OnMapChanged(currentMap)
      if self.map ~= currentMap then
         self:RefreshDistanceCoefficient()
         self:RefreshPins()
         self.map = currentMap
      end
   end

   CALLBACK_MANAGER:RegisterCallback("CustomCompassPins_MapChanged", OnMapChanged)

   WORLD_MAP_SCENE:RegisterCallback("StateChange",
      function(oldState, newState)
         if newState == SCENE_HIDDEN then
            if(SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED) then
               CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
            end
         end
      end)
end

-- pinType should be a string eg "skyshard"
-- pinCallbacks should be a function, it receives the pinManager as argument
-- layout should be table, currently only the key texture is used (which should return a string)
function COMPASS_PINS:AddCustomPin(pinType, pinCallback, layout)
   if type(pinType) ~= "string" or self.pinLayouts[pinType] ~= nil or type(pinCallback) ~= "function" or type(layout) ~= "table" then return end
   layout.maxDistance = layout.maxDistance or 0.02
   layout.texture = layout.texture or "EsoUI/Art/MapPins/hostile_pin.dds"

   self.pinCallbacks[pinType] = pinCallback
   self.pinLayouts[pinType] = layout
end

-- refreshes/calls the pinCallback of the given pinType
-- refreshes all custom pins if no pinType is given
function COMPASS_PINS:RefreshPins(pinType)
   self.pinManager:RemovePins(pinType)
   if pinType then
      if not self.pinCallbacks[pinType] then
         return
      end
      self.pinCallbacks[pinType](self.pinManager)
   else
      for tag, callback in pairs(self.pinCallbacks) do
         callback(self.pinManager)
      end
   end
end

function COMPASS_PINS:GetDistanceCoefficient()     --coefficient = Auridon size / current map size
   local coefficient = 1
   local mapId = GetCurrentMapIndex()
   if mapId then
      coefficient = coefficients[mapId] or 1       --zones and starting isles
   else
      if GetMapContentType() == MAP_CONTENT_DUNGEON then
         coefficient = 16                          --all dungeons, value between 8 - 47, usually 16
      elseif GetMapType() == MAPTYPE_SUBZONE then
         coefficient = 6                           --all subzones, value between 5 - 8, usually 6
      end
   end

   return math.sqrt(coefficient)                   --as we do not want that big difference, lets make it smaller...
end

function COMPASS_PINS:RefreshDistanceCoefficient()
   self.distanceCoefficient = self:GetDistanceCoefficient()
end

-- updates the pins (recalculates the position of the pins)
function COMPASS_PINS:Update()
   local heading = GetPlayerCameraHeading()
   if not heading then return end
   if heading > math.pi then --normalize heading to [-pi,pi]
      heading = heading - 2 * math.pi
   end

   local x, y = GetMapPlayerPosition("player")
   self.pinManager:Update(x, y, heading)
end

--
-- pin manager class, updates position etc
--
function CompassPinManager:New(...)
   local result = ZO_ControlPool.New(self, "ZO_MapPin", PARENT, "Pin")
   result:Initialize(...)

   return result
end

function CompassPinManager:Initialize(...)
   self.pinData = {}
   self.defaultAngle = 1
end

function CompassPinManager:GetNewPin(data)
   local pin, pinKey = self:AcquireObject()
   self:ResetPin(pin)
   pin:SetHandler("OnMouseDown", nil)
   pin:SetHandler("OnMouseUp", nil)
   pin:SetHandler("OnMouseEnter", nil)
   pin:SetHandler("OnMouseExit", nil)

   pin.xLoc = data.xLoc
   pin.yLoc = data.yLoc
   pin.pinType = data.pinType
   pin.pinTag = data.pinTag

   local layout = COMPASS_PINS.pinLayouts[data.pinType]
   local texture = pin:GetNamedChild("Background")
   texture:SetTexture(layout.texture)

   return pin, pinKey
end
-- creates a pin of the given pinType at the given location
-- (radius is not implemented yet)
function CompassPinManager:CreatePin(pinType, pinTag, xLoc, yLoc)
   local data = {}

   data.xLoc = xLoc
   data.yLoc = yLoc
   data.pinType = pinType
   data.pinTag = pinTag

   table.insert(self.pinData, data)
end

function CompassPinManager:RemovePins(pinType)
   if not pinType then
      self:ReleaseAllObjects()
      self.pinData = {}
   else
      for key, data in pairs(self.pinData) do
         if data.pinType == pinType then
            if data.pinKey then
               self:ReleaseObject(data.pinKey)
            end
            self.pinData[key] = nil
         end
      end
   end
end

function CompassPinManager:ResetPin(pin)
   for _, layout in pairs(COMPASS_PINS.pinLayouts) do
      if layout.additionalLayout then
         layout.additionalLayout[2](pin)
      end
   end
end

function CompassPinManager:Update(x, y, heading)
   local value
   local pin
   local angle
   local normalizedAngle
   local xDif, yDif
   local layout
   local normalizedDistance
   local distance
   for _, pinData in pairs(self.pinData) do

      layout = COMPASS_PINS.pinLayouts[pinData.pinType]
      distance = layout.maxDistance * COMPASS_PINS.distanceCoefficient
      xDif = x - pinData.xLoc
      yDif = y - pinData.yLoc
      normalizedDistance = (xDif * xDif + yDif * yDif) / (distance * distance)
      if normalizedDistance < 1 then
         if pinData.pinKey then
            pin = self:GetExistingObject(pinData.pinKey)
         else
            pin, pinData.pinKey = self:GetNewPin(pinData)
         end

         if pin then
            pin:SetHidden(true)
            angle = -math.atan2(xDif, yDif)
            angle = (angle + heading)
            if angle > math.pi then
               angle = angle - 2 * math.pi
            elseif angle < -math.pi then
               angle = angle + 2 * math.pi
            end

            normalizedAngle = 2 * angle / (layout.FOV or COMPASS_PINS.defaultFOV)

            if zo_abs(normalizedAngle) > (layout.maxAngle or self.defaultAngle) then
               pin:SetHidden(true)
            else
               pin:ClearAnchors()
               pin:SetAnchor(CENTER, PARENT, CENTER, 0.5 * PARENT:GetWidth() * normalizedAngle, 0)
               pin:SetHidden(false)

               if layout.sizeCallback then
                  layout.sizeCallback(pin, angle, normalizedAngle, normalizedDistance)
               else
                  if zo_abs(normalizedAngle) > 0.25 then
                     pin:SetDimensions(36 - 16 * zo_abs(normalizedAngle), 36 - 16 * zo_abs(normalizedAngle))
                  else
                     pin:SetDimensions(32, 32)
                  end
               end

               pin:SetAlpha(1 - normalizedDistance)

               if layout.additionalLayout then
                  layout.additionalLayout[1](pin, angle, normalizedAngle, normalizedDistance)
               end
            end
         else
            d("CustomCompassPin Error:")
            d("no pin with key " .. pinData.pinKey .. "found!")
         end
      else
         if pinData.pinKey then
            self:ReleaseObject(pinData.pinKey)
            pinData.pinKey = nil
         end
      end
   end
end

COMPASS_PINS:New()


--[[
example:

COMPASS_PINS:AddCustomPin("myCompassPins",
   function(pinManager)
      for _, pinTag in pairs(myData) do
         pinManager:CreatePin("myCompassPins", pinTag, pinTag.x, pinTag.y)
      end
   end,
   { maxDistance = 0.05, texture = "esoui/art/compass/quest_assistedareapin.dds" })

--]]
