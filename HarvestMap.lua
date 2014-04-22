Harvest = {}
Harvest.chestID = 6
Harvest.fishID = 8

local internalVersion = 1

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
-- Harvesting
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
--         Lore Book Tracking          --
-----------------------------------------

function Harvest.TrackBook()
    local zone, x, y = Harvest.GetLocation()
    if Harvest.settings.verbose then
        d("I Read a Book named, " .. Harvest.nodeName .. " in Zone, " .. zone .. "at xLoc, " .. x .. " and yLoc, " .. y)
    end
    Harvest.saveData( zone, x, y, Harvest.BookshelfID, Harvest.nodeName, nil )
    Harvest.RefreshPins( Harvest.BookshelfID )
end

-----------------------------------------
--         Get Player Location         --
-----------------------------------------

function Harvest.GetLocation()
    SetMapToPlayerLocation()

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


-- Define Function Better
-- 1: lootIndex
-- 2: Boolean: Is it Quest Loot
-- 3: Boolean: Looted By Player
function Harvest.OnLootReceived( receivedBy, objectName, stackCount, soundCategory, lootType, lootedBySelf )
    if Harvest.settings.verbose then
        d("OnLootReceived")
    end

    if not Harvest.isHarvesting or not lootedBySelf then
        if Harvest.settings.verbose then
            if not Harvest.isHarvesting then
                d("Not Harvesting!")
            end
            if not lootedBySelf then
                d("Not Looted by self!")
            end
        end
        return
    end

    local zone, x, y = Harvest.GetLocation()
    -- Global Harvest.NumItemLooted
    -- local itemLink = GetLootItemLink(Harvest.NumItemLooted) -- check variable
    local link = Harvest.ItemLinkParse( objectName )

    -- if link.id is nil Harvest.GetProfessionType will fail
    if link.id == nil then
        if Harvest.settings.verbose then
            d("OnLootReceived exited because itemID was nil")
        end
        return
    end

    -- Global Harvest.lootIndex
    _, _, _, _, _, _, LootIsQuest = GetLootItemInfo(Harvest.lootIndex)
    if LootIsQuest then
        if Harvest.settings.loot then
            d("This is Quest Loot!")
            return
        end
    end

    local TargetNodeName, TargetInteractionType, TargetActionName = GetLootTargetInfo()

    -- 0: INTERACT_TARGET_TYPE_NONE
    -- 1: INTERACT_TARGET_TYPE_OBJECT - NPC, Pure Water, Essence Rune
    -- 2: INTERACT_TARGET_TYPE_ITEM
    -- 4: INTERACT_TARGET_TYPE_QUEST_ITEM
    -- 5: INTERACT_TARGET_TYPE_FIXTURE - Trunk, Dresser
    -- 6: INTERACT_TARGET_TYPE_AOE_LOOT

    profession = Harvest.GetProfessionType(link.id, TargetNodeName)
    if Harvest.settings.debug then
        d("Looted : " .. link.name .. " : ItemID : " .. link.id .. " : Profession Type : " .. tostring(profession) )
    end

    if Harvest.settings.loot then
        local CurentInteractionType = GetInteractionType()
        -- Display Results
        d("Lootindex : " .. Harvest.lootIndex .. " : Number of item(s) looted since login : " .. Harvest.NumItemLooted )
        d("itemID : " .. link.id .. " : Item Type : " .. link.type .. " : Profession Type : " .. tostring(profession) )
        d("InteractionType : " .. CurentInteractionType .. " : [pref]TargetInteractionType : " .. TargetInteractionType )
        d("TargetActionName : " .. TargetActionName .. " : Node Name : " .. TargetNodeName .. " : Item Name : " .. link.name )
    end

    -- Don't need to track torchbug loot
    if (profession < 1) then
        if Harvest.settings.debug then
            d("OnLootReceived: Valid profession information Not found!")
        end
        return
    end

    Harvest.saveData( zone, x, y, profession, Harvest.nodeName, link.id )
    Harvest.RefreshPins( profession )

    if Harvest.settings.verbose then
        d("OnLootReceived exited")
    end
end

function Harvest.OnLootUpdate()

    if Harvest.settings.verbose then
        d("OnLootUpdate")
    end

    -- This line get how many items are in the container
    local items = GetNumLootItems()
    if items < 1 then
        if Harvest.settings.verbose then
            d("OnLootUpdate Exited because items is less then 1.")
            d("Was the Node looted already?")
        end
        return
    end

    for lootIndex = 1,items do
        Harvest.lootIndex = lootIndex
        Harvest.NumItemLooted, itemName = GetLootItemInfo(Harvest.lootIndex)
        if Harvest.settings.loot then
            d("Item #".. tostring(Harvest.NumItemLooted) .. " : " .. Harvest.FormatString(itemName))
        end
        -- ( receivedBy, objectName, stackCount, soundCategory, lootType, lootedBySelf )
        Harvest.OnLootReceived( nil , GetLootItemLink(Harvest.NumItemLooted), nil , nil , nil , true )
    end

    if Harvest.settings.verbose then
        d("OnLootUpdate Exited")
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

    return textureName
