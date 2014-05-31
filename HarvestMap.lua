Harvest = {}
Harvest.chestID = 6
Harvest.fishID = 8

Harvest.internalVersion = 3

-----------------------------------------
--          String Formatting          --
-----------------------------------------
function Harvest.FormatString(name)

    local StringToBeFormatted = zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
    return StringToBeFormatted
end

-- Returns true if the player is Harvesting
function Harvest.IsPlayerHarvesting()

    local InteractionType = GetInteractionType()
    if (InteractionType == INTERACTION_HARVEST) then
        return true
    end

    return false
end

-- Returns true if the player is Fishing
function Harvest.IsPlayerFishing()

    local InteractionType = GetInteractionType()
    if (InteractionType == INTERACTION_FISH) then
        return true
    end

    return false
end

-- Returns true if the player is Reading a Book
function Harvest.IsPlayerReading()

    local InteractionType = GetInteractionType()
    if (InteractionType == INTERACTION_BOOK) then
        return true
    end

    return false
end

-- Returns true if the player is Lock Picking
function Harvest.IsPlayerLockpicking()

    local InteractionType = GetInteractionType()
    if (InteractionType == INTERACTION_LOCKPICK) then
        return true
    end

    return false
end

-- I thought this would return true when using a blacksmith or clothing workstation
-- Returns True when Unknown??.  Needs more testing
function Harvest.HarvestProvisioning()

    local InteractionType = GetCraftingInteractionType()
    if InteractionType == CRAFTING_TYPE_PROVISIONING then
        return true
    end

    return false
end

-- Valid Types are ALCHEMY, BLACKSMITHING, CLOTHIER
-- ENCHANTING, or WOODWORKING
-- Returns True when Unknown??.  Needs more testing
function Harvest.ValidCraftingType()

    local InteractionType = GetCraftingInteractionType()
    if (InteractionType == (CRAFTING_TYPE_INVALID or CRAFTING_TYPE_PROVISIONING) ) then
        return false
    end

    return true
end

-- Returns True when Player is interacting with an Object
-- or doing one of the following
-- Lock Picking
-- Reading
-- Fishing
function Harvest.IsPlayerBusy()

    if ( IsPlayerInteractingWithObject() and
        ( Harvest.IsPlayerLockpicking() or
        Harvest.IsPlayerReading() or
        Harvest.IsPlayerFishing() ) ) then

        return true
    end

    return false
end

-----------------------------------------
--         Get Player Location         --
-----------------------------------------

function Harvest.GetLocation()
    if(SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED) then
        CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
    end

    local zone = Harvest.GetMap()
    local x, y = GetMapPlayerPosition( "player" )
    return zone, x, y
end

-----------------------------------------
--        Link Parsing                 --
-----------------------------------------

function Harvest.ItemLinkParse(link)

    local Field1, Field2, Field3, Field4, Field5 = ZO_LinkHandler_ParseLink( link )

    -- name = Field1
    -- unused = Field2
    -- type = Field3
    -- id = Field4
    -- quality = Field5

    return {
        type = Field3,
        id = tonumber(Field4),
        quality = tonumber(Field5),
        name = Harvest.FormatString(Field1)
    }
end


