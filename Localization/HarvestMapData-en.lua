if Harvest == nil then Harvest = {} end

--zones
Harvest.poiData = {
   ["alikr"] = {},      --Alik'r Desert
   ["auridon"] = {},    --Auridon, Khenarthi's Roost
   ["bangkorai"] = {},  --Bangkorai
   ["coldharbor"] = {}, --Coldharbour
   ["cyrodiil"] = {},   --Cyrodiil
   ["deshaan"] = {},    --"Deshaan"
   ["eastmarch"] = {},  --Eastmarch
   ["glenumbra"] = {},  --Glenumbra, Betnikh, Stros M'Kai
   ["grahtwood"] = {},  --Grahtwood
   ["greenshade"] = {}, --Greenshade
   ["malabaltor"] = {}, --Malabal Tor
   ["reapersmarch"] = {},  --Reaper's March
   ["rivenspire"] = {}, --Rivenspire
   ["shadowfen"] = {},  --Shadowfen
   ["stonefalls"] = {}, --Stonefalls, Bal Foyen, Bleakrock Isle
   ["stormhaven"] = {}, --Stormhaven
   ["therift"] = {},    --The Rift
   ["craglorn"] = {},   --Craglorn
}

--subzone
--Entered
Harvest.poiData["alikr"] = {
--Alik'r Desert (Daggerfall, lvl 31-37)
   ["alikr_base"] = {            --Alik'r Desert
      --en
      { "Aldunz", 3 },
      { "Alezer Kotu", 9 },
      { "Ancestor's Landing", 8 },
      { "Artisan's Oasis", 9 },
      { "Aswala Stables Wayshrine", 1 },
      { "Aswala's Remembrance", 2 },
      { "Bergama", 8 },
      { "Bergama Wayshrine", 1 },
      { "Coldrock Diggings", 3 },
      { "Divad's Chagrin Mine", 3 },
      { "Divad's Chagrin Mine Wayshrine", 1 },
      { "Duneripper Downs", 2 },
      { "Dungeon: Volenfell", 7 },
      { "Easterly Aerie", 2 },
      { "Forsaken Hearts Cave", 6 },
      { "Giant Camp", 6 },
      { "Goat's Head Oasis Wayshrine", 1 },
      { "Hag Camp", 6 },
      { "Hatiha's Camp", 2 },
      { "Hollow Waste Dolmen",  5},
      { "HoonDing's Watch",  8},
      { "HoonDing's Watch Wayshrine", 1 },
      { "King's Rest", 6 },
      { "Kozanset", 8 },
      { "Kulati Mines", 8 },
      { "Kulati Mines Wayshrine", 1 },
      { "Leki's Blade", 8 },
      { "Leki's Blade Wayshrine", 1 },
      { "Lesser Circle", 6 },
      { "Lost Caravan", 6 },
      { "Lost City of the Na-Totambu", 3 },
      { "Morwha's Bounty", 8 },
      { "Morwha's Bounty Wayshrine", 1 },
      { "Motalion Necropolis", 8 },
      { "Myrkwasa Dolmen", 5 },
      { "Na-Totambu's Landing", 2 },
      { "Ogre's Bluff", 8 },
      { "Ragnthar", 2 },
      { "Rain Catcher Fields", 8 },
      { "Rkulftzel", 9 },
      { "Salas En", 8 },
      { "Saltwalker Militia Camp", 2 },
      { "Sandblown Mine", 3 },
      { "Santaki", 3 },
      { "Satakalaam", 8 },
      { "Satakalaam Wayshrine", 1 },
      { "Sentinel", 8 },
      { "Sentinel Docks", 8 },
      { "Sentinel Wayshrine", 1 },
      { "Sep's Spine", 8 },
      { "Sep's Spine Wayshrine", 1 },
      { "Shrikes' Aerie Wayshrine", 1 },
      { "Tava's Blessing", 8 },
      { "Tears of the Dishonored", 8 },
      { "The Ritual", 4 },
      { "The Thief", 4 },
      { "The Warrior", 4 },
      { "Tigonus Dolmen", 5 },
      { "Tu'whacca's Throne", 8 },
      { "Wayfarer's Wharf", 2 },
      { "Yldzuun", 3 },      
   },
}

--Entered
Harvest.poiData["auridon"] = {
--Auridon (Aldmeri lvl 5-15)
   ["auridon_base"] = { --Auridon
     --en
     {"Beacon Falls", 9 },
     {"Bewan", 3 },
     {"Buraniim Isle", 2 },
     {"Calambar Dolmen", 5 },
     {"Castle Rilis", 8 },
     {"College of Aldmeri Propriety", 8 },
     {"College Wayshrine", 1 },
     {"Dawnbreak", 8 },
     {"Del's Claim", 3 },
     {"Dungeon: The Banished Cells", 7 },
     {"Eastshore Islets Camp", 9 },
     {"Entila's Folly", 3 },
     {"Errinorne Isle", 2 },
     {"Ezduiin", 8 },
     {"Firsthold", 8 },
     {"Firsthold Wayshrine", 1 },
     {"Glister Vale", 8 },
     {"Greenwater Cove", 8 },
     {"Greenwater Wayshrine", 1 },
     {"Heretic's Summons", 6 },
     {"Heritance Proving Ground", 6 },
     {"Hightide Keep", 9 },
     {"Iluvamir Dolmen", 5 },
     {"Isle of Contemplation", 2 },
     {"Maormer Invasion Camp", 2 },
     {"Mathiisen", 8 },
     {"Mathiisen Wayshrine", 1 },
     {"Mehrunes' Spite", 3 },
     {"Monkey's Rest", 2 },
     {"Nestmother's Den", 6 },
     {"Nine-Prow Landing", 2 },
     {"North Beacon", 8 },
     {"Ondil", 3 },
     {"Phaer", 8 },
     {"Phaer Wayshrine", 1 },
     {"Quendeluun", 8 },
     {"Quendeluun Wayshrine", 1 },
     {"Seaside Scarp Camp", 6 },
     {"Shattered Grove", 8 },
     {"Silsailen", 8 },
     {"Skywatch", 8 },
     {"Skywatch Wayshrine", 1 },
     {"Smuggler's Cove", 2 },
     {"Soulfire Plateau", 6 },
     {"South Beacon", 8 },
     {"Tanzelwil", 8 },
     {"Tanzelwil Wayshrine", 1 },
     {"The Harborage", 1 },
     {"The Lady", 4 },
     {"The Lover", 4 },
     {"Toothmaul Gully", 8 },
     {"Torinaan", 8 },
     {"Vafe Dolmen", 5 },
     {"Vulkhel Docks", 8 },
     {"Vulkhel Guard", 8 },
     {"Vulkhel Guard Wayshrine", 1 },
     {"Wansalen", 3 },
     {"Windy Glade Wayshrine", 1 },
     {"Wreck of the Raptor", 6 },
     
   },
--Khenarthi's Roost (Aldmeri, lvl 1-5)
   ["khenarthisroost_base"] = {  --Khenarthi's Roost
     --en
     {"Bolga's Hunting Camp", 2 },
     {"Cat's Eye Quay", 8 },
     {"Eagle's Strand", 2 },
     {"Hazak's Hollow", 8 },
     {"Khenarthi's Roost Wayshrine", 1 },
     {"Laughing Moons Plantation", 8 },
     {"Mistral", 8 },
     {"Mistral Wayshrine", 1 },
     {"Rid-Thar's Solace", 2 },
     {"Shattered Shoals", 8 },
     {"Speckled Shell Plantation", 8 },
     {"Temple of the Crescent Moons", 2 },
     {"Temple of the Dark Moon", 2 },
     {"Temple of the Mourning Springs", 8 },
     {"Temple of Two-Moons Dance", 2 },
     {"Windcatcher Plantation", 8 },
          
   },
}

