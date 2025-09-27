@echo off
setlocal

:: Prompt user for the target folder
set /p targetFolder=Enter the full path of the folder to list (e.g., C:\Users\YourName\Documents): 

:: Check if the folder exists
if not exist "%targetFolder%" (
    echo Folder does not exist. Exiting.
    pause
    exit /b
)

:: Output file (in the same folder as the .bat file)
set outputFile=FolderList.txt

:: List only directories and save to output file
dir /b /ad "%targetFolder%" > "%outputFile%"

echo Folder list saved to %outputFile%
pause