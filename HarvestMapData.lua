Harvest.SolventNodes = { ["en"] = { "Pure Water", "Water Skin", }, ["de"] = { "Reines Wasser", "Wasserhaut", }, ["fr"] = { "Eau Pure", "Outre d'Eau", }, }
Harvest.PotencyRunes = { ["en"] = "Potency Rune", ["de"] = "Machtrune", ["fr"] = "Rune de Puissance", }
Harvest.EssenceRunes = { ["en"] = "Essence Rune", ["de"] = "Essenzrune", ["fr"] = "Rune D'essence", },
Harvest.AspectRunes = { ["en"] = "Aspect Rune", ["de"] = "Aspektrune", ["fr"] = "Rune d'Aspect", },

Harvest.NodeArray = {
    -- : Mining
    [1] = {
        { itemID = 808, nodeName = { "Iron Ore", "Eisenerz", "Minerai de Fer"}, itemName = {"Iron Ore"} },--V
        { itemID = 4482, nodeName = {"Calcinium Ore", "Kalciniumerz", "Minerai de Calcinium"}, itemName = {"Calcinium Ore"} },
        { itemID = 5820, nodeName = { "High Iron Ore", "Feineisenerz", "Minerai de Fer Noble"}, itemName = {"High Iron Ore"} },--V
        { itemID = 23103, nodeName = {"Orichalcum Ore", "Oreichalkoserz", "Minerai D'orichalque"}, itemName = {"Orichalcum Ore"} },--V
        { itemID = 23104, nodeName = {"Dwarven Ore", "Dwemererz", "Minerai Dwemer"}, itemName = {"Dwarven Ore"} },--V
        { itemID = 23105, nodeName = {"Ebony Ore", "Ebenerz", "Minerai d'Ebonite"}, itemName = {"Ebony Ore"} },
        { itemID = 23133, nodeName = {"Galatite Ore", "Galatiterz", "Minerai de Galatite"}, itemName = {"Galatite Ore"} },
        { itemID = 23134, nodeName = {"Quicksilver Ore", "Quicksilver Ore", "Quicksilver Ore"}, itemName = {"Quicksilver Ore"} },
        { itemID = 23135, nodeName = {"Voidstone Ore", "Leerensteinerz", "Minerai de Pierre de Vide",}, itemName = {"Voidstone Ore"} },
    },
    -- : Clothing
    [2] = {
        { itemID = 793, nodeName = {}, itemName = {"Rawhide Scraps"} },
        { itemID = 800, nodeName = {}, itemName = {"Superb Hide Scraps"} },
        { itemID = 812, nodeName = {"Jute",}, itemName = {"Raw jute"} },--V
        { itemID = 4448, nodeName = {}, itemName = {"Hide Scraps"} },
        { itemID = 4464, nodeName = {"Flax", "Flachs", "Lin"}, itemName = {"Raw Flax"} },--V
        { itemID = 4478, nodeName = {}, itemName = {"Shadowhide Scraps"} },
        { itemID = 6020, nodeName = {}, itemName = {"Thick Leather Scraps"} },
        { itemID = 23095, nodeName = {}, itemName = {"Leather Scraps"} },
        { itemID = 23097, nodeName = {}, itemName = {"Fell Hide Scraps"} },
        { itemID = 23129, nodeName = {"Cotton", "Baumwolle", "Coton"}, itemName = {"Raw Cotton"} },--V
        { itemID = 23130, nodeName = {"Spidersilk","Spinnenseide","Toile D'araignée",}, itemName = {"Raw Spidersilk"} },
        { itemID = 23131, nodeName = {"Ebonthread","Ebenseide","Fil d'Ebonite",}, itemName = {"Raw Ebonthread"} },
        { itemID = 23142, nodeName = {}, itemName = {"Topgrain Hide Scraps"} },
        { itemID = 23143, nodeName = {}, itemName = {"Iron Hide Scraps"} },
        { itemID = 33217, nodeName = {"Kreshweed",}, itemName = {"Raw Kreshweed"} },
        { itemID = 33218, nodeName = {"Ironweed","Eisenkraut","Herbe de fer",}, itemName = {"Raw ironweed"} },
        { itemID = 33219, nodeName = {"Silverweed",}, itemName = {"Raw Silverweed"} },
        { itemID = 33220, nodeName = {"Void Bloom","Leere Blüte","Tissu de Vide",}, itemName = {"Raw Void Bloom"} },
    },
    -- : Enchanting
    [3] = {
        { itemID = 45806, nodeName = Harvest.PotencyRunes, itemName = {"Jejora"} },
        { itemID = 45807, nodeName = Harvest.PotencyRunes, itemName = {"Odra"} },
        { itemID = 45808, nodeName = Harvest.PotencyRunes, itemName = {"Pojora"} },
        { itemID = 45809, nodeName = Harvest.PotencyRunes, itemName = {"Edora"} },
        { itemID = 45810, nodeName = Harvest.PotencyRunes, itemName = {"Jaera"} },
        { itemID = 45811, nodeName = Harvest.PotencyRunes, itemName = {"Pora"} },
        { itemID = 45812, nodeName = Harvest.PotencyRunes, itemName = {"Denara"} },
        { itemID = 45813, nodeName = Harvest.PotencyRunes, itemName = {"Rera"} },
        { itemID = 45814, nodeName = Harvest.PotencyRunes, itemName = {"Derado"} },
        { itemID = 45815, nodeName = Harvest.PotencyRunes, itemName = {"Recura"} },
        { itemID = 45816, nodeName = Harvest.PotencyRunes, itemName = {"Cura"} },
        { itemID = 45817, nodeName = Harvest.PotencyRunes, itemName = {"Jode"} },
        { itemID = 45818, nodeName = Harvest.PotencyRunes, itemName = {"Notade"} },
        { itemID = 45819, nodeName = Harvest.PotencyRunes, itemName = {"Ode"} },
        { itemID = 45820, nodeName = Harvest.PotencyRunes, itemName = {"Tade"} },
        { itemID = 45821, nodeName = Harvest.PotencyRunes, itemName = {"Jayde"} },
        { itemID = 45822, nodeName = Harvest.PotencyRunes, itemName = {"Edode"} },
        { itemID = 45823, nodeName = Harvest.PotencyRunes, itemName = {"Pojode"} },
        { itemID = 45824, nodeName = Harvest.PotencyRunes, itemName = {"Rekude"} },
        { itemID = 45825, nodeName = Harvest.PotencyRunes, itemName = {"Hade"} },
        { itemID = 45826, nodeName = Harvest.PotencyRunes, itemName = {"Idode"} },
        { itemID = 45827, nodeName = Harvest.PotencyRunes, itemName = {"Pode"} },
        { itemID = 45828, nodeName = Harvest.PotencyRunes, itemName = {"Kedeko"} },
        { itemID = 45829, nodeName = Harvest.PotencyRunes, itemName = {"Rede"} },
        { itemID = 45830, nodeName = Harvest.PotencyRunes, itemName = {"Kude"} },
        { itemID = 45831, nodeName = Harvest.EssenceRunes itemName = {"Oko"} },
        { itemID = 45832, nodeName = Harvest.EssenceRunes itemName = {"Makko"} },
        { itemID = 45833, nodeName = Harvest.EssenceRunes itemName = {"Deni"} },
        { itemID = 45834, nodeName = Harvest.EssenceRunes itemName = {"Okoma"} },
        { itemID = 45835, nodeName = Harvest.EssenceRunes itemName = {"Makkoma"} },
        { itemID = 45836, nodeName = Harvest.EssenceRunes itemName = {"Denima"} },
        { itemID = 45837, nodeName = Harvest.EssenceRunes itemName = {"Kuoko"} },
        { itemID = 45838, nodeName = Harvest.EssenceRunes itemName = {"Rakeipa"} },
        { itemID = 45839, nodeName = Harvest.EssenceRunes itemName = {"Dekeipa"} },
        { itemID = 45840, nodeName = Harvest.EssenceRunes itemName = {"Meip"} },
        { itemID = 45841, nodeName = Harvest.EssenceRunes itemName = {"Haoko"} },
        { itemID = 45842, nodeName = Harvest.EssenceRunes itemName = {"Deteri"} },
        { itemID = 45843, nodeName = Harvest.EssenceRunes itemName = {"Okori"} },
        { itemID = 45844, nodeName = Harvest.EssenceRunes itemName = {"Jaedi"} },
        { itemID = 45845, nodeName = Harvest.EssenceRunes itemName = {"Lire"} },
        { itemID = 45846, nodeName = Harvest.EssenceRunes itemName = {"Oru"} },
        { itemID = 45847, nodeName = Harvest.EssenceRunes itemName = {"Taderi"} },
        { itemID = 45848, nodeName = Harvest.EssenceRunes itemName = {"Makderi"} },
        { itemID = 45849, nodeName = Harvest.EssenceRunes itemName = {"Kaderi"} },
        { itemID = 45850, nodeName = Harvest.AspectRunes, itemName = {"Ta"} },
        { itemID = 45851, nodeName = Harvest.AspectRunes, itemName = {"Jejota"} },
        { itemID = 45852, nodeName = Harvest.AspectRunes, itemName = {"Denata"} },
        { itemID = 45853, nodeName = Harvest.AspectRunes, itemName = {"Rekuta"} },
        { itemID = 45854, nodeName = Harvest.AspectRunes, itemName = {"Kuta"} },
        { itemID = 45855, nodeName = Harvest.PotencyRunes, itemName = {"Jora"} },
        { itemID = 45856, nodeName = Harvest.PotencyRunes, itemName = {"Porade"} },
        { itemID = 45857, nodeName = Harvest.PotencyRunes, itemName = {"Jera"} },
    },
    -- : Alchemy
    [4] = {
        { itemID = 30148, nodeName = {"Entoloma", "Glöckling",}, itemName = {"Blue Entoloma"} },
        { itemID = 30149, nodeName = {"Stinkhorn","Stinkmorchel","Mutinus Elégans",}, itemName = {"Stinkhorn"} },
        { itemID = 30151, nodeName = {"Emetic Russula","Brechtäubling","Russule Emetique",}, itemName = {"Emetic Russula"} },
        { itemID = 30152, nodeName = {"Violet Copninus","Violetter Tintling","Coprin Violet",}, itemName = {"Violet Copninus"} },
        { itemID = 30153, nodeName = {"Namira's Rot","Namiras Fäulnis","Truffe de Namira",}, itemName = {"Namira's Rot"} },
        { itemID = 30154, nodeName = {"White Cap","Weißkappe","Chapeau Blanc",}, itemName = {"White Cap"} },
        { itemID = 30155, nodeName = {"Luminous Russula","Leuchttäubling","Russule Phosphorescente",}, itemName = {"Luminous Russula"} },
        { itemID = 30156, nodeName = {"Imp Stool","Koboldschemel","Pied-de-Lutin",}, itemName = {"Imp Stool"} },
        { itemID = 30157, nodeName = {"Blessed Thistle","Benediktenkraut", "Chardon Béni",}, itemName = {"Blessed Thistle"} },
        { itemID = 30158, nodeName = {"Lady's Smock","Wiesenschaumkraut","Cardamine des Prés",}, itemName = {"Lady's Smock"} },
        { itemID = 30159, nodeName = {"Wormwood","Wermut","Absinthe",}, itemName = {"Wormwood"} },
        { itemID = 30160, nodeName = {"Bugloss","Wolfsauge","Noctuelle",}, itemName = {"Bugloss"} },
        { itemID = 30161, nodeName = {"Corn Flower","Kornblume","Bleuet",}, itemName = {"Corn Flower"} },
        { itemID = 30162, nodeName = {"Dragonthorn","Drachendorn","Épine-de-Dragon",}, itemName = {"Dragonthorn"} },
        { itemID = 30163, nodeName = {"Mountain Flower","Bergblume","Lys des Cimes",}, itemName = {"Mountain Flower"} },
        { itemID = 30164, nodeName = {"Columbine","Akelei","Ancolie",}, itemName = {"Columbine"} },
        { itemID = 30165, nodeName = {"Nirnroot","Nirnwurz","Nirnrave",}, itemName = {"Nirnroot"} },
        { itemID = 30166, nodeName = {"Water Hyacinth","Wasserhyazinthe","Jacinthe D'eau",}, itemName = {"Water Hyacinth"} },
    },
    -- : Wood ; In Esohead Wood is (6)
    [5] = {
        { itemID = 521, nodeName = {"Oak","Eiche","Chêne",}, itemName = {"Rough Oak"} },
        { itemID = 802, nodeName = {"Maple","Ahornholz","Érable",}, itemName = {"Rough Maple"} },
        { itemID = 818, nodeName = {"Birch","Birkenholz","Bouleau",}, itemName = {"Rough Birch"} },
        { itemID = 4439, nodeName = {"Ashtree","Eschenholz","Frêne",}, itemName = {"Rough Ash"} },
        { itemID = 23117, nodeName = {"Beech","Buche","Hêtre",}, itemName = {"Rough Beech"} },
        { itemID = 23118, nodeName = {"Hickory","Hickoryholz",}, itemName = {"Rough Hickory"} },
        { itemID = 23119, nodeName = {"Yew","Eibenholz","If",}, itemName = {"Rough Yew"} },
        { itemID = 23137, nodeName = {"Mahogany","Mahagoniholz","Acajou",}, itemName = {"Rough Mahogany"} },
        { itemID = 23138, nodeName = {"Nightwood","Nachtholz","Bois de nuit",}, itemName = {"Rough Nightwood"} },
    },
    [6] = {
    },
    -- : Solvent
    [7] = {
        { itemID = 883, nodeName = Harvest.SolventNodes, itemName = {"Natural Water"} }, --V
        { itemID = 1187, nodeName = Harvest.SolventNodes, itemName = {"Clear Water"} }, --V
        { itemID = 4570, nodeName = Harvest.SolventNodes, itemName = {"Pristine Water"} }, --V
        { itemID = 23265, nodeName = Harvest.SolventNodes, itemName = {"Cleansed Water"} }, --V
        { itemID = 23266, nodeName = Harvest.SolventNodes, itemName = {"Filtered Water"} }, --V
        { itemID = 23267, nodeName = Harvest.SolventNodes, itemName = {"Purified Water"} }, --V
        { itemID = 23268, nodeName = Harvest.SolventNodes, itemName = {"Cloud Mist"} }, --V
    },
    [8] = {
    },
}

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
-- 6 = Chest, 7 = Solvent, 8 = Fish
    [6] = {
    },
    [7] = {
        883,
        1187,
        4570,
        23265,
        23266,
        23267,
        23268,
    },
    [8] = {
    },
}
-- Node Names
-- (1) Mining
Harvest.mining = {
    ["en"] = {
        "Iron Ore",
        "High Iron Ore",
        "Orichalc Ore",
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
        "Orichalc Ore",
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
        "Orichalc Ore",
        "Minerai D'orichalque",
        "Minerai Dwemer",
        "Minerai d'Ebonite",
        "Minerai de Calcinium",
        "Minerai de Galatite",
        "Quicksilver Ore",
        "Minerai de Pierre de Vide",
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
        "Coton",
        "Fil d'Ebonite",
        "Lin",
        "Herbe de fer",
        "Jute",
        "Kreshweed",
        "Silverweed",
        "Toile D'araignée",
        "Tissu de Vide",
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
        "Benediktenkraut",
        "Glöckling",
        "Wolfsauge",
        "Akelei",
        "Kornblume",
        "Drachendorn",
        "Brechtäubling",
        "Koboldschemel",
        "Wiesenschaumkraut",
        "Leuchttäubling",
        "Bergblume",
        "Namiras Fäulnis",
        "Nirnwurz",
        "Stinkmorchel",
        "Violetter Tintling",
        "Wasserhyazinthe",
        "Weißkappe",
        "Wermut",
    },
    ["fr"] = {
        "Chardon Béni",
        "Entoloma",
        "Noctuelle",
        "Ancolie",
        "Bleuet",
        "Épine-de-Dragon",
        "Russule Emetique",
        "Pied-de-Lutin",
        "Cardamine des Prés",
        "Russule Phosphorescente",
        "Lys des Cimes",
        "Truffe de Namira",
        "Nirnrave",
        "Mutinus Elégans",
        "Coprin Violet",
        "Jacinthe D'eau",
        "Chapeau Blanc",
        "Absinthe",
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
        "Buche", -- "Buchenholz"
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
        "Acajou",
        "Érable",
        "Bois de nuit",
        "Chêne",
        "If",
    },
}
-- 7 = Solvent
Harvest.solvent = {
    ["en"] = {
        -- "Bottle",
        -- "Bottles",
        -- "Cup",
        -- "Cups",
        -- "Drink",
        -- "Goblet",
        -- "Jar",
        -- "Jug",
        -- "Mug",
        "Pure Water",
        "Water Skin",
        -- "Wine Rack",
    },
    ["de"] = {
        -- "Flasche",
        -- "Flaschen",
        -- "Tasse",
        -- "Tassen",
        -- "Getränk",
        -- "Becher",
        -- "Gefäß",
        -- "Krug",
        -- "Becher",
        "Reines Wasser",
        "Wasserhaut",
        -- "Weinregal",
    },
    ["fr"] = {
        -- "Bouteille",
        -- "Bouteilles",
        -- "Tasse",
        -- "Tasses",
        -- "Boisson",
        -- "Chope",
        -- "Jar",
        -- "Pichet",
        -- "Choppe",
        "Eau Pure",
        "Outre d'Eau",
        -- "Casier ŕ bouteilles",
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
        "Schwerer Sack",
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
        "Sac Lourd",
        "Table de chevet",
        "Pot",
        "Sac",
        "Urne tombale",
        "Coffre",
        "Urne",
        "Vase",
        "Garde-robe",
    },
}