--Entered
Harvest.poiData["bangkorai"] = {
--Bangkorai (Daggerfall, lvl 37-43)
   ["bangkorai_base"] = {        --Bangkorai
     --en
     {"Arlimahera's Sanctum", 6 },
     {"Ash'abahs' Oasis", 3 },
     {"Bangkorai Garrison", 8 },
     {"Bangkorai Pass Wayshrine", 1 },
     {"Basking Grounds", 3 },
     {"Blighted Isle", 6 },
     {"Crypt of the Exiles", 4 },
     {"Damar Farmstead", 22 },
     {"Dungeon: Blackheart Haven", 7 },
     {"Eastern Evermore Wayshrine", 1 },
     {"Ephesus Dolmen", 5 },
     {"Evermore", 8 },
     {"Evermore Wayshrine", 1 },
     {"Fallen Grotto", 8 },
     {"Fallen Wastes Dolmen", 5 },
     {"Gjarma's Rock", 2 },
     {"Halcyon Lake", 8 },
     {"Halcyon Lake Wayshrine", 1 },
     {"Hall of Heroes", 8 },
     {"Hallin's Stand", 8 },
     {"Hallin's Stand Wayshrine", 1 },
     {"Howlers' Nook", 2 },
     {"Jackdaw Cove", 8 },
     {"Kerbol's Hollow", 8 },
     {"Klathzgar", 3 },
     {"Lakewatch Tower", 6 },
     {"Martyr's Crossing", 8 },
     {"Mournoth Dolmen", 5 },
     {"Murcien's Hamlet", 8 },
     {"Nilata Falls", 6 },
     {"Nilata Ruins", 8 },
     {"Nilata Ruins Wayshrine", 1 },
     {"Northglen", 8 },
     {"Old Tower", 8 },
     {"Old Tower Wayshrine", 1 },
     {"Onsi's Breath", 8 },
     {"Onsi's Breath Wayshrine", 1 },
     {"Pelin Graveyard", 8 },
     {"Qharroa Ruins", 8 },
     {"Razak's Wheel", 3 },
     {"Rubble Butte", 3 },
     {"Sacred Springs", 2 },
     {"Silaseli Ruins", 9 },
     {"Strastnoc's Landing", 2 },
     {"Summoner's Camp", 6 },
     {"Sunken Road", 8 },
     {"Sunken Road Wayshrine", 1 },
     {"Telesubi Ruins", 6 },
     {"The Apprentice", 4 },
     {"The Parley", 8 },
     {"The Steed", 4 },
     {"Torog's Spite", 3 },
     {"Troll's Toothpick", 3 },
     {"Troll's Toothpick Wayshrine", 1 },
     {"Viridian Hideaway", 9 },
     {"Viridian Watch", 3 },
     {"Viridian Woods", 8 },
     {"Viridian Woods Wayshrine", 1 },
     {"Wethers' Cleft", 9 },
     {"Yanurah's Respite", 2 },
   },
}

--Entered
Harvest.poiData["coldharbor"] = {
--Coldharbour (all, lvl 45-50)
   ["coldharbour_base"] = {      --Coldharbour
     --en
     {"Aba-Darre", 6 },
     {"Aba-Loria", 3 },
     {"Cadwell's Hovel", 2 },
     {"Cliffs of Failure", 8 },
     {"Court of Contempt", 8 },
     {"Court of Contempt Wayshrine", 1 },
     {"Cynhamoth's Grove", 6 },
     {"Daedroth Larder", 6 },
     {"Deathspinner's Lair", 9 },
     {"Dungeon: Vaults of Madness", 7 },
     {"Duriatundur's Killing Field", 6 },
     {"Endless Overlook", 2 },
     {"Endless Stair Wayshrine", 1 },
     {"Everfull Flagon Wayshrine", 1 },
     {"Fighters Guildhall", 2 },
     {"Font of Schemes", 9 },
     {"Forsaken Village", 2 },
     {"Great Shackle Wayshrine", 1 },
     {"Haj Uxith", 8 },
     {"Haj Uxith Wayshrine", 1 },
     {"Hollow City Wayshrine", 1 },
     {"Library of Dusk", 8 },
     {"Library of Dusk Wayshrine", 1 },
     {"Mages Guildhall", 2 },
     {"Mal Sorra's Tomb", 3 },
     {"Manor of Revelry Wayshrine", 1 },
     {"Moonless Walk Wayshrine", 1 },
     {"Reaver Citadel Wayshrine", 1 },
     {"Risen Court", 6 },
     {"Shrine of Kyne", 2 },
     {"Shrouded Plains Wayshrine", 1 },
     {"Spurned Peak", 8 },
     {"Survivor's Camp", 2 },
     {"The Black Forge", 8 },
     {"The Cave of Trophies", 3 },
     {"The Chasm", 8 },
     {"The Chasm Wayshrine", 1 },
     {"The Endless Stair", 8 },
     {"The Everfull Flagon", 8 },
     {"The Great Shackle", 8 },
     {"The Grotto of Depravity", 3 },
     {"The Hollow City", 8 },
     {"The Lightless Oubliette", 8 },
     {"The Lost Fleet", 8 },
     {"The Manor of Revelry", 8 },
     {"The Moonless Walk", 8 },
     {"The Orchard", 8 },
     {"The Orchard Wayshrine", 1 },
     {"The Reaver Citadel", 8 },
     {"The Vile Laboratory", 8 },
     {"The Wailing Maw", 3 },
     {"Tower of Lies", 8 },
     {"Vault of Haman Forgefire", 3 },
     {"Village of the Lost", 3 },
     {"Zemarek's Hollow", 6 },
   },
}

