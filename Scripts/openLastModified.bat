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

if defined latestFile (
    echo Latest modified file: %latestFile%
    echo Opening latest modified file...
    start "" "%folder%\%latestFile%"
) else (
    echo No files found in the folder.
)

pause