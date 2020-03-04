HarvestMap by: Shinni and Sharlikran
==========

HarvestMap (formerly known as EsoheadMarkers) displays harvest nodes, chests and fishing spots on map and compass.

Features:
* displays (already discovered) harvest nodes and chests on map and compass
* filters for each pin type (chests/ore/herbs etc)
* size and color settings for each pin type
* import already discovered nodes from other players
* debug mode to delete pins

## What exactly does this addon do? ##

Whenever you harvest crafting materials, lockpick a chest, fish at a fishing hole, this addon will save the location and place a pin on your map and compass.
So if you need a certain ressource later, you can just open your map or look at your compass to find them.
This addon does NOT come with any data, this addon will only display the pins you found yourself. However, you can import other players' data. See ## How do I import other players' data? ## for more information.

## Why are there 5 HarvestMap addons/folders? ##

HarvestMap is split into 5 smaller addons: HarvestMap, HarvestMap-AD-Zones, HarvestMap-DC-Zones, HarvestMap-EP-Zones and HarvestMap-Import

The first one is the base addon which does all the data gathering and display of pins on your map/compass.

The HarvestMap-XX-Zones addons are just containers for your data.
See ## Since using HarvestMap the loading screens take a lot more time! ## for more information.

The HarvestMap-Import addon handles the import of addons.
See ## How do I import other players' data? ## for more information.

## How can I disable pin types? I only want to to see pins for ressource X. ##

When you open the map, there is a funnel icon on the right side.
If you click on it it opens the filters panel. Here you can enable/disable each pin type.

## What does the "HarvestMap Debug" checkbox in the filters panel do? ##

When you enable the debug mode, you can delete pins by clicking on them.

## Since using HarvestMap the loading screens take a lot more time! ##

HarvestMap collects a lot of data and loading this data can result in long loading screens.
You can disable one or more of the HarvestMap-XX-zones addons, to reduce the loaded data.
All data from Aldmeri Dominion zones are saved in the addon HarvestMap-AD-Zones.
Likewise the data from Daggerfall Covenant zones or Ebonheart Pact zones are saved in HarvestMap-DC-Zones or HarvestMap-EP-Zones.
If you are for instance currently not interested in pins on AD or DC zones (ie you are doing your cadewell's silver/gold in EP), you can disable the HarvestMap-AD-Zones and HarvestMap-EP-Zones addon.
This reduces the loaded data without deleting it: if you want to see the pins for the other zones again, simply reactivate the other addons.

## How do I import other players' data? ##

All the data is stored in: My Documents/Elder Scrolls Online/live/SavedVariables/HarvestMap.lua
(If you are playing on the EU server or on PTS the folder "live" is called "liveeu" or "pts".)
If you want to give your data to another player, you can simply send him/her this file.

If you want to user another player's data, you need to prepare their save file a bit:
- Rename their file to "HarvestMapImport.lua"
- Open the renamed file with a texteditor (ie notepad.exe, that one is installed by default on every windows machine.)
- The first line of the file is: Harvest_SavedVars =
replace this line with: HarvestImport_SavedVars =
- Save the file and close the editor. You have now finished preparing th other player's save file.
- While not playing a character (so when the game is closed or during login/character selection screen), move the file into your SavedVariables folder.
If there is already another HarvestMapImport.lua file, you can simply overwrite it.
- Log into a character and enable all 5 HarvestMap addons.
- Go to the import menu (ESC -> Settings -> AddonSettings -> HarvestMapImport).
- Here you can select which data you want to import (e.g. only certain pin types or zones).
- Hit the import button and wait a bit. Your chat will display the current process.
Your game may become a bit laggy while importing as there is a lot of data being processed.
- If you want to import another save file, you need to logout again an repeat the above steps with the next save file.

## When I harvest something, there isn't a new pin appearing! ##
Go to ESC -> Settings -> Addon Settings -> HarvestMap
On the very bottom the the options panel you can enable debug messages.
Now harvest a ressource and post the debug output (it's in the chat) to the comment section on esoui:
http://www.esoui.com/downloads/info57.html#comments
With the debug messages I might be able to find and fix the error.

## Disclaimer ##

This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc. or its affiliates.
The Elder Scrolls® and related logos are registered trademarks or trademarks of ZeniMax Media Inc. in the United States and/or other countries.
All rights reserved.
