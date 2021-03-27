
Harvest.localizedStrings = {
	-- conflict message for settings that don't work with Fyrakin's minimap
	["minimapconflict"] = "Questa impostazione è incompatibile con la mini mappa di Fyrakin.",
	-- top level description
	["esouidescription"] = "Per una descrizione dell'estensione e una FAQ, visitate la sua pagina su esoui.com",
	["openesoui"] = "Apri ESOUI",
	["exchangedescription"] = "Puoi scaricare gli ultimi dati di HarvestMap (posizione delle risorse) eseguendo nella cartella di HarvestMap 'DownloadNewData.command' (MacOS) o 'DownloadNewData.bat' (Windows).",
	["feedback"] = "Commento",
	["feedbackdescription"] = "Se hai trovato un bug, hai una richiesta o un suggerimento, o semplicemente desideri donare, invia una mail.\nPuoi anche lasciare un commento e delle segnalazioni di bug nella sezione dei commenti di HarvestMap su esoui.com.",
	["sendgold"] = "Invia <<1>> monete d'oro",
	["debuginfodescription"] = "Se vuoi segnalare un bug sulla pagina dei commenti di esoui.com, aggiungi anche le seguenti informazioni di debug:",
	["printdebuginfo"] = "Copia Informazioni di Debug",
	
	["notifications"] = "Notifiche e Avvisi",
	["notificationstooltip"] = "Visualizza le notifiche e gli avvisi nell'angolo in alto a destra dello schermo.",
	["moduleerrorload"] = "<<1>> è disabilitato.\nNessun dato disponibile per questa zona.",
	["moduleerrorsave"] = "<<1>> è disabilitato.\nLa posizione del punto di raccolta non è stata salvata.",
	
	-- outdated data settings
	["outdateddata"] = "Impostazione Dati Obsoleta",
	["outdateddatainfo"] = "Queste impostazioni sono condivise tra tutti i personaggi dell'account.",
	["mingameversion"] = "Versione minima del gioco",
	["mingameversiontooltip"] = "Determina la versione del gioco usata HarvestMap per visualizzare gli indicatori delle risorse.",
	["timedifference"] = "Utilizza solo Dati Recenti",
	["timedifferencetooltip"] = "Determina il numero massimo di giorni oltre i quali i dati non verranno più utilizzati.\nImpedisce la visualizzazione di dati che potrebbero essere troppo vecchi.\nImpostare a 0 per mantenere i dati permanenti.",
	["applywarning"] = "I dati più vecchi non potranno essere ripristinati una volta cancellati!",
	
	-- account wide settings
	["account"] = "Applica le Impostazioni su tutto l'Account",
	["accounttooltip"] = "Le impostazioni saranno le stesse per tutti i tuoi personaggi.",
	["accountwarning"] = "Cambiando questa impostazione, l'interfaccia verrà ricaricata.",
	
	-- map pin settings
	["mapheader"] = "Impostazioni Indicatori Mappa",
	["mappins"] = "Abilita gli indicatori sulla mappa principale",
	["mappinstooltip"] = "Abilita la visualizzazione degli indicatori sulla mappa principale. Può essere disabilitato per aumentare le prestazioni.",
	["minimappins"] = "Abilita gli indicatori sulla mini mappa",
	["minimappinstooltip"] = [[Abilita la visualizzazione degli indicatori sulla mini mappa, se hai un addon per la mini mappa installato. Può essere disabilitato per aumentare le prestazioni.
	Mini mappe supportate: Votan, Fyrakin e AUI]],
	mapspawnfilter = "Mostra solo le risorse rigenerate sulla mappa",
	minimapspawnfilter = "Mostra solo le risorse rigenerate sulla mini mappa",
	spawnfiltertooltip = [[Quando è abilitato, HarvestMap nasconderà gli indicatori per le risorse che non sono ancora state rigenerate.
Per esempio, se un altro giocatore ha già raccolto la risorsa, allora l'indicatore sarà nascosto fino a quando la risorsa non sarà di nuovo disponibile.
Questa impostazione funziona solo per il materiale per l'artigianato, non funziona per contenitori come casse o sacchi pesanti.
Non funziona se un altro addon nasconde o ridimensiona la bussola.]],
	nodedetectionmissing = "Questa impostazione può essere abilitata solo se la libreria 'NodeDetection' è abilitata.",
	spawnfilterwarning = "Non funziona se un altro addon nasconde o ridimensiona la bussola.",
	--["minimaponly"] = "Display pins only on the minimap",
	--["minimaponlytooltip"] = "When this option is enabled, there will be no pins on the default map. The pins will only be displayed on the minimap.",
	["level"] = "Mostra gli indicatori della mappa sopra gli indicatori POI",
	["leveltooltip"] = "Visualizza gli indicatori di HarvestMap sopra gli indicatori POI della mappa.",
	["hasdrawdistance"] = "Visualizza solo gli indicatori vicini",
	["hasdrawdistancetooltip"] = "Quando è abilitata, HarvestMap creerà solo gli indicatori per i punti di raccolta vicino al giocatore.\nQuesta impostazione ha effetto solo sulla mappa di gioco. Sulla mini mappa questa impostazione è automaticamente abilitata!",
	["hasdrawdistancewarning"] = "Questa impostazione ha effetto solo sulla mappa in gioco. Sulla mini mappa questa impostazione è automaticamente abilitata!",
	["drawdistance"] = "Distanza Indicatori Mappa",
	["drawdistancetooltip"] = "Determina la soglia della distanza per la visualizzazione degli indicatori disegnati sulla mappa. Questa impostazione influisce anche sulla mini mappa!",
	["drawdistancewarning"] = "Questa impostazione influisce anche sulla mini mappa!",
	["rotatingcompatibility"] = "Compatibilità Rotazione della Mini Mappa",
	["minimapcompatibilitymodedescription"] = "Per migliorare le prestazioni quando si visualizzano migliaia di punti di raccolta sulla mappa, HarvestMap crea la sua variante leggera degli indicatori. Questi indicatori leggeri non sono compatibili con la rotazione della mini mappa.\nSe usi una mini mappa con la rotazione, puoi abilitare la 'Modalità Compatibile Mini Mappa'. Quando questa modalità è abilitata, HarvestMap userà gli indicatori predefiniti invece di quelli leggeri. Questi indicatori predefiniti funzioneranno con la rotazione della mini mappa, ma potranno causare un calo di FPS e il gioco potrebbe bloccarsi per diversi secondi, ogni volta che viene visualizzata una mappa con molti punti di raccolta conosciuti.",
	["minimapcompatibilitymode"] = "Modalità Compatibile Mini Mappa",
	["minimapcompatibilitymodewarning"] = "Abilitare questa impostazione avrà un impatto negativo sulle prestazioni del gioco, quando verranno visualizzati molti indicatori sulla mappa.\n\nCambiare l'impostazione ricaricherà l'UI!",
	
	-- compass settings
	["compassheader"] = "Impostazioni Bussola",
	["compass"] = "Abilita nella Bussola",
	["compasstooltip"] = "Abilita la visualizzazione sulla bussola degli indicatori vicini. Può essere disabilitata per aumentare le prestazioni.",
	compassspawnfilter = "Mostra solo le risorse rigenerate",
	["compassdistance"] = "Distanza Massima degli Indicatori",
	["compassdistancetooltip"] = "Determina la distanza massima in metri oltre la quale i punti di raccolta non vengono più visualizzati sulla bussola.",
	
	-- 3d pin settings
	["worldpinsheader"] = "Impostazioni Indicatori 3D",
	["worldpins"] = "Abilita Indicatori 3D",
	["worldpinstooltip"] = "Permette alle risorse vicine al personaggio di apparire nel mondo usando un indicatore 3D. Disabilita questa impostazione per migliorare le prestazioni.",
	worldspawnfilter = "Mostra solo le risorse rigenerate",
	["worlddistance"] = "Distanza Massima Indicatori 3D",
	["worlddistancetooltip"] = "Determina la distanza massima in metri per la visualizzazione degli indicatori in tre dimensioni. Se un indicatore è oltre questa distanza, non sarà visualizzato.",
	["worldpinwidth"] = "Larghezza Indicatori 3D",
	["worldpinwidthtooltip"] = "Determina la larghezza in centimetri degli indicatori 3D.",
	["worldpinheight"] = "Altezza Indicatori 3D",
	["worldpinheighttooltip"] = "Determina l'altezza in centimetri degli indicatori 3D.",
	["worldpinsdepth"] = "Utilizza il Buffer di profindità per gli indicatori 3D",
	["worldpinsdepthtooltip"] = "Permette di nascondere gli indicatori 3D dietro altri oggetti.",
	["worldpinswarning"] = "Questa funzione è ancora in fase di sviluppo e non è ottimizzata. Attenzione ai bug.",
	
	
	-- respawn timer settings
	["farmandrespawn"] = "Timer di Rigenerazione e Aiuto Raccolta",
	["rangemultiplier"] = "Distanza Punto di Raccolta Visitato",
	["rangemultipliertooltip"] = "Determina il raggio in metri al di sotto del quale i punti di raccolta sono considerati visitati dal timer di rigenerazione e dall'aiuto raccolta.",
	["usehiddentime"] = "Nascondi i punti di raccolta visitati di recente",
	["usehiddentimetooltip"] = "Gli indicatori saranno nascosti se hai visitato la loro posizione di recente.",
	["hiddentime"] = "Durata (Timer di Rigenerazione)",
	["hiddentimetooltip"] = "I punti di raccolta visitati di recente saranno nascosti per X minuti.",
	["hiddenonharvestwarning"] = "Disattivare questa impostazione potrebbe avere un impatto negativo sulle prestazioni del gioco.",
	["hiddenonharvest"] = "Nascondi i punti solo dopo la raccolta",
	["hiddenonharvesttooltip"] = "Abilita per nascondere gli indicatori solo dopo che li hai raccolti. Se è disabilitato gli indicatori saranno nascosti dopo averli visiti.",
	
	
	-- pin type options
	["pinoptions"] = "Imposta Tipo Indicatori",
	["pinsize"] = "Dimensione Indicatori",
	["pinsizetooltip"] = "Imposta la dimensione degli indicatori sulla mappa.",
	["pinminsize"] = "Dimensione Minima Indicatori Mappa",
	["pinminsizetooltip"] = "Quando si riduce lo zoom sulla mappa, anche gli indicatori diventano più piccoli. Puoi usare questa impostazione per fornire la dimensione minima degli indicatori. Usando valori piccoli si evita che zone della mappa vengano nascosti dietro gli indicatori, ma potrebbero diventare più difficili da vedere.",
	["extendedpinoptions"] = "Di solito gli indicatori sulla mappa, sulla bussola e nel mondo 3d sono sincronizzati. Quindi se si nasconde un certo tipo di risorsa sulla mappa, verranno rimossi anche gli indicatori della bussola e nel mondo. Tuttavia, nel menu filtro avanzato degli indicatori è possibile impostare gli indicatori della bussola e nel mondo per essere indipendenti da quelli della mappa.",
	["extendedpinoptionsbutton"] = "Apri Filtro Avanzato degli Indicatori",
	["override"] = "Sovrascrivere filtro indicatori",
	
	["pincolor"] = "Colore Indicatori",
	["pincolortooltip"] = "Imposta il colore degli indicatori sulla mappa e sulla bussola.",
	["savepin"] = "Salva Posizioni",
	["savetooltip"] = "Abilita per salvare le posizioni di questa risorsa quando le scopri.",
	["pintexture"] = "Icone Indicatori",
	
	-- debug output setting
	["debugoptions"] = "Debug",
	["debug"] = "Mostra i messaggi di debug.",
	["debugtooltip"] = "Abilita la visualizzazione dei messaggi di debug nella chat.",
	
	-- pin type names
	["pintype1"] = "Forgiatura e Gioielleria",
	["pintypetooltip1"] = "Visualizza i minerali e le polveri sulla mappa e sulla bussola.",
	["pintype2"] = "Sartoria",
	["pintypetooltip2"] = "Visualizza i materiali per la sartoria sulla mappa e sulla bussola.",
	["pintype3"] = "Rune e Portali Pjijic",
	["pintypetooltip3"] = "Visualizza le rune e i portali Psijic sulla mappa e sulla bussola.",
	["pintype4"] = "Funghi",
	["pintypetooltip4"] = "Visualizza i funghi sulla mappa e sulla bussola.",
	["pintype13"] = "Erbe/Fiori",
	["pintypetooltip13"] = "Mostra erbe e fiori sulla mappa e sulla bussola.",
	["pintype14"] = "Piante Acquatiche",
	["pintypetooltip14"] = "Visualizza le piante acquatiche sulla mappa e sulla bussola.",
	["pintype5"] = "Falegnameria",
	["pintypetooltip5"] = "Visualizza il legno sulla mappa e sulla bussola.",
	["pintype6"] = "Forzieri",
	["pintypetooltip6"] = "Visualizza i forzieri sulla mappa e sulla bussola.",
	["pintype7"] = "Solventi",
	["pintypetooltip7"] = "Visualizza i solventi sulla mappa e sulla bussola.",
	["pintype8"] = "Luoghi di Pesca",
	["pintypetooltip8"] = "Visualizza i luoghi di pesca sulla mappa e sulla bussola.",
	["pintype9"] = "Sacche Pesanti",
	["pintypetooltip9"] = "Visualizza le sacche pesanti sulla mappa e sulla bussola.",
	["pintype10"] = "Tesori dei Ladri",
	["pintypetooltip10"] = "Mostra i tesori dei ladri sulla mappa e sulla bussola.",
	["pintype11"] = "Sistema Legale",
	["pintypetooltip11"] = "Mostra i Forziere della Giustizia come Cassette di Sicurezza o obiettivi di Furto sulla mappa e sulla bussola",
	["pintype12"] = "Nascondigli Segreti",
	["pintypetooltip12"] = "Mostra i Nascondigli Segreti.",
	["pintype15"] = "Vongole Giganti",
	["pintypetooltip15"] = "Visualizza le vongole giganti sulla mappa e sulla bussola.",
	
	["pintype18"] = "Punti di Raccolta Sconosciuti",
	["pintypetooltip18"] = "HarvestMap può rilevare il materiale per l'artigianato nelle vicinanze, ma non può rilevare il tipo di materiale, a meno che tu non abbia già scoperto la sua posizione.",
	
	["pintype19"] = "Radice di Nirn Cremisi",
	["pintypetooltip19"] = "Visualizza le radici di nirn cremisi sulla mappa e sulla bussola.",
	
	-- extra map filter buttons
	["deletepinfilter"] = "Rimuovi Indicatori HarvestMap",
	["filterheatmap"] = "Modalità Mappa Termica",
	
	-- localization for the farming helper
	["goldperminute"] = "Oro Al Minuto:",
	["farmresult"] = "Risultato HarvestFarm",
	["farmnotour"] = "HarvestFarm non è stato in grado di calcolare un buon percorso di raccolta con le dimensioni minime attualmente stabilite.",
	["farmerror"] = "Errore HarvestFarm",
	["farmnoresources"] = "Nessuna risorsa trovata.\nNon ci sono risorse su questa mappa o hai dimenticato di selezionarne qualcuna.",
	["farminvalidmap"] = "HarvestFarm non può essere utilizzato su questa mappa.",
	["farmsuccess"] = "HarvestFarm ha calcolato un percorso con <<1>> punti di raccolta per chilometro.\n\nClicca su uno degli indicatori del percorso per impostare il punto di partenza.",
	["farmdescription"] = "Questo menù permette di generare un percorso con un alto rapporto risorse/tempo.\nDopo la generazione del percorso, clicca su una delle risorse presenti sul percorso per definire il punto di partenza.",
	["farmminlength"] = "Lunghezza del percorso",
	["farmminlengthtooltip"] = "Determina la lunghezza minima del percorso in chilometri.",
	["farmminlengthdescription"] = "Più lungo è il percorso, maggiore è la probabilità che le risorse siano ricomparse dopo averlo completato.\nTuttavia, un percorso più breve avrà un miglior rapporto risorse/tempo.",
	["tourpin"] = "Prossimo obiettivo del tuo percorso",
	["calculatetour"] = "Calcola Percorso",
	["showtourinterface"] = "Mostra Interfaccia Percorso",
	["canceltour"] = "Cancella Percorso",
	["reverttour"] = "Inverti Direzione Percorso",
	["resourcetypes"] = "Tipo di Risorse",
	["skiptarget"] = "Salta l'obiettivo corrente",
	["removetarget"] = "Rimuovi l'obiettivo corrente",
	["nodesperminute"] = "Punti di Raccolta al minuto",
	["distancetotarget"] = "Distanza dalla Prossima Risorsa",
	["showarrow"] = "Mostra Direzione",
	["removetour"] = "Rimuovi Percorso",
	["undo"] = "Annulla l'ultima modifica",
	["tourname"] = "Nome Percorso: ",
	["defaultname"] = "Percorso senza nome",
	["savedtours"] = "Percorsi salvati per questa mappa:",
	["notourformap"] = "Non ci sono percorsi salvati per questa mappa.",
	["load"] = "Carica",
	["delete"] = "Elimina",
	["saveexiststitle"] = "Si prega di Confermare",
	["saveexists"] = "C'è già un percorso con il nome <<1>> per questa mappa. Vuoi sovrascriverlo?",
	["savenotour"] = "Non c'è nessun percorso che possa essere salvato.",
	["loaderror"] = "Il percorso non può essere caricato.",
	["removepintype"] = "Vuoi rimuovere <<1>> dal percorso?",
	["removepintypetitle"] = "Confermare rimozione",
	
	-- extra harvestmap menu
	["pinvisibilitymenu"] = "Menù Filtro Avanzato degli Indicatori",
	["menu"] = "Menù HarvestMap",
	["farmmenu"] = "Crea Percorso Raccolta",
	["editordescription"] = [[In questo menù puoi creare e modificare i percorsi.
Se al momento non c'è nessun altro percorso attivo, puoi creare un percorso cliccando sugli indicatori della mappa.
Se c'è un percorso attivo, puoi modificare il percorso sostituendo le sottosezioni:
- Prima clicca su un indicatore del tuo percorso (rosso).
- Poi, clicca sull'indicatore che vuoi aggiungere. (Apparirà un percorso verde)
- Infine, clicchi di nuovo su un indicatore del tuo percorso rosso.
Il percorso verde sarà ora inserito nel percorso rosso.]],
	["editorstats"] = [[Numero di punti di raccolta: <<1>>
Lunghezza: <<2>> m
Punti di raccolta per chilometro: <<3>>]],
	
	-- SI names to fit with ZOS api
	["SI_BINDING_NAME_SKIP_TARGET"] = "Salta Obiettivo",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "Attiva/Disattiva Indicatori 3D",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "Attiva/Disattiva Indicatori Mappa",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "Attiva/Disattiva Menù Indicatori di HarvestMap",
	["SI_HARVEST_CTRLC"] = "Premi CTRL+C per copiare il testo",
	["HARVESTFARM_GENERATOR"] = "Genera nuovo percorso",
	["HARVESTFARM_EDITOR"] = "Modifica percorso",
	["HARVESTFARM_SAVE"] = "Salva/Carica percorso",
	
	--Harvestmap menu (enhanced pin filters)
	["3dPins"] = "Indicatori 3D",
	["CompassPins"] = "Indicatori Bussola",
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
