HarvestMap by: Shinni
==========

HarvestMap (formerly known as EsoheadMarkers) displays harvest nodes and chests on map and compass.

Features:
* displays (discovered) harvest nodes and chests on map and compass
* compatible with all languages (French translation by Kalmeth and wookiefrag)
* filters for each pin type (chests + a pin type for every kind of harvest node)
* size and color settings for each pin type
* field of view and distance settings for the compass
* import your already discovered nodes from Esohead via the chat command /harvest import esohead

## Nodes are not included ##

There will be absolutely no harvest nodes after installing this addon.  There was a site that hosted an Esohead.lua file people could download.  I never had contact with the person maintaining that site.  That site was taken down.

## Do I still need the Esohead addon? ##

The Esohead addon needs to be active for /harvest import esohead to work. After you imported your old data, you don't need Esohead any more for this addon.  It would still be great if you continued to use Esohead and upload you data.

## Slash Commands
```/harvest reset```
Completely resets all gathered data.

```/harvest reset DATATYPE```
Resets a specific type of data

Valid types are:
"nodes" - All the valid data used by HarvestMap. It is not recommended to reset this.
"mapinvalid" - All invalid data from maps that HarvestMap could translate. This can be reset after importing data.
"esonodes" - All valid data from maps that HarvestMap could not translate. This can be kept for future updates.
"esoinvalid" - All invalid data from maps that HarvestMap could not translate. This can be reset after importing data.

```/merger datalog DATATYPE```
Returns the number of nodes in the database specified in DATATYPE.  

Valid data types are:

nodes - the primary nodes used by HarvestMap
mapinvalid - the invalid nodes for localized map names
esonodes - valid nodes for non localized map names
esoinvalid - invalid nodes for non localized map names

NOTE: When I update the localization HarvestMap automatically moves data from mapinvalid, esonodes, and esoinvalid to nodes.

```/harvest import addon```
Imports data from Esohead, EsoheadMerge, Harvester, and HarvestMerge.

"esohead" - Esohead
"esomerge" - EsoheadMerge
"harvester" - Harvester
"merger" - HarvestMerge

## Disclaimer

This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered trademarks or trademarks of ZeniMax Media Inc. in the United States and/or other countries. All rights reserved.