function Harvest.OnLootReceived( eventCode, receivedBy, objectName, stackCount, soundCategory, lootType, lootedBySelf )
    if Harvest.defaults.verbose then
        d("OnLootReceived")
    end

    -- These are only available in OnUpdate
    -- GetNumLootItems()
    -- GetLootItemInfo(lootIndex)
    -- GetLootItemLink(NumItemLooted)

    -- Moved here to track Solvents
    -- Revised: Some bottles give Beverages, needs more testing
    -- Water Sacks and Pure Water are considered Harvesting
    -- if profession ~= 7 then
        if not Harvest.isHarvesting or not lootedBySelf then
            if Harvest.defaults.debug then
                if not Harvest.isHarvesting then
                    d("Not Harvesting!")
                end
                if not lootedBySelf then
                    d("Not Looted by self!")
                end
            end
            return
        end
    -- end

    local zone, x, y = Harvest.GetLocation()
    link = Harvest.ItemLinkParse( objectName )
    if Harvest.defaults.debug then
        d("Item Name: " .. Harvest.FormatString(link.name) .. " : ItemID : " .. tostring(link.id) )
    end

    -- if link.id is nil Harvest.GetProfessionType will fail
    if link.id == nil then
        if Harvest.defaults.verbose then
            d("OnLootReceived exited because itemID was nil")
        end
        return
    end

    -- 0: INTERACT_TARGET_TYPE_NONE
    -- 1: INTERACT_TARGET_TYPE_OBJECT - NPC, Pure Water, Essence Rune
    -- 2: INTERACT_TARGET_TYPE_ITEM
    -- 4: INTERACT_TARGET_TYPE_QUEST_ITEM
    -- 5: INTERACT_TARGET_TYPE_FIXTURE - Trunk, Dresser
    -- 6: INTERACT_TARGET_TYPE_AOE_LOOT

    if ( link.type == LOOT_TYPE_QUEST_ITEM) then
        if Harvest.defaults.verbose then
            d("This is Quest Loot!")
            return
        end
    end

    profession = Harvest.GetProfessionType(link.id, Harvest.nodeName)

    -- Don't need to track torchbug loot
    -- Leave for future revision of Solvent Tracking
    if (profession < 1) then
        if Harvest.defaults.debug then
            d("No valid profession type for : " .. Harvest.FormatString(link.name))
            d("Node Name : " .. Harvest.nodeName )
        end
        return
    else
        if Harvest.defaults.debug then
            d("Item Type : " .. link.type .. " : Profession Type : " .. tostring(profession) )
            d("Node Name : " .. Harvest.nodeName )
        end
    end

    if Harvest.savedVars["settings"].gatherFilters[ profession ] then
        if Harvest.defaults.debug then
            d("Gathering disabled for profession : " .. tostring(profession) )
        end
        return
    end

    -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
    Harvest.saveData("nodes", zone, x, y, profession, Harvest.nodeName, link.id, nil )
    Harvest.RefreshPins( profession )

    if Harvest.defaults.verbose then
        d("OnLootReceived exited")
    end
end

function Harvest.OnLootUpdate()

    if Harvest.defaults.verbose then
        d("OnLootUpdate")
    end

    -- This line get how many items are in the container
    local items = GetNumLootItems()
    if items < 1 then
        if Harvest.defaults.verbose then
            d("OnLootUpdate Exited because items is less then 1.")
            d("Was the Node looted already?")
        end
        return
    end

    local NumItemLooted
    for lootIndex = 1, items do
        NumItemLooted = GetLootItemInfo(lootIndex)
        if Harvest.defaults.debug then
            d("Number of Item seen since login : ".. tostring(NumItemLooted) )
        end
        Harvest.OnLootReceived( nil, nil, GetLootItemLink(NumItemLooted), nil, nil, nil, true )
    end

    if Harvest.defaults.verbose then
        d("OnLootUpdate Exited")
    end

    if Harvest.isHarvesting == true then
        Harvest.isHarvesting = false
    end

end

function Harvest.RefreshPins( profession )
    if not profession then
        ZO_WorldMap_RefreshCustomPinsOfType()
        COMPASS_PINS:RefreshPins()
        return
    end
    -- if profession >= 1 and profession <= 6 then
    if profession >= 1 and profession <= 8 then
        ZO_WorldMap_RefreshCustomPinsOfType( _G[ Harvest.GetPinType( profession ) ] )
        COMPASS_PINS:RefreshPins( Harvest.GetPinType( profession ) )
    end
end

