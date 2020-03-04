
var basePath = "../../SavedVariables/";
var saveFiles = [
	"HarvestMapAD",
	"HarvestMapEP",
	"HarvestMapDC",
	"HarvestMapDLC",
	"HarvestMapNF"
]

var saveVarTables = {
	HarvestMapAD : "HarvestAD_SavedVars",
	HarvestMapEP : "HarvestEP_SavedVars",
	HarvestMapDC : "HarvestDC_SavedVars",
	HarvestMapDLC : "HarvestDLC_SavedVars",
	HarvestMapNF : "HarvestNF_SavedVars"
}


var reader = WScript.CreateObject("Scripting.FileSystemObject")
function readSaveFile(path) {
	var file = reader.OpenTextFile(path);
	var content = file.ReadAll();
	file.close()
	return content
}

function getEmptySaveFile(savedVar) {
	return saveVarTables[savedVar] + readSaveFile("Main/emptyTable.lua")
}

function exchangeData(savedVar, input, outputFile, isSecondTry) {
	var connection = WScript.CreateObject("Msxml2.XMLHTTP");
	connection.open('post', "http://harvestmap.binaryvector.net:8080/", false);
	
	connection.onreadystatechange = function() {
		if (connection.readyState == 4) {
			WScript.Echo("Finished.")
			if (connection.status == 200) {
				var fileStream = WScript.CreateObject("ADODB.Stream");
				fileStream.open();
				fileStream.type = 1;
				fileStream.write(connection.responseBody);
				fileStream.saveToFile(outputFile, 2);
				fileStream.close();
				WScript.Echo("Saved new data for file: " + savedVar)
			} else {
				WScript.Echo("Error while merging file: " + savedVar)
				WScript.Echo("The server answered:")
				WScript.Echo(connection.responseText)
				if (isSecondTry == 0) {
					WScript.Echo("Trying again with empty savefile...")
					isSecondTry = 1
					exchangeData(savedVar, getEmptySaveFile(savedVar), outputFile, isSecondTry)
				}
			}
		} else if (connection.readyState == 3) {
			WScript.Echo("Receiving answer...")
		} else if (connection.readyState == 2) {
			WScript.Echo("Finished uploading the file.")
		} else if (connection.readyState == 1) {
			WScript.Echo("Uploading file: " + savedVar)
		}
	}
	connection.send(input)
}



for (i = 0; i < saveFiles.length; i++) {
	
	var savedVar = saveFiles[i];
	var saveFile = basePath + savedVar + "-backup.lua"
	var outputFile = basePath + savedVar + ".lua"
	
	if (reader.FileExists(saveFile)) {
		WScript.Echo("Open file: " + savedVar);
		var content = readSaveFile(saveFile);
		var isSecondTry = 0
		exchangeData(savedVar, content, outputFile, isSecondTry)
	} else {
		WScript.Echo("Could not find file: " + savedVar);
		WScript.Echo("Trying again with an empty file...");
		var content = getEmptySaveFile(savedVar)
		var isSecondTry = 1
		exchangeData(savedVar, content, outputFile, isSecondTry)
	}
	WScript.Echo("")
}
