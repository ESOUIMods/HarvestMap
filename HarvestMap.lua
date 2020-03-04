if not Harvest then
    Harvest = {}
end

local AS = LibStub("AceSerializer-3.0")
local LMP = LibStub("LibMapPins-1.0")

function Harvest.GetLocation()
    if(SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED) then
        CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
    end

    local map = Harvest.GetMap()
    local x, y = GetMapPlayerPosition( "player" )
    return map, x, y
end

function Harvest.Serialize(data)
    return AS:Serialize(data)
end

function Harvest.Deserialize(data)
    local success, result = AS:Deserialize(data)
    
    if success then 
        return result
    else
        d(result)
    end
    return nil
end

function Harvest.Debug( message )
    if Harvest.AreDebugMessagesEnabled() then
        d( message )
    end
end

function Harvest.GetPinTypeId( itemId, nodeName )
    local itemIdPinType = Harvest.itemId2PinType[ itemId ]
    local nodeNamePinType = Harvest.nodeName2PinType[ zo_strlower( nodeName ) ]
    Harvest.Debug( "Item id " .. tostring(itemId) .. " returns pin type " .. tostring(itemIdPinType))
    Harvest.Debug( "Node name " .. tostring(nodeName) .. " returns pin type " .. tostring(nodeNamePinType))
    -- both return the same pin type (or both are unknown/nil)
    if itemIdPinType == nodeNamePinType then
        return itemIdPinType
    end
    -- heavy sacks can contain material for different professions
    -- so don't use the item id to determine the pin type
    if Harvest.IsHeavySack( nodeName ) then
        return nodeNamePinType
    end
    -- we allow this special case because of possible errors in the localization
    if nodeNamePinType == nil then
        return itemIdPinType
    end
    -- the pin types don't match, don't save the node as there is some error
    return nil
end

function Harvest.OnLootReceived( eventCode, receivedBy, objectName, stackCount, soundCategory, lootType, lootedBySelf )
    if not Harvest.IsUpdateQueueEmpty() then
        Harvest.Debug( "OnLootReceived failed: HarvestMap is updating" )
        return
    end

    if (not Harvest.wasHarvesting and not Harvest.IsHeavySack( Harvest.lastInteractableName )) or not lootedBySelf then
        Harvest.Debug( "OnLootReceived failed: wasn't harvesting or not looted by self" )
        return
    end

    local map, x, y = Harvest.GetLocation()
    local itemName, _, _, itemId = ZO_LinkHandler_ParseLink( objectName )
    local itemId = tonumber(itemId)
    if itemId == nil then
        Harvest.Debug( "OnLootReceived failed: item id is nil" )
        return
    end

    local pinTypeId = Harvest.GetPinTypeId(itemId, Harvest.lastInteractableName)

    if pinTypeId == nil then
        Harvest.Debug( "OnLootReceived failed: pin type id is nil" )
        return
    end

    if not Harvest.IsPinTypeSavedOnGather( pinTypeId ) then
        Harvest.Debug( "OnLootReceived failed: pin type is disable in the options" )
        return
    end

    Harvest.SaveData( map, x, y, pinTypeId, Harvest.lastInteractableName, itemId )
    Harvest.RefreshPins( pinTypeId )

end

function Harvest.OnLootUpdated()
    if not Harvest.wasHarvesting and not Harvest.IsHeavySack( Harvest.lastInteractableName ) then
        Harvest.Debug( "OnLootUpdated failed: wasn't harvesting" )
        return
    end

    local items = GetNumLootItems()

    for lootIndex = 1, items do
        Harvest.OnLootReceived( nil, nil, GetLootItemLink( GetLootItemInfo( lootIndex ), LINK_STYLE_DEFAULT ), nil, nil, nil, true )
    end

    if Harvest.wasHarvesting then
        Harvest.wasHarvesting = false
    end

end

function Harvest.RefreshPins( pinTypeId )
    if not pinTypeId then
        LMP:RefreshPins()
        COMPASS_PINS:RefreshPins()
        return
    end
    if Harvest.contains( Harvest.PINTYPES, pinTypeId ) then
        LMP:RefreshPins( Harvest.GetPinType( pinTypeId ) )
        COMPASS_PINS:RefreshPins( Harvest.GetPinType( pinTypeId ) )
    end
end

function Harvest.contains( table, value)
    for _, element in pairs(table) do
        if element == value then
            return true
        end
    end
    return false
end