Harvest.poiData["cyrodiil"] = {
--Cyrodiil (all, lvl 10+)
   ["ava_whole"] = {          --Cyrodiil
     --en
     {"Abandoned Orchard", 2 },
     {"Abbey of the Eight", 2 },
     {"Anga", 2 },
     {"Applewatch Wood Dolmen", 5 },
     {"Barren Cave", 2 },
     {"Belda", 2 },
     {"Bloodmayne Cave", 3 },
     {"Breakneck Cave", 3 },
     {"Bruma", 8 },
     {"Burned Estate", 2 },
     {"Capstone Cave", 3 },
     {"Ceyatatar", 2 },
     {"Cheydinhal", 8 },
     {"Cheydinhal Foothills Dolmen", 5 },
     {"Chorrol", 8 },
     {"Cloud Ruler Temple", 5 },
     {"Coldcorn Ruin", 2 },
     {"Cracked Wood Cave", 3 },
     {"Crooked Finger Redoubt", 2 },
     {"Cropsford", 8 },
     {"Culotte", 2 },
     {"Eastern Elsweyr Gate Wayshrine", 1 },
     {"Eastern Shore Dolmen", 5 },
     {"Echo Cave", 3 },
     {"Empire Tower", 2 },
     {"Fanacas", 2 },
     {"Fanacasecul", 2 },
     {"Gray Viper Outpost", 2 },
     {"Great Forest Dolmen", 5 },
     {"Greenmead Dolmen", 5 },
     {"Hackdirt", 2 },
     {"Harlun's Watch", 2 },
     {"Haynote Cave", 3 },
     {"Hedoran Estate", 2 },
     {"Highlander Camp", 2 },
     {"Homestead Ruins", 2 },
     {"Howling Cave", 2 },
     {"Hrotanda Vale", 2 },
     {"Ice-Heart Home", 2 },
     {"Juras' Fall", 2 },
     {"Kingscrest Cavern", 3 },
     {"Lake Mist Ruins", 2 },
     {"Lindai", 2 },
     {"Lipsand Tarn", 3 },
     {"Lunar Fang Docks", 2 },
     {"Moffka's Lament", 2 },
     {"Moranda", 2 },
     {"Muck Valley Cavern", 3 },
     {"Nagastani", 2 },
     {"Narsinfel", 2 },
     {"Newt Cave", 3 },
     {"Niben Basin Dolmen", 5 },
     {"Nibenay Valley Dolmen", 5 },
     {"Ninendava", 2 },
     {"Nisin Cave", 3 },
     {"Nornal", 2 },
     {"Nornalhorst", 2 },
     {"North Morrowind Gate Wayshrine", 1 },
     {"NorthHighrock Gate Wayshrine", 1 },
     {"Northwestern Shore Dolmen", 5 },
     {"Piukanda", 2 },
     {"Pothole Cavern", 3 },
     {"Quickwater Cave", 3 },
     {"Red Ruby Cave", 3 },
     {"Riverwatch", 2 },
     {"Sardavar Leed", 2 },
     {"Sedor", 2 },
     {"Sercen", 2 },
     {"Serpent Hollow Cave", 3 },
     {"Shurgak Clan Estate", 2 },
     {"South Highrock Gate Wayshrine", 1 },
     {"South Morrowind Gate Wayshrine", 1 },
     {"Temple of the Ancestor Moths", 2 },
     {"Thalara's Winery", 2},
     {"The Apprentice", 4 },
     {"The Atronach", 4 },
     {"The Lady", 4 },
     {"The Lover", 4 },
     {"The Mage", 4 },
     {"The Ritual", 4 },
     {"The Serpent", 4 },
     {"The Shadow", 4 },
     {"The Steed", 4 },
     {"The Thief", 4 },
     {"The Tower", 4 },
     {"The Warrior", 4 },
     {"Toadstool Hollow", 3 },
     {"Underpall Cave", 3 },
     {"Vahtacen", 3 },
     {"Vlastarus", 8 },
     {"Waterside Mine", 2 },
     {"Wenyandawik", 2 },
     {"Western Elsweyr Gate Wayshrine", 1 },
     {"Weye", 2 },
     {"Weynon Priory", 2 },
     {"White Fall Mountain", 2 },
     {"Wilminn's Winery", 2 },
     {"Winter's Reach Dolmen", 5 },
     {"Wooden Hand Outlook", 2 },
     {"Zimar's Winery", 2 },
     
   },
}

--Entered
Harvest.poiData["deshaan"] = {
--Deshaan (Ebonheart, lvl 16-23)
   ["deshaan_base"] = {          --"Deshaan"
      --en
      { "Avayan's Farm", 9},
      { "Berezan's Mine", 9},
      { "Bthanual", 8},
      { "Caravan Crest", 6},
      { "Coiled Path Landing", 2},
      { "Deepcrag Den", 8},
      { "Dire Bramblepatch", 6},
      { "Druitularg's Ritual Altar", 6},
      { "Dungeon: Darkshade Caverns", 7},
      { "Eidolon's Hollow", 8},
      { "Eidolon's Hollow Wayshrine", 1},
      { "Forgotten Crypts", 3},
      { "Ghost Snake Vale Wayshrine", 1},
      { "Grove of the Abomination", 6},
      { "Hlanii's Hovel", 2},
      { "House Dres Farmstead", 2},
      { "Knife Ear Grotto", 3},
      { "Lady Llarel's Shelter", 3},
      { "Lagomere Dolmen", 5},
      { "Lake Hlaalu Retreat", 9},
      { "Lower Bthanual", 3},
      { "Mabrigash Burial Circle", 6},
      { "Malak's Maw", 8},
      { "Mournhold", 8},
      { "Mournhold Wayshrine", 1},
      { "Muth Gnaar", 8},
      { "Muth Gnaar Hills Wayshrine", 1},
      { "Mzithumz", 8},
      { "Mzithumz Wayshrine", 1},
      { "Narsis", 8},
      { "Obsidian Gorge", 8},
      { "Obsidian Gorge Wayshrine", 1},
      { "Old Ida's Cottage", 2},
      { "Quarantine Serk", 8},
      { "Quarantine Serk Wayshrine", 1},
      { "Redolent Loam Dolmen", 5},
      { "Redoran Pier", 2},
      { "Selfora", 8},
      { "Selfora Wayshrine", 1},
      { "Shad Astula", 8},
      { "Shad Astula Wayshrine", 1},
      { "Short-Tusk's Hillock", 6},
      { "Shrine of Saint Veloth", 8},
      { "Shrine to Saint Rilms", 2},
      { "Silent Mire", 8},
      { "Silent Mire Wayshrine", 1},
      { "Siltreen Dolmen", 5},
      { "Smuggler's Slip", 2},
      { "Tal'Deic Fortress", 8},
      { "Tal'Deic Grounds Wayshrine", 1},
      { "Taleon's Crag", 3},
      { "The Corpse Garden", 3},
      { "The Lord", 4},
      { "The Mage", 4},
      { "The Tower", 4},
      { "Tribunal Temple", 8},
      { "Triple Circle Mine", 3},
      { "Vale of the Ghost Snake", 8},
      { "West Narsis Wayshrine", 1},
            
   },
}

