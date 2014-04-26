local maxDistance = 0.02

function Harvest.additionalLayout( pin )
    if pin ~= nil and COMPASS_PINS.pinLayouts[ pin.pinType ].color ~= nil then
        local color = COMPASS_PINS.pinLayouts[ pin.pinType ].color
        local tex = pin:GetNamedChild( "Background" )
        tex:SetColor(color[1] , color[2] , color[3], 1)
    else
        Harvest.additionalLayoutReset( pin )
    end
end

function Harvest.additionalLayoutReset( pin )
    local tex = pin:GetNamedChild( "Background" )
    tex:SetColor( 1, 1, 1, 1 )
end

-- Originally 6 changed to 8 adding (7)solvents, (8)fish
Harvest.defaultCompassLayouts = {
[1] = {texture = "HarvestMap/Textures/Compass/mining.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[2] = {texture = "HarvestMap/Textures/Compass/clothing.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[3] = {texture = "HarvestMap/Textures/Compass/enchanting.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[4] = {texture = "HarvestMap/Textures/Compass/alchemy.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[5] = {texture = "HarvestMap/Textures/Compass/wood.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[6] = {texture = "HarvestMap/Textures/Compass/chest.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[7] = {texture = "HarvestMap/Textures/Compass/solvent.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
[8] = {texture = "HarvestMap/Textures/Compass/fish.dds", maxDistance = maxDistance, color = {1, 1, 1}, additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset} },
}

function Harvest.addCompassCallback( profession, g_mapPinManager )
    if not Harvest.settings.filters[ profession ] or not Harvest.settings.compass then
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
        g_mapPinManager:CreatePin( pinType, node, node[1], node[2] )
    end
end

function Harvest.CreateCompassPin(profession)
    if not Harvest.settings.filters[ profession ] then
        return
    end
    local pinType = Harvest.GetPinType( profession )

    COMPASS_PINS:AddCustomPin(
        pinType,
        function( g_mapPinManager )
            Harvest.addCompassCallback( profession, g_mapPinManager )
        end,
        Harvest.settings.compassLayouts[ profession ]
    )
end

function Harvest.InitializeCompassMarkers()
    for _, layout in pairs(Harvest.settings.compassLayouts) do
        layout.additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset}
    end
    -- for profession = 1,6 do
    for profession = 1,8 do
        Harvest.CreateCompassPin( profession )
    end
    COMPASS_PINS:RefreshPins()
end