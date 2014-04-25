-- Originally 6 changed to 9 adding (7)solvents, (8)containers, (9)fish, (10)book
Harvest.defaultMapLayouts = {
        { level = 20, texture = "HarvestMap/Textures/Map/mining.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/clothing.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/enchanting.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/alchemy.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/wood.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/chest.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/solvent.dds", size = 20, color = {1, 1, 1} },
        { level = 20, texture = "HarvestMap/Textures/Map/fish.dds", size = 20, color = {1, 1, 1} },
    }

function Harvest.addCallback( profession, g_mapPinManager )
    if not Harvest.settings.filters[ profession ] then
        return
    end
    local zone = Harvest.GetMap()
    local nodes = Harvest.nodes.data[ zone ]
    local pinType = Harvest.GetPinType( profession )

    if not nodes then
        return
    end

    nodes = nodes[ profession ]
    if not nodes then
        return
    end
    for _, node in pairs( nodes ) do
        g_mapPinManager:CreatePin( _G[pinType], node, node[1], node[2] )
    end
end

Harvest.tooltipCreator = {
    creator = function( pin )
        for _, name in ipairs(pin.m_PinTag[3]) do
            if Harvest.nodeLocalization[name] then
                InformationTooltip:AddLine( Harvest.nodeLocalization[name] )
            else
                InformationTooltip:AddLine( name )
            end
        end
    end,
    tooltip = InformationTooltip
}

function Harvest.GetPinType( profession )
    return "HrvstPin" .. profession
end

function Harvest.CreateMapPin(profession)

    if Harvest.settings.verbose then 
        d(Harvest.settings)
        d(Harvest.settings.mapLayouts)
        d(Harvest.settings.mapLayouts[ profession ])
    end

    local pinType = Harvest.GetPinType( profession )
    ZO_WorldMap_AddCustomPin(
        pinType,
        function( g_mapPinManager )
            Harvest.addCallback( profession, g_mapPinManager )
        end,
        nil,
        Harvest.settings.mapLayouts[ profession ],
        Harvest.tooltipCreator
    )

    ZO_WorldMap_SetCustomPinEnabled( _G[pinType], true )
end

local oldData = ZO_MapPin.SetData
ZO_MapPin.SetData = function( self, pinTypeId, pinTag)
    local back = GetControl(self.m_Control, "Background")
    local color
    -- for profession = 1,6 do
    for profession = 1,8 do
        if pinTypeId == _G[Harvest.GetPinType( profession )] then
            color = Harvest.settings.mapLayouts[ profession ].color
            back:SetColor( color[1], color[2], color[3], 1)
            break
        end
    end

    if not color then
        back:SetColor( 1, 1, 1, 1 )
    end

    oldData(self, pinTypeId, pinTag)
end

function Harvest.InitializeMapMarkers()
    -- for profession = 1,6 do
    for profession = 1,8 do
        Harvest.CreateMapPin( profession )
    end
end