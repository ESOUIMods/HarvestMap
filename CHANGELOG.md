## 2.5.9

Minor Update
- Simplified duplicate node detection routine

## 2.5.8

Minor Update
- Updated Custom Compass Pins only

## 2.5.7

Bugfix
- Changed the coefficient from the incorrect value of 0.00001 to 0.000001

With the old value the result would have been 0.00025 and it should be 0.000025.  This would have made some nodes insert into other nodes when they shouldn't have.  I am sorry for the mistake and any nodes lost.  Please restore and import backups using HarvestMerge.  HarvestMerge was unaffected since it did not get the update to have a slider to adjust the range of duplicate nodes.

## 2.5.6

Feature
- Added slider options so users can fine tune the range at which the nodes are considered duplicate nodes
This will let users adjust the setting without manually editing files or waiting for me to release a new version with different values.

- Added new slash command "/harvest reset defaults"
Allows users to reset their settings to the original defaults.  This does not reset nodes or collected data.  If you had AccountWide settings ON you will need to toggle it ON again.

## 2.5.5

Updates
- Updated localization routines[1][2]
- Updated auto update routines for when localization has changed

[1] Upon further investigation versions 2.4.7, 2.4.8, and 2.4.9 would not have handled Cgarlorn data correctly due to lack of localization information from Esohead.com.  This has been resolved.  All versions of harvestMap 2.5.0 or newer handle Craglorn data.  HarvestMap will automatically move Craglorn data to the pool of usable data for map pins.
[2] Upon further investigation HarvestMerge version 0.1.4 had some Craglorn support.  HarvestMerge versions 0.1.5 or newer handle Craglorn data.  HarvestMerge will automatically move Craglorn data to the pool of usable data for importing into HarvestMap.

## 2.5.4

Bugfixes
- Updates to resolve HarvstMap refreshing pins too frequently [Garkin]
- Updated Custom Map Pins using data for maps other then the current one [Garkin]
- changed "Violet Copninus" to correct spelling of "Violet Coprinus"

Updates
- Verified some Craglorn map names.[1]
- Updated localization info

[1] It was reported that Craglorn data was made unavailable after 2.4.7.  I could still use backups of HarvestMap.lua from 2.4.0 to 2.4.6 and 2.5.0 or higher.  All versions of HarvestMpa 2.5.0 or higher have proper Craglorn support.  HarvestMap will automatically move Craglorn data to the pool of usable data for map pins.

## 2.5.3

Bugfix
- Duplicate node verification was too strict

## 2.5.2

Bugfix
- Fixed issue with HarvestMerge skipping chests and fishing holes in certain cases.

## 2.5.1

Bugfix
- Fixed importing with all filters on.  Some items were still being imported.

## 2.5.0

Updates
- Updated importing routines.  If you use HarvestMerge you will have to update to 0.1.5 in order to import information.
- Attempted to make counters more accurate.
- Updated Craglorn Support[1]

[1] It was reported that Craglorn data was made unavailable after 2.4.7.  I could still use backups of HarvestMap.lua from 2.4.0 to 2.4.6 and 2.5.0 or higher.  All versions of HarvestMpa 2.5.0 or higher have proper Craglorn support.  HarvestMap will automatically move Craglorn data to the pool of usable data for map pins.

## 2.4.9

Updates
- Added more craglorn support and other map localization from Esohead
- Updated node recording routines.  You should not get duplicate fishing and chest nodes.

## 2.4.8

Updates
- Added craglorn support to localization files

## 2.4.7
- Added importing features for Esohead, EsoheadMerge, Harvester, and HarvestMerge
- Added advanced slash commands
- Most of the save file is now part of an array similar to Esohead allowing use of advanced slash commands
- Updated report when importing data
- Filter settings apply to importing from the 4 different addons allowing you to minimize the data saved
- False nodes and containers are places in separate categories that can now be reset

Notes:

1) If you had previously activated "AccountWide" settings, you will have to set that again due to save file changes.  I highly recommend checking the filter settings also.
2) If you leave the data in the backup categories as I make more localization improvements, that data can be updated and placed into the usable data as long as it isn't duplicate information.

Code for slash commands borrowed from Esohead, used with permission

## 2.4.6
- Updated TOC
- Added wmrojer's suggestion for dealing with different map sizes

## 2.4.5
- Updated Libs for Compatibility with other Addons

