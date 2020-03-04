#!/bin/bash
# (C) 2018 @mojo66, eso@mojo66.de

# enjoy the beauty of scripting on a professional operating system

# exit if ESO is running
if [[ `uname -s` -eq "Darwin" ]]; then option="-q"; fi
pgrep -x $option eso
if [[ ! $? -eq 1 ]]; then echo "Quit ESO before running this script to avoid data corruption.";exit 1;fi

# use absolute paths. this makes the script work regardless of the dir it resides in
basedir=~/Documents/Elder\ Scrolls\ Online/live
addondir=${basedir}/AddOns/HarvestMap
emptyfile=${addondir}/Main/emptyTable.lua

# check if everything exists
if [[ ! -e "${addondir}" ]]; then echo "ERROR: ${addondir} does not exists, re-install this AddOn and try again...";exit 1;fi

savedvardir=${basedir}/SavedVariables
if [[ ! -e "${savedvardir}" ]]; then 
	# create saved vars dir if it doesn't exist
	echo "${savedvardir} doesn't exist. Creating..."
	mkdir "${savedvardir}"
	if [[ $? -gt 0 ]]; then echo "ERROR: Failed to create ${savedvardir}."; exit 1;fi
fi

# iterate over the different zones

for zone in AD EP DC DLC NF; do 

	fn=HarvestMap${zone}.lua

	echo "Working on ${fn}..."

	svfn1=${savedvardir}/${fn}
	svfn2=${svfn1}~

	# if saved var file exists, create backup...
	if [[ -e ${svfn1} ]]; then

		cp -fp "${svfn1}" "${svfn2}"

	# ...else, use empty table to create a placeholder
	else 
		name=Harvest${i}_SavedVars
		echo -n ${name} | cat - "${emptyfile}" > "${svfn2}"

	fi

	# up/download. Note that the equivalent of the next line requires 89 lines of code on Windows 

	curl -# -d @"${svfn2}" -o "${svfn1}" "http://harvestmap.binaryvector.net:8080"

	rm "${svfn2}"
done
