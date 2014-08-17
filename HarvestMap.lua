Harvest = {}
Harvest.chestID = 6
Harvest.fishID = 8

Harvest.internalVersion = 3
Harvest.dataVersion = 7
Harvest.displayVersion = "2.6.7"

local AS = LibStub("AceSerializer-3.0")

-----------------------------------------
--           Debug Logger              --
-----------------------------------------

local function EmitMessage(text)
    if(CHAT_SYSTEM)
    then
        if(text == "")
        then
            text = "[Empty String]"
        end

        CHAT_SYSTEM:AddMessage(text)
    end
end

local function EmitTable(t, indent, tableHistory)
    indent          = indent or "."
    tableHistory    = tableHistory or {}

    for k, v in pairs(t)
    do
        local vType = type(v)

        EmitMessage(indent.."("..vType.."): "..tostring(k).." = "..tostring(v))

        if(vType == "table")
        then
            if(tableHistory[v])
            then
                EmitMessage(indent.."Avoiding cycle on table...")
            else
                tableHistory[v] = true
                EmitTable(v, indent.."  ", tableHistory)
            end
        end
    end
end

function Harvest.Debug(...)
    for i = 1, select("#", ...) do
        local value = select(i, ...)
        if(type(value) == "table")
        then
            EmitTable(value)
        else
            EmitMessage(tostring (value))
        end
    end
end

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

-- formats a number with commas on thousands
function Harvest.NumberFormat(num)
    local formatted = num
    local k

    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then
            break
        end
    end

    return formatted
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
    -- linkStyle = Field2
    -- linkType = Field3
    -- id = Field4
    -- quality = Field5

    return {
--         type = Field3,
        id = tonumber(Field4),
--         quality = tonumber(Field5),
        name = Harvest.FormatString(Field1)
    }
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
    local link = Harvest.ItemLinkParse( objectName )
    if Harvest.defaults.debug then
        Harvest.Debug("Item Name: " .. Harvest.FormatString(link.name) .. " : itemID : " .. tostring(link.id) )
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

    if ( lootType == LOOT_TYPE_QUEST_ITEM) then
        if Harvest.defaults.verbose then
            d("This is Quest Loot!")
            return
        end
    end

    local profession = Harvest.GetProfessionType(link.id, Harvest.nodeName)

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
            d("Loot Type : " .. lootType .. " : Profession Type : " .. tostring(profession) )
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

    if textureName == "eyevea_base" then
        worldMapName = GetUnitZone("player")
        worldMapName = string.lower(worldMapName)
        textureName = worldMapName .. "/" .. textureName
    end

    return textureName
end

function Harvest.saveMapName(currentMap)
    local textureNameA = GetMapTileTexture()
    local textureNameB = GetMapTileTexture()
    textureNameA = string.lower(textureNameA)
    textureNameB = string.lower(textureNameB)

    local _,_,zone,subzone = string.find(textureNameA, "maps/([%w%-]+)/([%w%-]+_%w+)")
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
        Harvest.NumNodesAdded = Harvest.NumNodesAdded + 1
    end
    if counter == "nonfalse" then
        Harvest.NumUnlocalizedFalseNodes = Harvest.NumUnlocalizedFalseNodes + 1
    end
    if counter == "nonvalid" then
        Harvest.NumUnlocalizedNodesAdded = Harvest.NumUnlocalizedNodesAdded + 1
    end
    if counter == "reject" then
        Harvest.NumRejectedNodes = Harvest.NumRejectedNodes + 1
    end
    if counter == "insert" then
        Harvest.NumInsertedNodes = Harvest.NumInsertedNodes + 1
    end
    if counter == "mapfiltered" then
        Harvest.NumMapFiltered = Harvest.NumMapFiltered + 1
    end
end