## 2.4.4
- Updated Libs for Compatibility with other Addons
- Updated Solvent Icon

## 2.4.3
- Added update routine for better node management. Nodes that are not harvested will be saved in an unused section of the HarvestMap.lua save file. This section can be deleted after you see that most of the data is either from an unlocalized Map, or the node is a Crate, Urn, Bottle, Barrel, or bookshelf etc.

## 2.4.2
- Forgot to update foreign language Tool-tips. New Tool-tips need translation.

## 2.4.1
- Updated Tooltip to make them more clear

## 2.4
- Toggle between Account Wide settings, or single account settings (UI WILL RELOAD!!!)
- Filter on Import, per profession (no clean or purge command yet)
- Import feature now filters out Crates, Barrels and such from alchemy
- Import feature now skips False Nodes. For Example, Nodes that are Jute, with a mining ID number, under the Mining Group.
- Import feature now gives basic statistics after import
- Ability to set which harvest nodes are recorded by harvest map
- Added Fishing Hole Tracking
- Added Solvent Tracking (Water Sack and pure Water only)
- Updated localization of Harvest Nodes for French and German. UI translations for the menu are needed.
- Updated Debug messages so any unknown nodes can be properly added
- Attempted to fix in combat FPS loss.

## 2.3.4
- fixed a bug where the pins of the zone map would be drawn in a city or vice versa

## 2.3.3
- Hotfix for Pins without a defined color

## 2.3.2
- added filters to the filter panel (right of the map)
- addon settings are no longer account wide

## 2.3.1
- 2.3 broke the compass
- 2.3 broke chest import from esohead

## 2.3
- data from all clients can now be imported from esohead regardless of the clients' language.
- if you have clients of different languages installed, the gathered data is now shared
- and their tooltips are translated

## 2.2
- if there is a short delay between harvesting and looting a node, the node wasn't collected.

## 2.1.4
- forgot to delete some debug outputs
the chat shouldn't be spammed anymore
- changed some strings in the localization

## 2.1.3
- addon now works with autoloot disabled

## 2.1.2
- added debug function
- too many anchors should be fixed

## 2.1.1
- added French translation
- fixed a bug, where chest pin weren't instantly added to the map/compass

## 2.1
- fixed a chest bug
- changed CustomCompass library version to 1.1

## 2.0
- removed Esohead dependency
- renamed the addon to HarvestMap, as there is no connection to Esohead anymore
- removed skyshard support
The purpose of this addon is now to display recollectable/respawnable content.
If you miss the skyshard feature, use SkyShards by Garkin.
- removed fishing nodes (Sorry!)
They will be added again, but currently they are to buggy.

## 1.5.2
- compass now compatible with the new way of handling skyshard

## 1.5.1
- the pins weren't refreshed when a skyshard was collected
- a pin in Khenarthi's Roost was misplaced.

## 1.5
- fixed runestone bug (the texture file had a wrong name)
- skyshards are now connected to their respective achievement.
This change was already longer in development but it was hard to get the data.
I was able to finish it today thanks to SkyShards.
If you're using EsoheadMarkers only for the skyshard function, you probably want to use the other addon!
This also fixes the following bugs and implements requested features:
- dungeon pins are correctly marked as collected
- skyshards have their journal entry as tooltip
- you can now see, if a skyshard is inside a dungeon
- skyshards should work on non English clients. (But only those on the zone map, not on the dungeon map)

## 1.4
- added fishing nodes
- added filters for fishing nodes
- added new icons with higher resolution because of the compass
(size settings will be reset!)
- this also fixed an issue where it looked like there were two icons for every chest.
- fixed an error which caused the addon to crash if the character logs in on a pvp map.
- added a skyshard to Marbruk
- fixed an error where chests wouldn't appear on the map until the next refresh
- zip file has now version info

## 1.3.1
- fixed skyshard in mathiisen
- fixed bug where the default pins could get a random color

## 1.3
- added colors for highlighting certain pintypes (Requested feature)
- added (beta) compass

## 1.2
- debug mode for skyshards implemented
- filter for uncollected skyshards added

## 1.1
- fixed a filter bug
- pin size can now be changed via /pinsize [category] [size]

## 1.0
- chest pins added
- skyshards don't have to be collected via Esohead anymore
- already discovered skyshards can be filtered

## 0.6
- filters added
(Filters can be changed in the default Filterframe.)

## 0.5
- first release