end

function Harvest.saveData( zone, x, y, profession, nodeName, itemID )

    if not profession then
        return
    end

    if Harvest.alreadyFound( zone, x, y, profession, nodeName ) then
        return
    end

    -- If this check is not here the next routine will fail
    -- after the loading screen because for a brief moment
    -- the information is not available.
    if Harvest.nodes == nil then
        return
    end

    if not Harvest.nodes.data[zone] then
        Harvest.nodes.data[zone] = {}
    end

    if not Harvest.nodes.data[zone][profession] then
        Harvest.nodes.data[zone][profession] = {}
    end

    if Harvest.settings.debug then
        d("Save data!")
    end

    table.insert( Harvest.nodes.data[zone][profession], { x, y, { nodeName }, itemID } )

end

function Harvest.contains(table, value)
    for key, v in pairs(table) do
        if v == value then
            return key
        end
    end
    return nil
end

function Harvest.alreadyFound( zone, x, y, profession, nodeName )

    -- If this check is not here the next routine will fail
    -- after the loading screen because for a brief moment
    -- the information is not available.
    if Harvest.nodes == nil then
        return
    end

    if not Harvest.nodes.data[zone] then
        return false
    end

    if not Harvest.nodes.data[zone][profession] then
        return false
    end

    local dx, dy
    for _, entry in pairs( Harvest.nodes.data[zone][profession] ) do
        --if entry[3] == nodeName then
            dx = entry[1] - x
            dy = entry[2] - y
            if dx * dx + dy * dy < Harvest.minDist then
                if profession > 0 then
                    if not Harvest.contains(entry[3], nodeName) then
                        table.insert(entry[3], nodeName)
                    end
                    if Harvest.settings.debug then
                        d("Node:" .. nodeName .. " on: " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " already found!")
                    end
                    return true
                else
                    if entry[3][1] == nodeName then
                        if Harvest.settings.debug then
                            d("Node:" .. nodeName .. " on: " .. zone .. " x:" .. x .." , y:" .. y .. " for profession " .. profession .. " already found!")
                        end
                        return true
                    end
                end
            end
        --end
        end
    if Harvest.settings.debug then
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

    local newAction, nodeName, blockedNode, additionalInfo, contextlInfo = GetGameCameraInteractableActionInfo()
    local isHarvesting = ( IsPlayerInteractingWithObject() and Harvest.IsPlayerHarvesting() )
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

            if Harvest.settings.verbose and Harvest.action ~= nil then
                d("Action : " .. Harvest.action)
            end
            if Harvest.settings.verbose and nodeName ~= nil then
                d("Node Name : " .. nodeName)
            end
            if Harvest.settings.verbose and blockedNode ~= nil then
                if blockedNode then
                    d("blockedNode : Is True")
                end
            end
            if Harvest.settings.verbose and additionalInfo ~= nil then
                d("Additional Info : " .. additionalInfo)
            end
            if Harvest.settings.verbose and contextlInfo ~= nil then
                d("Contextual Info : " .. contextlInfo)
            end

            -- Track Chest
            if Harvest.action == GetString(SI_GAMECAMERAACTIONTYPE12) then
                local zone, x, y = Harvest.GetLocation()
                Harvest.saveData( zone, x, y, Harvest.chestID, "chest", nil )
                Harvest.RefreshPins( Harvest.chestID )
            end

            -- Track Fishing Hole
            if Harvest.action == GetString(SI_GAMECAMERAACTIONTYPE16) then
                local zone, x, y = Harvest.GetLocation()
                Harvest.saveData( zone, x, y, Harvest.fishID, "fish", nil )
                Harvest.RefreshPins( Harvest.fishID )
            end

        end
    else
        -- d("I am REALLY busy!")
        Harvest.isHarvesting = true
        Harvest.time = time

    -- End of Else Block
    end -- End of Else Block
end

function Harvest.OnLoad(eventCode, addOnName)
    if addOnName ~= "HarvestMap" then
        return
    end

    -- NEW keep these they init things
    Harvest.isHarvesting = false
    Harvest.NumItemLooted = 0
    Harvest.lootIndex = 0

    Harvest.minDist = 0.000025 -- 0.005^2
    Harvest.nodes = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "nodes", { data = {} } )
    Harvest.settings = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 1, "settings",
        {
            filters = {
                -- [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true
                [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true
            },
            mapLayouts = Harvest.defaultMapLayouts,
            compassLayouts = Harvest.defaultCompassLayouts
        }
    )

    if (Harvest.nodes.internalVersion or 0) < internalVersion then
        Harvest.updateNodes(Harvest.nodes.internalVersion or 0)
        Harvest.nodes.internalVersion = internalVersion
    end

    Harvest.InitializeMapMarkers()
    Harvest.InitializeCompassMarkers()
    Harvest.InitializeOptions()

    EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_RECEIVED, Harvest.OnLootReceived)
    EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_LOOT_UPDATED, Harvest.OnLootUpdate)

end

EVENT_MANAGER:RegisterForEvent("HarvestMap", EVENT_ADD_ON_LOADED, Harvest.OnLoad)