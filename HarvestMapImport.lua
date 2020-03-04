function Harvest.newMapNameFishChest(type, newMapName, x, y)
    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale 9) counter
    if type == "fish" then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.fishID ] then
            Harvest.saveData("nodes", newMapName, x, y, Harvest.fishID, type, nil, Harvest.minReticleover, "valid" )
        else
            Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
        end
    elseif type == "chest" then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
            Harvest.saveData("nodes", newMapName, x, y, Harvest.chestID, type, nil, Harvest.minReticleover, "valid" )
        else
            Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
        end
    else
        Harvest.Debug("Harvest : newMapName : unsupported type : " .. type)
        Harvest.saveData("rejected", newMapName, x, y, -1, type, nil, Harvest.minReticleover, "reject" )
    end
end

function Harvest.oldMapNameFishChest(type, oldMapName, x, y)
    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale 9) counter
    if type == "fish" then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.fishID ] then
            Harvest.saveData("esonodes", oldMapName, x, y, Harvest.fishID, type, nil, Harvest.minReticleover, "nonvalid" )
        else
            Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
        end
    elseif type == "chest" then
        if not Harvest.savedVars["settings"].importFilters[ Harvest.chestID ] then
            Harvest.saveData("esonodes", oldMapName, x, y, Harvest.chestID, type, nil, Harvest.minReticleover, "nonvalid" )
        else
            Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
        end
    else
        Harvest.Debug("Harvest : oldMapName : unsupported type : " .. type)
        Harvest.saveData("rejected", oldMapName, x, y, -1, type, nil, Harvest.minReticleover, "reject" )
    end
end

function Harvest.correctItemIDandNodeName(nodeName, itemID)
    local nodeUpdated = false
    if Harvest.IsValidContainerName(nodeName) then
        return nodeName, itemID
    end
    
    if nodeName ~= nil then
        Harvest.setItemIndex(nodeName)
    end

    if nodeName == nil and itemID ~= nil then
        nodeName = Harvest.GetItemNameFromItemID(itemID)
        Harvest.setItemIndex(nodeName)
        nodeUpdated = true
    end
    
    if nodeName ~= nil and itemID == nil then
        itemID = Harvest.GetItemIDFromItemName(nodeName)
    end

    if not Harvest.CheckProfessionTypeOnImport(itemID, nodeName) then
        nodeName = Harvest.GetItemNameFromItemID(itemID)
    else
        if not nodeUpdated then
            nodeName = Harvest.translateNodeName(nodeName)
        end
    end
    return nodeName, itemID
end

function Harvest.newMapItemIDHarvest(newMapName, x, y, profession, nodeName, itemID)
    if itemID ~= nil then
        if not Harvest.checkForValidNodeID(itemID) then
            return
        end
    end
    nodeName, itemID = Harvest.correctItemIDandNodeName(nodeName, itemID)

    if nodeName == nil and itemID ~= nil then
        Harvest.saveData("unlocalnode", newMapName, x, y, profession, "NilNodeName", itemID, nil, "reject" )
        return
    elseif nodeName ~= nil and itemID == nil then
        Harvest.saveData("unlocalnode", newMapName, x, y, profession, nodeName, 0, nil, "reject" )
        return
    end

    local professionFound = 0
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = Harvest.GetProfessionType(itemID, nodeName)
    elseif professionFound <= 0 then
        professionFound = profession
    end
    if professionFound < 1 or professionFound > 8 then
        Harvest.saveData("rejected", newMapName, x, y, professionFound, nodeName, itemID, nil, "reject" )
        return
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerName(nodeName) then -- returns true or false
        if Harvest.CheckProfessionTypeOnImport(itemID, nodeName) then
            if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                Harvest.saveData("nodes", newMapName, x, y, professionFound, nodeName, itemID, nil, "valid" )
            else
                Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
            end
        else
            Harvest.saveData("mapinvalid", newMapName, x, y, professionFound, nodeName, itemID, nil, "false" )
            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
        end
    else
        Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
    end
end

