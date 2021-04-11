#!/bin/bash
# (C) 2018 @mojo66, eso@mojo66.de

# enjoy the beauty of scripting on a professional operating system

# exit if ESO is running
if [[ "uname -s" == "Darwin" ]]; then option="-q"; fi
pgrep -x $option eso
if [[ ! $? -eq 1 ]]; then echo "Quit ESO before running this script to avoid data corruption.";exit 1;fi

# use absolute paths. this makes the script work regardless of the dir it resides in
basedir=~/Documents/Elder\ Scrolls\ Online/live
savedvardir=${basedir}/SavedVariables
addondir=${basedir}/AddOns/HarvestMap
emptyfile=${addondir}/Main/emptyTable.lua

# check if everything exists
if [[ ! -e "${addondir}" ]]; then echo "ERROR: ${addondir} does not exists, re-install this AddOn and try again...";exit 1;fi

# iterate over the different zones
for zone in AD EP DC DLC NF; do

	fn=HarvestMap${zone}.lua
	echo "Working on ${fn}..."

	svfn1=${savedvardir}/${fn}
	svfn2=${svfn1}~

	# if saved var file exists, create backup...
	if [[ -e ${svfn1} ]]; then
		mv -f "${svfn1}" "${svfn2}"
	# ...else, use empty table to create a placeholder
	else
		name=Harvest${i}_SavedVars
		echo -n ${name} | cat - "${emptyfile}" > "${svfn2}"
	fi
	# download data
	curl -# -d @"${svfn2}" -o "${addondir}/Modules/HarvestMap${zone}/${fn}" "http://harvestmap.binaryvector.net:8081"

done