function Harvest.IsValidMiningIDName(id, name)
    local nameMatch = Harvest.IsValidMiningName(name)
    local itemIDMatch = false

    for key1, value in pairs(Harvest.professions[1]) do
        if value == id then
            itemIDMatch = true
        end
    end

    if nameMatch and itemIDMatch then
        return true
    end

    return false
end

function Harvest.IsValidClothingIDName(id, name)
    local nameMatch = Harvest.IsValidClothingName(name)
    local itemIDMatch = false

    for key1, value in pairs(Harvest.professions[2]) do
        if value == id then
            itemIDMatch = true
        end
    end

    if nameMatch and itemIDMatch then
        return true
    end

    return false
end

function Harvest.IsValidEnchantingIDName(id, name)
    local nameMatch = Harvest.IsValidEnchantingName(name)
    local itemIDMatch = false

    for key1, value in pairs(Harvest.professions[3]) do
        if value == id then
            itemIDMatch = true
        end
    end

    if nameMatch and itemIDMatch then
        return true
    end

    return false
end

function Harvest.IsValidAlchemyIDName(id, name)
    local nameMatch = Harvest.IsValidAlchemyName(name)
    local itemIDMatch = false

    for key1, value in pairs(Harvest.professions[4]) do
        if value == id then
            itemIDMatch = true
        end
    end

    if nameMatch and itemIDMatch then
        return true
    end

    return false
