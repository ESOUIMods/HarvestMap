
Harvest.defaultLocalizedStrings = {
	-- conflict message for settings that don't work with Fyrakin's minimap
	["minimapconflict"] = "This option is incompatible with Fyrakin's minimap.",
	-- top level description
	["esouidescription"] = "For the addon description and FAQ visit the addon's page on esoui.com",
	["openesoui"] = "Open ESOUI",
	["exchangedescription"] = "You can download the most recent HarvestMap data (positions of resources) by executing 'DownloadNewData.command' (MacOS)' or 'DownloadNewData.bat' (Windows) in the HarvestMap folder. More information regarding this is available in the ESOUI addon description.",
	["feedback"] = "Feedback",
	["feedbackdescription"] = "If you found a bug, have a request or a suggestion, or simply wish to donate, send a mail.\nYou can also leave feedback and bug reports in the HarvestMap comment section on esoui.com.",
	["sendgold"] = "Send <<1>> gold",
	["debuginfodescription"] = "If you want to report a bug on the esoui.com comment page, please also add the following debug information:",
	["printdebuginfo"] = "Copy Debug Information",
	
	["notifications"] = "Notifications and Warnings",
	["notificationstooltip"] = "Displays notifications and warnings in the top right corner of the screen.",
	["moduleerrorload"] = "The addon <<1>> is disabled.\nNo data available for this area.",
	["moduleerrorsave"] = "The addon <<1>> is disabled.\nThe location of the node was not saved.",
	
	-- outdated data settings
	["outdateddata"] = "Outdated Data Settings",
	["outdateddatainfo"] = "These data related settings are shared between all accounts and characters on this computer.",
	["mingameversion"] = "Minimum game version",
	["mingameversiontooltip"] = "HarvestMap will only keep data from this and newer versions of ESO.",
	["timedifference"] = "Keep only recent data",
	["timedifferencetooltip"] = "HarvestMap will only keep data from the last X days.\nThis prevents displaying old data which may already be outdated.\nSet to 0 to keep any data regardless of its age.",
	["applywarning"] = "Once old data has been removed, it can not be restored!",
	
	-- account wide settings
	["account"] = "Account-wide Settings",
	["accounttooltip"] = "All the settings below will be the same for each of your characters.",
	["accountwarning"] = "Changing this setting will reload the UI.",
	
	-- map pin settings
	["mapheader"] = "Map Pin Settings",
	["mappins"] = "Enable pins on main map",
	["mappinstooltip"] = "Enable the display of pins on the main map. Can be disabled to increase performance.",
	["minimappins"] = "Enable pins on mini map",
	["minimappinstooltip"] = [[Enable the display of pins on the mini map, if you have a minimap addon installed. Can be disabled to increase performance.
Supported minimaps: Votan, Fyrakin and AUI]],
	mapspawnfilter = "Display only spawned resources on main map",
	minimapspawnfilter = "Display only spawned resources on minimap",
	spawnfiltertooltip = [[When enabled, HarvestMap will hide pins for resources that have not spawned yet.
For example if another player already harvested the resource, then the pin will be hidden until the resource is available again.
This option works only for harvestable crafting material, it does not work for containers such as chests or heavy sacks.
Does not work if another addon hides or rescales the compass.]],
	nodedetectionmissing = "This option can only be enabled, if the 'NodeDetection' library is enabled.",
	spawnfilterwarning = "Does not work if another addon hides or rescales the compass.",
	--["minimaponly"] = "Display pins only on the minimap",
	--["minimaponlytooltip"] = "When this option is enabled, there will be no pins on the default map. The pins will only be displayed on the minimap.",
	["level"] = "Display map pins above POI pins.",
	["leveltooltip"] = "Enable to display the pins of HarvestMap above the POI pins on the map.",
	["hasdrawdistance"] = "Display only nearby map pins",
	["hasdrawdistancetooltip"] = "When enabled, HarvestMap will only create map pins for harvest locations that are close to the player.\nThis setting only affects the ingame map. On minimaps this option is automatically enabled!",
	["hasdrawdistancewarning"] = "This setting only affects the ingame map. On minimaps this option is automatically enabled!",
	["drawdistance"] = "Map pin distance",
	["drawdistancetooltip"] = "The distance threshold for which map pins are drawn. This setting does also affect minimaps!",
	["drawdistancewarning"] = "This setting does also affect minimaps!",
	["rotatingcompatibility"] = "Rotating Minimap Compatibility",
	["minimapcompatibilitymodedescription"] = "To improve the performance when displaying thousands of resource locations on the map, HarvestMap creates its very own light-weight variant of map pins. These light-weight map pins are not compatible with rotating minimaps.\nIf you use a rotating minimap, you can enable the 'Minimap Compatibility Mode'. When this mode is enabled, HarvestMap will use default map pins instead of the light-weight pins. These default pins will work with rotating minimaps, but they can result in low FPS and the game freezing for several seconds, whenever a map with many known resource locations is displayed.",
	["minimapcompatibilitymode"] = "Minimap Compatibility Mode",
	["minimapcompatibilitymodewarning"] = "Enabling this option will negatively impact the game's performance, when many pins are displayed on the map.\n\nChanging the setting will reload the UI!",
	
	-- compass settings
	["compassheader"] = "Compass Settings",
	["compass"] = "Enable compass",
	["compasstooltip"] = "Enable the display of close pins on the compass. Can be disabled to increase performance.",
	compassspawnfilter = "Display only spawned resources",
	["compassdistance"] = "Max pin distance",
	["compassdistancetooltip"] = "The maximum distance for pins in meters that appear on the compass.",
	
	-- 3d pin settings
	["worldpinsheader"] = "3D Pin Settings",
	["worldpins"] = "Enable 3D pins",
	["worldpinstooltip"] = "Enable to display nearby resource locations in the 3D game world. Can be disabled to improve the performance.",
	worldspawnfilter = "Display only spawned resources",
	["worlddistance"] = "Max 3D pin distance",
	["worlddistancetooltip"] = "The maximum distance for harvest locations in meters. When a location is further away, no 3D pin is displayed.",
	["worldpinwidth"] = "3D pin width",
	["worldpinwidthtooltip"] = "The width of the 3D pins in centimeters.",
	["worldpinheight"] = "3D pin height",
	["worldpinheighttooltip"] = "The height of the 3D pins in centimeters.",
	["worldpinsdepth"] = "Use depth-buffer for 3D pins",
	["worldpinsdepthtooltip"] = "When disabled, the 3d pins will not be hidden behind other objects.",
	["worldpinsdepthwarning"] = "Because of a game bug, this option does not work, when a SubSampling quality of medium or low is selected in the game's video options.",
	
	
	-- respawn timer settings
	["farmandrespawn"] = "Respawn Timer and Farming Helper",
	["rangemultiplier"] = "Visited node range",
	["rangemultipliertooltip"] = "Nodes within X meters are considered as visited by the respawn timer and the farming helper.",
	["usehiddentime"] = "Hide recently visited nodes",
	["usehiddentimetooltip"] = "Pins will be hidden if you visited their location recently.",
	["hiddentime"] = "Duration (Respawn Timer)",
	["hiddentimetooltip"] = "Recently visited nodes will be hidden for X minutes.",
	["hiddenonharvestwarning"] = "Turning this option off could negatively impact the game's performance.",
	["hiddenonharvest"] = "Hide nodes only after harvesting",
	["hiddenonharvesttooltip"] = "Enable to hide pins only, when you harvested them. When disabled pins will also be hidden if you visit them.",
	
	
	-- pin type options
	["pinoptions"] = "Pin Type Options",
	["pinsize"] = "Pin size",
	["pinsizetooltip"] = "Set the size of the pins on the map.",
	["pinminsize"] = "Minimum map pin size",
	["pinminsizetooltip"] = "When zooming out on the map, the pins will become smaller as well. You can use this option to set a minimum for the pins' size. Using small values prevents the map from being hidden behind pins, but the pins may become more difficult to see.",
	["extendedpinoptions"] = "Usually the pins on map, compass and in the 3d world are synced. So if you hide a certain type of resource on the map, it will also remove the compass and world pins. However, in the extended pin filter menu you can set compass and world pins to be independent of the map pins.",
	["extendedpinoptionsbutton"] = "Open extended pin filter",
	["override"] = "Override map pin filter",
	
	["pincolor"] = "Pin color",
	["pincolortooltip"] = "Set the color of the pins on map and compass.",
	["savepin"] = "Save locations",
	["savetooltip"] = "Enable to save the locations of this resource when you discover them.",
	["pintexture"] = "Pin icon",
	
	-- debug output setting
	["debugoptions"] = "Debug",
	["debug"] = "Display debug messages",
	["debugtooltip"] = "Enable to display debug messages in the chat.",
	
	-- pin type names
	["pintype1"] = "Smithing and Jewelry",
	["pintypetooltip1"] = "Display ore and dust on the map and compass.",
	["pintype2"] = "Fibrous plants",
	["pintypetooltip2"] = "Display clothing material on the map and compass.",
	["pintype3"] = "Runestones and Psijic Portals",
	["pintypetooltip3"] = "Display runestones and Psijic portals on the map and compass.",
	["pintype4"] = "Mushrooms",
	["pintypetooltip4"] = "Display mushrooms on the map and compass.",
	["pintype13"] = "Herbs/Flowers",
	["pintypetooltip13"] = "Display herbs and flowers on the map and compass.",
	["pintype14"] = "Water herbs",
	["pintypetooltip14"] = "Display water plants on the map and compass.",
	["pintype5"] = "Wood",
	["pintypetooltip5"] = "Display wood on the map and compass.",
	["pintype6"] = "Chests",
	["pintypetooltip6"] = "Display chests on the map and compass.",
	["pintype7"] = "Solvents",
	["pintypetooltip7"] = "Display solvents on the map and compass.",
	["pintype8"] = "Fishing spots",
	["pintypetooltip8"] = "Display fishing locations on the map and compass.",
	["pintype9"] = "Heavy Sacks",
	["pintypetooltip9"] = "Display heavy sacks on the map and compass.",
	["pintype10"] = "Thieves Troves",
	["pintypetooltip10"] = "Display Thieves Troves on the map and compass.",
	["pintype11"] = "Justice Containers",
	["pintypetooltip11"] = "Display Justice Containers like Safeboxes or Heist objectives on the map and compass.",
	["pintype12"] = "Hidden Stashes",
	["pintypetooltip12"] = "Display hidden stashes like 'Loose Panels' on the map and compass.",
	["pintype15"] = "Giant Clams",
	["pintypetooltip15"] = "Display giant clams on the map and compass.",
	
	["pintype18"] = "Unknown harvest node",
	["pintypetooltip18"] = "HarvestMap can detect nearby crafting material, but it can not detect the type of material unless you discovered the location beforehand.",
	
	["pintype19"] = "Crimson Nirnroot",
	["pintypetooltip19"] = "Display crimson nirnroot on the map and compass.",

	-- extra map filter buttons
	["deletepinfilter"] = "Delete HarvestMap pins",
	["filterheatmap"] = "Heatmap mode",
	
	-- localization for the farming helper
	["goldperminute"] = "Gold per minute:",
	["farmresult"] = "HarvestFarm Result",
	["farmnotour"] = "HarvestFarm was not able to calculate a good farming route with the given minimum route length.",
	["farmerror"] = "HarvestFarm Error",
	["farmnoresources"] = "No resources found.\nThere are no resources on this map or you don't have any resource types selected.",
	["farminvalidmap"] = "The farming helper tool can not be used on this map.",
	["farmsuccess"] = "HarvestFarm calculated a farming tour with <<1>> nodes per kilometer.\n\nClick on one of the tour's pins to set the tour's starting point.",
	["farmdescription"] = "HarvestFarm will calculate a tour with a very high resource per time ratio.\nAfter generating a tour, click on one of the selected resources to set the tour's starting point.",
	["farmminlength"] = "Minimum route length",
	["farmminlengthtooltip"] = "The minimum length of the tour in kilometers.",
	["farmminlengthdescription"] = "The longer the tour, the higher the chance that the resources have respawned when you start the next cycle.\nHowever a shorter tour will have a better resource per time ratio.",
	["tourpin"] = "Next target of your tour",
	["calculatetour"] = "Calculate Tour",
	["showtourinterface"] = "Show Tour Interface",
	["canceltour"] = "Cancel Tour",
	["reverttour"] = "Revert Tour Direction",
	["resourcetypes"] = "Resource Types",
	["skiptarget"] = "Skip current target",
	["removetarget"] = "Remove current target",
	["nodesperminute"] = "Nodes per minute",
	["distancetotarget"] = "Distance to the next resource",
	["showarrow"] = "Display direction",
	["removetour"] = "Remove Tour",
	["undo"] = "Undo last change",
	["tourname"] = "Tour name: ",
	["defaultname"] = "Unnamed tour",
	["savedtours"] = "Saved tours for this map:",
	["notourformap"] = "There is no saved tour for this map.",
	["load"] = "Load",
	["delete"] = "Delete",
	["saveexiststitle"] = "Please Confirm",
	["saveexists"] = "There is already a tour with the name <<1>> for this map. Do you want to overwrite it?",
	["savenotour"] = "There is no tour that could be saved.",
	["loaderror"] = "The tour could not be loaded.",
	["removepintype"] = "Do you want to remove <<1>> from the tour?",
	["removepintypetitle"] = "Confirm Removal",
	
	-- extra harvestmap menu
	["pinvisibilitymenu"] = "Extended Pin Filter Menu",
	["menu"] = "HarvestMap Menu",
	["farmmenu"] = "Farming Tour Editor",
	["editordescription"] = [[In this menu, you can create and edit tours.
If there is currently no other tour active, you can create a tour by clicking onto the map pins.
If there is a tour active, you can edit the tour by replacing sub-sections:
- First click on a pin of your (red) tour.
- Then, click on the pins that you want to add to your tour. (A green tour will appear)
- Finally, click on a pin of your red tour again.
The green tour will now be inserted into the red tour.]],
	["editorstats"] = [[Number of nodes: <<1>>
Length: <<2>> m
Nodes per kilometer: <<3>>]],
	
	-- SI names to fit with ZOS api
	["SI_BINDING_NAME_SKIP_TARGET"] = "Skip Target",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "Toggle 3D pins",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "Toggle map pins",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "Toggle HarvestMap Pin Menu",
	["SI_HARVEST_CTRLC"] = "Press CTRL+C to copy the text",
	["HARVESTFARM_GENERATOR"] = "Generate new tour",
	["HARVESTFARM_EDITOR"] = "Edit tour",
	["HARVESTFARM_SAVE"] = "Save/Load tour",

	--Harvestmap menu (enhanced pin filters)
	["3dPins"] = "3D pins",
	["CompassPins"] = "Compass pins",
}

local default = Harvest.defaultLocalizedStrings
local current = Harvest.localizedStrings or {}

function Harvest.GetLocalization(tag)
	-- return the localization for the given tag,
	-- if the localization is missing, use the english string instead
	-- if the english string is missing, something went wrong.
	-- return the tag so that at least some string is returned to prevent the addon from crashing
	return (current[ tag ] or default[ tag ]) or tag
end

local UIStrings = {"SI_BINDING_NAME_SKIP_TARGET", "SI_BINDING_NAME_TOGGLE_WORLDPINS", "SI_BINDING_NAME_TOGGLE_MAPPINS", "SI_BINDING_NAME_HARVEST_SHOW_PANEL",
		"SI_HARVEST_CTRLC", "HARVESTFARM_GENERATOR","HARVESTFARM_EDITOR","HARVESTFARM_SAVE"}
for _, str in pairs(UIStrings) do
	ZO_CreateStringId(str, Harvest.GetLocalization(str))
end