function Harvest.oldMapItemIDHarvest(oldMapName, x, y, profession, nodeName, itemID)
    if itemID ~= nil then
        if not Harvest.checkForValidNodeID(itemID) then
            return
        end
    end
    nodeName, itemID = Harvest.correctItemIDandNodeName(nodeName, itemID)

    if nodeName == nil and itemID ~= nil then
        Harvest.saveData("unlocalnode", oldMapName, x, y, profession, "NilNodeName", itemID, nil, "reject" )
        return
    elseif nodeName ~= nil and itemID == nil then
        Harvest.saveData("unlocalnode", oldMapName, x, y, profession, nodeName, 0, nil, "reject" )
        return
    end

    local professionFound = 0
    professionFound = Harvest.GetProfessionTypeOnUpdate(nodeName) -- Get Profession by name only
    if professionFound <= 0 then
        professionFound = Harvest.GetProfessionType(itemID, nodeName)
    elseif professionFound <= 0 then
        professionFound = profession
    end
    if professionFound < 1 or professionFound > 8 then
        Harvest.saveData("rejected", oldMapName, x, y, professionFound, nodeName, itemID, nil, "reject" )
        return
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    if not Harvest.IsValidContainerName(nodeName) then -- returns true or false
        if Harvest.CheckProfessionTypeOnImport(itemID, nodeName) then
            if not Harvest.savedVars["settings"].importFilters[ professionFound ] then
                Harvest.saveData("esonodes", oldMapName, x, y, professionFound, nodeName, itemID, nil, "nonvalid" )
            else
                Harvest.NumNodesFiltered = Harvest.NumNodesFiltered + 1
            end
        else
            Harvest.saveData("esoinvalid", oldMapName, x, y, professionFound, nodeName, itemID, nil, "nonfalse" )
            Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
        end
    else
        Harvest.NumContainerSkipped = Harvest.NumContainerSkipped + 1
    end
end

