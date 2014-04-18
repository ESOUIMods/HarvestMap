-- CustomCompassPins by Shinni
local version = 1.12
local onlyUpdate = false

if COMPASS_PINS then
	if COMPASS_PINS.version and COMPASS_PINS.version >= version then
		return
	end
	onlyUpdate = true
else
	COMPASS_PINS = {}
end

local PARENT = COMPASS.container
local FOV = math.pi * 0.6

--
-- Base class, can be accessed via COMPASS_PINS
--

local CompassPinManager = ZO_ControlPool:Subclass()

function COMPASS_PINS:New( ... )
	if onlyUpdate then
		self:UpdateVersion()
	else
		self:Initialize( ... )
	end
	
	self.control:SetHidden(false)
	self.control:SetHandler("OnUpdate", function() self:Update() end )
	self.version = version
	self.defaultFOV = FOV
	return result
end

function COMPASS_PINS:UpdateVersion()
	local pins = self.pinManager.pins
	local data = self.pinManager.pinData
	self.pinManager = CompassPinManager:New()
	if pins then
		self.pinManager.pins = pins
	end
	if data then
		self.pinManager.pinData = data
	end
end

function COMPASS_PINS:Initialize( ... )
	self.control = WINDOW_MANAGER:CreateControlFromVirtual("CP_Control", GuiRoot, "ZO_MapPin")
	self.pinCallbacks = {}
	self.pinLayouts = {}
	self.pinManager = CompassPinManager:New()
end

-- pinType should be a string eg "skyshard"
-- pinCallbacks should be a function, it receives the pinManager as argument
-- layout should be table, currently only the key texture is used (which should return a string) 
function COMPASS_PINS:AddCustomPin( pinType, pinCallback, layout )
	self.pinCallbacks[ pinType ] = pinCallback
	self.pinLayouts[ pinType ] = layout
	self.pinManager:CreatePinType( pinType )
end

-- refreshes/calls the pinCallback of the given pinType
-- refreshes all custom pins if no pinType is given
function COMPASS_PINS:RefreshPins( pinType )
	self.pinManager:RemovePins( pinType )
	if pinType then
		if not self.pinCallbacks[ pinType ] then
			return
		end
		self.pinCallbacks[ pinType ]( self.pinManager )
	else
		for tag, callback in pairs( self.pinCallbacks ) do
			callback( self.pinManager )
		end
	end
	
end

-- updates the pins (recalculates the position of the pins)
function COMPASS_PINS:Update()
	-- maybe add some delay, because pin update could be to expensive to be calculated every frame
	local heading = GetPlayerCameraHeading()
	if not heading then
		return
	end
	if heading > math.pi then --normalize heading to [-pi,pi]
		heading = heading - 2 * math.pi
	end
	
	local x, y = GetMapPlayerPosition("player")
	self.pinManager:Update( x, y, heading )
end

--
-- pin manager class, updates position etc
--

function CompassPinManager:New( ... )
	
	local result = ZO_ControlPool.New(self, "ZO_MapPin", PARENT, "Pin")
	result:Initialize( ... )
	
	return result
end

function CompassPinManager:Initialize( ... )
	self.pins = {}
	self.pinData = {}
	self.defaultAngle = 1
end

function CompassPinManager:CreatePinType( pinType )
	self.pins[ pinType ] = {}
end

function CompassPinManager:GetNewPin( data )
	local pin, pinKey = self:AcquireObject()
	table.insert( self.pins[ data.pinType ], pinKey )
	self:ResetPin( pin )
	pin:SetHandler("OnMouseDown", nil)
	pin:SetHandler("OnMouseUp", nil)
	pin:SetHandler("OnMouseEnter", nil)
	pin:SetHandler("OnMouseExit", nil)
	
	pin.xLoc = data.xLoc
	pin.yLoc = data.yLoc
	pin.pinType = data.pinType
	pin.pinTag = data.pinTag
	
	local layout = COMPASS_PINS.pinLayouts[ data.pinType ]
	local texture = pin:GetNamedChild( "Background" )
	texture:SetTexture( layout.texture )
	
	return pin, pinKey
