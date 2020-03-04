local LMP = LibStub("LibMapPins-1.0")

if not Harvest then
	Harvest = {}
end

function Harvest.AddMapPinCallback( pinTypeId )
    if not Harvest.IsPinTypeVisible( pinTypeId ) then
        return
    end
    -- data is still being manipulated, better if we don't access it yet
    if not Harvest.IsUpdateQueueEmpty() then
        return
    end
    local map = Harvest.GetMap()
    local nodes = Harvest.GetNodesOnMap( map, pinTypeId )
    local pinType = Harvest.GetPinType( pinTypeId )
    local pinData = LMP.pinManager.customPins[_G[pinType]]
    LMP.pinManager:RemovePins(pinData.pinTypeString)
    Harvest.mapCounter[pinType] = Harvest.mapCounter[pinType] + 1
    Harvest.AddPinsLater(Harvest.mapCounter[pinType], pinType, nodes, nil)
end

function Harvest.AddPinsLater(counter, pinType, nodes, index)
    -- map was changed while new pins are still being added
    -- abort adding new pins!
    if counter ~= Harvest.mapCounter[pinType] then
        return
    end

    if not Harvest.IsPinTypeVisible_string( pinType ) then
        Harvest.mapCounter[pinType] = 0
        return
    end

    -- data is still being manipulated, better if we don't access it yet
    if not Harvest.IsUpdateQueueEmpty() then
        Harvest.mapCounter[pinType] = 0
        return
    end
    
    local node = nil
    for counter = 1,10 do
        index, node = next(nodes, index)
        if index == nil then
            Harvest.mapCounter[pinType] = 0
            return
        end
        LMP:CreatePin( pinType, node, node[1], node[2] )
    end
    if FyrMM then
        Harvest.AddPinsLater(counter, pinType, nodes, index)
    else
        zo_callLater(function() Harvest.AddPinsLater(counter, pinType, nodes, index) end, 0.1)
    end
end

Harvest.tooltipCreator = {
    creator = function( pin )
        for _, name in pairs( pin.m_PinTag[3] ) do
            InformationTooltip:AddLine( Harvest.GetLocalizedNodeName( name ) )
        end
    end,
    tooltip = 1
}

function Harvest.InitializeMapPinType( pinTypeId )
    local pinType = Harvest.GetPinType( pinTypeId )

    LMP:AddPinType(
        pinType,
        function( g_mapPinManager )
            Harvest.AddMapPinCallback( pinTypeId )
        end,
        nil,
        Harvest.GetMapPinLayout( pinTypeId ),
        Harvest.tooltipCreator
    )

    LMP:AddPinFilter(
        pinType,
        Harvest.GetLocalizedPinFilter( pinTypeId ),
        false,
        Harvest.savedVars["settings"].isPinTypeVisible
    )

end

local nameFun = function(pin)
    local str = ""
    if not IsInGamepadPreferredMode() then str = "Delete Pin: " end
    for _, name in pairs( pin.m_PinTag[3] ) do
        str = str .. Harvest.GetLocalizedNodeName( name ) .. " "
    end
    return str
end

Harvest.debugHandler = {
    {
        name = nameFun,
        callback = function(pin)
            if not Harvest.IsDebugEnabled() or IsInGamepadPreferredMode() then
                for _,pinTypeId in ipairs( Harvest.PINTYPES ) do
                    local pinType = Harvest.GetPinType( pinTypeId )
                    LMP:SetClickHandlers(pinType, nil, nil)
                end
                return
            end
            local pinType, pinTag = pin:GetPinTypeAndTag()
            pinType = LMP.pinManager.customPins[pinType].pinTypeString
            local pinTypeId = Harvest.GetPinId( pinType )
            --LMP:RemoveCustomPin( pinType, pinTag )
            local map = Harvest.GetMap()
            local saveFile = Harvest.GetSaveFile( map )
            for i, node in pairs( Harvest.cache[ map ][ pinTypeId ]) do
                if node == pinTag then
                    LMP:RemoveCustomPin( pinType, pinTag )
                    saveFile.data[ map ][ pinTypeId ][ i ] = nil
                    Harvest.cache[ map ][ pinTypeId ][ i ] = nil
                    return
                end
            end

        end,
        show = function() return true end,
        duplicates = function(pin1, pin2) return not Harvest.IsDebugEnabled() end,
        gamepadName = nameFun
    }
}

function Harvest.InitializeMapMarkers()
    for pinTypeId in ipairs( Harvest.PINTYPES ) do
        Harvest.InitializeMapPinType( pinTypeId )
    end

    LMP:AddPinType(
        Harvest.GetPinType( "Debug" ),
        function( g_mapPinManager ) --gets called when debug is enabled
            if IsInGamepadPreferredMode() then
                for _,pinTypeId in ipairs( Harvest.PINTYPES ) do
                    local pinType = Harvest.GetPinType( pinTypeId )
                    LMP:SetClickHandlers(pinType, nil, nil)
                end
                return
            end
            for _,pinTypeId in ipairs( Harvest.PINTYPES ) do
                local pinType = Harvest.GetPinType( pinTypeId )
                LMP:SetClickHandlers(pinType, Harvest.debugHandler, nil)
            end
        end,
        nil,
        Harvest.GetMapPinLayout( 1 ),
        Harvest.tooltipCreator
    )
    -- debug pin type. when enabled clicking on pins deletes them
    LMP:AddPinFilter(
        Harvest.GetPinType( "Debug" ),
        "HarvestMap debug mode",
        false,
        Harvest.savedVars["settings"].isPinTypeVisible
    )

end
