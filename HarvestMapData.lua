Harvest.professions = {
    -- : Mining
    [1] = {
        808,
        4482,
        4995,
        5820,
        23103,
        23104,
        23105,
        23133,
        23134,
        23135,
    },
    -- : Clothing
    [2] = {
        793,
        800,
        812,
        4448,
        4464,
        4478,
        6020,
        23095,
        23097,
        23129,
        23130,
        23131,
        23142,
        23143,
        33217,
        33218,
        33219,
        33220,
    },
    -- : Enchanting
    [3] = {
        45806,
        45807,
        45808,
        45809,
        45810,
        45811,
        45812,
        45813,
        45814,
        45815,
        45816,
        45817,
        45818,
        45819,
        45820,
        45821,
        45822,
        45823,
        45824,
        45825,
        45826,
        45827,
        45828,
        45829,
        45830,
        45831,
        45832,
        45833,
        45834,
        45835,
        45836,
        45837,
        45838,
        45839,
        45840,
        45841,
        45842,
        45843,
        45844,
        45845,
        45846,
        45847,
        45848,
        45849,
        45850,
        45851,
        45852,
        45853,
        45854,
        45855,
        45856,
        45857,
        54248,
        54253,
        54289,
        54294,
        54297,
        54299,
        54306,
        54330,
        54331,
        54342,
        54373,
        54374,
        54375,
        54481,
        54482,
    },
    -- : Alchemy
    [4] = {
        883,
        1187,
        4570,
        23265,
        23266,
        23267,
        23268,
        30148,
        30149,
        30151,
        30152,
        30153,
        30154,
        30155,
        30156,
        30157,
        30158,
        30159,
        30160,
        30161,
        30162,
        30163,
        30164,
        30165,
        30166,
        42871,
    },
    -- : Wood ; In Esohead Wood is (6)
    [5] = {
        521,
        802,
        818,
        4439,
        23117,
        23118,
        23119,
        23137,
        23138,
    },
-- These additional elements in the array are here for consistency in how
-- the arrays are already handled.  It is also appended in this way for
-- compatibility with the data already collected by users.  Chests are already
-- handled separately.
--
-- 6 = Chest, 7 = Solvent, 8 = Container, 9 = Fish, 10 = Books
-- 45036, -- This is a Chest you unlock
    [6] = {
    },
    [7] = {
    },
    -- Added : Container
    -- These values are from Esohead in section [5]
    -- I believe they are provisioning ItemID numbers
    [8] = {
        26802,
        26954,
        26962,
        26966,
        26974,
        26975,
        26976,
        26977,
        26978,
        26986,
        26987,
        26988,
        26989,
        26990,
        26998,
        26999,
        27000,
        27001,
        27002,
        27003,
        27004,
        27035,
        27043,
        27044,
        27048,
        27049,
        27051,
        27052,
        27053,
        27057,
        27058,
        27059,
        27063,
        27064,
        27100,
        28603,
        28604,
        28605,
        28606,
        28607,
        28608,
        28609,
        28610,
        28632,
        28634,
        28635,
        28636,
        28637,
        28638,
        28639,
        28666,
        29030,
        33752,
        33753,
        33754,
        33755,
        33756,
        33757,
        33758,
        33767,
        33768,
        33769,
        33770,
        33771,
        33772,
        33773,
        33774,
        34304,
        34305,
        34306,
        34307,
        34308,
        34309,
        34311,
        34312,
        34321,
        34322,
        34323,
        34324,
        34329,
        34330,
        34331,
        34332,
        34333,
        34334,
        34335,
        34336,
        34345,
        34346,
        34347,
        34348,
        34349,
        40260,
        40261,
        40262,
        40263,
        40264,
        40265,
        40266,
        40267,
        40268,
        40269,
        40270,
        40271,
        40272,
        40273,
        40274,
        40276,
        45522,
        45523,
        45524,
    },
    [9] = {
    },
    [10] = {
    },
}
-- Books is the exception such that there may be a way to record lore books
-- that are always in the same location and usable only once like Skyshards.
--
-- Esohead uses the same ItemID for multiple items.  Therefore maintaining
-- a list based on the item number would become useless bloat in a file.
-- All items looted in ESO are containers.  Such that Jute is a container
-- it just gives you Jute.  a Crate is a container that gives you food items.
-- Therefore the name of the item collected will dictate it's category
-- rather than the Item's ID number.
--
-- (1) Mining
Harvest.mining = {
    ["en"] = {
        "Iron Ore",
        "High Iron Ore",
        "Orichalcum Ore",
        "Dwarven Ore",
        "Ebony Ore",
        "Calcinium Ore",
        "Galatite Ore",
        "Quicksilver Ore",
        "Voidstone Ore",
    },
    ["de"] = {
        "Eisenerz",
        "Feineisenerz",
        "Oreichalkoserz",
        "Dwemererz",
        "Ebenerz",
        "Kalciniumerz",
        "Galatiterz",
        "Quicksilver Ore",
        "Leerensteinerz",
    },
    ["fr"] = {
        "Minerai de Fer",
        "Minerai de Fer Noble",
        "Minerai D'orichalque",
        "Dwarven Ore",
        "Ebony Ore",
        "Calcinium Ore",
        "Galatite Ore",
        "Quicksilver Ore",
        "Voidstone Ore",
    },
}

