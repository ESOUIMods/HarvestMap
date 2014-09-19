local LMP = LibStub("LibMapPins-1.0")

-- Originally 6 changed to 8 adding (7)solvents, (8)fish
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

function Harvest.addCallback( profession )
    if not Harvest.savedVars["settings"].filters[ profession ] then
        return
    end
    --d("Profession : " .. profession )
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
    for key, item in ipairs( nodes ) do
        local node = type(item) == "string" and Harvest.Deserialize(item) or item
        LMP:CreatePin( pinType, node, node[1], node[2] )
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

    if Harvest.defaults.verbose then
        d(Harvest.settings)
        d(Harvest.savedVars["settings"].mapLayouts)
        d(Harvest.savedVars["settings"].mapLayouts[ profession ])
    end

    local pinType = Harvest.GetPinType( profession )

    LMP:AddPinType(
        pinType,
        function( g_mapPinManager )
            Harvest.addCallback( profession )
        end,
        nil,
        Harvest.savedVars["settings"].mapLayouts[ profession ],
        Harvest.tooltipCreator
    )

    LMP:AddPinFilter(
        pinType,
        Harvest.localization[ "filter"..profession ],
        false,
        Harvest.savedVars["settings"].filters,
        profession,
        nil
    )

end

function Harvest.InitializeMapMarkers()
    for profession = 1,8 do
        Harvest.CreateMapPin( profession )
    end
end