function Harvest.GetMap()
    local textureName = GetMapTileTexture()
    textureName = string.lower(textureName)
    textureName = string.gsub(textureName, "^.*maps/", "")
    textureName = string.gsub(textureName, "_%d+%.dds$", "")

    local mapType = GetMapType()
    local mapContentType = GetMapContentType()
    --if (mapType == MAPTYPE_SUBZONE) or (mapContentType == MAP_CONTENT_DUNGEON) then
    --    Harvest.minDistanceFactor = 20  -- Larger value for minDist since map is smaller
    --elseif (mapContentType == MAP_CONTENT_AVA) then
    --    Harvest.minDistanceFactor = 4 -- Smaller value for minDist since map is larger
    --else
    --    Harvest.minDistanceFactor = 1 -- This is the default value for minDist
    --end

    if textureName == "eyevea_base" then
        local worldMapName = GetUnitZone("player")
        worldMapName = string.lower(worldMapName)
        textureName = worldMapName .. "/" .. textureName
    end

    return textureName
end

function Harvest.IsNodeAlreadyFound( nodes, x, y )
    --local nodes = dataHarvest.GetNodesOnMap( map, pinTypeId )
    local minDistance = Harvest.GetMinDistanceBetweenPins()
    local dist2 = 0
    for index, node in pairs( nodes ) do
        local dx = node[1] - x
        local dy = node[2] - y
        -- distance is sqrt(dx * dx + dy * dy) but for performance we compare the squared values
        dist2 = dx * dx + dy * dy
        if dist2 < minDistance then -- the new node is too close to an old one, it's probably a duplicate
            return index
        end
    end
    return nil
end

function Harvest.SaveData( map, x, y, pinTypeId, nodeName, itemID )
    -- old data may be mising some information. in that case skip that node data completely
    if not nodeName then
        Harvest.Debug( "SaveData failed: node name is nil" )
        return
    end
    if not pinTypeId then
        Harvest.Debug( "SaveData failed: pin type id is nil" )
        return
    end

    -- If the map is on the blacklist then don't log it
    if Harvest.IsMapBlacklisted( map ) then
        Harvest.Debug( "SaveData failed: map " .. tostring(map) .. " is blacklisted" )
        return
    end

    local saveFile = Harvest.GetSaveFile( map )
    -- tables may not exist yet
    saveFile.data[ map ] = saveFile.data[ map ] or {}
    saveFile.data[ map ][ pinTypeId ] = saveFile.data[ map ][ pinTypeId ] or {}
    Harvest.LoadToCache( map, pinTypeId )
    local nodes = Harvest.cache[ map ][ pinTypeId ]
    local stamp = Harvest.GetCurrentTimestamp()

    -- If we have found this node already then we don't need to save it again
    local index = Harvest.IsNodeAlreadyFound( nodes, x, y )
    if index then
        -- update the timestamp of the node, to confirm its a recent position (maybe we will delete old data in the future)
        local node = nodes[ index ]
        node[5] = stamp
        -- add the node name if it's a new one
        if not Harvest.ContainsNodeName(node[3], nodeName) then
            table.insert(node[3], nodeName)
        end
        -- serialize the node for the save file
        saveFile.data[ map ][ pinTypeId ][ index ] = Harvest.Serialize( node )
        return
    end

    -- we need to save the data in serialized form, but also as table in the cache for faster access
    table.insert( saveFile.data[ map ][ pinTypeId ], Harvest.Serialize({ x, y, { nodeName }, itemID, stamp }) )
    table.insert( nodes, { x, y, { nodeName }, itemID, stamp } )
end

function Harvest.OnDelayedUpdate(time)
end

function Harvest.OnUpdate(time)
    -- don't update everyframe. instead only every 0.2 seconds
    if time - Harvest.lastUpdate < 0.2 then
        return
    end
    Harvest.lastUpdate = time
    if not Harvest.IsUpdateQueueEmpty() then
        Harvest.UpdateUpdateQueue()
        return
    end

    local interactionType = GetInteractionType()
    local isHarvesting = (interactionType == INTERACTION_HARVEST)
    
    -- update the harvesting state. check if the character was harvesting something during the last two seconds
    if not isHarvesting then
        if Harvest.wasHarvesting and time - Harvest.harvestTime > 2 then
            Harvest.wasHarvesting = false
        end
    else
        Harvest.wasHarvesting = true
        Harvest.harvestTime = time
    end

    -- the character started a new interaction
    if interactionType ~= Harvest.lastInteractType then
        Harvest.lastInteractType = interactionType
        -- the character started picking a lock
        if interactionType == INTERACTION_LOCKPICK then
            -- don't create new pin if chests are disabled
            if not Harvest.IsPinTypeSavedOnGather( Harvest.CHESTS ) then
                Harvest.Debug( "chests are disabled" )
                return
            end
            -- if the interactable is owned by an NPC but the action isn't called "Steal From"
            -- then it wasn't a safebox but a simple door. so don't place a chest pin
            if Harvest.lastInteractableOwned and not Harvest.lastInteractableAction == GetString(SI_GAMECAMERAACTIONTYPE20) then
                Harvest.Debug( "not a chest(?)" )
                return
            end
            local zone, x, y = Harvest.GetLocation()
            Harvest.SaveData( zone, x, y, Harvest.CHESTS, "chest", nil )
            Harvest.RefreshPins( Harvest.CHEST )
        end
        -- the character started fishing
        if interactionType == INTERACTION_FISH then
            -- don't create new pin if fishing pins are disabled
            if not Harvest.IsPinTypeSavedOnGather( Harvest.FISHING ) then
                Harvest.Debug( "fishing spots are disabled" )
                return
            end
            local zone, x, y = Harvest.GetLocation()
            Harvest.SaveData( zone, x, y, Harvest.FISHING, "chest", nil )
            Harvest.RefreshPins( Harvest.FISHING )
        end
    end