function Harvest.GetMap()
    local textureName = GetMapTileTexture()
    textureName = string.lower(textureName)
    textureName = string.gsub(textureName, "^.*maps/", "")
    textureName = string.gsub(textureName, "_%d+%.dds$", "")

    local mapType = GetMapType()
    local mapContentType = GetMapContentType()
    if (mapType == MAPTYPE_SUBZONE) or (mapContentType == MAP_CONTENT_DUNGEON) then
        Harvest.minDist = 0.00005  -- Larger value for minDist since map is smaller
    elseif (mapContentType == MAP_CONTENT_AVA) then
        Harvest.minDist = 0.00001 -- Smaller value for minDist since map is larger
    else
        Harvest.minDist = 0.000025 -- This is the default value for minDist
    end

    return textureName
end

function Harvest.saveMapName(currentMap)
    local textureNameA = GetMapTileTexture()
    local textureNameB = GetMapTileTexture()
    textureNameA = string.lower(textureNameA)
    textureNameB = string.lower(textureNameB)

    local _,_,_,zone,subzone = string.find(textureNameA, "(maps/)([%w%-]+)/([%w%-]+_%w+)")
    textureNameB = string.gsub(textureNameB, "^.*maps/", "")
    textureNameB = string.gsub(textureNameB, "%.dds$", "")

    local mapZone = GetMapName()
    local unitZone = GetUnitZone("player")
    local zoneIndex = GetCurrentMapZoneIndex()
    local mapIndex = GetCurrentMapIndex()
    local mapType = GetMapType()
    local mapContentType = GetMapContentType()
    local mapWidth, mapHeight = GetMapNumTiles()
    local dimensionsX, dimensionsY = ZO_WorldMapContainer:GetDimensions()
    local location = GetPlayerLocationName()
    local categoryName, categoryIndex, mapInfoName, mapInfoIndex = GetMapParentCategories(mapIndex)
    --d(categoryName .. " : " .. categoryIndex .. " : " .. mapInfoName .. " : " .. mapInfoIndex)
    --local var1, var2, var3, var4 = GetMapParentCategories(zoneIndex)
    --d(var1 .. " : " .. var2 .. " : " .. var3 .. " : " .. var4)
    --d(var1 .. " : " .. var2 .. " : " .. var3 .. " : " .. var4)
    --d("1 : " .. var1)
    --d("2 : " .. var2)
    --d("3 : " .. var3)
    --d("4 : " .. var4)
    --d("5 : " .. var5)
    --d("6 : " .. var6)

    if Harvest.savedVars["mapnames"] == nil then
        Harvest.savedVars["mapnames"] = {}
    end

    if Harvest.savedVars["mapnames"].data == nil then
        Harvest.savedVars["mapnames"].data = {}
    end

    if textureNameA == nil then
        textureNameA = "Empty"
    end
    if textureNameB == nil then
        textureNameB = "Empty"
    end
    if zone == nil then
        zone = "Empty"
    end
    if subzone == nil then
        subzone = "Empty"
    end
    if location == nil then
        location = "Empty"
    end
    if mapZone == nil then
        mapZone = "Empty"
    end
    if unitZone == nil then
        unitZone = "Empty"
    end
    if zoneIndex == nil then
        zoneIndex = "Empty"
    end
    if mapIndex == nil then
        mapIndex = "Empty"
    end
    if mapType == nil then
        mapType = "Empty"
    end
    if mapContentType == nil then
        mapContentType = "Empty"
    end
    if mapWidth == nil then
        mapWidth = "Empty"
    end
    if mapHeight == nil then
        mapHeight = "Empty"
    end
    if dimensionsX == nil then
        dimensionsX = "Empty"
    end
    if dimensionsY == nil then
        dimensionsY = "Empty"
    end
    if categoryName == nil then
        categoryName = "Empty"
    end
    if categoryIndex == nil then
        categoryIndex = "Empty"
    end
    if mapInfoName == nil then
        mapInfoName = "Empty"
    end
    if mapInfoIndex == nil then
        mapInfoIndex = "Empty"
    end

    --d("CurrentMap : " .. currentMap)
    --d("TextureA : " .. textureNameA)
    --d("TextureB : " .. textureNameB)
    --d("Zone : " .. zone .. " : Subzone : " .. subzone .. " : location : " ..  location .. " : mapZone : " .. mapZone .. " : unitZone : " .. unitZone .. " : zoneIndex : " .. zoneIndex .. " : " .. mapIndex .. " : " .. mapType .. " : " .. mapContentType .. " : " .. mapWidth .. " : " .. mapHeight .. " : " .. dimensionsX .. " : " .. dimensionsY)
    
    data = { currentMap, textureNameA, zone , subzone, location, mapZone , unitZone , zoneIndex, mapIndex, mapType, mapContentType, mapWidth, mapHeight, dimensionsX, dimensionsY, categoryName, categoryIndex, mapInfoName, mapInfoIndex }
    
    local savemapdata = true
    for index, maps in pairs(Harvest.savedVars["mapnames"].data) do
        for _, map in pairs(maps) do
            if textureNameB == index then
                savemapdata = false
            end
            for i = 1, 19 do
                if textureNameB == index and (data[i] ~= map[i]) then
                    savemapdata = true
                end
            end
        end
    end
    
    if savemapdata then
        if Harvest.savedVars["mapnames"].data[textureNameB] == nil then
            Harvest.savedVars["mapnames"].data[textureNameB] = {}

            if Harvest.savedVars["mapnames"].data[textureNameB] then
                --d("It was not here")
                table.insert( Harvest.savedVars["mapnames"].data[textureNameB], data )
            end
        end
    end