-- (2) Clothing
Harvest.clothing = {
    ["en"] = {
        "Cotton",
        "Ebonthread",
        "Flax",
        "Ironweed",
        "Jute",
        "Kreshweed",
        "Silverweed",
        "Spidersilk",
        "Void Bloom",
        "Silver Weed",
        "Kresh Weed",
    },
    ["de"] = {
        "Baumwolle",
        "Ebenseide",
        "Flachs",
        "Eisenkraut",
        "Jute",
        "Kreshweed",
        "Silverweed",
        "Spinnenseide",
        "Leere Blüte",
        "Silver Weed",
        "Kresh Weed",
    },
    ["fr"] = {
        "Cotton",
        "Ebonthread",
        "Lin",
        "Ironweed",
        "Jute",
        "Kreshweed",
        "Silverweed",
        "Spidersilk",
        "Void Bloom",
        "Silver Weed",
        "Kresh Weed",
    },
}
-- (3) Enchanting
Harvest.enchanting = {
    ["en"] = {
        "Aspect Rune",
        "Essence Rune",
        "Potency Rune",
    },
    ["de"] = {
        "Aspektrune",
        "Essenzrune",
        "Machtrune",
    },
    ["fr"] = {
        "Rune d'Aspect",
        "Rune D'essence",
        "Rune de Puissance",
    },
}
-- (4) Alchemy
Harvest.alchemy = {
    ["en"] = {
        "Blessed Thistle",
        "Entoloma",
        "Bugloss",
        "Columbine",
        "Corn Flower",
        "Dragonthorn",
        "Emetic Russula",
        "Imp Stool",
        "Lady's Smock",
        "Luminous Russula",
        "Mountain Flower",
        "Namira's Rot",
        "Nirnroot",
        "Stinkhorn",
        "Violet Copninus",
        "Water Hyacinth",
        "White Cap",
        "Wormwood",
    },
    ["de"] = {
        "Blessed Thistle",
        "Entoloma",
        "Bugloss",
        "Columbine",
        "Corn Flower",
        "Dragonthorn",
        "Emetic Russula",
        "Imp Stool",
        "Lady's Smock",
        "Luminous Russula",
        "Mountain Flower",
        "Namira's Rot",
        "Nirnroot",
        "Stinkhorn",
        "Violet Copninus",
        "Water Hyacinth",
        "White Cap",
        "Wormwood",
    },
    ["fr"] = {
        "Blessed Thistle",
        "Entoloma",
        "Bugloss",
        "Columbine",
        "Corn Flower",
        "Dragonthorn",
        "Emetic Russula",
        "Imp Stool",
        "Lady's Smock",
        "Luminous Russula",
        "Mountain Flower",
        "Namira's Rot",
        "Nirnroot",
        "Stinkhorn",
        "Violet Copninus",
        "Water Hyacinth",
        "White Cap",
        "Wormwood",
    },
}
-- (5) Woodworking ; In Esohead Woodworking is (6)
Harvest.woodworking = {
    ["en"] = {
        "Ashtree",
        "Beech",
        "Birch",
        "Hickory",
        "Mahogany",
        "Maple",
        "Nightwood",
        "Oak",
        "Yew",
    },
    ["de"] = {
        "Eschenholz",
        "Buchenholz",
        "Birkenholz",
        "Hickoryholz",
        "Mahagoniholz",
        "Ahornholz",
        "Nachtholz",
        "Eiche",
        "Eibenholz",
    },
    ["fr"] = {
        "Frêne",
        "Hêtre",
        "Bouleau",
        "Hickory",
        "Mahogany",
        "Érable",
        "Nightwood",
        "Chêne",
        "If",
    },
}