function Harvest.importFromEsohead()
    Harvest.NumNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumUnlocalizedNodesAdded = 0
    Harvest.NumRejectedNodes = 0
    Harvest.NumInsertedNodes = 0
    Harvest.NumMapFiltered = 0

    if not EH then
        Harvest.Debug("Please enable the Esohead addon to import data!")
        return
    end

    Harvest.Debug("Starting import from Esohead")
    local newMapName
    local oldMapName
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

    Harvest.Debug("Import Harvest Nodes:")
    for map, data in pairs(EH.savedVars["harvest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for profession, nodes in pairs(data) do
                    for index, node in pairs(nodes) do
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                        -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                        -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                        -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                        Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                    end
                end
            end
        else -- << New Map Name NOT found
            oldMapName = map
            Harvest.Debug(oldMapName .. " could not be localized.  Saving to oldData!")
            for profession, nodes in pairs(data) do
                for index, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                    -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                    -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                    Harvest.oldMapItemIDHarvest(oldMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    Harvest.Debug("Import Chests:")
    for map, nodes in pairs(EH.savedVars["chest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            Harvest.Debug(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Import Fishing Holes:")
    for map, nodes in pairs(EH.savedVars["fish"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            Harvest.Debug(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    Harvest.Debug("Number of nodes added : " .. tostring(Harvest.NumNodesAdded) )
    Harvest.Debug("Number of nodes inserted : " .. tostring(Harvest.NumInsertedNodes) )
    Harvest.Debug("Number of nodes filtered : " .. tostring(Harvest.NumNodesFiltered) )
    Harvest.Debug("Number of maps filtered : " .. tostring(Harvest.NumMapFiltered) )
    Harvest.Debug("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    Harvest.Debug("Number of False Nodes saved : " .. tostring(Harvest.NumFalseNodes) )
    Harvest.Debug("Number of Unlocalized nodes saved : " .. tostring(Harvest.NumUnlocalizedNodesAdded) )
    Harvest.Debug("Number of Unlocalized False Nodes saved : " .. tostring(Harvest.NumUnlocalizedFalseNodes) )
    -- Harvest.Debug("Number of Rejected Nodes saved : " .. tostring(Harvest.NumRejectedNodes) )
    Harvest.Debug("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromEsoheadMerge()
    Harvest.NumNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumUnlocalizedNodesAdded = 0
    Harvest.NumRejectedNodes = 0
    Harvest.NumInsertedNodes = 0
    Harvest.NumMapFiltered = 0

    if not EHM then
        Harvest.Debug("Please enable the EsoheadMerge addon to import data!")
        return
    end

    Harvest.Debug("Starting import from EsoheadMerge")
    local newMapName
    local oldMapName
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

    Harvest.Debug("Import Harvest Nodes:")
    for map, data in pairs(EHM.savedVars["harvest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for profession, nodes in pairs(data) do
                    for index, node in pairs(nodes) do
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                        -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                        -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                        -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                        Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                    end
                end
            end
        else -- << New Map Name NOT found
            oldMapName = map
            Harvest.Debug(oldMapName .. " could not be localized.  Saving to oldData!")
            for profession, nodes in pairs(data) do
                for index, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                    -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                    -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                    Harvest.oldMapItemIDHarvest(oldMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    Harvest.Debug("Import Chests:")
    for map, nodes in pairs(EHM.savedVars["chest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Import Fishing Holes:")
    for map, nodes in pairs(EHM.savedVars["fish"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    Harvest.Debug("Number of nodes added : " .. tostring(Harvest.NumNodesAdded) )
    Harvest.Debug("Number of nodes inserted : " .. tostring(Harvest.NumInsertedNodes) )
    Harvest.Debug("Number of nodes filtered : " .. tostring(Harvest.NumNodesFiltered) )
    Harvest.Debug("Number of maps filtered : " .. tostring(Harvest.NumMapFiltered) )
    Harvest.Debug("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    Harvest.Debug("Number of False Nodes saved : " .. tostring(Harvest.NumFalseNodes) )
    Harvest.Debug("Number of Unlocalized nodes saved : " .. tostring(Harvest.NumUnlocalizedNodesAdded) )
    Harvest.Debug("Number of Unlocalized False Nodes saved : " .. tostring(Harvest.NumUnlocalizedFalseNodes) )
    -- Harvest.Debug("Number of Rejected Nodes saved : " .. tostring(Harvest.NumRejectedNodes) )
    Harvest.Debug("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromHarvester()
    Harvest.NumNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumUnlocalizedNodesAdded = 0
    Harvest.NumRejectedNodes = 0
    Harvest.NumInsertedNodes = 0
    Harvest.NumMapFiltered = 0

    if not Harvester then
        Harvest.Debug("Please enable the Harvester addon to import data!")
        return
    end

    Harvest.Debug("Starting import from Harvester")
    local newMapName
    local oldMapName
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

    Harvest.Debug("Import Harvest Nodes:")
    for map, data in pairs(Harvester.savedVars["harvest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for profession, nodes in pairs(data) do
                    for index, node in pairs(nodes) do
                        Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                        -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                        -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                        -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                        Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, node[4], node[5])
                    end
                end
            end
        else -- << New Map Name NOT found
            oldMapName = map
            Harvest.Debug(oldMapName .. " could not be localized.  Saving to oldData!")
            for profession, nodes in pairs(data) do
                for index, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- [1], [2] = X/Y, [3] = Stack Size, [4] = nodeName, [5] = itemID
                    -- Harvest.Debug(node[1] .. " : " .. node[2] .. " : " .. profession .. " : " .. node[5])
                    -- [1] map name [2], [3] = X/Y, [4] profession [5] nodeName [6] itemID
                    Harvest.oldMapItemIDHarvest(oldMapName, node[1], node[2], profession, node[4], node[5])
                end
            end
        end
    end

    Harvest.Debug("Import Chests:")
    for map, nodes in pairs(Harvester.savedVars["chest"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("chest", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("chest", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Import Fishing Holes:")
    for map, nodes in pairs(Harvester.savedVars["fish"].data) do
        Harvest.Debug("import data from "..map)
        newMapName = Harvest.GetNewMapName(map)
        if newMapName then
            if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
                for _, node in pairs(nodes) do
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                    Harvest.newMapNameFishChest("fish", newMapName, node[1], node[2])
                end
            end
        else -- << New Map Name NOT found
            d(map .. " could not be localized.  Saving to oldData!")
            for v1, node in pairs(nodes) do
                Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                -- 1) map name 2) x 3) y 4) profession 5) nodeName 6) itemID
                Harvest.oldMapNameFishChest("fish", map, node[1], node[2])
            end
        end
    end

    Harvest.Debug("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    Harvest.Debug("Number of nodes added : " .. tostring(Harvest.NumNodesAdded) )
    Harvest.Debug("Number of nodes inserted : " .. tostring(Harvest.NumInsertedNodes) )
    Harvest.Debug("Number of nodes filtered : " .. tostring(Harvest.NumNodesFiltered) )
    Harvest.Debug("Number of maps filtered : " .. tostring(Harvest.NumMapFiltered) )
    Harvest.Debug("Number of Containers skipped : " .. tostring(Harvest.NumContainerSkipped) )
    Harvest.Debug("Number of False Nodes saved : " .. tostring(Harvest.NumFalseNodes) )
    Harvest.Debug("Number of Unlocalized nodes saved : " .. tostring(Harvest.NumUnlocalizedNodesAdded) )
    Harvest.Debug("Number of Unlocalized False Nodes saved : " .. tostring(Harvest.NumUnlocalizedFalseNodes) )
    -- Harvest.Debug("Number of Rejected Nodes saved : " .. tostring(Harvest.NumRejectedNodes) )
    Harvest.Debug("Finished.")
    Harvest.RefreshPins()
end

function Harvest.importFromHarvestMerge()
    Harvest.NumNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumUnlocalizedNodesAdded = 0
    Harvest.NumRejectedNodes = 0
    Harvest.NumInsertedNodes = 0
    Harvest.NumMapFiltered = 0

    if not HarvestMerge then
        Harvest.Debug("Please enable the HarvestMerge addon to import data!")
        return
    end

    if HarvestMerge.internal.internalVersion < 5 then
        Harvest.Debug("Please upgrade to HarvestMerge 0.2.7 or newer to import data!")
        return
    end
    Harvest.Debug("Starting import from HarvestMerge")
    for newMapName, data in pairs(HarvestMerge.savedVars["nodes"].data) do
        if not Harvest.filteredMapCheck(newMapName) and not Harvest.filteredCityMapCheck(newMapName) then
            for profession, nodes in pairs(data) do
                for index, item in ipairs(nodes) do
                    local node = type(item) == "string" and Harvest.Deserialize(item) or item
                    Harvest.NumNodesProcessed = Harvest.NumNodesProcessed + 1
                    for contents, nodeName in ipairs(node[3]) do
                        -- [1], [2] = X/Y, [3] = Node Names, [4] = itemID
                        if (nodeName) == "chest" or (nodeName) == "fish" then
                            Harvest.newMapNameFishChest(nodeName, newMapName, node[1], node[2])
                        else
                            Harvest.newMapItemIDHarvest(newMapName, node[1], node[2], profession, nodeName, node[4])
                        end

                    end
                end
            end
        end
    end

    Harvest.Debug("Number of nodes processed : " .. tostring(Harvest.NumNodesProcessed) )
    Harvest.Debug("Number of nodes added : " .. tostring(Harvest.NumNodesAdded) )
    Harvest.Debug("Number of nodes inserted : " .. tostring(Harvest.NumInsertedNodes) )
    Harvest.Debug("Number of nodes filtered : " .. tostring(Harvest.NumNodesFiltered) )
    Harvest.Debug("Number of maps filtered : " .. tostring(Harvest.NumMapFiltered) )
    -- Harvest.Debug("Number of Rejected Nodes saved : " .. tostring(Harvest.NumRejectedNodes) )
    Harvest.Debug("Finished.")
    Harvest.RefreshPins()
end