end

function Harvest.changeCounters(counter)
    if counter == "false" then
        Harvest.NumFalseNodes = Harvest.NumFalseNodes + 1
    end
    if counter == "valid" then
        Harvest.NumbersNodesAdded = Harvest.NumbersNodesAdded + 1
    end
    if counter == "nonfalse" then
        Harvest.NumUnlocalizedFalseNodes = Harvest.NumUnlocalizedFalseNodes + 1
    end
    if counter == "nonvalid" then
        Harvest.NumbersUnlocalizedNodesAdded = Harvest.NumbersUnlocalizedNodesAdded + 1
    end
end

function Harvest.saveData(type, zone, x, y, profession, nodeName, itemID, scale, counter )

    -- Harvest.saveMapName(zone)

    if not profession then
        return
    end

    if Harvest.savedVars[type] == nil or Harvest.savedVars[type].data == nil then
        d("Attempted to log unknown type: " .. type)
        return
    end

    if Harvest.alreadyFound(type, zone, x, y, profession, nodeName, scale ) then
        return
    end

    -- If this check is not here the next routine will fail
    -- after the loading screen because for a brief moment
    -- the information is not available.
    if Harvest.savedVars[type] == nil then
        return
    end
    
    if not Harvest.savedVars[type].data[zone] then
        Harvest.savedVars[type].data[zone] = {}
    end

    if not Harvest.savedVars[type].data[zone][profession] then
        Harvest.savedVars[type].data[zone][profession] = {}
    end

    if Harvest.defaults.debug then
        d("Save data!")
    end

    table.insert( Harvest.savedVars[type].data[zone][profession], { x, y, { nodeName }, itemID } )
    Harvest.changeCounters(counter)

end

function Harvest.contains(table, value)
    for key, v in pairs(table) do
        if v == value then
            return key
        end
    end
    return nil
end