function Harvest.saveData(nodeType, zone, x, y, profession, nodeName, itemID, scale, counter )

    -- If the map is on the blacklist then don't log it
    if Harvest.blacklistMap(zone) then
        return
    end

    if not profession then
        return
    end

    if Harvest.savedVars[nodeType] == nil or Harvest.savedVars[nodeType].data == nil then
        d("Attempted to log unknown type: " .. nodeType)
        return
    end

    if Harvest.alreadyFound(nodeType, zone, x, y, profession, nodeName, scale, counter ) then
        return
    end

    -- If this check is not here the next routine will fail
    -- after the loading screen because for a brief moment
    -- the information is not available.
    if Harvest.savedVars[nodeType] == nil then
        return
    end

    if not Harvest.savedVars[nodeType].data[zone] then
        Harvest.savedVars[nodeType].data[zone] = {}
    end

    if not Harvest.savedVars[nodeType].data[zone][profession] then
        Harvest.savedVars[nodeType].data[zone][profession] = {}
    end

    if Harvest.defaults.debug then
        d("Save data!")
    end

    table.insert( Harvest.savedVars[nodeType].data[zone][profession], Harvest.Serialize({ x, y, { nodeName }, itemID }) )
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

function Harvest.returnNameFound(table, value)
    for key, name in pairs(table) do
        if name == value then
            return name
        end
    end
    return nil
end

function Harvest.duplicateName(table, value)
    for key, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Harvest.alreadyFound(nodeType, zone, x, y, profession, nodeName, scale, counter )

    if not Harvest.savedVars[nodeType].data[zone] then
        return false
    end

    if not Harvest.savedVars[nodeType].data[zone][profession] then
        return false
    end

    local distance
    if scale == nil then
        distance = Harvest.minDefault
    else
        distance = scale
    end

    for i, item in ipairs( Harvest.savedVars[nodeType].data[zone][profession] ) do
        local entry = type(item) == "string" and Harvest.Deserialize(item) or item 
        local dx = entry[1] - x
        local dy = entry[2] - y
        -- (x - center_x)2 + (y - center_y)2 = r2, where center is the player
        dist = math.pow(dx, 2) + math.pow(dy, 2)
        -- dist2 = dx * dx + dy * dy
        -- Harvest.Debug(dist .. " : " .. dist2)
        if dist < distance then -- near player location
            if not Harvest.duplicateName(entry[3], nodeName) then
                if Harvest.defaults.debug then
                    Harvest.Debug(nodeName .. " : insterted into existing Node")
                end
                table.insert(entry[3], nodeName)
                Harvest.savedVars[nodeType].data[zone][profession][i] = Harvest.Serialize(entry)
                Harvest.changeCounters("insert")
            end
            if Harvest.defaults.debug then
                d("Node:" .. nodeName .. " on: " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " already found!")
            end
            return true
        end
    end
    if Harvest.defaults.debug then
        d("Node:" .. nodeName .. " on: " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " not found!")
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
            -- if Harvest.defaults.verbose and blockedNode ~= nil then
            --     if blockedNode then
            --         d("blockedNode : Is True")
            --     end
            -- end
            -- if Harvest.defaults.verbose and additionalInfo ~= nil then
            --     d("Additional Info : " .. additionalInfo)
            -- end
            -- if Harvest.defaults.verbose and contextlInfo ~= nil then
            --     d("Contextual Info : " .. contextlInfo)
            -- end

            local myLocation = Harvest.GetMap()
            if Harvest.defaults.verbose then
                d("Map Name : " .. GetMapName() .. " : texture name : " .. myLocation )
            end

            --Harvest.saveMapName(myLocation)

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
    "esoinvalid",
    "unlocalnode",
    "rejected",
}

function Harvest.IsValidCategory(name)
    for k, v in pairs(Harvest.validCategories) do
        if string.lower(v) == string.lower(name) then
            return true
        end
    end

    return false
end