--Entered
Harvest.poiData["eastmarch"] = {
--Eastmarch (Ebonheart, lvl 31-37)
   ["eastmarch_base"] = {        --Eastmarch
      --en
      { "Ammabani's Pride", 6 },
      { "Bitterblade's Camp", 2 },
      { "Bonestrewn Crest", 8 },
      { "Cradlecrush", 8 },
      { "Cradlecrush Wayshrine", 1 },
      { "Cragwallow", 8 },
      { "Cragwallow Cave", 2 },
      { "Crimson Kada's Crafting Cavern", 9 },
      { "Darkwater Crossing", 2 },
      { "Dragon Mound", 6 },
      { "Dragon's Hallow", 6 },
      { "Dungeon: Direfrost Keep", 7 },
      { "Fort Amol", 8 },
      { "Fort Amol Wayshrine", 1 },
      { "Fort Morvunskar", 8 },
      { "Fort Morvunskar Wayshrine", 1 },
      { "Frostwater Tundra Dolmen", 5 },
      { "Giant's Heart", 2 },
      { "Giant's Run Dolmen", 5 },
      { "Hall of the Dead", 3 },
      { "Hammerhome", 9 },
      { "Hermit's Hideout", 2 },
      { "Icehammer's Vault", 3 },
      { "Icewind Peaks Dolmen", 5 },
      { "Jorunn's Stand", 8 },
      { "Jorunn's Stand Wayshrine", 1 },
      { "Kynesgrove", 8 },
      { "Kynesgrove Wayshrine", 1 },
      { "Logging Camp Wayshrine", 1 },
      { "Lost Knife Cave", 8 },
      { "Lower Yorgrim", 8 },
      { "Mistwatch", 8 },
      { "Mistwatch Wayshrine", 1 },
      { "Mzulft", 8 },
      { "Old Sord's Cave", 3 },
      { "Rageclaw's Den", 6 },
      { "Ragnthar", 2 },
      { "Ratmaster's Prowl", 6 },
      { "Skuldafn", 8 },
      { "Skuldafn Wayshrine", 1 },
      { "Stormcrag Crypt", 3 },
      { "Swiftblade's Camp", 6 },
      { "Thane Jeggi's Drinking Hole", 2 },
      { "The Bastard's Tomb", 3 },
      { "The Chill Hollow", 3 },
      { "The Frigid Grotto", 3 },
      { "The Ritual", 4 },
      { "The Thief", 4 },
      { "The Warrior", 4 },
      { "Thulvald's Logging Camp", 8 },
      { "Tinkerer Tobin's Workshop", 9 },
      { "Voljar Meadery Wayshrine", 1 },
      { "Voljar's Meadery", 8 },
      { "Windhelm", 8 },
      { "Windhelm Wayshrine", 1 },
      { "Wittestadr", 8 },
      { "Wittestadr Wayshrine", 1 },
   },
}

--Entered
Harvest.poiData["glenumbra"] = {
--Glenumbra (Daggerfall, lvl 5-15)
   ["glenumbra_base"] = {        --Glenumbra
    --en
    { "Aldcroft", 8},
    { "Aldcroft Wayshrine", 1},
    { "Bad Man's Hallows", 3},
    { "Baelborne Rock", 8},
    { "Baelborne Rock Wayshrine", 1},
    { "Balefire Island", 6},
    { "Beldama Wyrd Tree", 8},
    { "Burial Mounds", 8},
    { "Burial Tombs Wayshrine", 1},
    { "Cambray Hills Dolmen", 5}, 
    { "Cambray Pass", 8},
    { "Camlorn", 8},
    { "Cath Bedraud", 8}, 
    { "Chill House", 9},
    { "Crosswych", 8},
    { "Crosswych Wayshrine", 1}, 
    { "Cryptwatch Fort", 3},
    { "Daenia Dolmen", 5},
    { "Daggerfall", 8},
    { "Daggerfall Southern Docks", 8}, 
    { "Daggerfall Wayshrine", 1},
    { "Deleyn's Mill", 8}, 
    { "Deleyn's Mill Wayshrine", 1}, 
    { "Dourstone Isle", 2},
    { "Dresan Keep", 8},
    { "Dungeon: Spindleclutch", 7}, 
    { "Dwynnarth Ruins", 8},
    { "Eagle's Brook", 8},
    { "Eagle's Brook Wayshrine", 1}, 
    { "Ebon Crypt", 3},
    { "Enduum", 3},
    { "Farwatch Wayshrine", 1}, 
    { "Gaudet Farm", 2},
    { "Glenumbra Moors", 8},
    { "Hag Fen", 8},
    { "Hag Fen Wayshrine", 1}, 
    { "Ilessan Tower",  3},
    { "King's Guard Dolmen", 5}, 
    { "Lion Guard Redoubt", 8},
    { "Lion Guard Redoubt Wayshrine", 1}, 
    { "Merovec's Folly", 2},
    { "Mesanthano's Tower", 9},
    { "Miltrin's Fishing Cabin", 2}, 
    { "Mines of Khuras", 3},
    { "Mire Falls", 2},
    { "North Hag Fen Wayshrine", 1}, 
    { "North Shore Point", 6},
    { "Par Molag", 9},
    { "Red Rook Camp", 8}, 
    { "Seaview Point", 6},
    { "Shrieking Scar", 8}, 
    { "Silumm", 3},
    { "Tangle Rock", 2},
    { "The Harborage", 1}, 
    { "The Lady", 4},
    { "The Lover", 4},
    { "The Wolf's Camp", 6},
    { "Tomb of Lost Kings", 8},
    { "Trapjaw's Cove", 6},
    { "Vale of the Guardians", 8},
    { "Valewatch Tower", 2},
    { "Western Overlook", 6},
    { "Westtry", 8},
    { "Wyrd Tree Wayshrine", 1},
   },
--Betnikh (Daggerfall, lvl 1-5)
   ["betnihk_base"] = {
      --en
      { "Carved Hills", 8 },
      { "Carved Hills Wayshrine", 1 },
      { "Carzog's Demise", 8 },
      { "Eyearata", 2 },
      { "Gilbard's Nook", 2 },
      { "Grimfield", 8 },
      { "Grimfield Wayshrine", 1 },
      { "Moriseli", 8 },
      { "Stonetooth Wayshrine", 1 },
   },
--Stros M'Kai (Daggerfall, lvl 1-5)
   ["strosmkai_base"] = {
      --en
      { "Bthzark", 8 },
      { "Dogeater Goblin Camp", 2 },
      { "Pillar of the Singing Sun", 2 },
      { "Port Hunding", 8 },
      { "Port Hunding Wayshrine", 1 },
      { "Rash Merchant's Plummet", 2 },
      { "Saintsport", 8 },
      { "Saintsport Wayshrine", 1 },
      { "Sandy Grotto Wayshrine", 1 },
      { "The Grave", 8 },
   },
}


