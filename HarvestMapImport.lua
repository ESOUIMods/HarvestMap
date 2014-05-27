function Harvest.importFromEsohead()
    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0

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
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    if not Harvest.IsValidContainerOnImport(node[4]) then -- << Not a Container
                        if Harvest.CheckProfessionTypeOnImport(node[5], node[4]) then -- << If Valid Profession Type
                            professionFound = Harvest.GetProfessionType(node[5], node[4])
                            if professionFound >= 1 then
                                -- When import filter is false do NOT import the node
                                if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                                    Harvest.saveData( newMapName, node[1], node[2], professionFound, node[4], node[5] )
                                else
                                    -- d("skipping Node : " .. node[4] .. " : ID : " .. tostring(node[5]))
                                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                                end
                            end
                        else -- << If Valid Profession Type
                            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
                            -- d("Node:" .. node[4] .. " ItemID " .. tostring(node[5]) .. " skipped")
                        end -- << If Valid Profession Type
                    else -- << Not a Container
                        Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                        -- d("Container :" .. node[4] .. " ItemID " .. tostring(node[5]) .. " skipped")
                    end -- << Not a Container
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
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ 6 ] then
                    Harvest.saveData( newMapName, node[1], node[2], 6, "chest", nil )
                else
                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                end
            end
        end
    end

    d("Import Fishing Holes:")
    for map, nodes in pairs(EH.savedVars["fish"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- Esohead "fish" has nodes only, add appropriate data
                -- The 8 before "fish" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ 8 ] then
                    Harvest.saveData( newMapName, node[1], node[2], 8, "fish", nil )
                else
                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                end
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of nodes filtered : " .. tostring(Harvest.NumbersNodesFiltered) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromHarvester()
    Harvest.NumNodesProcessed = 0
    Harvest.NumbersNodesAdded = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

    if not Harvester then
        d("Please enable the Harvester addon to import data!")
        return
    end

    d("import data from Harvester")
    local profession
    local newMapName
    -- if not Harvest.oldData then
    --     Harvest.oldData = {}
    -- end

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
    for map, data in pairs(Harvester.savedVars["harvest"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    professionFound = Harvest.GetProfessionType(node[5], node[4])

                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    if not Harvest.IsValidContainerOnImport(node[4]) then -- << Not a Container
                        if Harvest.CheckProfessionTypeOnImport(node[5], node[4]) then -- << Check Profession Type
                            Harvest.NumbersNodesAdded = Harvest.NumbersNodesAdded + 1
                            Harvest.saveData("harvest", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                        else -- << Invalid Profession Type
                            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
                            Harvest.saveData("mapinvalid", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                        end
                    else -- << Container
                        Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                        Harvest.saveData("mapinvalid", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                    end
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for index, nodes in pairs(data) do
                for v1, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    professionFound = Harvest.GetProfessionType(node[5], node[4])
                    --d(node[1] .. node[2] .. node[3] .. node[4] .. node[5])

                    -- 1) type 2) nodes (MapName) 3) x 4) y 5) scale 6) name)
                    if professionFound >= 1 then
                        dupeNode = Harvest.LogCheck("esoharvest",  {map, professionFound}, node[1], node[2], nil, node[4])
                        if not dupeNode then
                            Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                            Harvest.Log("esoharvest", {map, professionFound}, node[1], node[2], node[3], node[4], node[5])
                        end
                    else -- << Invalid Profession Type
                        dupeNode = Harvest.LogCheck("esoinvalid",  {map, professionFound}, node[1], node[2], nil, node[4])
                        if not dupeNode then
                            Harvest.NumUnlocalizedFalseNodes = Harvest.NumUnlocalizedFalseNodes + 1
                            Harvest.Log("esoinvalid", {map, professionFound}, node[1], node[2], node[3], node[4], node[5])
                        end
                    end
                end
            end
        end
    end

    d("Import Chests:")
    for map, nodes in pairs(Harvester.savedVars["chest"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.NumbersNodesAdded = Harvest.NumbersNodesAdded + 1
                -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                Harvest.saveData("chest", newMapName, node[1], node[2], Harvest.chestID, "chest", nil, Harvest.minReticleover )
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) type 2) nodes (MapName) 3) x 4) y 5) scale 6) name)
                dupeNode = Harvest.LogCheck("esochest", { map }, node[1], node[2], Harvest.minReticleover, nil)
                if not dupeNode then
                    Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                    Harvest.Log("esochest", { map }, node[1], node[2])
                end
            end
        end
    end

    d("Import Fishing Holes:")
    for map, nodes in pairs(Harvester.savedVars["fish"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.NumbersNodesAdded = Harvest.NumbersNodesAdded + 1
                -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                Harvest.saveData("fish", newMapName, node[1], node[2], Harvest.fishID, "fish", nil, Harvest.minReticleover )
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) type 2) nodes (MapName) 3) x 4) y 5) scale 6) name)
                dupeNode = Harvest.LogCheck("esofish", { map }, node[1], node[2], Harvest.minReticleover, nil)
                if not dupeNode then
                    Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                    Harvest.Log("esofish", { map }, node[1], node[2])
                end
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False Nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Number of Unlocalized nodes saved : " .. tostring(Harvest.NumbersUnlocalizedNodesAdded) )
    d("Number of Unlocalized False Nodes skipped : " .. tostring(Harvest.NumUnlocalizedFalseNodes) )
    d("Finished.")
    Harvest.RefreshPins()
end