-- 7 = Solvent: These need verification to see
-- if all of them have Solvents in then
Harvest.solvent = {
    ["en"] = {
        "Bottle",
        "Bottles",
        "Cup",
        "Cups",
        "Drink",
        "Goblet",
        "Jar",
        "Jug",
        "Mug",
        "Pure Water",
        "Water Skin",
        "Wine Rack",
    },
    ["de"] = {
        "Flasche",
        "Flaschen",
        "Tasse",
        "Tassen",
        "Getränk",
        "Becher",
        "Gefäß",
        "Krug",
        "Becher",
        "Pure Water",
        "Wasserhaut",
        "Weinregal",
    },
    ["fr"] = {
        "Bouteille",
        "Bouteilles",
        "Cup",
        "Cups",
        "Boisson",
        "Chope",
        "Jar",
        "Pichet",
        "Mug",
        "Pure Water",
        "Outre d'Eau",
        "Casier ŕ bouteilles",
    },
}

-- 8 = Container
Harvest.container = {
    ["en"] = {
        "Backpack",
        "Barrel",
        "Barrel (Burnt)",
        "Barrels",
        "Barrels (Burnt)",
        "Basket",
        "Cabinet",
        "Crate",
        "Crate (Burnt)",
        "Crates",
        "Crates (Burnt)",
        "Cupboard",
        "Desk",
        "Dresser",
        "Heavy Sack",
        "Nightstand",
        "Pot",
        "Sack",
        "Tomb Urn",
        "Trunk",
        "Urn",
        "Vase",
        "Wardrobe",
    },
    ["de"] = {
        "Rucksack",
        "Fass",
        "Fass (versengt)",
        "Fässer",
        "Fässer (versengt)",
        "Korb",
        "Schrank",
        "Kiste",
        "Kiste (versengt)",
        "Kisten",
        "Kisten (versengt)",
        "Schrank",
        "Schreibtisch",
        "Kommode",
        "Heavy Sack",
        "Nachttisch",
        "Topf",
        "Sack",
        "Urnengrab",
        "Truhe",
        "Urne",
        "Vase",
        "Kleiderschrank",
    },
    ["fr"] = {
        "Sac ŕ dos",
        "Tonneau",
        "Tonneau (brûlé)",
        "Tonneaux",
        "Tonneaux (brûlés)",
        "Panier",
        "Cabinet",
        "Caisse",
        "Caisse (brûlée)",
        "Caisses",
        "Caisses (brûlées)",
        "Commode",
        "Bureau",
        "Table de chevet",
        "Heavy Sack",
        "Table de chevet",
        "Pot",
        "Sac",
        "Tomb Urn",
        "Coffre",
        "Urne",
        "Vase",
        "Garde-robe",
    },
}