end
-- creates a pin of the given pinType at the given location
-- (radius is not implemented yet)
function CompassPinManager:CreatePin( pinType, pinTag, xLoc, yLoc )
	local data = {}
	
	data.xLoc = xLoc
	data.yLoc = yLoc
	data.pinType = pinType
	data.pinTag = pinTag
	
	table.insert(self.pinData, data)
end

function CompassPinManager:RemovePins( pinType )
	if not pinType then
		self:ReleaseAllObjects()
		self.pinData = {}
		for pinType, _ in pairs( self.pins ) do
			self.pins[ pinType ] = {}
		end
	else
		if not self.pins[ pinType ] then
			return
		end
		for _, pinKey in pairs( self.pins[ pinType ] ) do
			self:ReleaseObject( pinKey )
		end
		for key, data in pairs( self.pinData ) do
			if data.pinType == pinType then
				self.pinData[key] = nil
			end
		end
		self.pins[ pinType ] = {}
	end
end

function CompassPinManager:ResetPin( pin )
	for _, layout in pairs(COMPASS_PINS.pinLayouts) do
		if layout.additionalLayout then
			layout.additionalLayout[2]( pin )
		end
	end
end

function CompassPinManager:Update( x, y, heading )
	local value
	local pin
	local angle
	local normalizedAngle
	local xDif, yDif
	local layout
	local normalizedDistance
	for _, pinData in pairs( self.pinData ) do
	
		layout = COMPASS_PINS.pinLayouts[ pinData.pinType ]
		xDif = x - pinData.xLoc
		yDif = y - pinData.yLoc
		normalizedDistance = (xDif * xDif + yDif * yDif) / (layout.maxDistance * layout.maxDistance)
		if normalizedDistance < 1 then
				
			if pinData.pinKey then
				pin = self:GetExistingObject( pinData.pinKey )
			else
				pin, pinData.pinKey = self:GetNewPin( pinData )
			end
			
			if pin then
				--self:ResetPin( pin )
				pin:SetHidden( true )
				angle = -math.atan2( xDif, yDif )
				angle = (angle + heading)
				if angle > math.pi then
					angle = angle - 2 * math.pi
				elseif angle < -math.pi then
					angle = angle + 2 * math.pi
				end
				
				normalizedAngle = 2 * angle / (layout.FOV or COMPASS_PINS.defaultFOV)
					
				if zo_abs(normalizedAngle) > (layout.maxAngle or self.defaultAngle) then
					pin:SetHidden( true )
				else
					
					pin:ClearAnchors()
					pin:SetAnchor( CENTER, PARENT, CENTER, 0.5 * PARENT:GetWidth() * normalizedAngle, 0)
					pin:SetHidden( false )
					
					if layout.sizeCallback then
						layout.sizeCallback( pin, angle, normalizedAngle, normalizedDistance )
					else
						if zo_abs(normalizedAngle) > 0.25 then
							pin:SetDimensions( 36 - 16 * zo_abs(normalizedAngle), 36 - 16 * zo_abs(normalizedAngle) )
						else
							pin:SetDimensions( 32 , 32  )
						end
					end
					
					pin:SetAlpha(1 - normalizedDistance)
					
					if layout.additionalLayout then
						layout.additionalLayout[1]( pin, angle, normalizedAngle, normalizedDistance)
					end
					
					-- end for inside maxAngle
				end --stupid lua has no continue/next in loops >_>
			end
		else
			if pinData.pinKey then
				self:ReleaseObject( pinData.pinKey )
				pinData.pinKey = nil
			else
			
			end
		end
	end
end

COMPASS_PINS:New()
--can't create OnUpdate handler on via CreateControl, so i'll have to create somethin else via virtual


--[[
example:

COMPASS_PINS:CreatePinType( "skyshard", function (pinManager)
		for _, skyshard in pairs( mySkyshards ) do
			pinManager:CreatePin( "skyshard", skyshard.x, skyshard.y )
		end
	end,
	{ texture = "esoui/art/compass/quest_assistedareapin.dds" } )
	
]]--