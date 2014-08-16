local maxDistance = 0.02

function Harvest.additionalLayout( pin )
    local color = COMPASS_PINS.pinLayouts[ pin.pinType ].color
    if not color then
        d("The Pin Type : " .. pin.pinType )
        return
    end
    local tex = pin:GetNamedChild( "Background" )
    tex:SetColor(color[1] , color[2] , color[3], 1)
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
    if not Harvest.savedVars["settings"].filters[ profession ] or not Harvest.defaults.compass then
        return
    end
    local zone = Harvest.GetMap()
    local nodes = Harvest.savedVars["nodes"].data[zone]
    local pinType = Harvest.GetPinType( profession )

    if not nodes then
        return
    end

    nodes = nodes[ profession ]
    if not nodes then
        return
    end
    
    for _, item in ipairs( nodes ) do
        local node = type(item) == "string" and Harvest.Deserialize(item) or item
        g_mapPinManager:CreatePin( pinType, node, node[1], node[2] )
    end
end

function Harvest.CreateCompassPin(profession)
    --if not Harvest.savedVars["settings"].filters[ profession ] then
    --    return
    --end
    local pinType = Harvest.GetPinType( profession )

    COMPASS_PINS:AddCustomPin(
        pinType,
        function( g_mapPinManager )
            Harvest.addCompassCallback( profession, g_mapPinManager )
        end,
        Harvest.savedVars["settings"].compassLayouts[ profession ]
    )
end

function Harvest.InitializeCompassMarkers()
    for _, layout in pairs(Harvest.savedVars["settings"].compassLayouts) do
        layout.additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset}
    end
    -- for profession = 1,6 do
    for profession = 1,8 do
        Harvest.CreateCompassPin( profession )
    end
    COMPASS_PINS:RefreshPins()
end