--Entered
Harvest.poiData["grahtwood"] = {
--Grahtwood (Aldmeri, lvl 16-23)
   ["grahtwood_base"] = {        --Grahtwood
      --en
      { "Battle of Cormount Memorial", 2 },
      { "Boar's Run Overlook", 2 },
      { "Bone Orchard", 8 },
      { "Brackenleaf", 8 },
      { "Burroot Kwama Mine", 3 },
      { "Cave of Broken Sails", 8 },
      { "Cormount", 8 },
      { "Cormount Wayshrine", 1 },
      { "Dungeon: Elden Hollow", 7 },
      { "Elden Root", 8 },
      { "Elden Root Temple Wayshrine", 1 },
      { "Elden Root Wayshrine", 1 },
      { "Falinesti Winter Site", 8 },
      { "Falinesti Winter Wayshrine", 1 },
      { "Faltonia's Mine", 2 },
      { "Fisherman's Isle", 9 },
      { "Forked Root Camp", 2 },
      { "Gil-Var-Delle", 8 },
      { "Gil-Var-Delle Wayshrine", 1 },
      { "Goldfolly", 8 },
      { "Gray Mire Wayshrine", 1 },
      { "Green Hall Dolmen", 5 },
      { "Haven", 8 },
      { "Haven Wayshrine", 1 },
      { "Hircine's Henge", 6 },
      { "Karthdar", 8 },
      { "Lady Solace's Fen", 6 },
      { "Laeloria", 8 },
      { "Long Coast Dolmen", 5 },
      { "Mobar Mine", 3 },
      { "Ne Salas", 3 },
      { "Nindaeril's Perch", 6 },
      { "Ossuary of Telacar", 8 },
      { "Ossuary Wayshrine", 1 },
      { "Poacher Camp", 6 },
      { "Redfur Trading Post", 8 },
      { "Redfur Trading Post Wayshrine", 1 },
      { "Reliquary of Stars", 8 },
      { "Reman's Bluff", 8 },
      { "Root Sunder Ruins", 3 },
      { "Sacred Leap Grotto", 2 },
      { "Southpoint", 8 },
      { "Southpoint Wayshrine", 1 },
      { "Sweetbreeze Cottage", 2 },
      { "Tarlain Bandit Camp", 2 },
      { "Tarlain Heights Dolmen", 5 },
      { "Temple of the Eight", 9 },
      { "The Gray Mire", 8 },
      { "The Lord", 4 },
      { "The Mage", 4 },
      { "The Scuttle Pit", 3 },
      { "The Tower", 4 },
      { "Thugrub's Cave", 6 },
      { "Valanir's Rest", 6 },
      { "Vinedeath Cave", 3 },
      { "Vineshade Lodge", 9 },
      { "Wormroot Depths", 3 },
   },
}

Harvest.poiData["greenshade"] = {
--Greenshade (Aldmeri lvl 25-30)
   ["greenshade_base"] = {       --Greenshade
      --en
      { "Arananga", 9 },
      { "Barrow Trench", 3 },
      { "Bramblebreach", 8 },
      { "Camp Gushnukbur", 2 },
      { "Carac Dena", 3 },
      { "Dread Vullain", 8 },
      { "Driladan Pass", 8 },
      { "Drowned Coast Dolmen", 5 },
      { "Dungeon: City of Ash", 7 },
      { "Echo Pond", 2 },
      { "Falinesti Spring Site", 8 },
      { "Falinesti Wayshrine", 1 },
      { "Fisherman's Point", 2 },
      { "Gathongor's Mire", 6 },
      { "Green's Marrow Dolmen", 5 },
      { "Greenheart", 8 },
      { "Greenheart Wayshrine", 1 },
      { "Gurzag's Mine", 3 },
      { "Harridan's Lair", 3 },
      { "Hectahame", 8 },
      { "Hollow Den", 2 },
      { "Labyrinth", 8 },
      { "Labyrinth Wayshrine", 1 },
      { "Lanalda Pond", 9 },
      { "Maormer Camp", 6 },
      { "Marbruk", 8 },
      { "Marbruk Wayshrine", 1 },
      { "Moonhenge", 8 },
      { "Moonhenge Wayshrine", 1 },
      { "Naril Nagaia", 3 },
      { "Pelda Tarn", 6 },
      { "Reconnaissance Camp", 6 },
      { "Rootwatch Tower", 9 },
      { "Rootwater Grove", 8 },
      { "Rootwater Spring", 6 },
      { "Rulanyil's Fall", 2 },
      { "Seaside Overlook", 2 },
      { "Seaside Sanctuary", 8 },
      { "Seaside Sanctuary Wayshrine", 1 },
      { "Serpent's Grotto", 8 },
      { "Serpent's Grotto Wayshrine", 1 },
      { "Shademist Moors", 8 },
      { "Shadows Crawl", 8 },
      { "Shrouded Vale", 8 },
      { "Spinner's Cottage", 8 },
      { "The Atronach", 4 },
      { "The Serpent", 4 },
      { "The Shadow", 4 },
      { "The Underroot", 3 },
      { "Thodundor's View", 6 },
      { "Tower Rocks Vale", 2 },
      { "Twin Falls Rest", 2 },
      { "Verrant Morass", 8 },
      { "Verrant Morass Wayshrine", 1 },
      { "Wilderking Court Dolmen", 5 },
      { "Woodhearth", 8 },
      { "Woodhearth Wayshrine", 1 },
   },
}

