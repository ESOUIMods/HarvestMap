function Harvest.newMapNameFishChest(type, newMapName, x, y)
    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
        if type == "fish" then
            if not Harvest.savedVars["settings"].importFilters[ Harvest.fishID ] then
                Harvest.saveData("nodes", newMapName, x, y, Harvest.fishID, type, nil, Harvest.minReticleover )
            else
                Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
            end
        elseif type == "chest" then
            if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
                Harvest.saveData("nodes", newMapName, x, y, Harvest.chestID, type, nil, Harvest.minReticleover )
            else
                Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
            end
        else
            d("unsupported type : " .. type)
        end
end
function Harvest.oldMapNameFishChest(type, oldMapName, x, y)
    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if type == Harvest.chestID then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
            Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded +1
            Harvest.saveData("esonodes", oldMapName, x, y, Harvest.chestID, "chest", nil, Harvest.minReticleover )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    elseif type == Harvest.fishID then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.fishID ] then
            Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded +1
            Harvest.saveData("esonodes", oldMapName, x, y, Harvest.fishID, "fish", nil, Harvest.minReticleover )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    else
        d("unsupported type : " .. type)
    end
end

function Harvest.newMapNilItemIDHarvest(newMapName, x, y, profession, nodeName)
    local professionFound
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = profession
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerOnImport(nodeName) then
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.saveData("nodes", newMapName, x, y, professionFound, nodeName, nil, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    else
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.NumContainerSkipped = Harvest.NumContainerSkipped +1
            Harvest.saveData("mapinvalid", newMapName, x, y, professionFound, nodeName, nil, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    end
end

function Harvest.oldMapNilItemIDHarvest(oldMapName, x, y, profession, nodeName)
    local professionFound
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = profession
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerOnImport(nodeName) then
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded +1
            Harvest.saveData("esonodes", oldMapName, x, y, professionFound, nodeName, nil, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    else
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.NumContainerSkipped = Harvest.NumContainerSkipped +1
            Harvest.saveData("esoinvalid", oldMapName, x, y, professionFound, nodeName, nil, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    end
end

function Harvest.newMapItemIDHarvest(newMapName, x, y, profession, nodeName, itemID)
    local professionFound = 0
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = Harvest.GetProfessionType(itemID, nodeName)
    elseif professionFound <= 0 then
        professionFound = profession
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerOnImport(nodeName) then -- returns true or false
        if Harvest.CheckProfessionTypeOnImport(itemID, nodeName) then -- returns true or false no item Id number
            if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                Harvest.saveData("nodes", newMapName, x, y, professionFound, nodeName, itemID, nil )
            else
                Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
            end
        else
            if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
                Harvest.saveData("mapinvalid", newMapName, x, y, professionFound, nodeName, itemID, nil )
            else
                Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
            end
        end
    else
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
            Harvest.saveData("mapinvalid", newMapName, x, y, professionFound, nodeName, itemID, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    end
end

function Harvest.oldMapItemIDHarvest(oldMapName, x, y, profession, nodeName, itemID)
    local professionFound = 0
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = Harvest.GetProfessionType(itemID, nodeName)
    elseif professionFound <= 0 then
        professionFound = profession
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerOnImport(nodeName) then -- returns true or false
        if Harvest.CheckProfessionTypeOnImport(itemID, nodeName) then -- returns true or false no item Id number
            if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                Harvest.saveData("esonodes", oldMapName, x, y, professionFound, nodeName, itemID, nil )
            else
                Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
            end
        else
            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
            Harvest.saveData("esoinvalid", oldMapName, x, y, professionFound, nodeName, itemID, nil )
        end
    else
        if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
            Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
            Harvest.saveData("esoinvalid", oldMapName, x, y, professionFound, nodeName, itemID, nil )
        else
            Harvest.NumbersNodesFiltered = Harvest.NumbersNodesFiltered + 1
        end
    end
end

function Harvest.importFromEsohead()
    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

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

    d("Import Harvest Nodes:")
    for map, data in pairs(EH.savedVars["harvest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.oldMapItemIDHarvest(map, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    d("Import Chests:")
    for map, nodes in pairs(EH.savedVars["chest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    d("Import Fishing Holes:")
    for map, nodes in pairs(EH.savedVars["fish"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of nodes filtered : " .. tostring(Harvest.NumbersNodesFiltered) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Number of Unlocalized False Nodes skipped : " .. tostring(Harvest.NumbersUnlocalizedNodesAdded) )
    d("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromEsoheadMerge()
    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

    if not EHM then
        d("Please enable the EsoheadMerge addon to import data!")
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

    d("Import Harvest Nodes:")
    for map, data in pairs(EHM.savedVars["harvest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.oldMapItemIDHarvest(map, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    d("Import Chests:")
    for map, nodes in pairs(EHM.savedVars["chest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    d("Import Fishing Holes:")
    for map, nodes in pairs(EHM.savedVars["fish"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of nodes filtered : " .. tostring(Harvest.NumbersNodesFiltered) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Number of Unlocalized False Nodes skipped : " .. tostring(Harvest.NumbersUnlocalizedNodesAdded) )
    d("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromHarvester()
    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

    if not Harvester then
        d("Please enable the Harvester addon to import data!")
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

    d("Import Harvest Nodes:")
    for map, data in pairs(Harvester.savedVars["harvest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- GetProfessionType(id, name) [5] = 1187, [4] = [[Barrel]] 
                    Harvest.oldMapItemIDHarvest(map, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    d("Import Chests:")
    for map, nodes in pairs(Harvester.savedVars["chest"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    d("Import Fishing Holes:")
    for map, nodes in pairs(Harvester.savedVars["fish"].data) do
        d("import data from "..map)
        if Harvest.hasNewMapName(map) then
            newMapName = map
        else
            newMapName = Harvest.GetNewMapName(map)
        end
        if newMapName then
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
            end
        else
            d(map .. " could not be localized.  Saving to backup location!")
            for _, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of nodes filtered : " .. tostring(Harvest.NumbersNodesFiltered) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Number of Unlocalized False Nodes skipped : " .. tostring(Harvest.NumbersUnlocalizedNodesAdded) )
    d("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromHarvestMerge()
    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
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
            for profession, nodes in pairs(data) do
                for index, node in pairs(nodes) do
                    for contents, nodeName in ipairs(node[3]) do
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1

                        if node[4] == nil then
                            Harvest.newMapNilItemIDHarvest(newMapName, node[1], node[2], profession, nodeName)
                        else -- node[4] which is the ItemID should not be nil at this point
                            Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, nodeName, node[4])
                        end

                    end
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for profession, nodes in pairs(data) do
                for index, node in pairs(nodes) do
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1

                        if node[4] == nil then
                            Harvest.oldMapNilItemIDHarvest(map, node[1], node[2], profession, nodeName)
                        else -- node[4] which is the ItemID should not be nil at this point
                            Harvest.oldMapItemIDHarvest(map, node[1], node[2], profession, nodeName, node[4])
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
                    Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
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
                    Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to backup location!")
            for index, nodes in pairs(data) do
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
                end
            end
        end
    end

    d("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    d("Number of nodes added : " .. tostring(Harvest.NumbersNodesAdded) )
    d("Number of nodes filtered : " .. tostring(Harvest.NumbersNodesFiltered) )
    d("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    d("Number of False nodes skipped : " .. tostring(Harvest.NumFalseNodes) )
    d("Number of Unlocalized False Nodes skipped : " .. tostring(Harvest.NumbersUnlocalizedNodesAdded) )
    d("Finished.")
    Harvest.RefreshPins()
end