end

function Harvest.IsValidWoodworkingIDName(id, name)
    local nameMatch = Harvest.IsValidWoodworkingName(name)
    local itemIDMatch = false

    for key1, value in pairs(Harvest.professions[5]) do
        if value == id then
            itemIDMatch = true
        end
    end

    if nameMatch and itemIDMatch then
        return true
    end

    return false
end

-- (1)Mining
function Harvest.IsValidMiningName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.mining[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- (2)Clothing
function Harvest.IsValidClothingName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.clothing[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- (3)Enchanting
function Harvest.IsValidEnchantingName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.enchanting[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- (4)Alchemy
function Harvest.IsValidAlchemyName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.alchemy[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- (5)Woodworking
function Harvest.IsValidWoodworkingName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.woodworking[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- (7)Woodworking
function Harvest.IsValidSolventName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.solvent[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

function Harvest.IsValidContainerName(name)
    for lang, langs in pairs(Harvest.langs) do
        for k, v in pairs(Harvest.container[langs]) do
            if v == name then
                return true
            end
        end
    end

    return false
end

-- Arguments Required ItemID, NodeName
-- Returns -1 when Object interacted with is invalid
-- Valid types: (1)Mining, (2)Clothing, (3)Enchanting
-- (4)Alchemy, (5)Wood, (6)Chests, (7)Solvents
-- (8)Fish
function Harvest.CheckProfessionTypeOnImport(id, name)
    local isOk = false
    id = tonumber(id)

    -- Set (1)Mining
    if Harvest.IsValidMiningIDName(id, name) then
        isOk = true
    end
    -- Set (2)Clothing
     if Harvest.IsValidClothingIDName(id, name) then
        isOk = true
    end
    -- Set (3)Enchanting
     if Harvest.IsValidEnchantingIDName(id, name) then
        isOk = true
    end
    -- Set (4)Alchemy
     if Harvest.IsValidAlchemyIDName(id, name) then
        isOk = true
    end
    -- Set (5)Woodworking
     if Harvest.IsValidWoodworkingIDName(id, name) then
        isOk = true
    end
    -- Set (7)Solvent
    if Harvest.IsValidSolventName(name) then
        isOk = true
    end

    return isOk
end

-- Arguments Required: NodeName
-- Returns -1 when Object interacted with is invalid
-- Valid types: (1)Mining, (2)Clothing, (3)Enchanting
-- (4)Alchemy, (5)Wood, (7)Solvents
-- Containers are assigned 4 Alchemy the same as 2.2
function Harvest.GetProfessionTypeOnUpdate(name)
    local tsId

    if Harvest.IsValidSolventName(name) then
        tsId = 7
        return tsId
    end

    if Harvest.IsValidMiningName(name) then
        tsId = 1
        return tsId
    end

    if Harvest.IsValidClothingName(name) then
        tsId = 2
        return tsId
    end

    if Harvest.IsValidEnchantingName(name) then
        tsId = 3
        return tsId
    end

    if Harvest.IsValidAlchemyName(name) then
        tsId = 4
        return tsId
    end

    if Harvest.IsValidWoodworkingName(name) then
        tsId = 5
        return tsId
    end

    if Harvest.IsValidContainerName(name) then
        tsId = 4
        return tsId
    end

    return -1
end

-- Arguments Required ItemID, NodeName
-- Returns -1 when Object interacted with is invalid
-- Valid types: (1)Mining, (2)Clothing, (3)Enchanting
-- (4)Alchemy, (5)Wood, (6)Chests, (7)Solvents
-- (8)Fish
function Harvest.GetProfessionType(id, name)
    local tsId
    id = tonumber(id)

    if Harvest.defaults.verbose then
        d("Attempting GetProfessionType with id : " .. id)
        d("Node Name : " .. name)
    end

    --if Harvest.IsValidSolvent(name) then
    --    tsId = 7
    --    if Harvest.settings.verbose then
    --        d("Solvent id assigned : " .. tsId)
    --    end
    --    return tsId
    --end

    -- For this HarvestMap version there are no containers
    -- Set any container found to 0 so that it is not recorded.
    if Harvest.IsValidContainerName(name) then
        tsId = 0
        if Harvest.defaults.verbose then
            d("Container is not used in this version id assigned : " .. tsId)
        end
        return tsId
    end

    -- if no valid Node Name by Name is found use ItemID
    for key1, tsData in pairs(Harvest.professions) do
        for key2, value in pairs(tsData) do
            if value == id then
                tsId = key1
                if Harvest.defaults.verbose then
                    d("Esohead id assigned : " .. tsId)
                end
                return tsId
            end
        end
    end

    if Harvest.defaults.verbose then
        d("No Profession Type found with id : " .. id)
        d("In GetProfessionType with name : " .. name)
    end

    return -1
end

-- local alliance = GetUnitAlliance("player")
-- valid alliance values are:
--  ALLIANCE_ALDMERI_DOMINION = 1
--  ALLIANCE_EBONHEART_PACT = 2
--  ALLIANCE_DAGGRTFALL_COVENANT = 3
