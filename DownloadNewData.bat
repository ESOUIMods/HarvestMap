
@echo off

REM in case the bat is executed from somewhere else
cd %~dp0

echo .
echo .

REM check if we can find the save files
if exist ..\..\SavedVariables goto exists

REM we were not able to find the files!
echo The script could not find your SavedVariables folder.
echo Make sure the AddOn and this script are installed in
echo [...]\Elder Scrolls Online\live\AddOns\HarvestMap
echo Currently the script is installed in:

REM get the last folders of the current path
set rest=%cd%
:find_last_loop
for /f "tokens=1* delims=\/" %%i in ("%rest%") do (
	set ppppp=%pppp%
	set pppp=%ppp%
	set ppp=%pp%
	set pp=%rest%
	set rest=%%j
	goto find_last_loop)
	)
echo [...]\%ppppp%

echo Press any key to close this window.
pause
exit

REM the save files folder exists, so we can try to execute the upload script
:exists
echo You are about to upload and merge your HarvestMap savefiles with the global database.
pause

echo .
echo You need to be logged out of ESO, otherwise merging data will NOT work!
echo Please make sure you are LOGGED OUT.
pause

echo .
echo Creating backup copy of your data

copy /Y ..\..\SavedVariables\HarvestMapAD.lua ..\..\SavedVariables\HarvestMapAD-backup.lua"
copy /Y ..\..\SavedVariables\HarvestMapEP.lua ..\..\SavedVariables\HarvestMapEP-backup.lua"
copy /Y ..\..\SavedVariables\HarvestMapDC.lua ..\..\SavedVariables\HarvestMapDC-backup.lua"
copy /Y ..\..\SavedVariables\HarvestMapDLC.lua ..\..\SavedVariables\HarvestMapDLC-backup.lua"
copy /Y ..\..\SavedVariables\HarvestMapNF.lua ..\..\SavedVariables\HarvestMapNF-backup.lua"

echo Connecting to database...

%SystemRoot%\System32\cscript.exe //E:jscript //T:0 //nologo Main\upload.js

echo Press any key to close this window.
pause
