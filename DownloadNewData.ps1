
echo ""
echo ""
echo "You are about to upload and merge your HarvestMap savefiles with the global database."

$ESO = Get-Process eso64 -ErrorAction SilentlyContinue
if ($ESO) {
	echo "You need to be logged out of ESO, otherwise merging data will NOT work!"
	pause
	exit
}

try {
	# the addon is not always located in ~/Documents, i.e. when OneDrive is active.
	# so let's first try with relative paths since this script should be in the addon's folder
	cd "../../../.." # move to the documents folder (assuming the script is in the HarvestMap addon folder)
	foreach ($BasePath in "Elder Scrolls Online/live", "~/Documents/Elder Scrolls Online/live") {
		$HarvestMapPath="${BasePath}/AddOns/HarvestMap"
		$SavedVarriablesPath = "${BasePath}/SavedVariables"
		$EmptySaveFile="${HarvestMapPath}/Main/emptyTable.lua"
		# check if we find the addon and the saved variables
		if ((Test-Path "$HarvestMapPath") -and (Test-Path "$SavedVarriablesPath")) {
			foreach ($Module in "AD","EP","DC","DLC","NF") { 
				$SavedVariable="HarvestMap${Module}"
				$SavedVariableFile="${SavedVarriablesPath}/${SavedVariable}.lua"
				$SavedVariableBackup="${SavedVarriablesPath}/${SavedVariable}-backup.lua"
				
				echo "Creating backup copy of ${SavedVariable}."
				cp -Force "${SavedVariableFile}" "${SavedVariableBackup}" -ErrorAction SilentlyContinue
				# if the copy could not be created (e.g. the original doesn't exist)
				# try to create an empty file that can be uploaded instead
				if (!(Test-Path "${SavedVariableBackup}")) {
					("Harvest${Module}_SavedVars" + (cat "${EmptySaveFile}")) | Out-File "${SavedVariableBackup}" -Encoding ascii
				}
				
				echo "Merging file: ${SavedVariable}"
				try {
					#echo (cat "${SavedVariableBackup}")
					wget -Uri "http://harvestmap.binaryvector.net:8080" -InFile "${SavedVariableBackup}" -OutFile "${SavedVariableFile}" -Method Post
					echo "Finished merging: ${SavedVariable}"
				} catch {
					# something went wrong while connecting to the server
					$Response = $_
					echo "Error:"
					echo $Response.toString()
					pause
					exit
				}
			}
			echo "Finished merging the files."
			pause
			exit
		}
	}
	echo "The script could not find the HarvestMap addon and your SavedVariables folder."
	echo "Make sure the AddOn and this script are installed in"
	echo "[...]\Elder Scrolls Online\live\AddOns\HarvestMap"
	pause
} catch {
    echo $_.Exception.ToString()
    pause
}
