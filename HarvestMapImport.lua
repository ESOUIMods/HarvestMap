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
    -- if not Harvest.nodes.oldData then
    --    Harvest.nodes.oldData = {}
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
    for map, data in pairs(EH.savedVars["harvest"].data) do
        d("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    professionFound = Harvest.GetProfessionType(node[5], node[4])
                    if not Harvest.IsValidContainerOnImport(node[4]) then -- << Not a Container
                        if Harvest.CheckProfessionTypeOnImport(node[5], node[4]) then -- << If Valid Profession Type
                            if professionFound >= 1 then
                                -- When import filter is false do NOT import the node
                                if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                                    Harvest.saveData("nodes", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                                else
                                    -- d("skipping Node : " .. node[4] .. " : ID : " .. tostring(node[5]))
                                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                                end
                            end
                        else -- << If Valid Profession Type
                            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
                            Harvest.saveData("mapinvalid", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                            -- d("Node:" .. node[4] .. " ItemID " .. tostring(node[5]) .. " skipped")
                        end -- << If Valid Profession Type
                    else -- << Not a Container
                        Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                        Harvest.saveData("mapinvalid", newMapName, node[1], node[2], professionFound, node[4], node[5], nil )
                        -- d("Container :" .. node[4] .. " ItemID " .. tostring(node[5]) .. " skipped")
                    end -- << Not a Container
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    professionFound = Harvest.GetProfessionType(node[5], node[4])
                    if Harvest.CheckProfessionTypeOnImport(node[5], node[4]) then
                        if professionFound <= 0 then
                            professionFound = profession
                        end
                        -- When import filter is false do NOT import the node
                        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                            -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                            Harvest.saveData("esonodes", map, node[1], node[2], professionFound, node[4], node[5], nil )
                        end
                    else
                        if professionFound <= 0 then
                            professionFound = profession
                        end
                        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                            -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                            Harvest.saveData("esoinvalid", map, node[1], node[2], professionFound, node[4], node[5], nil )
                        end
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
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("nodes", newMapName, node[1], node[2], Harvest.chestID, "chest", nil, Harvest.minReticleover )
                else
                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                end
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("esonodes", map, node[1], node[2], Harvest.chestID, "chest", nil, Harvest.minReticleover )
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
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("nodes", newMapName, node[1], node[2], Harvest.fishID, "fish", nil, Harvest.minReticleover )
                else
                    Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
                end
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                -- Esohead "chest" has nodes only, add appropriate data
                -- The 6 before "chest" refers to it's Profession ID
                -- When import filter is false do NOT import the node
                if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("esonodes", map, node[1], node[2], Harvest.fishID, "fish", nil, Harvest.minReticleover )
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

function Harvest.importFromHarvestMerge()
    Harvest.NumNodesProcessed = 0
    Harvest.NumbersNodesAdded = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

    if not HarvestMerge then
        d("Please enable the HarvestMerge addon to import data!")
        return
    end

    d("import data from HarvestMerge")
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
    for map, data in pairs(HarvestMerge.savedVars["harvest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    for _, nodeName in ipairs(node[3]) do
                        --d(newMapName .. " : " .. node[1] .. " : " .. node[2] .. " : " .. index .. " : " .. nodeName)
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1

                        if node[4] == nil then
                            -- Get the profession, 7 if solvent and -1 if not found
                            ProfessionOnUpdate = Harvest.GetProfessionTypeOnUpdate(nodeName)
                            if not Harvest.IsValidContainerOnImport(nodeName) then -- << Not a Container
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = profession
                                end
                                -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                                Harvest.saveData("nodes", newMapName, node[1], node[2], ProfessionOnUpdate, nodeName, nil, nil )
                            else -- << Container
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = profession
                                end
                                Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                                Harvest.saveData("mapinvalid", newMapName, node[1], node[2], ProfessionOnUpdate, nodeName, nil, nil )
                            end
                        else -- node[4] which is the ItemID should not be nil at this point
                            -- << Not a Container and a valid item i.e not a Bottle
                            ProfessionOnUpdate = Harvest.GetProfessionTypeOnUpdate(nodeName)
                            if not Harvest.IsValidContainerOnImport(nodeName) then -- << Not a Container
                                -- << a valid item i.e not a Bottle or Crate, or it is a Solvent
                                if Harvest.CheckProfessionTypeOnImport(node[4], nodeName) then
                                    Harvest.saveData("nodes", newMapName, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                                else
                                    if ProfessionOnUpdate <= 0 then
                                        ProfessionOnUpdate = Harvest.GetProfessionType(node[4], nodeName)
                                    end
                                    if ProfessionOnUpdate <= 0 then
                                        ProfessionOnUpdate = profession
                                    end
                                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                                    Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
                                    Harvest.saveData("mapinvalid", newMapName, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                                end
                            else -- << Container
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = Harvest.GetProfessionType(node[4], nodeName)
                                end
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = profession
                                end
                                Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                                Harvest.saveData("mapinvalid", newMapName, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                            end
                        end

                    end
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    for _, nodeName in ipairs(node[3]) do
                        ProfessionOnUpdate = Harvest.GetProfessionTypeOnUpdate(nodeName)
                        if not Harvest.IsValidContainerOnImport(nodeName) then
                            if Harvest.CheckProfessionTypeOnImport(node[4], nodeName) then
                                -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                                Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                                Harvest.saveData("esonodes", map, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                            else
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = Harvest.GetProfessionType(node[4], nodeName)
                                end
                                if ProfessionOnUpdate <= 0 then
                                    ProfessionOnUpdate = profession
                                end
                                Harvest.NumUnlocalizedFalseNodes = Harvest.NumUnlocalizedFalseNodes + 1
                                Harvest.saveData("esoinvalid", map, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                            end
                        else -- << Container
                            if ProfessionOnUpdate <= 0 then
                                ProfessionOnUpdate = Harvest.GetProfessionType(node[4], nodeName)
                            end
                            if ProfessionOnUpdate <= 0 then
                                ProfessionOnUpdate = profession
                            end
                            Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
                            Harvest.saveData("esoinvalid", map, node[1], node[2], ProfessionOnUpdate, nodeName, node[4], nil )
                        end
                    end
                end
            end
        end

    end

    d("Import Chests:")
    for map, data in pairs(HarvestMerge.savedVars["chest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("nodes", newMapName, node[1], node[2], Harvest.chestID, "chest", nil, Harvest.minReticleover )
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("esoinvalid", newMapName, node[1], node[2], Harvest.chestID, "chest", nil, Harvest.minReticleover )
                end
            end
        end
    end

    d("Import Fishing Holes:")
    for map, data in pairs(HarvestMerge.savedVars["fish"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("nodes", newMapName, node[1], node[2], Harvest.fishID, "fish", nil, Harvest.minReticleover )
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
                    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
                    Harvest.saveData("esoinvalid", newMapName, node[1], node[2], Harvest.fishID, "fish", nil, Harvest.minReticleover )
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