-- 10 = Books
Harvest.books = {
    ["en"] = {
        "Book",
        "Book Stack",
        "Books",
        "Bookshelf",
    },
    ["de"] = {
        "Buch",
        "Buchstapel",
        "Bücher",
        "Bücherregal",
    },
    ["fr"] = {
        "Livre",
        "Pile de livres",
        "Livres",
        "Étagère",
    },
}

function Harvest.IsValidMining(name)
    for k, v in pairs(Harvest.mining[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidClothing(name)
    for k, v in pairs(Harvest.clothing[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidEnchanting(name)
    for k, v in pairs(Harvest.enchanting[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidAlchemy(name)
    for k, v in pairs(Harvest.alchemy[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidWoodworking(name)
    for k, v in pairs(Harvest.woodworking[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidSolvent(name)
    for k, v in pairs(Harvest.solvent[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidContainer(name)
    for k, v in pairs(Harvest.container[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

function Harvest.IsValidBook(name)
    for k, v in pairs(Harvest.books[Harvest.language]) do
        if v == name then
            return true
        end
    end

    return false
end

-- Arguments Required ItemID, NodeName
-- Returns -1 when Object interacted with is invalid
-- Valid types: (1)Mining, (2)Clothing, (3)Enchanting
-- (4)Alchemy, (5)Wood, (6)Chests, (7)Solvents
-- (8)Containers, (9)Fish, (10)Books
-- Books Not fully implemented
function Harvest.GetProfessionType(id, name)
    local tsId
    id = tonumber(id)

    if Harvest.settings.debug then
        d("Attempting GetProfessionType with id : " .. id)
        d("and item name : " .. name)
    end

    -- Set (1)Mining
    if Harvest.IsValidMining(name) then
        tsId = 1
        if Harvest.settings.verbose then
            d("Solvent id assigned : " .. tsId)
        end
        return tsId
    end
    -- Set (2)Clothing
    if Harvest.IsValidClothing(name) then
        tsId = 2
        if Harvest.settings.verbose then
            d("Clothing id assigned : " .. tsId)
        end
        return tsId
    end
    -- Set (3)Enchanting
    if Harvest.IsValidEnchanting(name) then
        tsId = 3
        if Harvest.settings.verbose then
            d("Solvent id assigned : " .. tsId)
        end
        return tsId
    end
    -- Set (4)Alchemy
    if Harvest.IsValidAlchemy(name) then
        tsId = 4
        if Harvest.settings.verbose then
            d("Solvent id assigned : " .. tsId)
        end
        return tsId
    end
    -- Set (5)Woodworking
    if Harvest.IsValidWoodworking(name) then
        tsId = 5
        if Harvest.settings.verbose then
            d("Solvent id assigned : " .. tsId)
        end
        return tsId
    end
    -- Set (7)Solvent
    if Harvest.IsValidSolvent(name) then
        tsId = 7
        if Harvest.settings.verbose then
            d("Solvent id assigned : " .. tsId)
        end
        return tsId
    end

    -- Set (8)Container
    -- Added Container ItemIDs from EsoHead
    -- However, it seems that names are still needed.
    if Harvest.IsValidContainer(name) then
        tsId = 8
        if Harvest.settings.debug then
            d("Profession id assigned:" .. tsId)
        end
        return tsId
    end

    -- Set Books to (10)Books
    -- This means the Node Name not the Book Title
    if Harvest.IsValidBook(name) then
        tsId = 10
        if Harvest.settings.verbose then
            d("Book id assigned : " .. tsId)
        end
        return tsId
    end

    -- if no valid Node Name by Name is found use ItemID
    for key1, tsData in pairs(Harvest.professions) do
        for key2, value in pairs(tsData) do
            if value == id then
                tsId = key1
                if Harvest.settings.debug then
                    d("Profession id assigned : " .. tsId)
                end
                return tsId
            end
        end
    end

    if Harvest.settings.debug then
        d("No Profession Type found with id : " .. id)
        d("In GetProfessionType with name : " .. name)
    end

    return -1
end