Harvest.poiData["malabaltor"] = {
--Malabal Tor (Aldmeri, lvl 31-37)
   ["malabaltor_base"] = { --Malabal Tor
      --en
      { "Abamath", 8 },
      { "Abamath Wayshrine", 1 },
      { "Baandari Tradepost", 8 },
      { "Baandari Tradepost Wayshrine", 1 },
      { "Belarata", 8 },
      { "Bitterpoint Strand", 6 },
      { "Black Vine Ruins", 4 },
      { "Bloodtoil Valley", 8 },
      { "Bloodtoil Valley Wayshrine", 1 },
      { "Bone Grappler's Nest", 6 },
      { "Broken Coast Dolmen", 5 },
      { "Chancel of Divine Entreaty", 9 },
      { "Crimson Cove", 3 },
      { "Dead Man's Drop", 3 },
      { "Deepwoods", 8 },
      { "Dra'bul", 8 },
      { "Dra'Bul Wayshrine", 1 },
      { "Dugan's Knoll", 6 },
      { "Dungeon: Tempest Island", 7 },
      { "Falinesti Summer Site", 8 },
      { "Four Quarry Islet", 2 },
      { "Fuller's Break", 8 },
      { "Hoarvor Pit", 3 },
      { "Horseshoe Island", 2 },
      { "Ilayas Ruins", 8 },
      { "Ilayas Ruins Wayshrine", 1 },
      { "Jagged Grotto", 6 },
      { "Jathsogur", 8 },
      { "Jode's Pocket", 8 },
      { "Matthild's Last Venture", 9 },
      { "Ogrim's Yawn", 2 },
      { "Ouze", 8 },
      { "Ragnthar", 2 },
      { "River Edge", 6 },
      { "Roots of Silvenar", 3 },
      { "Shael Ruins", 3 },
      { "Silvenar", 8 },
      { "Silvenar Vale Dolmen", 5 },
      { "Sleepy Senche Overlook", 9 },
      { "Starwalk Cavern", 2 },
      { "Stranglewatch", 2 },
      { "Supplication House", 2 },
      { "Tanglehaven", 8 },
      { "The Ritual", 4 },
      { "The Thief", 4 },
      { "The Warrior", 4 },
      { "Tomb of the Apostates", 3 },
      { "Treehenge", 8 },
      { "Valeguard", 8 },
      { "Valeguard Wayshrine", 1 },
      { "Velyn Harbor", 8 },
      { "Velyn Harbor Wayshrine", 1 },
      { "Vulkwasten", 8 },
      { "Vulkwasten Wayshrine", 1 },
      { "Wilding Run", 8 },
      { "Wilding Vale Wayshrine", 1 },
      { "Windshriek Strand", 6 },
      { "Xylo River Basin Dolmen", 5 },
   },
}



Harvest.poiData["reapersmarch"] = {
--Reaper's March (Aldmeri, lvl 37-43)
   ["reapersmarch_base"] = {     --Reaper's March
      --en
      { "Arenthia", 8 },
      { "Arenthia Wayshrine", 1 },
      { "Big Ozur's Valley", 6 },
      { "Broken Arch", 9 },
      { "Claw's Strike", 3 },
      { "Crescent River Camp", 2 },
      { "Dawnmead Brigand Camp", 2 },
      { "Dawnmead Dolmen", 5 },
      { "Dawnmead Ruin Camp", 2 },
      { "Deathsong Cleft", 6 },
      { "Do'Krin Monastery", 8 },
      { "Dune", 8 },
      { "Dune Wayshrine", 1 },
      { "Dungeon: Selene's Web", 7 },
      { "Fadir's Folly", 3 },
      { "Falinesti Autumn Site", 8 },
      { "Fishing Dock", 2 },
      { "Fort Grimwatch", 8 },
      { "Fort Grimwatch Wayshrine", 1 },
      { "Fort Sphinxmoth", 8 },
      { "Fort Sphinxmoth Wayshrine", 1 },
      { "Greenhill", 8 },
      { "Greenspeaker's Grove", 9 },
      { "Hadran's Caravan", 8 },
      { "Jode's Light", 3 },
      { "Jodewood Dolmen", 5 },
      { "Kuna's Delve", 3 },
      { "Little Ozur's Camp", 2 },
      { "Moonmont", 8 },
      { "Moonmont Wayshrine", 1 },
      { "Northern Woods Dolmen", 5 },
      { "Old S'ren-ja Docks", 6 },
      { "Old Town Cavern", 9 },
      { "Pa'alat", 8 },
      { "Rawl'kha", 8 },
      { "Rawl'kha Wayshrine", 1 },
      { "Reaper's Henge", 6 },
      { "Researcher's Camp", 2 },
      { "S'ren-ja", 8 },
      { "Senalana", 8 },
      { "Sren-ja Wayshrine", 1 },
      { "The Apprentice", 4 },
      { "The Steed", 4 },
      { "The Vile Manse", 3 },
      { "Thibaut's Cairn", 3 },
      { "Thizzrini Arena", 8 },
      { "Thormar", 8 },
      { "Two Moons Path", 8 },
      { "Ushmal's Rest", 6 },
      { "Vinedusk Village", 8 },
      { "Vinedusk Wayshrine", 1 },
      { "Waterdancer Falls", 6 },
      { "Weeping Wind Cave", 3 },
      { "Willowgrove", 8 },
      { "Willowgrove Cavern", 2 },
      { "Willowgrove Wayshrine", 1 },
   },
}


Harvest.poiData["rivenspire"] = {
--Rivenspire (Daggerfall, lvl 25-30)
   ["rivenspire_base"] = {       --Rivenspire
      --en
      { "Aesar's Web", 6 },
      { "Boralis Dolmen", 5 },
      { "Boralis Wayshrine", 1 },
      { "Breagha-Fin", 8 },
      { "Camp Tamrith", 8 },
      { "Camp Tamrith Wayshrine", 1 },
      { "Crestshade", 8 },
      { "Crestshade Mine", 3 },
      { "Crestshade Wayshrine", 1 },
      { "Dorell Farmhouse", 2 },
      { "Dungeon: Crypt of Hearts", 7 },
      { "East-Rock Landing", 6 },
      { "Edrald Estate", 8 },
      { "Erokii Ruins", 3 },
      { "Eyebright Feld Dolmen", 5 },
      { "Fell's Run", 8 },
      { "Fell's Run Wayshrine", 1 },
      { "Flyleaf Catacombs", 3 },
      { "Hildune's Secret Refuge", 3 },
      { "Hinault Farm", 8 },
      { "Hoarfrost Downs", 8 },
      { "Hoarfrost Downs Wayshrine", 1 },
      { "Lagra's Pearl", 2 },
      { "Lorkrata Hills", 8 },
      { "Magdelena's Haunt", 6 },
      { "Moira's Hope", 8 },
      { "Northpoint", 8 },
      { "Northpoint Wayshrine", 1 },
      { "Northsalt Village", 2 },
      { "Obsidian Scar", 3 },
      { "Old Fell's Fort", 2 },
      { "Old Kalgon's Keep", 6 },
      { "Old Shornhelm Ruins", 2 },
      { "Oldgate Wayshrine", 1 },
      { "Orc's Finger Ruins", 3 },
      { "Ravenwatch Castle", 8 },
      { "Sanguine Barrows", 8 },
      { "Sanguine Barrows Wayshrine", 1 },
      { "Shadowfate Cavern", 2 },
      { "Shornhelm", 8 },
      { "Shornhelm Wayshrine", 1 },
      { "Shrouded Pass Wayshrine", 1 },
      { "Silverhoof Vale", 8 },
      { "Siren's Cove", 6 },
      { "Southgard Tower", 2 },
      { "Staging Grounds Wayshrine", 1 },
      { "The Atronach", 4 },
      { "The Doomcrag", 8 },
      { "The Serpent", 4 },
      { "The Shadow", 4 },
      { "Trader's Rest", 9 },
      { "Traitor's Tor", 8 },
      { "Tribulation Crypt", 3 },
      { "Valewatch Tower", 6 },
      { "Veawend Ede", 9 },
      { "Westmark Moor Dolmen", 5 },
      { "Westwind Lighthouse", 9 },
   },
}