function Harvest.alreadyFound(type, zone, x, y, profession, nodeName, scale, counter )

    -- If this check is not here the next routine will fail
    -- after the loading screen because for a brief moment
    -- the information is not available.
    if Harvest.savedVars[type] == nil then
        return
    end

    if not Harvest.savedVars[type].data[zone] then
        return false
    end

    if not Harvest.savedVars[type].data[zone][profession] then
        return false
    end

    local distance
    if scale == nil then
        distance = Harvest.minDefault
    else
        distance = scale
    end

    for _, entry in pairs( Harvest.savedVars[type].data[zone][profession] ) do
        --if entry[3] == nodeName then
            dx = entry[1] - x
            dy = entry[2] - y
            -- (x - center_x)2 + (y - center_y)2 = r2, where center is the player
            dist = math.pow(dx, 2) + math.pow(dy, 2)
            if dist < distance then
                if profession > 0 then
                    if not Harvest.contains(entry[3], nodeName) then
                        table.insert(entry[3], nodeName)
                        Harvest.changeCounters(counter)
                    end
                    if Harvest.defaults.debug then
                        d("Node : " .. nodeName .. " on : " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " already found!")
                    end
                    return true
                else
                    if entry[3][1] == nodeName then
                        if Harvest.defaults.debug then
                            d("Node : " .. nodeName .. " on : " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " already found!")
                        end
                        return true
                    end
                end
            end
        --end
        end

    if Harvest.defaults.debug then
        d("Node : " .. nodeName .. " on : " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " not found!")
    end
    return false
end

function Harvest.OnUpdate(time)
    if IsGameCameraUIModeActive() or IsUnitInCombat("player") then
        return
    end

    if Harvest.IsPlayerBusy() then
        return
    end

    -- if Harvest.IsPlayerHarvesting() then
    --     d("I am Harvesting!")
    --     return
    -- end

    local newAction, nodeName, blockedNode, additionalInfo, contextlInfo = GetGameCameraInteractableActionInfo()
    local interactionType = GetInteractionType()
    local active = IsPlayerInteractingWithObject()
    local isHarvesting = ( active and (interactionType == INTERACTION_HARVEST) )
    if not isHarvesting then
        -- d("I am NOT busy!")
        if nodeName then
            Harvest.nodeName = nodeName
        end

        if Harvest.isHarvesting and time - Harvest.time > 1 then
            Harvest.isHarvesting = false
        end

        if newAction ~= Harvest.action then
            Harvest.action = newAction

            if Harvest.defaults.verbose and Harvest.action ~= nil then
                d("Action : " .. Harvest.action)
            end
            if Harvest.defaults.verbose and nodeName ~= nil then
                d("Node Name : " .. nodeName)
            end
            if Harvest.defaults.verbose and blockedNode ~= nil then
                if blockedNode then
                    d("blockedNode : Is True")
                end
            end
            if Harvest.defaults.verbose and additionalInfo ~= nil then
                d("Additional Info : " .. additionalInfo)
            end
            if Harvest.defaults.verbose and contextlInfo ~= nil then
                d("Contextual Info : " .. contextlInfo)
            end

            if Harvest.defaults.verbose then
                d("Map Name : " .. GetMapName() .. " : texture name : " .. Harvest.GetMap() )
            end

            -- 1) type 2) map name 3) x 4) y 5) profession 6) nodeName 7) itemID 8) scale
            -- Track Chest
            if not Harvest.savedVars["settings"].gatherFilters[ Harvest.chestID ] then
                if interactionType == INTERACTION_NONE and Harvest.action == GetString(SI_GAMECAMERAACTIONTYPE12) then
                    local zone, x, y = Harvest.GetLocation()
                    Harvest.saveData("nodes", zone, x, y, Harvest.chestID, "chest", nil, Harvest.minReticleover )
                    Harvest.RefreshPins( Harvest.chestID )
                end
            end

            -- Track Fishing Hole
            if not Harvest.savedVars["settings"].gatherFilters[ Harvest.fishID ] then
                if interactionType == INTERACTION_NONE and Harvest.action == GetString(SI_GAMECAMERAACTIONTYPE16) then
                    local zone, x, y = Harvest.GetLocation()
                    Harvest.saveData("nodes", zone, x, y, Harvest.fishID, "fish", nil, Harvest.minReticleover )
                    Harvest.RefreshPins( Harvest.fishID )
                end
            end

        end
    else
        -- d("I am REALLY busy!")
        Harvest.isHarvesting = true
        Harvest.time = time

    -- End of Else Block
    end -- End of Else Block
end

-----------------------------------------
--           Slash Command             --
-----------------------------------------

Harvest.validCategories = {
    "nodes",
    "mapinvalid",
    "esonodes",
    "esoinvalid"
}

