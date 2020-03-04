if not Harvest then
	Harvest = {}
end

function Harvest.additionalLayout( pin )
    local color = COMPASS_PINS.pinLayouts[ pin.pinType ].color
    if not color then
    --    d("The Pin Type : " .. pin.pinType )
        return
	end

    local tex = pin:GetNamedChild( "Background" )
    tex:SetColor(color[1] , color[2] , color[3], 1)
end

function Harvest.additionalLayoutReset( pin )
    local tex = pin:GetNamedChild( "Background" )
    tex:SetColor( 1, 1, 1, 1 )
end


function Harvest.AddCompassCallback( pinTypeId, g_mapPinManager )
    if not Harvest.IsPinTypeVisible(pinTypeId) or not Harvest.AreCompassPinsVisible() then
        return
    end
    -- data is still being manipulated, better if we don't access it yet
    if not Harvest.IsUpdateQueueEmpty() then
        return
    end
    local map = Harvest.GetMap()
    local nodes = Harvest.GetNodesOnMap( map, pinTypeId )
    local pinType = Harvest.GetPinType( pinTypeId )

    Harvest.compassCounter[pinType] = Harvest.compassCounter[pinType] + 1
    Harvest.AddCompassPinsLater(Harvest.compassCounter[pinType], g_mapPinManager, pinType, nodes, nil)
end

function Harvest.AddCompassPinsLater(counter, g_mapPinManager, pinType, nodes, index)
    if counter ~= Harvest.compassCounter[pinType] then
        return
    end

	if not Harvest.IsPinTypeVisible_string( pinType ) then
		Harvest.compassCounter[pinType] = 0
		return
	end

    -- data is still being manipulated, better if we don't access it yet
    if not Harvest.IsUpdateQueueEmpty() then
        Harvest.compassCounter[pinType] = 0
        return
    end

    local node = nil
    for counter = 1,10 do
        index, node = next(nodes, index)
        if index == nil then
            Harvest.compassCounter[pinType] = 0
            return
        end
        g_mapPinManager:CreatePin( pinType, node, node[1], node[2] )
    end
    zo_callLater(function() Harvest.AddCompassPinsLater(counter, g_mapPinManager, pinType, nodes, index) end, 0.1)
end

function Harvest.InitializeCompassPinType( pinTypeId )
    local pinType = Harvest.GetPinType( pinTypeId )

    COMPASS_PINS:AddCustomPin(
        pinType,
        function( g_mapPinManager )
            Harvest.AddCompassCallback( pinTypeId, g_mapPinManager )
        end,
        Harvest.GetCompassPinLayout( pinTypeId )
    )
end

function Harvest.InitializeCompassMarkers()
    -- initialize each compass pin type
    for pinType in ipairs( Harvest.PINTYPES ) do
        Harvest.InitializeCompassPinType( pinType )
    end
    COMPASS_PINS:RefreshPins()
end


