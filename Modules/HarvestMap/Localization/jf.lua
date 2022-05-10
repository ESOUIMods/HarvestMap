-- by Juijote
Harvest.localizedStrings = {
	-- conflict message for settings that don't work with Fyrakin's minimap
	["minimapconflict"] = "此选项不兼容Fyrakin's minimap插件。",
	-- top level description
	["esouidescription"] = "有关插件描述和常见问题，请访问esoui.com上的插件页面",
	["openesoui"] = "打开ESOUI",
	["exchangedescription"] = "通过执行在HarvestMap 收获地图文件夹下的'DownloadNewData.command' (苹果系统)'或 'DownloadNewData.bat' (Windows系统) 程序，你可以下载最新的HarvestMap 收获地图数据(资源的位置) 。更多有关这方面的信息，请参阅ESOUI上的插件描述信息。",
	["feedback"] = "反馈",
	["feedbackdescription"] = "如果你发现了一个BUG, 或者有任何意见和建议, 或者仅是希望捐赠, 请发送一封邮件.\n您还可以在esoui.com网站的HarvestMap 收获地图插件的评论区留下反馈和BUG报告。",
	["sendgold"] = "发送 <<1>> 金币",
	["debuginfodescription"] = "如果您想要在esoui.com的评论页上报告一个BUG, 还请添加以下调试信息:",
	["printdebuginfo"] = "复制调试信息",
	
	["notifications"] = "通知和警告",
	["notificationstooltip"] = "在屏幕右上角显示通知和警告。",
	["moduleerrorload"] = " <<1>> 插件被禁用了。\n此区域没有可用数据。",
	["moduleerrorsave"] = " <<1>> 插件被禁用了。\n此节点的位置信息没有被保存。",
	
	-- outdated data settings
	["outdateddata"] = "过时的数据设置",
	["outdateddatainfo"] = "这些数据相关的设置在这台计算机上的所有帐户和角色之间共享.",
	["mingameversion"] = "最低的游戏版本",
	["mingameversiontooltip"] = "HarvestMap 收获地图将从此版本及更新的版本的ESO中保留数据。",
	["timedifference"] = "只保存最近的数据",
	["timedifferencetooltip"] = "HarvestMap 收获地图将只保存最近X天的数据。\n这可以防止显示可能已经过时的旧数据。\n设置为0以保存任何数据，不论其时间.",
	["applywarning"] = "旧数据一旦删除，就无法恢复!",
	
	-- account wide settings
	["account"] = "账户全局设置",
	["accounttooltip"] = "下面的所有设置对每个角色都是相同的.",
	["accountwarning"] = "更改此设置将重新加载UI.",
	
	-- map pin settings
	["mapheader"] = "地图标记设置",
	["mappins"] = "在主地图上启用标记",
	["mappinstooltip"] = "允许在主地图上显示标记。禁用可以提高性能。",
	["minimappins"] = "在小地图上启用标记",
	["minimappinstooltip"] = [[如果你安装了带小地图功能的插件时，允许在小地图上显示标记, 禁用可以提高性能。
支持的小地图插件: Votan, Fyrakin 和 AUI]],
	mapspawnfilter = "在主地图上只显示已生成的资源",
	minimapspawnfilter = "在小地图上只显示已生成的资源",
	spawnfiltertooltip = [[启用后，HarvestMap 收获地图将隐藏尚未生成资源的标记。
例如，如果另一个玩家已经采集了资源, 那么标记将被隐藏，直到资源再次可用。
此选项仅适用于可采集的制造原料。不适用于宝箱或重麻袋等容器。
当其他插件隐藏了罗盘时，此功能不可用。]],
	nodedetectionmissing = "只有当'NodeDetection'运行库开启时，此选项才可用。",
	spawnfilterwarning = "当其他插件隐藏了罗盘时，此功能不可用。",
	--["minimaponly"] = "只在小地图上显示标记",
	--["minimaponlytooltip"] = "启用此选项时, 在默认地图上将不显示标记。标记只会显示在小地图上。",
	["level"] = "在地点图标之上显示标记",
	["leveltooltip"] = "开启在地图地点图标之上显示HarvestMap 收获地图的图标.",
	["hasdrawdistance"] = "只显示附近的地图标记",
	["hasdrawdistancetooltip"] = "开启时, HarvestMap 收获地图只为靠近玩家的采集地点创建地图标记.\n此设置只影响游戏内地图。小地图上则会自动启用此选项!",
	["hasdrawdistancewarning"] = "此设置只影响游戏内地图。小地图上则会自动启用此选项!",
	["drawdistance"] = "地图标记距离",
	["drawdistancetooltip"] = "绘制地图标记的距离阈值。此设置也影响小地图!",
	["drawdistancewarning"] = "此设置也影响小地图!",
	["rotatingcompatibility"] = "旋转小地图兼容性",
	["minimapcompatibilitymodedescription"] = "在地图上显示大量资源位置时，为了提高性能, HarvestMap 收获地图创建了自己的轻量级地图标记图标。这些轻量级的图标不兼容小地图旋转。\n如果你使用了旋转小地图, 你可以开启'小地图兼容模式'。开启此模式时, HarvestMap 收获地图将使用默认地图图标替代轻量级图标。这类默认图标可以支持旋转小地图, 但每当显示具有许多已知资源位置的地图时，它们可能会导致FPS降低并引起游戏画面冻结数秒。",
	["minimapcompatibilitymode"] = "小地图兼容模式",
	["minimapcompatibilitymodewarning"] = "当地图上显示较多标记时。启用此选项将对游戏的性能产生负面影响。\n\n更改设置将重新加载UI!",
	
	-- compass settings
	["compassheader"] = "罗盘设置",
	["compass"] = "启用罗盘",
	["compasstooltip"] = "开启在罗盘上显示附近的标记。禁用可以提高性能。",
	compassspawnfilter = "只显示已生成的资源",
	["compassdistance"] = "最大标记距离",
	["compassdistancetooltip"] = "显示在罗盘上标记的最大距离(以米为单位).",
	
	-- 3d pin settings
	["worldpinsheader"] = "3D标记设置",
	["worldpins"] = "开启3D标记",
	["worldpinstooltip"] = "能够在3D游戏世界中显示附近的资源位置。禁用可以提高性能。",
	worldspawnfilter = "只显示已生成的资源",
	["worlddistance"] = "最大3D标记距离",
	["worlddistancetooltip"] = "显示采集位置的最大距离(以米为单位)。当一个位置较远时, 则不会显示3D标记。",
	["worldpinwidth"] = "3D标记宽度",
	["worldpinwidthtooltip"] = "3D标记的宽度，单位为厘米。",
	["worldpinheight"] = "3D标记高度",
	["worldpinheighttooltip"] = "3D标记的高度，单位为厘米。",
	["worldpinsdepth"] = "为3D标记使用深度提升",
	["worldpinsdepthtooltip"] = "关闭时, 3D标记将不会隐藏在其他物体后面。",
	["worldpinsdepthwarning"] = "由于一个游戏BUG, 当在游戏的视频选项中将二次取样质量设置为中等或者低时，此选项无法生效。",
	
	
	-- respawn timer settings
	["farmandrespawn"] = "刷新计时器和采集助手",
	["rangemultiplier"] = "访问的节点范围",
	["rangemultipliertooltip"] = "在X米内的节点才会被刷新计时器和采集助手访问。",
	["usehiddentime"] = "隐藏最近访问的节点",
	["usehiddentimetooltip"] = "隐藏您最近访问过的标记位置。",
	["hiddentime"] = "持续时间 (刷新计时器)",
	["hiddentimetooltip"] = "最近访问的节点将被隐藏X分钟。",
	["hiddenonharvestwarning"] = "关闭此选项可能会对游戏的性能产生负面影响。",
	["hiddenonharvest"] = "只在采集之后隐藏节点",
	["hiddenonharvesttooltip"] = "开启后只当你采集完成时隐藏标记。关闭后当你访问时标记也将被隐藏",
	
	
	-- pin type options
	["pinoptions"] = "标记类型选项",
	["pinsize"] = "标记尺寸",
	["pinsizetooltip"] = "设置地图上的标记尺寸.",
	["pinminsize"] = "小地图标记尺寸",
	["pinminsizetooltip"] = "在地图上缩小的时候标记也会变小。您可以使用此选项为标记的大小设置最小值。使用更小的值可以防止地图被隐藏在标记后面, 但这些标记可能会变得更加难以看清。",
	["extendedpinoptions"] = "通常地图上的标记, 罗盘和3d世界中是同步的。如果你在地图上隐藏了某种类型的资源, 它也将移除罗盘和世界中的标记。然而, 在扩展标记过滤器菜单中，您可以设置罗盘和世界标记独立于地图标记存在。",
	["extendedpinoptionsbutton"] = "打开扩展标记过滤器",
	["override"] = "覆盖地图标记过滤器",
	
	["pincolor"] = "标记颜色",
	["pincolortooltip"] = "设置地图和罗盘上标记的颜色.",
	["savepin"] = "保存位置",
	["savetooltip"] = "启用在发现资源时保存它们的位置。",
	["pintexture"] = "标记图标",
	
	-- debug output setting
	["debugoptions"] = "调试",
	["debug"] = "显示调试信息",
	["debugtooltip"] = "启用在聊天框中显示调试消息。",
	
	-- pin type names
	["pintype1"] = "锻造和首饰",
	["pintypetooltip1"] = "在地图和罗盘上显示矿锭和矿粉。",
	["pintype2"] = "纤维织物",
	["pintypetooltip2"] = "在地图和罗盘上显示制衣原料。",
	["pintype3"] = "符文石和赛伊克传送门",
	["pintypetooltip3"] = "在地图和罗盘上显示符文石和赛伊克传送门。",
	["pintype4"] = "蘑菇",
	["pintypetooltip4"] = "在地图和罗盘上显示蘑菇。",
	["pintype13"] = "草药/花朵",
	["pintypetooltip13"] = "在地图和罗盘上显示草药和花朵。",
	["pintype14"] = "水生植物",
	["pintypetooltip14"] = "在地图和罗盘上显示水生植物。",
	["pintype5"] = "木材",
	["pintypetooltip5"] = "在地图和罗盘上显示木材。",
	["pintype6"] = "宝箱",
	["pintypetooltip6"] = "在地图和罗盘上显示宝箱。",
	["pintype7"] = "溶剂",
	["pintypetooltip7"] = "在地图和罗盘上显示溶剂。",
	["pintype8"] = "钓鱼点",
	["pintypetooltip8"] = "在地图和罗盘上显示钓鱼地点。",
	["pintype9"] = "重麻袋",
	["pintypetooltip9"] = "在地图和罗盘上显示重麻袋。",
	["pintype10"] = "盗贼的宝藏",
	["pintypetooltip10"] = "在地图和罗盘上显示盗贼的宝藏。",
	["pintype11"] = "审判容器",
	["pintypetooltip11"] = "在地图和罗盘上显示审判容器，例如保险箱或劫掠目标。",
	["pintype12"] = "隐藏物品",
	["pintypetooltip12"] = "在地图和罗盘上显示隐藏物品，例如'松动的镶板'。",
	["pintype15"] = "巨型水蚌",
	["pintypetooltip15"] = "在地图和罗盘上显示巨型水蚌。",
	
	["pintype18"] = "未知收集节点",
	["pintypetooltip18"] = "HarvestMap 收获地图能探测到附近的制造原料, 但它不能检测原料的类型，除非你事先发现了该位置.",
	
	["pintype19"] = "猩红奈恩根",
	["pintypetooltip19"] = "在地图和罗盘上显示猩红奈恩根。",

	-- extra map filter buttons
	["deletepinfilter"] = "删除HarvestMap 收获地图标记",
	["filterheatmap"] = "热力地图模式",
	
	-- localization for the farming helper
	["goldperminute"] = "每分钟的金币:",
	["farmresult"] = "HarvestFarm 结果",
	["farmnotour"] = "HarvestFarm 不能基于设定的最小路线长度计算出一个良好的收割路线。",
	["farmerror"] = "HarvestFarm 错误",
	["farmnoresources"] = "没有找到资源。\n此地图上没有资源，或者您没有选择任何资源类型。",
	["farminvalidmap"] = "收割辅助工具不能在此地图上使用.",
	["farmsuccess"] = "HarvestFarm 计算出了一条每公里 <<1>> 节点的收割线路。\n\n按一下其中一个路线标记以设定路线的起点。",
	["farmdescription"] = "HarvestFarm 将计算出一条非常高效的资源收割线路。\n在生成一条线路之后, 点击其中一个被选择的资源来设置线路的起点。",
	["farmminlength"] = "最小路径长度",
	["farmminlengthtooltip"] = "路线的最小长度(以公里为单位).",
	["farmminlengthdescription"] = "路线越长, 当您开始下一个循环时，资源重新出现的机会就越大。\n然而，一个较短的线路将获得更高的收割效率。",
	["tourpin"] = "你线路的下一个目标",
	["calculatetour"] = "计算线路",
	["showtourinterface"] = "显示路线界面",
	["canceltour"] = "取消线路",
	["reverttour"] = "恢复线路方向",
	["resourcetypes"] = "资源类型",
	["skiptarget"] = "跳过当前目标",
	["removetarget"] = "删除当前目标",
	["nodesperminute"] = "每分钟的节点数",
	["distancetotarget"] = "到下一个资源的距离",
	["showarrow"] = "显示方向",
	["removetour"] = "删除路线",
	["undo"] = "撤消最后的变动",
	["tourname"] = "线路名: ",
	["defaultname"] = "未命名的线路",
	["savedtours"] = "此地图已保存的线路:",
	["notourformap"] = "此地图没有已保存线路。",
	["load"] = "载入",
	["delete"] = "删除",
	["saveexiststitle"] = "请确认",
	["saveexists"] = "此地图已有一个以 <<1>> 命名的线路了。您要覆盖它吗?",
	["savenotour"] = "没有可保存的线路。",
	["loaderror"] = "此线路无法被载入",
	["removepintype"] = "您想从路线中删除 <<1>> 吗?",
	["removepintypetitle"] = "确认删除",
	
	-- extra HarvestMap menu
	["pinvisibilitymenu"] = "扩展标记过滤器菜单",
	["menu"] = "HarvestMap 收获地图 菜单",
	["farmmenu"] = "收割线路编辑器",
	["editordescription"] = [[在此菜单中，您可以创建和编辑线路。
如果目前没有其他被激活的线路, 您可以通过点击地图标记创建一个线路。
如果有被激活的线路, 您可以通过替换其中一部分来编辑线路:
- 首先点击您线路(红色)中的一个标记。
- 然后，点击你想添加到路线中的标记。 (一条绿色线路将会出现)
- 最后，再次点击你的红色线路中的标记。
现在绿色线路将被插入红色线路。]],
	["editorstats"] = [[节点数量: <<1>>
长度: <<2>> 米
每公里节点数: <<3>>]],
	
	-- SI names to fit with ZOS api
	["SI_BINDING_NAME_SKIP_TARGET"] = "跳过目标",
	["SI_BINDING_NAME_TOGGLE_WORLDPINS"] = "切换3D标记",
	["SI_BINDING_NAME_TOGGLE_MAPPINS"] = "切换地图标记",
	["SI_BINDING_NAME_HARVEST_SHOW_PANEL"] = "切换HarvestMap 收获地图标记菜单",
	["SI_HARVEST_CTRLC"] = "按CTRL+C以复制文本",
	["HARVESTFARM_GENERATOR"] = "生成新线路",
	["HARVESTFARM_EDITOR"] = "编辑线路",
	["HARVESTFARM_SAVE"] = "保存/载入 线路",

	--HarvestMap menu (enhanced pin filters)
	["3dPins"] = "3D标记",
	["CompassPins"] = "罗盘标记",
}