function Harvest.getTotals(counter)
    local totalNodes = 0
    for counterName, counterValue in pairs(counter) do
        totalNodes = totalNodes + counterValue
    end
    return totalNodes
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

    if commands[1] == "import" then
        if commands[2] then
            if commands[2] == "esohead" then
                return Harvest.importFromEsohead()
            elseif commands[2] == "esomerge" then
                return Harvest.importFromEsoheadMerge()
            elseif commands[2] == "harvester" then
                return Harvest.importFromHarvester()
            elseif commands[2] == "merger" then
                return Harvest.importFromHarvestMerge()
            end
            d("Please enter a valid addon to import")
            d("Valid addons are esohead, esomerge, harvester and")
            d("merger (HarvestMerge)")
            return
        end

    elseif commands[1] == "update" then
        if commands[2] then
            if Harvest.IsValidCategory(commands[2]) then
                return Harvest.updateHarvestNodes(commands[2])
            end
        end
        d("Please enter a valid HarvestMap category to update")
        d("Valid categories are mapinvalid, esonodes, esoinvalid")
        d("and nodes (Not recomended)")
        return

    elseif commands[1] == "reset" then
        if commands[2] then
            if commands[2] == "defaults" then
                Harvest.savedVars.settings = Harvest.DefaultConfiguration
                Harvest.defaults = Harvest.DefaultSettings
                ReloadUI("ingame")
            elseif Harvest.IsValidCategory(commands[2]) then
                Harvest.savedVars[commands[2]].data = {}
                Harvest.RefreshPins()
                return d("HarvestMap saved data : " .. commands[2] .. " has been reset")
            elseif commands[2] == "alldata" then
                for nodeType, nodeData in pairs(Harvest.savedVars) do
                    if nodetype ~= "settings" and nodeType ~= "defaults" then
                        nodeData.data = {}
                    end
                end
                Harvest.RefreshPins()
                return d("HarvestMap saved data has been completely reset")
            end
        end
        d("Please enter a valid HarvestMap category to reset.")
        d("Valid categories are mapinvalid, esonodes, esoinvalid,")
        d("nodes and alldata (Not recomended)")
        return

    elseif commands[1] == "datalog" then
        if not commands[2] or not Harvest.IsValidCategory(commands[2]) then
            d("Please enter a valid datalog type.")
            d("Valid types are mapinvalid, esonodes, esoinvalid")
            d("and nodes.")
        else
            d("---")
            d("Complete list of gathered data:")
            d("---")

            local counter = {
                ["mining"] = 0,
                ["cloth"] = 0,
                ["rune"] = 0,
                ["alch"] = 0,
                ["wood"] = 0,
                ["chest"] = 0,
                ["solvent"] = 0,
                ["fish"] = 0,
            }

            for nodeType, nodeData in pairs(Harvest.savedVars) do
                if nodeType == commands[2] then
                    for zone, zoneData in pairs(nodeData.data) do
                        for provisions, data in pairs(zoneData) do
                            if provisions == 1 then
                                counter["mining"] = counter["mining"] + #data
                            end
                            if provisions == 2 then
                                counter["cloth"] = counter["cloth"] + #data
                            end
                            if provisions == 3 then
                                counter["rune"] = counter["rune"] + #data
                            end
                            if provisions == 4 then
                                counter["alch"] = counter["alch"] + #data
                            end
                            if provisions == 5 then
                                counter["wood"] = counter["wood"] + #data
                            end
                            if provisions == Harvest.chestID then
                                counter["chest"] = counter["chest"] + #data
                            end
                            if provisions == 7 then
                                counter["solvent"] = counter["solvent"] + #data
                            end
                            if provisions == Harvest.fishID then
                                counter["fish"] = counter["fish"] + #data
                            end
                        end
                    end
                end
            end

            local totals = Harvest.getTotals(counter)
            d("Mining: "          .. Harvest.NumberFormat(counter["mining"]))
            d("Clothing: "          .. Harvest.NumberFormat(counter["cloth"]))
            d("Enchanting: "          .. Harvest.NumberFormat(counter["rune"]))
            d("Alchemy: "          .. Harvest.NumberFormat(counter["alch"]))
            d("Woodworking: "          .. Harvest.NumberFormat(counter["wood"]))
            d("Treasure Chests: "  .. Harvest.NumberFormat(counter["chest"]))
            d("Solvent: "          .. Harvest.NumberFormat(counter["solvent"]))
            d("Fishing Pools: "    .. Harvest.NumberFormat(counter["fish"]))
            d("Total: "    .. Harvest.NumberFormat(totals))

            d("---")
        end
        return
    end

    d("Please enter a valid HarvestMap command:")
    d("  /harvest import <addon>")
    d("  /harvest update <category>")
    d("  /harvest reset <category>")
    d("  /harvest datalog <category>")
end

