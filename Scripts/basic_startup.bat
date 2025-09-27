start "" "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE"
start chrome.exe "https://document.shands.ufl.edu/dsweb/HomePage" "https://spok.ufhealth.org/smartweb" "https://uc4.shands.ufl.edu" "https://ithelp.ufhealth.org/HEAT/"

::Open Documents and files for current prokect
start "" "V:\Infosvcs\Technical Services\Data Center\UC4\382856 - DO_NOT_USE  91PS UC4 Jobs\DO_NOT_USE  91PS UC4 Jobs.xlsx"

:: Open last Modified File of Weekly Status Report
:: Turns off the display of each command in the batch file as it executes, providing a cleaner output.
@echo off
:: Enables delayed expansion of variables, allowing variables to be expanded at execution time rather than at parse time.
setlocal enabledelayedexpansion

:: Set the folder path
set "folder=P:\Weekly Status Report"

:: Loop through files in the folder
set "latestFile="
set "latestDate=0"
for /f "tokens=*" %%a in ('dir /b /a-d "%folder%\*"') do (
    for %%b in ("%folder%\%%a") do (
        set "fileName=%%~nxa"
        if "!fileName:~0,2!" neq "~$" (
            set "fileDate=%%~tb"
            set "fileDate=!fileDate:~0,10! !fileDate:~11,5!"
            for /f "tokens=1-2 delims= " %%c in ("!fileDate!") do (
                set "fileDateTime=%%c %%d"
            )
            if "!fileDateTime!" geq "!latestDate!" (
                set "latestDate=!fileDateTime!"
                set "latestFile=%%a"
            )
        )
    )
)