function Harvest.IsValidCategory(name)
    for k, v in pairs(Harvest.validCategories) do
        if string.lower(v) == string.lower(name) then
            return true
        end
    end

    return false
end

SLASH_COMMANDS["/harvest"] = function (cmd)
    local commands = {}
    local index = 1
    for i in string.gmatch(cmd, "%S+") do
        if (i ~= nil and i ~= "") then
            commands[index] = i
            index = index + 1
        end
    end

    if #commands == 0 then
        return d("Please enter a valid Harvester command")
    end

    if #commands == 2 and commands[1] == "import" then
        Harvest.NumbersNodesAdded = 0
        Harvest.NumFalseNodes = 0
        Harvest.NumContainerSkipped = 0
        Harvest.NumbersNodesFiltered = 0
        Harvest.NumNodesProcessed = 0
        Harvest.NumUnlocalizedFalseNodes = 0
        Harvest.NumbersUnlocalizedNodesAdded = 0

        if commands[2] == "esohead" then
            Harvest.importFromEsohead()
        elseif commands[2] == "esomerge" then
            Harvest.importFromEsoheadMerge()
        elseif commands[2] == "harvester" then
            Harvest.importFromHarvester()
        elseif commands[2] == "merger" then
            Harvest.importFromHarvestMerge()
        else
            d("Please enter a valid addon to import")
            d("Valid addons are esohead, esomerge, harvester and")
            d("merger (HarvestMerge)")
            return
        end

    elseif #commands == 2 and commands[1] == "update" then
        if Harvest.IsValidCategory(commands[2]) then
            Harvest.updateNodes(commands[2])
        else
            d("Please enter a valid HarvestMap category to update")
            d("Valid categories are mapinvalid, esonodes, esoinvalid,")
            d("and nodes (Not recomended)")
            return
        end

    elseif commands[1] == "reset" then
        if #commands ~= 2 then 
            for type,sv in pairs(Harvest.savedVars) do
                if type ~= "settings" or type ~= "defaults" then
                    Harvest.savedVars[type].data = {}
                end
            end
            d("HarvestMap saved data has been completely reset")
        else
            if commands[2] ~= "settings" or commands[2] ~= "defaults" or commands[2] ~= "mapnames" then
                if Harvest.IsValidCategory(commands[2]) then
                    Harvest.savedVars[commands[2]].data = {}
                    d("HarvestMap saved data : " .. commands[2] .. " has been reset")
                else
                    d("Please enter a valid HarvestMap category to reset.")
                    d("Valid categories are mapinvalid, esonodes, esoinvalid,")
                    d("and nodes (Not recomended)")
                    return
                end
            end
        end
        Harvest.RefreshPins()

    --[[
    elseif commands[1] == "datalog" then
        d("---")
        d("Complete list of gathered data:")
        d("---")

        local counter = {
            ["harvest"] = 0,
            ["chest"] = 0,
            ["fish"] = 0,
        }

        for type,sv in pairs(Harvest.savedVars) do
            if type ~= "internal" and (type == "chest" or type == "fish") then
                for zone, t1 in pairs(Harvest.savedVars[type].data) do
                    counter[type] = counter[type] + #Harvest.savedVars[type].data[zone]
                end
            elseif type ~= "internal" then
                for zone, t1 in pairs(Harvest.savedVars[type].data) do
                    for data, t2 in pairs(Harvest.savedVars[type].data[zone]) do
                        counter[type] = counter[type] + #Harvest.savedVars[type].data[zone][data]
                    end
                end
            end
        end

        d("Harvest: "          .. Harvest.NumberFormat(counter["harvest"]))
        d("Treasure Chests: "  .. Harvest.NumberFormat(counter["chest"]))
        d("Fishing Pools: "    .. Harvest.NumberFormat(counter["fish"]))

        d("---")
    ]]--
    end
end

