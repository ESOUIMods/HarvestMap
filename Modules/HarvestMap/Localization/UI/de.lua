
Harvest.localizedStrings = {
	-- conflict message for settings that don't work with Fyrakin's minimap
	["minimapconflict"] = "Diese Option ist nicht kompatibel mit Fyrakin's minimap.",
	-- top level description
	["esouidescription"] = "Eine Addon Beschreibung sowie die FAQ befinden sich auf esoui.com",
	["openesoui"] = "Öffne ESOUI",
	["exchangedescription"] = "Du kannst die aktuellsten HarvestMap-Daten (Positionen der Ressourcen) herunterladen, indem du 'DownloadNewData.command' (macOS) bzw. 'DownloadNewData.bat' (Windows) im HarvestMap-Ordner ausführst. Mehr Informationen dazu findest du in der Addon-Beschreibung auf ESOUI.",
	["debuginfodescription"] = "Whenn du einen Bug/Fehler in der Kommentarsektion auf esoui.com melden willst, bitte füge die folgende Debuginformation an:",
	["printdebuginfo"] = "Kopiere Debuginformation",
	
	-- outdated data settings
	["outdateddata"] = "Veraltete Daten Optionen",
	["outdateddatainfo"] = "Diese Optionen werden mit allen Accounts und Figuren auf diesem Computer geteilt.",
	["mingameversion"] = "Minimale Spielversion",
	["mingameversiontooltip"] = "HarvestMap wird alle Daten entfernen, die älter als die eingestellte Spielversion von ESO sind.",
	["timedifference"] = "Verwerfe veraltete Daten",
	["timedifferencetooltip"] = "HarvestMap verwirft Daten älter als X Tage.\nSetze diesen Wert auf 0, um alle Daten zu behalten - egal wie alt sie sind.",
	["applywarning"] = "Einmal gelöschte Daten können nicht wiederhergestellt werden!",
	
	-- account wide settings
	["account"] = "Accountweite Einstellungen",
	["accounttooltip"] = "Alle Einstellungen unterhalb sind dieselben für alle deine Figuren.",
	["accountwarning"] = "Wenn diese Einstellung geändert wird, wird das Interface neu geladen und es kommt zu einem Ladebildschirm.",
	
	--performance settings
	["performance"] = "Performance und Kompatibilität",
	["minimapcompatibilitymodedescription"] = "Um die Performance bei tausenden von Ressourcen auf der Karte zu verbessern, verwendet HarvestMap seine eigene Variante von Karten-Pins. Diese Karten-Pins since nicht kompatibel mit rotierenden Minimaps.\nFalls du eine rotierende Minimap verwendest, kannst du den 'Minimap Kompatibilitätsmodus' aktivieren. Wenn dieser Modus aktiv ist, verwendet HarvestMap stattdessen die standard Karten-Pins. Diese standard Karten-Pins funktionieren mit rotierenden Minimaps, aber sie können in niedrigen FPS und kurzem einfrieren des Spieles resultieren, wann immer eine Karte mit vielen Ressourcen angezeigt wird.",
	["minimapcompatibilitymode"] = "Minimap Kompatibilitätsmodus",
	["minimapcompatibilitymodewarning"] = "Das Aktivieren dieser Option wird die Spielperformance negativ beeinflussen, wenn viele Ressourcen auf der Karte angezeigt werden.\n\nDas User-Interface wird neu geladen, wenn du diese Option änderst!",
	["hasdrawdistance"] = "Zeige nur nahe Pins",
	--["hasdrawdistancetooltip"] = "Falls aktiviert, wird HarvestMap nur Pins in der Nähe des Spieler anzeigen.",
	["drawdistance"] = "Anzeigedistanz",
	["drawdistancetooltip"] = "Die Distanzgrenze für die 'Zeige nur nahe Pins' Option.",
	
	-- respawn timer settings
	--["farmandrespawn"] = "Respawn Timer and Farming Helper",
	--["rangemultiplier"] = "Visited Node Range",
	--["rangemultipliertooltip"] = "Nodes within X meters are considered as visited by the respawn timer and the farming helper.",
	["hiddentime"] = "Respawn Timer",
	["hiddentimetooltip"] = "Vor kurzem besuche Pins werden für X minuten von der Karte und dem Kompass versteckt. Ist dieser Wert 0, so werden die Pins niemals versteckt.",
	["hiddentimewarning"] = "Setze diesen Wert auf 0, um die Performanz zu verbessern.",
	["hiddenonharvest"] = "Erntespezifischer Respawn Timer",
	["hiddenonharvesttooltip"] = "Aktiviere diese Einstellung um Pins nur zu verstecken, wenn du an ihrer Position etwas geerntet hast.\nWenn deaktiviert werden Pins bereits beim Besuchen versteckt.",
	
	-- compass and world pin settings
	["compassandworld"] = "Compass and 3D Pins",
	["compass"] = "Aktiviere Kompasspins",
	["compasstooltip"] = "Aktiviere diese Einstellung um nahegelegene Pins auf dem Kompass anzeigen zu lassen. Deaktivieren kann zu einer Performanceverbesserung führen.",
	["compassdistance"] = "Maximale Pinentfernung",
	["compassdistancetooltip"] = "Die maximale Entfernung von Pins in Metern, sodass diese noch immer auf dem Kompass erscheinen.",
	["worldpins"] = "Aktiviere 3D Pins",
	["compasstooltip"] = "Aktiviere diese Einstellung um nahegelegene Pins in der 3D Welt anzeigen zu lassen. Deaktivieren kann zu einer Performanceverbesserung führen.",
	["worlddistance"] = "Max 3D Pin Distanz",
	["worlddistancetooltip"] = "Die maximale Distanz für 3D Pins in Metern. Wenn eine Ressource weiter entfernt ist, wird kein 3D Pin angezeigt.",
	["worldpinwidth"] = "3D Pin Breite",
	["worldpinwidthtooltip"] = "Die Breite der 3D Pins in Zentimetern.",
	["worldpinheight"] = "3D Pin Höhe",
	["worldpinheighttooltip"] = "Die Höhe der 3D Pins in Zentimetern.",
	["worldpinsdepth"] = "Verwende den Depth-Buffer für 3D Pins",
	["worldpinsdepthtooltip"] = "Wenn deaktiviert, werden die 3D Pins nicht hinter Objekten versteckt.",
	["worldpinsdepthwarning"] = "Aufgrund eines Fehlers im Spiel funktioniert diese Option nicht, falls eine SubSampling Qualität von Mittel oder Niedrig in den Grafikoptionen ausgewählt ist.",
	
	-- general pin options
	["pinoptions"] = "Allgemeine Pin Optionen",
	--["extendedpinoptions"] = "Usually the pins on map, compass and in the 3d world are synced. So if you hide a certain type of resource on the map, it will also remove the compass and world pins. However, in the extended pin filter menu you can set compass and world pins to be independent of the map pins.",
	--["extendedpinoptionsbutton"] = "Open extended pin filter",
	--["override"] = "Überschreibe Kartenpinfilter",
	["level"] = "Zeige HarvestMaps Pins über den anderen Pins.",
	["leveltooltip"] = "Falls diese Einstellung aktiviert ist, werden HarvestMaps Pins nicht von den anderen Pins auf der Karte verdeckt.",
	["pinsize"] = "Pingröße",
	["pinsizetooltip"] = "Setze die Größe der Pins auf der Karte.",
	["pincolor"] = "Pinfarbe",
	["pincolortooltip"] = "Setze die Farbe der Pins auf der Karte und dem Kompass.",
	["savepin"] = "Speichere Fundorte",
	["savetooltip"] = "Aktiviere diese Einstellung, um die Position dieser Ressource zu speichern, wenn du sie findest.",
	["pintexture"] = "Icon",
	
	-- debug output setting
	["debugoptions"] = "Debug",
	["debug"] = "Zeige Debugnachrichten an",
	["debugtooltip"] = "Falls aktiviert werden Debugnachrichten im Chatfenster angezeigt.",
	
	-- pin type names
	["pintype1"] = "Schmied und Schmuck",
	["pintypetooltip1"] = "Zeige Erze und Staub auf der Karte und dem Kompass.",
	["pintype2"] = "Faserige Pflanzen",
	["pintypetooltip2"] = "Zeige Kleidungsmaterial auf der Karte und dem Kompass.",
	["pintype3"] = "Runen and Psijik Portale",
	["pintypetooltip3"] = "Zeige Runen und Psijik Portale auf der Karte und dem Kompass.",
	["pintype4"] = "Pilze",
	["pintypetooltip4"] = "Zeige Pilze (Alchemie Zutat) auf der Karte und dem Kompass.",
	["pintype13"] = "Kräuter/Blumen",
	["pintypetooltip4"] = "Zeige Kräuter und Blumen (Alchemie Zutaten) auf der Karte und dem Kompass.",
	["pintype14"] = "Wasserkräuter",
	["pintypetooltip4"] = "Zeige Wasserkräuter (Alchemie Zutat) auf der Karte und dem Kompass.",
	["pintype5"] = "Holz",
	["pintypetooltip5"] = "Zeige Holz auf der Karte und dem Kompass.",
	["pintype6"] = "Schatztruhen Pins",
	["pintypetooltip6"] = "Zeige Schatztruhen auf der Karte und dem Kompass.",
	["pintype7"] = "Lösungen Pins",
	["pintypetooltip7"] = "Zeige Lösungen (Alchemie Zutat) auf der Karte und dem Kompass.",
	["pintype8"] = "Fischgründe",
	["pintypetooltip8"] = "Zeige Fischgründe auf der Karte und dem Kompass.",
	["pintype9"] = "Schwere Säcke",
	["pintypetooltip9"] = "Zeige Schwere Säcke auf der Karte und dem Kompass.",
	["pintype10"] = "Diebesgut",
	["pintypetooltip10"] = "Zeige Diebesgut auf der Karte und dem Kompass.",
	["pintype11"] = "Rechtssystem Pins",
	["pintypetooltip11"] = "Zeige Rechtssystem Pins (Beutezugziele und Wertkassetten) auf der Karte und dem Kompass.",
	["pintype12"] = "Geheimverstecke",
	["pintypetooltip12"] = "Zeige Geheimverstecke auf der Karte und dem Kompass.",
	["pintype15"] = "Riesenmuscheln",
	["pintypetooltip15"] = "Zeige Riesenmuscheln auf der Karte und dem Kompass.",
	
	-- extra map filter buttons
	["deletepinfilter"] = "Lösche HarvestMap Pins",
	["filterheatmap"] = "Heatmap Modus",
	
	-- localization for the farming helper
	["goldperminute"] = "Gold pro Minute:",
	["farmresult"] = "HarvestFarm Ergebnis",
	["farmnotour"] = "HarvestFarm war nicht in der Lage eine gute Tour mit der gegebenen minimalen Tourlänge zu berechnen.",
	["farmerror"] = "HarvestFarm Fehler",
	["farmnoresources"] = "Keine Ressourcen gefunden.\nEs gibt keine Ressourcen auf dieser Karte oder du hast keine Ressourcen ausgewählt.",
	["farminvalidmap"] = "HarvestFarm kann auf dieser Karte nicht verwendet werden.",
	["farmsuccess"] = "HarvestFarm berechnete eine Tour mit <<1>> Erntepunkten pro Kilometer.\n\nKlicke auf einen Pin der Tour, um den Startpunkt festzulegen.",
	["farmdescription"] = "HarvestFarm berechnet eine Tour mit einer sehr hohen Ressourcen-pro-Zeit-Rate.",
	["farmminlength"] = "Minimale Tourlänge",
	["farmminlengthtooltip"] = "Die Länge wird in Kilometern angegeben.",
	["farmminlengthdescription"] = "Je länger die Tour, desto höher die Wahrscheinlichtkeit, dass die Erntepunkte beim nächsten Besuch respawnt sind.\nEine kürzere Tour liefert jedoch eine bessere Ressourcen-pro-Zeit-Rate.",
	["tourpin"] = "Nächstes Ziel deiner Tour",
	["calculatetour"] = "Berechne die Tour",
	["showtourinterface"] = "Zeige Tour Interface",
	["canceltour"] = "Tour Abbrechen",
	["resourcetypes"] = "Ressourcenarten",
	["skiptarget"] = "Überspringe Ziel",
	--["removetarget"] = "Remove current target",
	["nodesperminute"] = "Erntepunkte pro Minute",
	["distancetotarget"] = "Distanz zum Ziel:",
	["showarrow"] = "Zeige Richtung an",
	--["removetour"] = "Remove Tour",
	--["undo"] = "Undo last change",
	--["tourname"] = "Tour name: ",
	--["defaultname"] = "Unnamed tour",
	--["savedtours"] = "Saved tours for this map:",
	--["notourformap"] = "There is no saved tour for this map.",
	--["load"] = "Load",
	--["delete"] = "Delete",
	--["saveexiststitle"] = "Please Confirm",
	--["saveexists"] = "There is already a tour with the name <<1>> for this map. Do you want to overwrite it?",
	--["savenotour"] = "There is no tour that could be saved.",
	--["loaderror"] = "The tour could not be loaded.",
	--["removepintype"] = "Do you want to remove <<1>> from the tour?",
	--["removepintypetitle"] = "Confirm Removal",
	--["minimaponly"] = "Display map pins only on the minimap",
	--["minimaponlytooltip"] = "If enabled, the worldmap will not display any map pins. Works only with Votan's Minimap.",
	
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
	["SI_BINDING_NAME_SKIP_TARGET"] =  "Überspringe Ziel",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "(De-)Aktiviere Pins auf der Karte",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "(De-)Aktiviere 3D Pins",
	--["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "Toggle HarvestMap Pin Menu",
	--["SI_HARVEST_CTRLC"] = "Press CTRL+C to copy the text",
	--["HARVESTFARM_GENERATOR"] = "Generate new tour",
	--["HARVESTFARM_EDITOR"] = "Edit tour",
	--["HARVESTFARM_SAVE"] = "Save/Load tour",
}
