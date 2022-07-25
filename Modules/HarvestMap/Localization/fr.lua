
Harvest.localizedStrings = {
	-- description du haut
	["esouidescription"] = "Pour lire la description et la FAQ de cet addon, visitez sa page sur esoui.com",
	["openesoui"] = "Ouvrir ESOUI",
	["exchangedescription2"] = "Vous pouvez télécharger les données d'HarvestMap les plus récentes (positions des ressources) en installant le module complémentaire HarvestMap-Data. Pour plus d'informations, consultez la description de l'addon sur ESOUI.",

	["notifications"] = "Notifications et avertissements",
	["notificationstooltip"] = "Affiche les notifications et les avertissements en haut à droite de l'écran.",
	["moduleerrorload"] = "L'addon <<1>> est désactivé.\nAucune donnée disponible pour cette zone.",
	["moduleerrorsave"] = "L'addon <<1>> est désactivé.\nL'emplacement du nœud n'a pas été enregistré.",

	-- paramètres des données obsolètes
	["outdateddata"] = "Paramètres des données obsolètes",
	["outdateddatainfo"] = "Ces paramètres liés aux données sont partagés entre tous les comptes et personnages de cet ordinateur.",
	["timedifference"] = "Durée d'utilisation des données",
	["timedifferencetooltip"] = "Détermine le nombre de jours maximums au-delà duquel l'addon n'utilise plus les données.\nCela permet d'éviter l'affichage de données qui peuvent être obsolètes.\nDéfinir sur 0 pour garder les données indéfiniment.",
	["applywarning"] = "Les données les plus anciennes ne pourront pas être restaurées une fois effacées !",

	-- paramètres communs au compte
	["account"] = "Paramètres communs au compte",
	["accounttooltip"] = "Tous les paramètres ci-dessous seront les mêmes pour tous les personnages.",
	["accountwarning"] = "Modifier ce paramètre provoquera un rechargement de l'interface utilisateur.",

	-- Paramètres d'icône de carte
	["mapheader"] = "Paramètres d'icône de carte",
	["mappins"] = "Afficher les icônes sur la carte principale",
	["minimappins"] = "Afficher les icônes sur la mini-carte",
	["minimappinstooltip"] = "Mini-cartes supportées : Votan, Fyrakin et AUI.",
	["level"] = "Superposition des icônes de carte.",
	["leveltooltip"] = "Détermine si les icônes de carte doivent être affichées devant les icônes de Points d'Intérêt.",
	["hasdrawdistance"] = "Seulement les icônes proches",
	["hasdrawdistancetooltip"] = "Lorsque cette option est activée, HarvestMap ne créera que des icônes de carte pour les emplacements de récolte proches du joueur.\nCe paramètre n'affecte que la carte principale. Sur les mini-cartes, cette option est automatiquement activée !",
	["hasdrawdistancewarning"] = "Ce paramètre n'affecte que la carte en jeu. Sur les mini-cartes, cette option est automatiquement activée !",
	["drawdistance"] = "Distance d'affichage de l'icône",
	["drawdistancetooltip"] = "Détermine la distance maximale en mètres pour l'affichage des icônes de carte lorsque l'option 'Seulement les icônes proches' est activée. Ce paramètre affecte également les mini-cartes !",
	["drawdistancewarning"] = "Ce paramètre affecte également les mini-cartes !",

	visiblepintypes = "Types d'icônes visibles",
	custom_profile = "Personnalisée",
	same_as_map = "Identique à la carte",

	-- paramètres de la boussole
	["compassheader"] = "Paramètres de la boussole",
	["compass"] = "Afficher les icônes sur la boussole",
	["compassdistance"] = "Distance d'affichage de l'icône",
	["compassdistancetooltip"] = "Détermine la distance d'affichage maximale en mètres au-delà de laquelle les icônes ne sont plus affichés sur la boussole.",

	-- paramètres d'icône 3d
	["worldpinsheader"] = "Paramètres d'icône 3D",
	["worldpins"] = "Afficher les icônes 3D sur le monde",
	["worlddistance"] = "Distance d'affichage de l'icône 3D",
	["worlddistancetooltip"] = "Détermine la distance d'affichage maximale en mètres au-delà de laquelle les icônes en trois dimensions ne sont plus affichés sur le monde.",
	["worldpinwidth"] = "Largeur des icônes 3D",
	["worldpinwidthtooltip"] = "Détermine la largeur en centimètres des icônes en 3D.",
	["worldpinheight"] = "Hauteur des icônes 3D",
	["worldpinheighttooltip"] = "Détermine la hauteur en centimètres des icônes en 3D.",
	["worldpinsdepth"] = "Utiliser un tampon de profondeur",
	["worldpinsdepthtooltip"] = "Lorsque cette option est désactivée, les icônes 3D seront visibles à travers les murs et autres objets.",
	["worldpinsdepthwarning"] = "À cause d'un bug du jeu, les icônes 3D sont invisibles si l'option de tampon de profondeur est activé et que la résolution du jeu ne correspond pas à celle de l'interface. C'est le cas lorsqu'une qualité autre que 'Haute' de sous-échantillonage est sélectionnée dans les options vidéo du jeu ou si la résolution du jeu ne correspond pas à celle de votre écran.",

	-- paramètres du temps de réapparition
	["visitednodes"] = "Nœuds visités et aide à la récolte",
	["rangemultiplier"] = "Rayon de nœuds visités",
	["rangemultipliertooltip"] = "Détermine le rayon en mètres en-dessous duquel les noeuds sont considérés comme visités par le temps de réapparition et par l'outil d'aide à la récolte.",
	["usehiddentime"] = "Masquer les nœuds récemment visités",
	["usehiddentimetooltip"] = "Masque les icônes des nœuds, si vous avez visité leur emplacement récemment.",
	["hiddentime"] = "Masquer la durée",
	["hiddentimetooltip"] = "Détermine le temps en minutes pendant lequel les noeuds visités récemment seront masquées.",
	["hiddenonharvest"] = "Masquer les nœuds uniquement après la récolte",
	["hiddenonharvesttooltip"] = "Lorsque cette option est désactivée, les icônes seront masquées si vous les visitez. Activé cette option pour masquer uniquement les icônes lorsque vous les avez récoltées.",

	-- filtre d'apparition
	spawnfilter = "Filtres d'apparition des ressources",
	nodedetectionmissing = "Ces options ne peuvent être activées que si la bibliothèque 'NodeDetection' est activée.",
	spawnfilterdescription = [[Lorsque cette option est activée, HarvestMap masquera les icônes pour les ressources qui n'ont pas encore réapparues.
Par exemple, si un autre joueur a déjà récolté la ressource, l'icône sera masquée jusqu'à ce que la ressource soit à nouveau disponible.
Cette option ne fonctionne que pour les matériaux d'artisanat récoltables. HarvestMap ne peut pas détecter les apparitions tels que les coffres, les sacs lourds ou les portails psijiques.
Le filtre ne fonctionne pas, si un autre addon masque ou redimensionne la boussole.]],
	spawnfilter_map = "Utiliser le filtre sur la carte principale",
	spawnfilter_minimap = "Utiliser le filtre sur la mini-carte",
	spawnfilter_compass = "Utiliser le filtre pour les icônes de boussole",
	spawnfilter_world = "Utiliser le filtre pour les icônes 3D",
	spawnfilter_pintype = "Activer le filtre pour les types d'icônes:",

	-- paramètres de type d'icône
	["pinoptions"] = "Paramètres de type d'icône",
	["pinsize"] = "Taille de l'icône",
	["pinsizetooltip"] = "Détermine la taille des icônes sur la carte.",
	["pincolor"] = "Couleur de l'icône",
	["pincolortooltip"] = "Détermine la couleur des icônes sur la carte et la boussole.",
	["savepin"] = "Sauvegarder les emplacements",
	["savetooltip"] = "Activé cette option pour sauvegarder les emplacements de cette ressource lorsque vous les découvrez.",
	["pintexture"] = "Texture de l'icône",

	-- noms de type d'icône
	["pintype1"] = "Forge et Joaillerie",
	["pintype2"] = "Couture",
	["pintype3"] = "Runes et Portails Psijique",
	["pintype4"] = "Champignons",
	["pintype13"] = "Herbes/Fleurs",
	["pintype14"] = "Herbes aquatiques",
	["pintype5"] = "Bois",
	["pintype6"] = "Coffres",
	["pintype7"] = "Solvants",
	["pintype8"] = "Trous de pêche",
	["pintype9"] = "Sacs lourds",
	["pintype10"] = "Trésors de voleurs",
	["pintype11"] = "Conteneurs de Justice",
	["pintype12"] = "Planques cachées",
	["pintype15"] = "Palourdes géantes",
	-- icônes de type 16, 17 étaient autrefois des bijoux et des portails psijiques
	-- mais les emplacements sont les mêmes que pour la forge et les runes
	["pintype18"] = "Nœuds inconnus",
	["pintype19"] = "Nirnroot écarlate",

	-- boutons de filtre de carte supplémentaire
	["deletepinfilter"] = "Supprimer les icônes d'HarvestMap",
	["filterheatmap"] = "Mode carte thermique",

	-- localisation pour l'aide à la récolte
	["goldperminute"] = "Or par minute:",
	["farmresult"] = "Résultat d'HarvestFarm",
	["farmnotour"] = "HarvestFarm n'a pas été en mesure de calculer un bon parcours de récolte avec la longueur minimale donnée.",
	["farmerror"] = "Erreur d'HarvestFarm",
	["farmnoresources"] = "Aucune ressource trouvée.\nIl n'y a aucune ressource sur cette carte ou vous n'avez sélectionné aucun type de ressource.",
	["farmsuccess"] = "Harvest Farm a calculé un parcours de récolte avec <<1>> nœuds par kilomètre.\n\nCliquer sur l'une des icônes du parcours pour définir le point de départ du tour.",
	["farmdescription"] = "HarvestFarm calculera un parcours avec un ratio ressource/temps très élevé.\nCliquer sur l'une des ressources sélectionnées du parcours généré pour définir le point de départ du tour.",
	["farmminlength"] = "Longueur minimale",
	["farmminlengthtooltip"] = "Détermine la longueur minimale du parcours en kilomètre.",
	["farmminlengthdescription"] = "Plus le parcours est long, plus la probabilité que les ressources soient réapparues après avoir fini le tour est élévée.\nEn revanche, un parcours plus court aura un meilleur rapport ressources/temps.\n(La longueur minimale est donnée en kilomètres.)",
	["tourpin"] = "Prochaine cible de votre parcours",
	["calculatetour"] = "Calculer le parcours",
	["showtourinterface"] = "Afficher l'interface du parcours",
	["canceltour"] = "Annuler le parcours",
	["reverttour"] = "Inverser le sens du parcours",
	["resourcetypes"] = "Types de ressources",
	["skiptarget"] = "Ignorer la cible actuelle",
	["removetarget"] = "Supprimer la cible actuelle",
	["nodesperminute"] = "Nœuds par minute",
	["distancetotarget"] = "Distance jusqu'à la prochaine ressource",
	["showarrow"] = "Afficher la direction",
	["removetour"] = "Supprimer le parcours",
	["undo"] = "Annuler la dernière modification",
	["tourname"] = "Nom du parcours: ",
	["defaultname"] = "Parcours sans nom",
	["savedtours"] = "Parcours sauvegarder pour cette carte:",
	["notourformap"] = "Il n'y a pas de parcours sauvegardé pour cette carte.",
	["load"] = "Charger",
	["delete"] = "Supprimer",
	["saveexiststitle"] = "Veuillez confirmer",
	["saveexists"] = "Il existe déjà un parcours portant le nom <<1>> pour cette carte. Voulez-vous l'écraser ?",
	["savenotour"] = "Il n'y a pas de parcours qui puisse être sauvegardé",
	["loaderror"] = "Le parcours n'a pas pu être chargé.",
	["removepintype"] = "Voulez-vous supprimer <<1>> du parcours ?",
	["removepintypetitle"] = "Confirmer la suppression",

	-- menu de carte de récolte supplémentaire
	["farmmenu"] = "Éditeur de parcours de récolte",
	["editordescription"] = [[Dans ce menu, vous pouvez créer et modifier des parcourss.
S'il n'y a actuellement aucun autre parcours actif, vous pouvez le créer en cliquant sur les icônes de la carte.
Si un parcours est actif, vous pouvez le modifier en remplaçant les sous-sections:
- En premier, cliquer sur une icône de votre parcours (rouge).
- Ensuite, cliquer sur les icônes que vous souhaitez ajouter à votre parcours (Un parcours vert apparaîtra).
- Enfin, cliquer à nouveau sur une icône de votre parcours rouge.
Le parcours vert va maintenant être inséré dans le parcours rouge.]],
	["editorstats"] = [[Nombre de nœuds: <<1>>
Longueur: <<2>> m
Nœuds par kilomètre: <<3>>]],

	-- profils de filtre
	filterprofilebutton = "Ouvrir le menu du profil de filtre",
	filtertitle = "Menu de profil de filtre",
	filtermap = "Profil pour les icônes de carte",
	filtercompass = "Profil pour les icônes de boussole",
	filterworld = "Profil pour les icônes 3D",
	unnamedfilterprofile = "Profil sans nom",
	defaultprofilename = "Profil de filtre par défaut",

	-- Noms SI adaptés à l'API ZOS
	["SI_BINDING_NAME_SKIP_TARGET"] = "Ignorer la cible",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "Basculer les icônes 3D",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "Basculer les icônes de carte",
	["SI_BINDING_NAME_TOGGLE_MINIMAPPINS"] = "Basculer les icônes de mini-carte",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "Ouvrir l'éditeur de parcours d'HarvestMap",
	["SI_BINDING_NAME_HARVEST_SHOW_FILTER"] = "Ouvrir le menu de filtre d'HarvestMap",
	["HARVESTFARM_GENERATOR"] = "Générer un nouveau parcours",
	["HARVESTFARM_EDITOR"] = "Modifier le parcours",
	["HARVESTFARM_SAVE"] = "Sauvegarder/Charger le parcours",
}

local interactableName2PinTypeId = {
	["Sac lourd"] = Harvest.HEAVYSACK,
	-- nœuds spéciaux dans havreglace avec le même butin que les sacs lourds
	["Caisse pesante"] = Harvest.HEAVYSACK,
	["Trésor des voleurs"] = Harvest.TROVE,
	["Panneau mobile"] = Harvest.STASH,
	["Tuile descellée"] = Harvest.STASH,
	["Pierre délogée"] = Harvest.STASH,
	["Portail Psijique"] = Harvest.PSIJIC,
	["Palourde géante"] = Harvest.CLAM,
}
-- convertir en minuscules. zos change parfois la capitalisation, il est donc plus sûr de faire toute la logique en minuscules
Harvest.interactableName2PinTypeId = Harvest.interactableName2PinTypeId or {}
local globalList = Harvest.interactableName2PinTypeId
for name, pinTypeId in pairs(interactableName2PinTypeId) do
	globalList[zo_strlower(name)] = pinTypeId
end