function Harvest.OnLoad(eventCode, addOnName)
        Harvest.defaults = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "defaults", { 
                wideSetting = false, 
                debug = false,
                verbose = false,
                internalVersion = 0, 
                dataVersion = 0, 
                language = ""
        })

        if Harvest.defaults.wideSetting then 
            Harvest.savedVars = {
                -- All Localized Nodes
                ["nodes"]           = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "nodes", Harvest.dataDefault),
                -- All Invalid Localized Nodes
                ["mapinvalid"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapinvalid", Harvest.dataDefault),
                -- All Unlocalized Nodes
                ["esonodes"]        = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "esonodes", Harvest.dataDefault),
                -- All Invalid Unlocalized Nodes
                ["esoinvalid"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "esoinvalid", Harvest.dataDefault),
                -- Map name collection for future versions
                ["mapnames"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapnames", Harvest.dataDefault),

                ["settings"]    = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 1, "settings", {
                    filters = {
                        -- [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true
                        [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true
                    },
                    -- Import filters false by default so they are imported
                    importFilters = {
                        [0] = false, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false
                    },
                    -- Gather filters true by default so they are gathered
                    gatherFilters = {
                        [0] = false, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false
                    },
                    mapLayouts = Harvest.defaultMapLayouts,
                    compassLayouts = Harvest.defaultCompassLayouts
                })
            }
        else
            Harvest.savedVars = {
                -- All Localized Nodes
                ["nodes"]           = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "nodes", Harvest.dataDefault),
                -- All Invalid Localized Nodes
                ["mapinvalid"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapinvalid", Harvest.dataDefault),
                -- All Unlocalized Nodes
                ["esonodes"]        = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "esonodes", Harvest.dataDefault),
                -- All Invalid Unlocalized Nodes
                ["esoinvalid"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "esoinvalid", Harvest.dataDefault),
                -- Map name collection for future versions
                ["mapnames"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapnames", Harvest.dataDefault),

                ["settings"]    = ZO_SavedVars:New("Harvest_SavedVars", 1, "settings", {
                    filters = {
                        -- [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true
                        [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true
                    },
                    -- Import filters false by default so they are imported
                    importFilters = {
                        [0] = false, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false
                    },
                    -- Gather filters true by default so they are gathered
                    gatherFilters = {
                        [0] = false, [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false
                    },
                    mapLayouts = Harvest.defaultMapLayouts,
                    compassLayouts = Harvest.defaultCompassLayouts
                })
            }
        end

    Harvest.defaults.language = Harvest.language

    if Harvest.defaults.internalVersion < Harvest.internalVersion then
        Harvest.updateHarvestNodes("data")
        Harvest.updateHarvestNodes("oldData")
        Harvest.updateHarvestNodes("oldMapData")
        Harvest.defaults.internalVersion = Harvest.internalVersion
    end

    Harvest.InitializeMapMarkers()
    Harvest.InitializeCompassMarkers()
    Harvest.InitializeOptions()

    EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_RECEIVED, Harvest.OnLootReceived)
    -- EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_UPDATED, Harvest.OnLootUpdate)

end

function Harvest.Initialize()

    Harvest.dataDefault = {
        data = {}
    }
    -- Harvest.DataStore = {}
    Harvest.langs = { "en", "de", "fr", }
    
    Harvest.minDefault = 0.000025 -- 0.005^2
    Harvest.minDist = 0.000025 -- 0.005^2
    Harvest.minReticleover = 0.000049 -- 0.007^2

    Harvest.isHarvesting = false
    Harvest.action = nil

    Harvest.NumbersNodesAdded = 0
    Harvest.NumFalseNodes = 0
    Harvest.NumContainerSkipped = 0
    Harvest.NumbersNodesFiltered = 0
    Harvest.NumNodesProcessed = 0
    Harvest.NumUnlocalizedFalseNodes = 0
    Harvest.NumbersUnlocalizedNodesAdded = 0

end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, function (eventCode, addOnName)
    if addOnName == "HarvestMap" then
        Harvest.Initialize()
        Harvest.OnLoad(eventCode, addOnName)
    end
end)