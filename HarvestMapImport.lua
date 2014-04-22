function Harvest.importFromEsohead()
    if not EH then
        d("Please enable the Esohead addon to import data!")
        return
    end
    d("import data from Esohead")
    local profession
    local newMapName
    if not Harvest.nodes.oldData then
        Harvest.nodes.oldData = {}
    end

    -- Esohead "harvest" Profession designations
    -- 1 Mining
    -- 2 Clothing
    -- 3 Enchanting
    -- 4 Alchemy
    -- 5 Was Provisioning, moved to separate section in Esohead
    -- 6 Wood

    -- Additional HarvestMap Catagories
    -- 6 = Chest, 7 = Solvent, 8 = Fish
    
    local professionFound
    d("Import Harvest Nodes:")
    for map, data in pairs(EH.savedVars["harvest"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    professionFound = Harvest.GetProfessionType(node[5], node[4])
                    if professionFound >= 1 then
                        Harvest.saveData( newMapName, node[1], node[2], professionFound, node[4], node[5] )
                    end
                end
            end
        end
    end

    d("Import Chests:")
    for map, nodes in pairs(EH.savedVars["chest"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for _, node in pairs(nodes) do
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                Harvest.saveData( newMapName, node[1], node[2], 6, "chest", nil )
            end
        end
    end
    
    d("Import Fishing Holes:")
    for map, nodes in pairs(EH.savedVars["fish"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for _, node in pairs(nodes) do
                -- Esohead "fish" has nodes only, add appropriate data
                -- The 8 before "fish" refers to it's Profession ID
                Harvest.saveData( newMapName, node[1], node[2], 8, "fish", nil )
            end
        end
    end

    d("Finished.")
    Harvest.RefreshPins()
end

SLASH_COMMANDS["/import"] = Harvest.importFromEsohead