function Harvest.OnLoad(eventCode, addOnName)

        Harvest.defaults = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "defaults", Harvest.DefaultSettings )

        Harvest.minDefault = 0.000001 * Harvest.defaults.minDefault
        Harvest.minReticleover = 0.000001 * Harvest.defaults.minReticleover

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
                --["mapnames"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapnames", Harvest.dataDefault),

                ["settings"]    = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 1, "settings", Harvest.DefaultConfiguration ),

                -- All rejected records for debugging
                ["rejected"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "rejected", Harvest.dataDefault),
                ["unlocalnode"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "unlocalnode", Harvest.dataDefault)
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
                --["mapnames"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "mapnames", Harvest.dataDefault),


                ["settings"]    = ZO_SavedVars:New("Harvest_SavedVars", 1, "settings", Harvest.DefaultConfiguration ),

                -- All rejected records for debugging
                ["rejected"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "rejected", Harvest.dataDefault),
                ["unlocalnode"]      = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "unlocalnode", Harvest.dataDefault)
            }
        end

    Harvest.defaults.language = Harvest.language

    if Harvest.defaults.internalVersion < Harvest.internalVersion then
        Harvest.updateOldHarvestMapNodes("data")
        Harvest.updateOldHarvestMapNodes("oldData")
        Harvest.updateOldHarvestMapNodes("oldMapData")
        Harvest.defaults.internalVersion = Harvest.internalVersion
    end

    if Harvest.defaults.dataVersion < Harvest.dataVersion then
        Harvest.updateHarvestNodes("nodes")
        Harvest.updateHarvestNodes("mapinvalid")
        Harvest.updateHarvestNodes("esonodes")
        Harvest.updateHarvestNodes("esoinvalid")
        Harvest.defaults.dataVersion = Harvest.dataVersion
    end

    if Harvest.defaults.internalVersion ~= Harvest.internalVersion then
        Harvest.defaults.internalVersion = Harvest.internalVersion
    end

    Harvest.InitializeMapMarkers()
    Harvest.InitializeCompassMarkers()
    EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_PLAYER_ACTIVATED,
    function()
        Harvest.InitializeOptions()
        EVENT_MANAGER:UnregisterForEvent("HarvestMap", EVENT_PLAYER_ACTIVATED)
    end)

    EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_RECEIVED, Harvest.OnLootReceived)
    -- EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_UPDATED, Harvest.OnLootUpdate)

end

function Harvest.Initialize()

    Harvest.dataDefault = {
        data = {}
    }
    Harvest.DefaultSettings = {
        wideSetting = false,
        debug = false,
        verbose = false,
        compass = true,
        internalVersion = 0,
        dataVersion = 0,
        language = "",
        minDefault = 25, -- 0.000025 or 0.005^2
        minReticleover = 49 -- 0.000049 or 0.007^2
    }

    Harvest.DefaultConfiguration = {
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
        compassLayouts = Harvest.defaultCompassLayouts,
        mapnameFilters = {
            ["alikr"] = false,          --Alik'r Desert
            ["auridon"] = false,        --Auridon, Khenarthi's Roost
            ["bangkorai"] = false,      --Bangkorai
            ["coldharbor"] = false,     --Coldharbour
            ["craglorn"] = false,       --Craglorn
            ["cyrodiil"] = false,       --Cyrodiil
            ["deshaan"] = false,        --"Deshaan"
            ["eastmarch"] = false,      --Eastmarch
            ["glenumbra"] = false,      --Glenumbra, Betnikh, Stros M'Kai
            ["grahtwood"] = false,      --Grahtwood
            ["greenshade"] = false,     --Greenshade
            ["malabaltor"] = false,     --Malabal Tor
            ["reapersmarch"] = false,   --Reaper's March
            ["rivenspire"] = false,     --Rivenspire
            ["shadowfen"] = false,      --Shadowfen
            ["stonefalls"] = false,     --Stonefalls, Bal Foyen, Bleakrock Isle
            ["stormhaven"] = false,     --Stormhaven
            ["therift"] = false,        --The Rift
            ["cities"] = false,         --City Filters
        }
}

    Harvest.langs = { "en", "de", "fr", }

    Harvest.minDefault = 0.000025 -- 0.005^2
    Harvest.minDist = 0.000025 -- 0.005^2
    Harvest.minReticleover = 0.000049 -- 0.007^2

    Harvest.isHarvesting = false
    Harvest.action = nil

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

end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, function (eventCode, addOnName)
    if addOnName == "HarvestMap" then
        Harvest.Initialize()
        Harvest.OnLoad(eventCode, addOnName)
    end
end)