end

-- this hack saves the object's name that was last interacted with
local oldInteract = FISHING_MANAGER.StartInteraction
FISHING_MANAGER.StartInteraction = function(...)
    local action, name, blockedNode, isOwned = GetGameCameraInteractableActionInfo()
    Harvest.lastInteractableAction = action
    Harvest.lastInteractableName = name
    Harvest.lastInteractableOwned = isOwned
    return oldInteract(...)
end

function Harvest.FixSaveFile()
    -- functions can not be saved, so reload them
    for _, layout in pairs( Harvest.GetCompassLayouts() ) do
        layout.additionalLayout = {Harvest.additionalLayout, Harvest.additionalLayoutReset}
    end
    -- tints cannot be saved (only as rgba table) so restore these tables to tint objects
    for _, layout in pairs( Harvest.GetMapLayouts() ) do
        if layout.color then
            layout.tint = ZO_ColorDef:New(unpack(layout.color))
            layout.color = nil
        else
            layout.tint = ZO_ColorDef:New(layout.tint)
        end
    end
end

function Harvest.GetCurrentTimestamp()
    -- data is saved as string, to prevent the save file from bloating up, reduce the stamp to hours
    return zo_floor(GetTimeStamp() / 3600)
end

function Harvest.ImportFromMap( map, data, target, checkPinType )
    -- nothing to consolidate, just copy it over and be done
    if target.data[ map ] == nil then
        target.data[ map ] = data
        return
    end

    local targetData = nil
    local newNode = nil
    local index = 0
    local oldNode = nil
    for _, pinTypeId in ipairs( Harvest.PINTYPES ) do
        if not checkPinType or Harvest.IsPinTypeSavedOnImport( pinTypeId ) then
            if target.data[ map ][ pinTypeId ] == nil then
                -- nothing to consolidate for this pin type, just copy it
                target.data[ map ][ pinTypeId ] = data[ pinTypeId ]
            else
                -- deserialize old data and clear the serialized version (we'll fill it again at the end)
                targetData = {}
                for _, node in pairs( target.data[ map ][ pinTypeId ] ) do
                    table.insert(targetData, Harvest.Deserialize(node))
                end
                target.data[ map ][ pinTypeId ] = {}
                -- deserialize every new node and update the old nodes accordingly
                data[ pinTypeId ] = data[ pinTypeId ] or {}
                for _, entry in pairs( data[ pinTypeId ] ) do
                    newNode = Harvest.Deserialize( entry )
                    -- If we have found this node already then we don't need to save it again
                    index = Harvest.IsNodeAlreadyFound( targetData, newNode[1], newNode[2] )
                    if index then
                        -- update the timestamp of the node, to confirm its a recent position (maybe we will delete old data in the future)
                        oldNode = targetData[ index ]
                        if oldNode[5] and newNode[5] then
                            oldNode[5] = zo_max( oldNode[5], newNode[5] )
                        else
                            oldNode[5] = oldNode[5] or newNode[5]
                        end
                        -- add the node name if it's a new one
                        for _, nodeName in pairs( newNode[3] ) do
                            if not Harvest.ContainsNodeName(oldNode[3], nodeName) then
                                table.insert(oldNode[3], nodeName)
                            end
                        end
                    else
                        table.insert(targetData, newNode)
                    end
                end
                -- serialize the new data
                for _, node in pairs( targetData ) do
                    table.insert(target.data[ map ][ pinTypeId ], Harvest.Serialize(node))
                end
            end
        end
    end
end

function Harvest.ContainsNodeName(table, name)
    for _, entry in pairs(table) do
        if Harvest.GetLocalizedNodeName(entry) == Harvest.GetLocalizedNodeName(name) then
            return true
        end
    end
end

function Harvest.GetSaveFile( map )
    return Harvest.GetSpecialSaveFile( map ) or Harvest.savedVars["nodes"]
end

function Harvest.GetSpecialSaveFile( map )
    local zone = string.gsub( map, "/.*$", "" )
    if HarvestAD then
        if HarvestAD.zones[ zone ] then
            return Harvest.savedVars["ADnodes"]
        end
    end
    if HarvestEP then
        if HarvestEP.zones[ zone ] then
            return Harvest.savedVars["EPnodes"]
        end
    end
    if HarvestDC then
        if HarvestDC.zones[ zone ] then
            return Harvest.savedVars["DCnodes"]
        end
    end
    return nil
end


function Harvest.MoveData()
    for map, data in pairs( Harvest.savedVars["nodes"].data ) do
        local zone = string.gsub( map, "/.*$", "" )
        local file = Harvest.GetSpecialSaveFile( map )
        if file ~= nil then
            Harvest.AddToUpdateQueue(function()
                Harvest.ImportFromMap( map, data, file )
                Harvest.savedVars["nodes"].data[ map ] = nil
                d("Moving old data to the correct save files. " .. Harvest.GetQueuePercent() .. "%")
            end)
        end
    end
end

function Harvest.LoadToCache( map, pinTypeId )
    local saveFile = Harvest.GetSaveFile(map)
    Harvest.cache[ map ] = Harvest.cache[ map ] or {}
    if Harvest.cache[ map ][ pinTypeId ] == nil then
        local cachedNodes = {}
        local nodes = saveFile.data[ map ] or {}
        nodes = nodes[ pinTypeId ] or {}
        for index, node in pairs( nodes ) do -- don't use ipairs,
        -- it won't iterate over all entires even though they are all indexed with integers
        cachedNodes[index] = (type( node ) == "string" and Harvest.Deserialize( node )) or node
        end
        Harvest.cache[ map ][ pinTypeId ] = cachedNodes
    end
end

-- Deserializes each node and caches the deserialized nodes
function Harvest.GetNodesOnMap( map, pinTypeId )
    Harvest.LoadToCache( map, pinTypeId )
    return Harvest.cache[ map ][ pinTypeId ]
end

function Harvest.OnLoad(eventCode, addOnName)
    if addOnName ~= "HarvestMap" then
        return
    end

    -- initialize temporary variables
    Harvest.wasHarvesting = false
    Harvest.action = nil
    Harvest.cache = {}
    Harvest.lastUpdate = 0
    Harvest.minDistanceFactor = 1
    Harvest.mapCounter = {}
    for _, pinTypeId in ipairs(Harvest.PINTYPES) do
        Harvest.mapCounter[Harvest.GetPinType( pinTypeId )] = 0
    end
    Harvest.compassCounter = {}
    for _, pinTypeId in ipairs(Harvest.PINTYPES) do
        Harvest.compassCounter[Harvest.GetPinType( pinTypeId )] = 0
    end

    -- initialize save variables
    Harvest.savedVars = {}
    Harvest.savedVars["global"] = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 3, "global", Harvest.defaultGlobalSettings)
    Harvest.savedVars["nodes"]  = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "nodes", Harvest.dataDefault)
    if HarvestAD then
        Harvest.savedVars["ADnodes"]  = HarvestAD.savedVars
    end
    if HarvestEP then
        Harvest.savedVars["EPnodes"]  = HarvestEP.savedVars
    end
    if HarvestDC then
        Harvest.savedVars["DCnodes"]  = HarvestDC.savedVars
    end
    if Harvest.savedVars["global"].accountWideSettings then
        Harvest.savedVars["settings"] = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "settings", Harvest.defaultSettings )
    else
        Harvest.savedVars["settings"] = ZO_SavedVars:New("Harvest_SavedVars", 2, "settings", Harvest.defaultSettings )
    end
    -- check if saved data is from an older version,
    -- update the data if needed
    Harvest.UpdateDataVersion()
    -- move data to correct save files
    -- if AD was disabled while harvesting in AD, everything was saved in ["nodes"]
    -- when ad is enabled, everything needs to be moved to that save file
    -- HOWEVER, only execute this after the save files were updated!
    Harvest.AddToUpdateQueue(Harvest.MoveData)
    -- some data cannot be properly saved, ie functions or tints.
    -- repair this data
    -- HOWEVER, only execute this after the save files were updated!
    Harvest.AddToUpdateQueue(Harvest.FixSaveFile)

    -- initialize pin callback functions
    Harvest.InitializeMapMarkers()
    Harvest.InitializeCompassMarkers()
    -- create addon option panels
    Harvest.InitializeOptions()

    Harvest.OnDelayedUpdate = Harvest.OnUpdate
end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, Harvest.OnLoad)
EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_RECEIVED, Harvest.OnLootReceived)
EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_UPDATED, Harvest.OnLootUpdated)