Harvest.poiData["shadowfen"] = {
--Shadowfen (Ebonheart, lvl 25-30)
   ["shadowfen_base"] = {        --Shadowfen
      --en
      { "Alten Corimont", 8 },
      { "Alten Corimont Wayshrine", 1 },
      { "Atanaz Ruins", 3 },
      { "Atronach Stone", 4 }, --WTF?
      { "Bitterroot Cave", 6 },
      { "Bogmother", 8 },
      { "Bogmother Wayshrine", 1 },
      { "Broken Tusk", 3 },
      { "Camp Crystal Abattoir", 2 },
      { "Camp Merciful Reduction", 2 },
      { "Camp Silken Snare", 2 },
      { "Captain Bones' Ship", 6 },
      { "Chid-Moska Ruins", 3 },
      { "Deep Graves", 8 },
      { "Dungeon: Arx Corinium", 7 },
      { "Forsaken Hamlet", 8 },
      { "Forsaken Hamlet Wayshrine", 1 },
      { "Gandranen Ruins", 3 },
      { "Hatching Pools", 8 },
      { "Hatching Pools Wayshrine", 1 },
      { "Hatchling's Crown", 9 },
      { "Haynekhtnamet's Lair", 6 },
      { "Hei-Halai", 2 },
      { "Hissmir", 8 },
      { "Hissmir Wayshrine", 1 },
      { "Leafwater Dolmen", 5 },
      { "Loriasel", 8 },
      { "Loriasel Wayshrine", 1 },
      { "Mud Tree Village", 8 },
      { "Murkwater", 8 },
      { "Nen Ria", 6 },
      { "Onkobra Kwama Mine", 3 },
      { "Percolating Mire", 8 },
      { "Percolating Mire Wayshrine", 1 },
      { "Reticulated Spine Dolmen", 5 },
      { "Sanguine's Demesne", 3 },
      { "Serpent Stone", 4 }, --WTF
      { "Shrine of the Black Maw", 3 },
      { "Slaver Camp", 6 },
      { "Stillrise Village", 8 },
      { "Stillrise Wayshrine", 1 },
      { "Stormhold", 8 },
      { "Stormhold Wayshrine", 1 },
      { "Sunscale Strand", 8 },
      { "Telvanni Acquisition Camp", 2 },
      { "Ten-Maur-Wolk", 8 },
      { "The Graceful Dominator", 2 },
      { "The Shadow", 4 },
      { "The Vile Pavilion", 2 },
      { "Tsonashap Mine", 2 },
      { "Venomous Fens Dolmen", 5 },
      { "Venomous Fens Wayshrine", 1 },
      { "Weeping Wamasu Falls", 9 },
      { "White Rose Prison", 8 },
      { "Xal Haj-Ei Shrine", 9 },
      { "Xal Ithix", 8 },
      { "Xal Thak", 6 },
      { "Zuuk", 8 },
      
   },
}




Harvest.poiData["stonefalls"] = {
--Stonefalls (Ebonheart, lvl 5-15)
   ["stonefalls_base"] = {       --Stonefalls
      --en
      { "Armature's Upheaval", 9 },
      { "Ash Mountain", 8 },
      { "Ashen Road Wayshrine", 1 },
      { "Brothers of Strife", 8 },
      { "Brothers of Strife Wayshrine", 1 },
      { "Cave of Memories", 6 },
      { "Crow's Wood", 3 },
      { "Daen Seeth Dolmen", 5 },
      { "Dagger's Point Invasion Camp", 2 },
      { "Davenas Farm", 2 },
      { "Davon's Watch", 8 },
      { "Davon's Watch Wayshrine", 1 },
      { "Dockyards", 8 },
      { "Dungeon: Fungal Grotto", 7 },
      { "Ebonheart", 8 },
      { "Ebonheart Wayshrine", 1 },
      { "Emberflint Mine", 3 },
      { "Fort Arand", 8 },
      { "Fort Arand Wayshrine", 1 },
      { "Fort Virak", 8 },
      { "Fort Virak Wayshrine", 1 },
      { "Greymist Falls", 2 },
      { "Heimlyn Keep", 8 },
      { "Hightide Hollow", 3 },
      { "Hrogar's Hold", 8 },
      { "Hrogar's Hold Wayshrine", 1 },
      { "Iliath Temple", 8 },
      { "Iliath Temple Wayshrine", 1 },
      { "Inner Sea Armature", 3 },
      { "Kragenmoor", 8 },
      { "Kragenmoor Wayshrine", 1 },
      { "Lukiul Uxith", 8 },
      { "Magmaflow Overlook", 9 },
      { "Mephala's Nest", 3 },
      { "Othrenis", 8 },
      { "Othrenis Wayshrine", 1 },
      { "Sathram Plantation", 8 },
      { "Sathram Plantation Wayshrine", 1 },
      { "Senie", 8 },
      { "Senie Wayshrine", 1 },
      { "Sheogorath's Tongue", 3 },
      { "Shipwreck Strand", 6 },
      { "Shivering Shrine", 6 },
      { "Softloam Cavern", 3 },
      { "Starved Plain", 8 },
      { "Steamfont Cavern", 9 },
      { "Steamlake Encampment", 2 },
      { "Still-Water's Camp", 2 },
      { "Stonefang Isle", 2 },
      { "Strifeswarm Hive", 6 },
      { "Strifeswarm Kwama Mine", 2 },
      { "Sulfur Pools", 8 },
      { "Sulfur Pools Wayshrine", 1 },
      { "The Brahma's Grove", 6 },
      { "The Harborage", 1 },
      { "The Lady", 4 },
      { "The Lover", 4 },
      { "The Matron's Clutch", 6 },
      { "Tormented Spire", 8 },
      { "Varanis Dolmen", 5 },
      { "Vivec's Antlers", 8 },
      { "Vivec's Antlers Wayshrine", 1 },
      { "Zabamat Dolmen", 5 },
      
   },

--Entered
--Bal Foyen (Ebonheart lvl 1-5)
   ["balfoyen_base"] = {      --Bal Foyen
      --en
      { "Bal Foyen Dockyards", 8 },
      { "Dhalmora", 8 },
      { "Dhalmora Wayshrine", 1 },
      { "Fort Zeren", 8 },
      { "Fort Zeren Wayshrine", 1 },
      { "Foyen Docks Wayshrine", 1 },
      { "Hidden Dagger Landing Site", 2 },
      { "Plantation Point Overlook", 2 },
   },

--Entered
--Bleakrock Isle (Ebonheart, lvl 1-5)


   ["bleakrock_base"] = {  --Bleakrock Isle
      --en      
      { "Bleakrock Village", 8 },
      { "Bleakrock Wayshrine", 1 },
      { "Companions Point", 2 },
      { "Deathclaw's Lair", 2 },
      { "Frostedge Camp", 8 },
      { "Halmaera's House", 8 },
      { "Hozzin's Folly", 8 },
      { "Hunter's Camp", 8 },
      { "Orkey's Hollow", 8 },
      { "Paddlefloe Fishing Camp", 2 },
      { "Skyshroud Barrow", 8 },
   },
}




