local LMP = LibStub("LibMapPins-1.0")

-- Originally 6 changed to 8 adding (7)solvents, (8)fish
Harvest.defaultMapLayouts = {
    [1] = { level = 20, texture = "HarvestMap/Textures/Map/mining.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [2] = { level = 20, texture = "HarvestMap/Textures/Map/clothing.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [3] = { level = 20, texture = "HarvestMap/Textures/Map/enchanting.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [4] = { level = 20, texture = "HarvestMap/Textures/Map/alchemy.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [5] = { level = 20, texture = "HarvestMap/Textures/Map/wood.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [6] = { level = 20, texture = "HarvestMap/Textures/Map/chest.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [7] = { level = 20, texture = "HarvestMap/Textures/Map/solvent.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
    [8] = { level = 20, texture = "HarvestMap/Textures/Map/fish.dds", size = 20, tint = ZO_ColorDef:New(1, 1, 1) },
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
    tooltip = 1
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

    if Harvest.savedVars["settings"].mapLayouts[ profession ].color then
        Harvest.savedVars["settings"].mapLayouts[ profession ].tint = ZO_ColorDef:New(unpack(Harvest.savedVars["settings"].mapLayouts[ profession ].color))
        Harvest.savedVars["settings"].mapLayouts[ profession ].color = nil
    else
        Harvest.savedVars["settings"].mapLayouts[ profession ].tint = ZO_ColorDef:New(Harvest.savedVars["settings"].mapLayouts[ profession ].tint)
    end

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
