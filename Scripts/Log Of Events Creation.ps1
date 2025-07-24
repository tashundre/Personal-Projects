# Prompt user for a brief description of the issue
$issueDescription = Read-Host "Enter a brief description of the issue for the Log of Events file"

# Define source and destination directories
$sourceDir = "V:\Infosvcs\Technical Services\Data Center\DC Log of Events\Archive"
$destDir = "V:\Infosvcs\Technical Services\Data Center\DC Log of Events"

# Define the source file pattern
$filePattern = "LOE_(Event Type) Event_xx-xx-xxxx.xlsx"

# Get the current date in MMddyyyy format
$currentDate = (Get-Date).ToString("MMddyyyy")

# Get a list of files that match the pattern in the source directory
$sourceFiles = Get-ChildItem -Path $sourceDir -Filter $filePattern

# Debug: Output the files found
Write-Output "Files found matching pattern '$filePattern':"
$sourceFiles | ForEach-Object { Write-Output $_.FullName }

# Check if any files are found
if ($sourceFiles.Count -eq 0) {
    Write-Output "No files found matching pattern: $filePattern"
    return
}

# Iterate over each file found (assuming you only need the first match)
foreach ($file in $sourceFiles) {
    # Construct the destination file path with the new name
    $destFile = Join-Path $destDir "LOE_${issueDescription}_Event_${currentDate}.xlsx"

    # Debug: Output the source and destination paths
    Write-Output "Copying file from: $($file.FullName) to: $destFile"

    # Copy and rename the file
    try {
        Copy-Item -Path $file.FullName -Destination $destFile -Force
        Write-Output "File copied and renamed to: $destFile"
    } catch {
        Write-Output "Failed to copy file: $_"
    }

    # Verify if the file exists in the destination directory
    if (Test-Path $destFile) {
        Write-Output "File successfully created at destination."

        # Update the "date modified" timestamp to the current date and time
        $currentTime = Get-Date
        (Get-Item $destFile).LastWriteTime = $currentTime

        Write-Output "File 'date modified' updated to: $currentTime"
    } else {
        Write-Output "File not found at destination. Check for issues."
    }
}

# Open Windows Explorer in the destination directory
Start-Process explorer.exe -ArgumentList $destDir
