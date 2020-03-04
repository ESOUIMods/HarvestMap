
local CallbackManager = LibNodeDetection.callbackManager
local Events = LibNodeDetection.events
local PinTypes = LibNodeDetection.pinTypes

local Detection = {}
LibNodeDetection:RegisterModule("detection", Detection)

Detection.compassPins = {}
Detection.unknownPinTypeCompassPins = {}
Detection.unknownPositionCompassPins = {} -- compass pins whose world position is not yet known
Detection.knownPositionCompassPins = {} -- compass pins whose world position we know

function Detection:Initialize()
	
	self.container = ZO_CompassContainer
	EVENT_MANAGER:RegisterForUpdate("LibNodeDetection-NodeDetection", 50, self.OnUpdateNodeListHandler)
	EVENT_MANAGER:RegisterForUpdate("LibNodeDetection-TypeDetection", 100, function() self:OnUpdatePinTypeHandler() end)
	EVENT_MANAGER:RegisterForEvent("LibNodeDetection-CompassPins", EVENT_PLAYER_DEACTIVATED, function()
		self.compassPins = {}
		self.unknownPinTypeCompassPins = {}
		self.unknownPositionCompassPins = {}
		self.knownPositionCompassPins = {}
	end )
	
end

function CraftingCompassPinAdded(compassPin)
	compassPin.pinTypeId = PinTypes.UNKNOWN
	compassPin.tag = tostring(compassPin)
	compassPin.id = #Detection.compassPins + 1
	compassPin.worldX = {}
	compassPin.worldY = {}
	compassPin.lastPositionIndex = 0
	Detection.compassPins[compassPin.id] = compassPin
	Detection.unknownPinTypeCompassPins[compassPin.id] = compassPin
	Detection.unknownPositionCompassPins[compassPin.id] = compassPin
	
	CallbackManager:FireCallbacks(Events.HARVEST_NODE_VISIBLE, compassPin)
end

function CraftingCompassPinRemoved(compassPin)
	Detection.compassPins[compassPin.id] = nil
	Detection.unknownPinTypeCompassPins[compassPin.id] = nil
	Detection.unknownPositionCompassPins[compassPin.id] = nil
	Detection.knownPositionCompassPins[compassPin.id] = nil
	CallbackManager:FireCallbacks(Events.HARVEST_NODE_HIDDEN, compassPin)
end

function Detection:OnUpdatePinTypeHandler()
	
	-- don't do anything, if there are no unknown pins
	if not next(self.unknownPinTypeCompassPins) then return end
	
	local container = self.container
	
	for i = 1, container:GetNumCenterOveredPins() do
		if container:GetCenterOveredPinType(i) == MAP_PIN_TYPE_HARVEST_NODE then
			local interactableName = container:GetCenterOveredPinDescription(i)
			local pinTypeId = PinTypes:GetPinTypeIdFromInteractableName(interactableName)
			if pinTypeId then
				local _, level = container:GetCenterOveredPinLayerAndLevel(i)
				local matchingControl = nil
				for _, control in pairs(self.unknownPinTypeCompassPins) do
					if control:GetDrawLevel() == level then
						local relativeX = 2 * (control:GetCenter() - container:GetLeft()) / container:GetWidth() - 1.0
						if relativeX < 0.14 then
							-- if there is more than one matching control, then we can not
							-- know which of the two is the correct one
							if matchingControl then
								matchingControl = nil
								break
							end
							matchingControl = control
						end
					end
				end
				
				if matchingControl and matchingControl.pinTypeId ~= pinTypeId then
					matchingControl.pinTypeId = pinTypeId
					self.unknownPinTypeCompassPins[matchingControl.id] = nil
					CallbackManager:FireCallbacks(Events.HARVEST_NODE_PINTYPE_UPDATED, matchingControl, pinTypeId)
				end
			end
		end
	end
	
end

function Detection.OnUpdateNodeListHandler()
	if not Lib3D:IsValidZone() then return end
	if ZO_CompassContainer:IsHidden() then return end
	local camX, camZ, camY, forwardX, forwardZ, forwardY, rightX, rightZ, rightY = Lib3D:GetCameraRenderSpace()
	camX, camZ, camY = GuiRender3DPositionToWorldPosition(camX, camZ, camY)
	camX, camZ, camY = camX / 100, camZ / 100, camY / 100
	
	for _, control in pairs(Detection.unknownPositionCompassPins) do
		
		local relativeX = 2 * (control:GetCenter() - ZO_CompassContainer:GetLeft()) / ZO_CompassContainer:GetWidth() - 1.0
		local cotangent = Detection.ComputeCotangent(relativeX)
		local distance = (2-control:GetScale()) * 100
		-- Pins on the far right/left of the compass do not yield accurate
		-- information about the node position, in that case the cotangent is nil.
		-- If the distance is too large, then any error is amplified.
		-- If the alpha value is too small, then the compass just became visible
		-- and the measurements are not very accurate.
		if cotangent and distance < 190 and control:GetAlpha() >= 0.99 then
			
			-- compute direction in which the resource lies
			local forwardLength = (forwardX^2 + forwardY^2)^0.5
			local dirX = forwardX / forwardLength + rightX * cotangent
			local dirY = forwardY / forwardLength + rightY * cotangent
			local dirLength = (dirX^2 + dirY^2)^0.5
			dirX = dirX / dirLength
			dirY = dirY / dirLength
			
			control.cotangent = cotangent
			-- line information
			control.dirX = dirX
			control.dirY = dirY
			control.camX = camX
			control.camY = camY
			-- plane information
			control.normalX = dirY
			control.normalY = -dirX
			control.offset = camX * control.normalX + camY * control.normalY
			
			local index = control.lastPositionIndex + 1
			control.lastPositionIndex = index
			
			local worldX = camX + dirX * distance
			local worldY = camY + dirY * distance
			
			control.worldX[index] = worldX
			control.worldY[index] = worldY
			if index >= 3 then
				-- if the last 3 measurements are close to each other,
				-- then the position is accurate enough
				local sumX = 0
				local sumY = 0
				for i = index - 2, index do
					sumX = sumX + control.worldX[i] / 3
					sumY = sumY + control.worldY[i] / 3
				end
				local isValid = true
				local dx, dy
				for i = index - 2, index do
					dx = sumX - control.worldX[i]
					dy = sumY - control.worldY[i]
					if dx * dx + dy * dy > 9 then -- max 3m apart
						isValid = false
						break
					end
				end
				if isValid then
					Detection.knownPositionCompassPins[control.id] = control
					Detection.unknownPositionCompassPins[control.id] = nil
					control.worldX = worldX
					control.worldY = worldY
					control.globalX, control.globalY = Lib3D:WorldToGlobal(worldX, worldY)
					CallbackManager:FireCallbacks(Events.HARVEST_NODE_LOCATION_UPDATED, control)
				end
			end
			
		end
	end