Harvest.poiData["stormhaven"] = {
--Stormhaven (Daggerfall, lvl 16-23)
   ["stormhaven_base"] = {       --Stormhaven
      --en
      { "Abandoned Farm", 6 },
      { "Alcaire Castle", 8 },
      { "Alcaire Castle Wayshrine", 1 },
      { "Alcaire Dolmen", 5 },
      { "Ancient Altar", 6 },
      { "Aphren's Hold", 8 },
      { "At-Tura Estate", 8 },
      { "Bearclaw Mine", 3 },
      { "Bonesnap Ruins", 3 },
      { "Bonesnap Ruins Wayshrine", 1 },
      { "Cave of Dreams", 2 },
      { "Cumberland Falls", 2 },
      { "Cumberland's Watch", 8 },
      { "Dreugh Waters", 6 },
      { "Dreughside", 8 },
      { "Dro'dara Plantation Wayshrine", 1 },
      { "Dro-Dara Plantation", 8 },
      { "Dungeon: Wayrest Sewers", 7 },
      { "Farangel's Delve", 3 },
      { "Farangel's Landing", 8 },
      { "Firebrand Keep", 8 },
      { "Firebrand Keep Wayshrine", 1 },
      { "Fisherman's Island", 9 },
      { "Gavaudon Dolmen", 5 },
      { "Hammerdeath Workshop", 9 },
      { "Koeglin Lighthouse", 8 },
      { "Koeglin Mine", 3 },
      { "Koeglin Village", 8 },
      { "Koeglin Village Wayshrine", 1 },
      { "Menevia Dolmen", 5 },
      { "Moonlit Maw", 8 },
      { "Mudcrab Beach", 6 },
      { "Nightmare Crag", 2 },
      { "Norvulk Ruins", 3 },
      { "Nurin Farm", 8 },
      { "Pariah Abbey", 8 },
      { "Pariah Abbey Wayshrine", 1 },
      { "Pariah Catacombs", 3 },
      { "Portdun Watch", 3 },
      { "Scrag's Larder", 6 },
      { "Shinji's Scarp", 8 },
      { "Shrine to Azura", 2 },
      { "Soulshriven Tower", 8 },
      { "Soulshriven Wayshrine", 1 },
      { "Spider Nest", 6 },
      { "Steelheart Moorings", 8 },
      { "Stonechewer Goblin Camp", 2 },
      { "Supernal Dreamers Camp", 2 },
      { "The Lord", 4 },
      { "The Mage", 4 },
      { "The Tower", 4 },
      { "Travelers' Rest", 2 },
      { "Vanne Farm", 8 },
      { "Wayrest Wayshrine", 1 },
      { "Weeping Giant", 8 },
      { "Weeping Giant Wayshrine", 1 },
      { "Wind Keep", 228 },
      { "Wind Keep Wayshrine", 1 },
      { "Windridge Cave", 8 },
      { "Windridge Warehouse", 9 },
   },
}

Harvest.poiData["therift"] = {
--The Rift (Ebonheart, lvl 37-43)
   ["therift_base"] = {          --The Rift
      --en
      { "Abandoned Camp", 6 },
      { "Autumnshade Clearing", 2 },
      { "Avanchnzel", 3 },
      { "Boulderfall Pass", 8 },
      { "Broken Helm Hollow", 3 },
      { "Dungeon: Blessed Crucible", 7 },
      { "Eldbjorg's Hideaway", 9 },
      { "Faldar's Tooth", 3 },
      { "Fallowstone Hall", 8 },
      { "Fallowstone Hall Wayshrine", 1 },
      { "Forelhost", 8 },
      { "Fort Greenwall", 3 },
      { "Frostmoon Farmstead", 8 },
      { "Frozen Ruins", 6 },
      { "Fullhelm Fort", 8 },
      { "Fullhelm Fort Wayshrine", 1 },
      { "Geirmund's Hall", 8 },
      { "Geirmund's Hall Wayshrine", 1 },
      { "Giant Camp", 6 },
      { "Grethel's Vigil", 2 },
      { "Honeystrand Hill", 2 },
      { "Honrich Tower", 8 },
      { "Honrich Tower Wayshrine", 1 },
      { "Hunter Camp", 6 },
      { "Ivarstead", 8 },
      { "Jenedusil's Claw", 2 },
      { "Linele Skullcarver's Camp", 2 },
      { "Lion's Den", 3 },
      { "Lost Prospect", 8 },
      { "Mammoth Ridge", 2 },
      { "Nimalten", 8 },
      { "Nimalten Wayshrine", 1 },
      { "Northwind Mine", 8 },
      { "Northwind Mine Wayshrine", 1 },
      { "Pinepeak Cavern", 8 },
      { "Ragged Hills Dolmen", 5 },
      { "Ragged Hills Wayshrine", 1 },
      { "Riften", 8 },
      { "Riften Wayshrine", 1 },
      { "Shor's Stone", 8 },
      { "Shroud Hearth Barrow", 3 },
      { "Skald's Retreat", 8 },
      { "Skald's Retreat Wayshrine", 1 },
      { "Smokefrost Peaks Dolmen", 5 },
      { "Smokefrost Vigil", 9 },
      { "Snapleg Cave", 3 },
      { "Stony Basin Dolmen", 5 },
      { "Taarengrav", 8 },
      { "Taarengrav Wayshrine", 1 },
      { "The Apprentice", 4 },
      { "The Steed", 4 },
      { "Three Tribes Camp", 2 },
      { "Treva's Farm", 8 },
      { "Trolhetta", 8 },
      { "Trolhetta Summit Wayshrine", 1 },
      { "Trolhetta Wayshrine", 1 },
      { "Troll Cave", 6 },
      { "Trollslayer's Gully", 9 },
      { "Vernim Woods", 8 },
      { "Wisplight Glen", 6 },
      
   },
}

Harvest.poiData["craglorn"] = {
--craglorn
   ["craglorn_base"] = {          --craglorn
      --en
   },
}

