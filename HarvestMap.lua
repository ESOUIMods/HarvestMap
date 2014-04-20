Harvest = {}
Harvest.chestID = 6
Harvest.fishID = 9
Harvest.BookshelfID = 10

local internalVersion = 1

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
        Harvest.IsPlayerFishing() or
        Harvest.IsPlayerHarvesting() ) ) then

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

-- Define Function Better
-- 1: lootIndex
-- 2: Boolean: Is it Quest Loot
-- 3: Boolean: Looted By Player
-- Harvest.OnLootReceived( NumItemsLooted, LootIsQuest, true )
function Harvest.OnLootReceived( NumItemsLooted, LootIsQuest, LootedBySelf )

    if Harvest.settings.verbose then
        d("OnLootReceived")
    end

    -- Exit if Quest Loot or not LootedBySelf then
    if LootIsQuest or (not LootedBySelf) then
        if Harvest.settings.debug then
            if  not LootedBySelf then
                d("Not Looted by self.")
            end
            if  not LootIsQuest then
                d("This is Quest Loot!")
            end
        end
        if Harvest.settings.verbose then
            d("OnLootReceived exited")
        end
        return
    end

    local zone, x, y = Harvest.GetLocation()
    local itemID
    -- name, color, type, id, +19 other attributes
    -- local unknown1, unknown2, unknown3, unknown4, unknown5, unknown6, unknown7, unknown8, unknown9, unknown10, unknown11, unknown12, unknown13, unknown14, unknown15, unknown16, unknown17, unknown18, unknown19, unknown20, unknown21, unknown22 = ITEM_LINK_TYPE( objeckLink )

    -- option 2: Keep
    local CurentInteractionType = GetInteractionType()
    -- option 3: Keep
    local ItemName, itemColor, itemType, itemID = ZO_LinkHandler_ParseLink( GetLootItemLink(NumItemsLooted) )
    -- [PREFERED] option 4
    -- string TargetNodeName, TargetInteractionType targetType, string TargetActionName
    local TargetNodeName, TargetInteractionType, TargetActionName = GetLootTargetInfo()

    itemID = tonumber(itemID)
    -- if itemID is nil Harvest.GetProfessionType will fail
    if itemID == nil then
        if Harvest.settings.verbose then
            d("OnLootReceived exited because itemID was nil")
        end
        return
    end

    -- Display Results
    if Harvest.settings.verbose then
        -- NumItemsLooted
        d("Lootindex : " .. NumItemsLooted .. " : Target Action : " .. TargetActionName .. " : Node Name : " .. TargetNodeName .. " : Item Name : " .. ItemName )
        -- InterAction Type
        d("InteractionType : " .. CurentInteractionType .. " : TargetInteractionType : preferred(" .. TargetInteractionType .. ")" )
        -- ItemType
        d("itemID : " .. itemID .. " : Item Type : " .. itemType )
    end

    -- 0: INTERACT_TARGET_TYPE_NONE
    -- 1: INTERACT_TARGET_TYPE_OBJECT - NPC, Pure Water, Essence Rune
    -- 2: INTERACT_TARGET_TYPE_ITEM
    -- 4: INTERACT_TARGET_TYPE_QUEST_ITEM
    -- 5: INTERACT_TARGET_TYPE_FIXTURE - Trunk, Dresser
    -- 6: INTERACT_TARGET_TYPE_AOE_LOOT

    if TargetInteractionType == INTERACT_TARGET_TYPE_FIXTURE then
        profession = 8 -- set to Container
    else
        -- HarvestMap tracks lootable nodes, not item names. Pass Node Name
        profession = Harvest.GetProfessionType(itemID, TargetNodeName)
    end

    -- Don't need to track torchbug loot
    if (profession < 1) then
        if Harvest.settings.debug then
            d("OnLootReceived: Valid profession information Not found!")
        end
        return
    end

    Harvest.saveData( zone, x, y, profession, Harvest.nodeName, itemID )
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
        local NumItemsLooted, ItemName, ItemtextureName, Itemcount, Itemquality, Itemvalue, LootIsQuest = GetLootItemInfo(lootIndex)

        if (ItemName ~= "") or (ItemName ~= nil) then
            Harvest.ItemName = ItemName
        else
            -- force display if Debug is off to inform player of potential issue
            d('OnLootUpdate ItemName is empty or nil.')
        end

        -- previously it was GetLootItemLink(id)
        -- Passes lootIndex to OnLootRecived, not the link
        -- Passes QuestLoot Boolean, and PlayerLooted
        Harvest.OnLootReceived( NumItemsLooted, LootIsQuest, true )
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
    if profession >= 1 and profession <= 10 then
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
            return v
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
    -- Returns when you load a new area such as the bank or
    -- when the Map or Char screen is open
    -- Prevents a bug causing an exception when zone information
    -- is briefly unavailable after the loading screen closes
    if IsGameCameraUIModeActive() then
        return
    end

    --  string:nilable action, string:nilable name, bool interactBlocked, integer additionalInfo, integer:nilable contextualInfo
    local newAction, nodeName, blockedNode, additionalInfo, contextlInfo = GetGameCameraInteractableActionInfo()

    local isHarvesting = Harvest.IsPlayerBusy()
    if not isHarvesting then

        -- Use node name for Pure Water in Deshann
        if nodeName then
            Harvest.nodeName = nodeName
        end

        if Harvest.isHarvesting and time - Harvest.time > 1 then
            Harvest.isHarvesting = false
        end

        -- To Do: Make sure HarvestMap does not track Lore Books
        -- BOOK_LINK_TYPE
        -- GetItemLink(integer bagId, integer slotIndex, LinkStyle linkStyle)
        -- Returns: string link
        -- GetItemLinkInfo(string itemLink)
        -- Returns: string icon, integer sellPrice, bool meetsUsageRequirement, integer equipType, integer itemStyle

        -- Player read the book, record it
        if Harvest.PlayerReadBook then
            Harvest.TrackBook()
            Harvest.PlayerReadBook = false
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

            -- Track BookShelf
            if Harvest.action == GetString(SI_GAMECAMERAACTIONTYPE1) then
                if Harvest.IsValidBook(Harvest.nodeName) then
                    local zone, x, y = Harvest.GetLocation()
                    Harvest.saveData( zone, x, y, Harvest.BookshelfID, Harvest.nodeName, nil )
                    Harvest.RefreshPins( Harvest.BookshelfID )
                end
            end

        end
    else
    -- if IsPlayerInteractingWithObject() then
    -- Same as a beginning of a new block of code
        Harvest.isHarvesting = true
        Harvest.time = time

            -- Player is interacting with an object, what is it?
            -- Determine if New Action is Reading
            if Harvest.IsPlayerReading() and not Harvest.PlayerReadBook then
                Harvest.PlayerReadBook = true
            end

    -- End of Else Block
    end -- End of Else Block
end

function Harvest.OnLoad(eventCode, addOnName)
    if addOnName ~= "HarvestMap" then
        return
    end

    -- Set Localization
    Harvest.language = (GetCVar("language.2") or "en")
    Harvest.localization = Harvest.allLocalizations[Harvest.language]

    -- NEW keep these they init some flags
    Harvest.PlayerReadBook = false

    Harvest.isHarvesting = false
    Harvest.minDist = 0.000025 -- 0.005^2
    Harvest.nodes = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 2, "nodes", { data = {} } )
    Harvest.settings = ZO_SavedVars:NewAccountWide("Harvest_SavedVars", 1, "settings",
        {
            filters = {
                -- [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true
                [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true
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