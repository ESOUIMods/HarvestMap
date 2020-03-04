
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
	["minimapcompatibilitymodedescription"] = "Um die Performance bei tausenden von Ressourcen auf der Karte zu verbessern, verwendet HarvestMap seine eigene Variante von Karten-Pinnen. Diese Karten-Pinne since nicht kompatibel mit rotierenden Minimaps.\nFalls du eine rotierende Minimap verwendest, kannst du den 'Minimap Kompatibilitätsmodus' aktivieren. Wenn dieser Modus aktiv ist, verwendet HarvestMap stattdessen die standard Karten-Pinne. Diese standard Karten-Pinne funktionieren mit rotierenden Minimaps, aber sie können in niedrigen FPS und kurzem einfrieren des Spieles resultieren, wann immer eine Karte mit vielen Ressourcen angezeigt wird.",
	["minimapcompatibilitymode"] = "Minimap Kompatibilitätsmodus",
	["minimapcompatibilitymodewarning"] = "Das Aktivieren dieser Option wird die Spielperformance negativ beeinflussen, wenn viele Ressourcen auf der Karte angezeigt werden.\n\nDas User-Interface wird neu geladen, wenn du diese Option änderst!",
	["hasdrawdistance"] = "Zeige nur nahe Pinne",
	["hasdrawdistancetooltip"] = "Falls aktiviert, wird HarvestMap nur Pinne in der Nähe des Spieler anzeigen.\nDiese Einstellung betrifft nur die Karte des Spieles. Auf MiniMaps wird diese Einstellung automatisch aktiviert!",
	["hasdrawdistancewarning"] = "Diese Einstellung betrifft nur die Karte des Spieles. Auf MiniMaps wird diese Einstellung automatisch aktiviert!",
	["drawdistance"] = "Anzeigedistanz",
	["drawdistancetooltip"] = "Die Distanzgrenze für die 'Zeige nur nahe Pinne' Option.",

	-- respawn timer settings
	["farmandrespawn"] = "Respawn-Timer und Farm Hilfe",
	["rangemultiplier"] = "Besuchte Knoten Reichweite",
	["rangemultipliertooltip"] = "Knoten innerhalb von X Metern werden vom Respawn-Timer und der Farm Hilfe als besucht berücksichtigt.",
	["usehiddentime"] = "Verstecke kürzlich besuchte Knoten",
	["usehiddentimetooltip"] = "Pinne werden versteckt, wenn du ihre Position kürzlich besucht hast.",
	["hiddentime"] = "Respawn-Timer",
	["hiddentimetooltip"] = "Vor kurzem besuche Pinne werden für X minuten von der Karte und dem Kompass versteckt. Ist dieser Wert 0, so werden die Pinne niemals versteckt.",
	["hiddentimewarning"] = "Setze diesen Wert auf 0, um die Performanz zu verbessern.",
	["hiddenonharvest"] = "Erntespezifischer Respawn Timer",
	["hiddenonharvesttooltip"] = "Aktiviere diese Einstellung um Pinne nur zu verstecken, wenn du an ihrer Position etwas geerntet hast.\nWenn deaktiviert werden Pinne bereits beim Besuchen versteckt.",

	-- compass and world pin settings
	["compassheader"] = "Kompass Einstellungen",
	["compassandworld"] = "Kompass und 3D Pinne",
	["compass"] = "Aktiviere Kompasspins",
	["compasstooltip"] = "Aktiviere diese Einstellung um nahegelegene Pinne auf dem Kompass anzeigen zu lassen. Deaktivieren kann zu einer Performanceverbesserung führen.",
	["compassdistance"] = "Maximale Pinentfernung",
	["compassdistancetooltip"] = "Die maximale Entfernung von Pinnen in Metern, sodass diese noch immer auf dem Kompass erscheinen.",
	compassspawnfilter = "Zeige nur verfügbare Ressourcen",

	["worldpinsheader"] = "3D Pin Einstellungen",
	["worldpins"] = "Aktiviere 3D Pinne",
	["compasstooltip"] = "Aktiviere diese Einstellung um nahegelegene Pinne in der 3D Welt anzeigen zu lassen. Deaktivieren kann zu einer Performanceverbesserung führen.",
	["worlddistance"] = "Max 3D Pin Distanz",
	["worlddistancetooltip"] = "Die maximale Distanz für 3D Pinne in Metern. Wenn eine Ressource weiter entfernt ist, wird kein 3D Pin angezeigt.",
	["worldpinwidth"] = "3D Pin Breite",
	["worldpinwidthtooltip"] = "Die Breite der 3D Pinne in Zentimetern.",
	["worldpinheight"] = "3D Pin Höhe",
	["worldpinheighttooltip"] = "Die Höhe der 3D Pinne in Zentimetern.",
	["worldpinsdepth"] = "Verwende den Tiefen-Puffer für 3D Pinne",
	["worldpinsdepthtooltip"] = "Wenn deaktiviert, werden die 3D Pinne nicht hinter Objekten versteckt.",
	["worldpinsdepthwarning"] = "Aufgrund eines Fehlers im Spiel funktioniert diese Option nicht, falls eine SubSampling Qualität von Mittel oder Niedrig in den Grafikoptionen ausgewählt ist.",
	worldspawnfilter = "Zeige nur verfügbare Ressourcen",

	-- general pin options
	["pinoptions"] = "Allgemeine Pin Optionen",
	["extendedpinoptions"] = "Normalerweise werden die Pinne auf der Map, dem Kompass und in der 3D Welt synchronisiert. Also wenn du eine bestimmte Art von Ressource auf der Map entfernst, wird diese auch vom Kompass und den Welt-Pinnen entfernt. Dennoch kannst du mit dem Erweiterten Pin Filter Menü die Kompass und Welt-Pins von den Karten Pinnen getrennt einstellen.",
	["extendedpinoptionsbutton"] = "Erweit. Pin Filter öffnen",
	["override"] = "Überschreibe Karten Pin Filter",
	["level"] = "Zeige HarvestMaps Pinne über den anderen Pinnen.",
	["leveltooltip"] = "Falls diese Einstellung aktiviert ist, werden HarvestMaps Pinne nicht von den anderen Pinnen auf der Karte verdeckt.",
	["pinsize"] = "Pingröße",
	["pinsizetooltip"] = "Setze die Größe der Pinne auf der Karte.",
	["pincolor"] = "Pinfarbe",
	["pincolortooltip"] = "Setze die Farbe der Pinne auf der Karte und dem Kompass.",
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
	["pintype6"] = "Schatztruhen Pinne",
	["pintypetooltip6"] = "Zeige Schatztruhen auf der Karte und dem Kompass.",
	["pintype7"] = "Lösungen Pinne",
	["pintypetooltip7"] = "Zeige Lösungen (Alchemie Zutat) auf der Karte und dem Kompass.",
	["pintype8"] = "Fischgründe",
	["pintypetooltip8"] = "Zeige Fischgründe auf der Karte und dem Kompass.",
	["pintype9"] = "Schwere Säcke",
	["pintypetooltip9"] = "Zeige Schwere Säcke auf der Karte und dem Kompass.",
	["pintype10"] = "Diebesgut",
	["pintypetooltip10"] = "Zeige Diebesgut auf der Karte und dem Kompass.",
	["pintype11"] = "Rechtssystem Pinne",
	["pintypetooltip11"] = "Zeige Rechtssystem Pinne (Beutezugziele und Wertkassetten) auf der Karte und dem Kompass.",
	["pintype12"] = "Geheimverstecke",
	["pintypetooltip12"] = "Zeige Geheimverstecke auf der Karte und dem Kompass.",
	["pintype15"] = "Riesenmuscheln",
	["pintypetooltip15"] = "Zeige Riesenmuscheln auf der Karte und dem Kompass.",
	["pintype18"] = "Unbekannter einsammelbarer Knoten",
	["pintypetooltip18"] = "HarvestMap kann nahe Handwerksmaterialien erkennen, aber es kann nicht den Materialtyp erkennen, wenn du nicht wenigstens einmal vorher an dieser Position gewesen bist.",

	-- extra map filter buttons
	["deletepinfilter"] = "Lösche HarvestMap Pinne",
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
	["pinvisibilitymenu"] = "Erweitertes Pin Filter Menü",
	["menu"] = "HarvestMap Menu",
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

	-- SI names to fit with ZOS api
	["SI_BINDING_NAME_SKIP_TARGET"] =  "Überspringe Ziel",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "(De-)Aktiviere Pinne auf der Karte",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "(De-)Aktiviere 3D Pinne",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "(De)Aktiviere Pinne Menü",
	["SI_HARVEST_CTRLC"] = "Drücke STRG+C um Text zu kopieren",
	["HARVESTFARM_GENERATOR"] = "Generiere neue Tour",
	["HARVESTFARM_EDITOR"] = "Ändere Tour",
	["HARVESTFARM_SAVE"] = "Sicher/Lade Tour",

	["notifications"] = "Benachrichtigungen und Warnungen",
	["notificationstooltip"] = "Zeigt Benachrichtigungen und Warnungen an der oberen rechten Bildschirmecke an.",
	["mapheader"] = "Map Pin Einstellungen",
	["mappins"] = "Aktiviere Pinne auf der Karte",
	["mappinstooltip"] = "Aktiviert die Anzeige von Pinne auf der Karte. Deaktiviere diese Option, um die Performance zu verbessern.",
	["minimappins"] = "Aktiviere Pinne auf der MiniMap",
	["minimappinstooltip"] = [[Aktiviert die Anzeige von Pinnen auf der MiniMap, wenn du ein MiniMap AddOn installiert hast. Deaktiviere diese Option, um die Performance zu verbessern.
Unterstütze MiniMap AddOns: Votan, Fyrakin und AUI]],
	mapspawnfilter = "Zeige nur verfügbare Ressourcen auf der Karte.",
	minimapspawnfilter = "Zeige nur verfügbare Ressourcen auf der MiniMap",
	spawnfiltertooltip = [[Ist diese Option aktiviert, so wird HarvestMap die Pinne verstecken dessen Ressourcen noch nicht wiederw verfügbar sind.
Wenn z.B. ein anderer Spieler diese Ressource eingesammelt hat, dann wird dieser Pin versteckt, bis die Ressouce dort wieder verfügbar ist.
Diese Option funktioniert nur für einsammelbare Handwerksmaterialien! Sie funktioniert nicht für Behälter, Kisten oder Schwere Säcke!.
Dies funktioniert nicht wenn ein anderes AddOn den Kompass versteckt oder in der größe verändert.]],
	["pinminsize"] = "Minimale Krten Pin Größe",
	["pinminsizetooltip"] = "Wenn du aus der Karte heraus-zoomst werden die Pinne ebenfalls kleiner werden. Du kannst diese Option nutzen, um eine minimal größe der Pinne einzustellen. Kleine Werte verhindern, dass die Karten Inhalte hinter den Pinnen versteckt werden können, aber die Pinne können dadurch natürlich schwierig zu erkennen sein.",

	--Harvestmap menu (enhanced pin filters)
	["3dPins"] = "3D Pinne",
	["CompassPins"] = "Kompass Pinne",
}
