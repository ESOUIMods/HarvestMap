
Harvest.localizedStrings = {
	-- top level description
	["esouidescription"] = "Eine Addon Beschreibung sowie die FAQ befinden sich auf esoui.com",
	["openesoui"] = "Öffne ESOUI",
	["exchangedescription2"] = "You can download the most recent HarvestMap data (positions of resources) by installing the HarvestMap-Data add-on. For more information, see the addon description on ESOUI.",
	["exchangedescription"] = "Du kannst die aktuellsten HarvestMap-Daten (Positionen der Ressourcen) herunterladen, indem du das 'HarvestMap-Data' installierst. Mehr Informationen dazu findest du in der Addon-Beschreibung auf ESOUI.",
	
	["notifications"] = "Benachrichtigungen und Warnungen",
	["notificationstooltip"] = "Zeigt Benachrichtigungen und Warnungen an der oberen rechten Bildschirmecke an.",
	["moduleerrorload"] = "Das Addon <<1>> ist deaktiviert.\nKeine Daten verfügbar für die diese Gegend.",
	["moduleerrorsave"] = "Das Addon <<1>> ist deaktiviert.\nDie aktuelle Position konnte nicht gespeichert werden.",
	
	-- outdated data settings
	["outdateddata"] = "Veraltete Daten Optionen",
	["outdateddatainfo"] = "Diese Optionen werden mit allen Accounts und Figuren auf diesem Computer geteilt.",
	["timedifference"] = "Verwerfe veraltete Daten",
	["timedifferencetooltip"] = "HarvestMap verwirft Daten älter als X Tage.\nSetze diesen Wert auf 0, um alle Daten zu behalten - egal wie alt sie sind.",
	["applywarning"] = "Einmal gelöschte Daten können nicht wiederhergestellt werden!",

	-- account wide settings
	["account"] = "Accountweite Einstellungen",
	["accounttooltip"] = "Alle Einstellungen unterhalb sind dieselben für alle deine Figuren.",
	["accountwarning"] = "Wenn diese Einstellung geändert wird, wird das Interface neu geladen und es kommt zu einem Ladebildschirm.",

	-- map pin settings
	["mapheader"] = "Map Pin Einstellungen",
	["mappins"] = "Aktiviere Pinne auf der Karte",
	["minimappins"] = "Aktiviere Pinne auf der MiniMap",
	["minimappinstooltip"] = [[Unterstütze MiniMap AddOns: Votan, Fyrakin und AUI]],
	["level"] = "Zeige HarvestMaps Pinne über den anderen Pinnen.",
	["hasdrawdistance"] = "Zeige nur nahe Pinne",
	["hasdrawdistancetooltip"] = "Falls aktiviert, wird HarvestMap nur Pinne in der Nähe des Spieler anzeigen.\nDiese Einstellung betrifft nur die Karte des Spieles. Auf MiniMaps wird diese Einstellung automatisch aktiviert!",
	["hasdrawdistancewarning"] = "Diese Einstellung betrifft nur die Karte des Spieles. Auf MiniMaps wird diese Einstellung automatisch aktiviert!",
	["drawdistance"] = "Anzeigedistanz",
	["drawdistancetooltip"] = "Die Distanzgrenze für die 'Zeige nur nahe Pinne' Option.",
	["drawdistancewarning"] = "Diese Option beinflusst ebenfalls MiniMaps!",
	
	visiblepintypes = "Angezeigte Pinarten",
	custom_profile = "Custom",
	same_as_map = "Gleich wie auf der Karte",
	
	-- compass settings
	["compassheader"] = "Kompass Einstellungen",
	["compass"] = "Aktiviere Kompasspins",
	["compassdistance"] = "Maximale Pinentfernung",
	["compassdistancetooltip"] = "Die maximale Entfernung von Pinnen in Metern, sodass diese noch immer auf dem Kompass erscheinen.",
	
	-- 3d pin settings
	["worldpinsheader"] = "3D Pin Einstellungen",
	["worldpins"] = "Aktiviere 3D Pinne",
	["worlddistance"] = "Max 3D Pin Distanz",
	["worlddistancetooltip"] = "Die maximale Distanz für 3D Pinne in Metern. Wenn eine Ressource weiter entfernt ist, wird kein 3D Pin angezeigt.",
	["worldpinwidth"] = "3D Pin Breite",
	["worldpinwidthtooltip"] = "Die Breite der 3D Pinne in Zentimetern.",
	["worldpinheight"] = "3D Pin Höhe",
	["worldpinheighttooltip"] = "Die Höhe der 3D Pinne in Zentimetern.",
	["worldpinsdepth"] = "Verwende den Tiefen-Puffer für 3D Pinne",
	["worldpinsdepthtooltip"] = "Wenn deaktiviert, werden die 3D Pinne nicht hinter Objekten versteckt.",
	["worldpinsdepthwarning"] = "Aufgrund eines Fehlers im Spiel funktioniert diese Option nicht, falls eine SubSampling Qualität von Mittel oder Niedrig in den Grafikoptionen ausgewählt ist.",
	
	-- respawn timer settings
	["visitednodes"] = "Besuchte Knoten und Farm Hilfe",
	["rangemultiplier"] = "Besuchte Knoten Reichweite",
	["rangemultipliertooltip"] = "Knoten innerhalb von X Metern werden vom Respawn-Timer und der Farm Hilfe als besucht berücksichtigt.",
	["usehiddentime"] = "Verstecke kürzlich besuchte Knoten",
	["usehiddentimetooltip"] = "Pinne werden versteckt, wenn du ihre Position kürzlich besucht hast.",
	["hiddentime"] = "Respawn-Timer",
	["hiddentimetooltip"] = "Vor kurzem besuche Pinne werden für X minuten von der Karte und dem Kompass versteckt. Ist dieser Wert 0, so werden die Pinne niemals versteckt.",
	["hiddenonharvest"] = "Erntespezifischer Respawn Timer",
	["hiddenonharvesttooltip"] = "Aktiviere diese Einstellung um Pinne nur zu verstecken, wenn du an ihrer Position etwas geerntet hast.\nWenn deaktiviert werden Pinne bereits beim Besuchen versteckt.",

	-- spawn filter
	spawnfilter = "Verfügbare Resourcen-Filter",
	nodedetectionmissing = "Diese Einstellungen sind nur verfügbar, wenn die 'NodeDetection' Bibliothek/Addon aktiviert ist.",
	spawnfilterdescription = [[Falls aktiviert, wird HarvestMap Pinne verstecken, wenn diese noch nicht verfügbar sind.
Zum Beispiel, wenn eine andere Person eine Ressource bereits eingesammelt hat, wird kein Pin dort angezeigt, bis die Ressource wieder verfügbar ist.
Dieser Filter funktioniert nur für Handwerksmaterialien und nicht für Behälter wie Schwatztruhen, Schwere Säcke, oder Psijik Portale.
Dieser Filter funktioniert nicht, sofern ein anderes Addon den Kompass versteckt oder skaliert.]],
	spawnfilter_map = "Aktiviere Filter auf der Karte",
	spawnfilter_minimap = "Aktiviere Filter auf der Minimap",
	spawnfilter_compass = "Aktivierte Filter auf dem Kompass",
	spawnfilter_world = "Aktiviere Filter für 3D Pinne",
	spawnfilter_pintype = "Verwende Filter für Pinarten:",
	
	-- pin type options
	["pinoptions"] = "Allgemeine Pin Optionen",
	["pinsize"] = "Pingröße",
	["pinsizetooltip"] = "Setze die Größe der Pinne auf der Karte.",
	["pincolor"] = "Pinfarbe",
	["pincolortooltip"] = "Setze die Farbe der Pinne auf der Karte und dem Kompass.",
	["savepin"] = "Speichere Fundorte",
	["savetooltip"] = "Aktiviere diese Einstellung, um die Position dieser Ressource zu speichern, wenn du sie findest.",
	["pintexture"] = "Icon",
	
	-- pin type names
	["pintype1"] = "Schmied und Schmuck",
	["pintype2"] = "Faserige Pflanzen",
	["pintype3"] = "Runen and Psijik Portale",
	["pintype4"] = "Pilze",
	["pintype13"] = "Kräuter/Blumen",
	["pintype14"] = "Wasserkräuter",
	["pintype5"] = "Holz",
	["pintype6"] = "Schatztruhen",
	["pintype7"] = "Lösungen",
	["pintype8"] = "Fischgründe",
	["pintype9"] = "Schwere Säcke",
	["pintype10"] = "Diebesgut",
	["pintype11"] = "Rechtssystem",
	["pintype12"] = "Geheimverstecke",
	["pintype15"] = "Riesenmuscheln",
	-- pin type 16, 17 used to be jewlry and psijic portals 
	-- but the locations are the same as smithing and runes
	["pintype18"] = "Unbekannte Ressource",
	["pintype19"] = "Purpurnes Nirnwurz",
	
	-- extra map filter buttons
	["deletepinfilter"] = "Lösche HarvestMap Pinne",
	["filterheatmap"] = "Heatmap Modus",
	
	-- localization for the farming helper
	["goldperminute"] = "Gold pro Minute:",
	["farmresult"] = "HarvestFarm Ergebnis",
	["farmnotour"] = "HarvestFarm war nicht in der Lage eine gute Tour mit der gegebenen minimalen Tourlänge zu berechnen.",
	["farmerror"] = "HarvestFarm Fehler",
	["farmnoresources"] = "Keine Ressourcen gefunden.\nEs gibt keine Ressourcen auf dieser Karte oder du hast keine Ressourcen ausgewählt.",
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
	["removetarget"] = "Lösche aktuelles Ziel",
	["nodesperminute"] = "Erntepunkte pro Minute",
	["distancetotarget"] = "Distanz zum Ziel:",
	["showarrow"] = "Zeige Richtung an",
	["reverttour"] = "Tour Richtung umdrehen",
	["removetour"] = "Lösche Tour",
	["undo"] = "Letzte Änderung zurücknehmen",
	["tourname"] = "Tour Name: ",
	["defaultname"] = "Unbenannte Tour",
	["savedtours"] = "Gespeicherte Touren dieser Karte:",
	["notourformap"] = "Es existiert keine Tour für diese Karte.",
	["load"] = "Laden",
	["delete"] = "Löschen",
	["saveexiststitle"] = "Bitte bestätigen",
	["saveexists"] = "Es existiert bereits eine Tour mit Name <<1>> auf dieser Karte. Überschreiben?",
	["savenotour"] = "Keine Tour zum Speichern gewählt.",
	["loaderror"] = "Die Tour konnte nicht geladen werden.",
	["removepintype"] = "Willst du <<1>> aus der Tour entfernen?",
	["removepintypetitle"] = "Bestätige Entfernen",
	["minimaponly"] = "Karten Pins nur auf der MiniMap",
	["minimaponlytooltip"] = "Wenn aktiviert, wird die Karte keine Pins anzeigen. Nur die MiniMap zeigt diese an.\nFunktioniert nur mit Votan's MiniMap!",
	
	-- extra harvestmap menu
	["farmmenu"] = "Farm Tour Editor",
	["editordescription"] = [[Hier kannst du Touren erstellen/ändern.
Wenn aktuell keine Tour aktiv ist kannst du eine erstellen, indem du auf einen Pin auf der Map klickst.
Ist eine Tour aktiv, so kannst du Unter-Sektionen veränderst:
- Klicke auf einen Pin der (roten) Tour.
- Dann klicke auf Pins, welche du der Tour hinzufügen möchtest (grüne Tour wird angezeigt).
- Zuletzt klicke auf einen Pin in deiner roten Tour.
Die grüne wird nun in die rote Tour eingefügt.]],
	["editorstats"] = [[Anzahl Knoten: <<1>>
Länge: <<2>> m
Knoten pro KM: <<3>>]],
	
	-- filter profiles
	filterprofilebutton = "Öffne Filterprofilmenü",
	filtertitle = "Filterprofilmenü",
	filtermap = "Filterprofil für Kartenpinne",
	filtercompass = "Filterprofil für Kompasspinne",
	filterworld = "Filterprofil für 3D Pinne",
	unnamedfilterprofile = "Unnamed Profile",
	defaultprofilename = "Default Filter Profile",
	
	-- SI names to fit with ZOS api
	["SI_BINDING_NAME_SKIP_TARGET"] =  "Überspringe Ziel",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "(De-)Aktiviere Pinne auf der Karte",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "(De-)Aktiviere 3D Pinne",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "Öffne HarvestMap Tour-Editor",
	["SI_BINDING_NAME_HARVEST_SHOW_FILTER"] = "Open HarvestMap Filterprofilmenü",
	["HARVESTFARM_GENERATOR"] = "Generiere neue Tour",
	["HARVESTFARM_EDITOR"] = "Ändere Tour",
	["HARVESTFARM_SAVE"] = "Sicher/Lade Tour",
}

local interactableName2PinTypeId = {
	["schwerer sack"] = Harvest.HEAVYSACK,
	-- special nodes in cold harbor with the same loot as heavy sacks
	["schwere Kiste"] = Harvest.HEAVYSACK,
	["Diebesgut"] = Harvest.TROVE,
	["Lose Tafel"] = Harvest.STASH,
	["Lose Platte"] = Harvest.STASH,
	["Loser Stein"] = Harvest.STASH,
	["Psijik-Portal"] = Harvest.PSIJIC,
	["riesenmuschel"] = Harvest.CLAM,
}
-- convert to lower case. zos sometimes changes capitalization so it's safer to just do all the logic in lower case
Harvest.interactableName2PinTypeId = Harvest.interactableName2PinTypeId or {}
local globalList = Harvest.interactableName2PinTypeId
for name, pinTypeId in pairs(interactableName2PinTypeId) do
	globalList[zo_strlower(name)] = pinTypeId
end