
-- addon version history:
-- 0 or nil = before this number was introduced
-- 1 = filter local nodes which were saved with their global coords instead of local ones
-- since 2.3.0 incremental:
-- 2 = 3.3.0
-- 3 = 3.3.1
-- 4 = 3.4.0
-- 5 = 3.4.1
-- 6 = 3.4.2
-- 7 = 3.4.3
-- 8 = 3.4.4 - 3.4.7
-- 9 = 3.4.8 - 3.4.10
-- 10 = 3.4.11 - 3.4.14
-- 11 = 3.4.15
-- 12 = 3.5.0
-- 13 = 3.5.4
-- 14 = 3.5.5 (might be 13)
-- 15 = 3.5.6
-- 16 = 3.6.0
-- 17 = 3.6.4 change in map focus logic
-- 18 revert to setmaptoplayerlocation
-- 19 save global on new node
-- 20 3.7.0
-- 21 3.7.5 changed 3d pin height
-- 22 3.7.7 changed 3d pin height
-- 23 3.8.0
-- 24 3.9.0 rework of data structure, added database exchange batch script
-- 25 3.9.4 save flags on harvest
-- 26 3.9.6 perform map click when retrieving node position
-- 27 3.10.0 save jewelry, clams and psijic portals
-- 28 3.10.10 changed merge logic
-- 29 3.10.11 updated data version
-- 30 3.11.0 refactored interaction code
-- 31 3.12.0
-- 32 3.12.3 added workaround for map bug
-- 33 3.12.4 fixed lib3d
-- 34 3.13.0 new 3d logic via api function, also the later 3.13.0 pts elsweyr beta
-- 35 revert to 3.12.X
-- 36 3.12.8 added timeout for interactable names
-- 37 3.13.1 pts elsweyr beta
-- 38 3.13.9 dungeon dlc after elsweyr
-- 39 3.14.0 save per zone id
-- 40 3.14.6 verify zone id
-- 41 3.14.8 fixed fishing globalX <= globalY bug
-- 42 3.14.11 move data to DLC
-- 43 3.15.0 remove globalX, globalY, flags
-- 44 3.15.2 added deletion nodes to savedvar
-- 45 3.15.8 in a previous version i made shifted locations save the player position instead of the camera position
local addonVersion = 45

-- node version which is saved for each node
-- the node version encodes the current game and addon version
-- this is used to detect invalid data caused by addon bugs and game changes (ie sometimes maps get rescaled/translated)
local version, update, patch = string.match(GetESOVersionString(), "(%d+)%.(%d+)%.(%d+)")
-- encode 2.5.4 as 20504, let's hope we never get more than 99 patches for an update :D
local versionInteger = tonumber(version) * 10000 + tonumber(update) * 100 + tonumber(patch)
-- the addon has far less than 100 updates per year, so the upcoming 10 years should be fine with this offset
Harvest.nodeVersion = 1000 * versionInteger + addonVersion
-- example: game version is 2.5.4, addon version is 2:
-- node version is thus 20504002

Harvest.deleteFlag = 2