end

-- the code below is a PITA
-- I tried really hard to reverse engineer ZOS' compass position function
-- ... I was not able to find some closed form :(
-- Now I just use some linear interpolation instead

local offset = 0.005

local coords = {
	offset,
	--0.0051947677,
	0.0159936977,
	0.0399850114,
	0.0675543836,
	0.1022636077,
	0.1356943180,
	0.1749565977,
	0.2152086055,
	0.2375973271,
	0.2634134230,
	0.3065370230,
	0.3354407635,
	0.3526835132,
	0.3778287424,
	0.3971341160,
	0.4208228338,
	0.4376307170,
	0.4565601474,
	0.4786610039,
	0.4972964314,
	0.5233592688,
	0.5512536401,
	0.5756193626,
	0.5955185730,
	0.6223989718,
	0.6438041032,
	0.6609244029,
	0.6719013304,
	0.6857532260,
	0.7023932390,
	0.7188300893,
	0.7360068572,
	0.7510755812,
	0.7622510681,
	0.7723987723,
	0.7851793065,
	0.7969084273,
	0.8040602479,
	0.8190850862,
	0.8286816117,
	0.8441680162,
	0.8560241905,
	0.8652220627,
	0.8792307803,
	0.8913809575,
	0.8993693668,
	0.9135220169,
	0.9204875538,
	0.9334408684,
	0.9431641405,
	0.9556390098,
	0.9635641993,
	0.9727795644,
	0.9769775456,
	0.9852679370,
	0.9907161979,
	0.9967693437
}

local cotangents = {
	0.0,
  -- -0.0004722493,
	0.0085273034,
	0.0285333869,
	0.0515696229,
	0.0806963688,
	0.1089478714,
	0.1424698159,
	0.1773397682,
	0.1970044971,
	0.2199598529,
	0.2590834413,
	0.2859391355,
	0.3022354622,
	0.3264079847,
	0.3453245844,
	0.3690022725,
	0.3861396535,
	0.4058039954,
	0.4292895232,
	0.4495709557,
	0.4787399772,
	0.5111067515,
	0.5404631615,
	0.5652689374,
	0.6000939111,
	0.6290229445,
	0.6530064915,
	0.6688099199,
	0.6892637656,
	0.7146379784,
	0.7406365624,
	0.7688877909,
	0.7946643060,
	0.8144304050,
	0.8328914282,
	0.8568829405,
	0.8796816632,
	0.8939722234,
	0.9250310727,
	0.9456528901,
	0.9803411060,
	1.0081780907,
	1.0306066431,
	1.0662892661,
	1.0988650428,
	1.1211842878,
	1.1626498188,
	1.1840383319,
	1.2257112395,
	1.2587682683,
	1.3036665641,
	1.3337922969,
	1.3705564259,
	1.3879692677,
	1.4236807059,
	1.4481727585,
	1.4764147356,
}

-- compute cotangent (ratio of right/forward) based on
-- relative position of the pin on the compass
-- returns nil if computation failed
function Detection.ComputeCotangent(relativeX)
	-- I tried reverse engineering ZOS' function
	-- it looks a bit like arctan or sigmoid but neither of them fits
	-- so instead i just create a piecewise linear interpolation based on measurements
	local sign = 1
	if relativeX < 0 then
		sign = -1
		relativeX = -relativeX
	end
	relativeX = relativeX + offset
	for i = 2, #coords do
		if coords[i] >= relativeX then
			local max = coords[i] - coords[i-1]
			local value = relativeX - coords[i-1]
			local t = value / max
			return ((1-t) * cotangents[i-1] + t * cotangents[i]) * sign
		end
	end
	return nil
end

function Detection.ComputeRatio(cotangent)
	-- I tried reverse engineering ZOS' function
	-- it looks a bit like arctan or sigmoid but neither of them fits
	-- so instead i just create a piecewise linear interpolation based on measurements
	local sign = 1
	if cotangent < 0 then
		sign = -1
		cotangent = -cotangent
	end
	for i = 2, #cotangents do
		if cotangents[i] >= cotangent then
			local max = cotangents[i] - cotangents[i-1]
			local value = cotangent - cotangents[i-1]
			local t = value / max
			return ((1-t) * coords[i-1] + t * coords[i] - offset) * sign
		end
	end
	return nil
end
