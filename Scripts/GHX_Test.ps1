# Define email parameters
$toAddresses = "IJSCS@jax.ufl.edu; CentralSupplyTeam@jax.ufl.edu; Dwayne.Perkins@jax.ufl.edu; Robert.Alday@jax.ufl.edu; Matthew.Jackson@owens-minor.com"
$ccAddress = "AHC_DATA_CENTER@SHANDS.UFL.EDU"
$currentDate = (Get-Date).ToString("MM/dd/yyyy")
$subject = "GHX Orders for $currentDate"
$body = "FYI,`n`nThank you,"

# Create a new Outlook COM object
$outlook = New-Object -ComObject Outlook.Application

# Create a new mail item
$mail = $outlook.CreateItem(0)

# Set email properties
$mail.To = $toAddresses
$mail.CC = $ccAddress
$mail.Subject = $subject
$mail.Body = $body

# Display the compose email window
$mail.Display()

# Wait for the email window to open
Start-Sleep -Seconds 3

# Define MouseSimulator class
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class MouseSimulator {
    [DllImport("user32.dll")]
    public static extern void SetCursorPos(int x, int y);
    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

    public const int MOUSEEVENTF_LEFTDOWN = 0x02;
    public const int MOUSEEVENTF_LEFTUP = 0x04;

    public static void LeftClick(int x, int y) {
        SetCursorPos(x, y);
        mouse_event(MOUSEEVENTF_LEFTDOWN, x, y, 0, 0);
        mouse_event(MOUSEEVENTF_LEFTUP, x, y, 0, 0);
    }

    public static void DragAndDrop(int startX, int startY, int endX, int endY) {
        SetCursorPos(startX, startY);
        mouse_event(MOUSEEVENTF_LEFTDOWN, startX, startY, 0, 0);
        SetCursorPos(endX, endY);
        mouse_event(MOUSEEVENTF_LEFTUP, endX, endY, 0, 0);
    }
}
"@

# Open the GHX login page
Start-Process "https://login.ghx.com/login"

# Wait for the browser to open and load the login page
Start-Sleep -Seconds 5

# Focus and maximize the browser window
Write-Host "Maximizing browser window..."
$wshell = New-Object -ComObject WScript.Shell
$wshell.AppActivate("GHX Login")  # Focus the browser window
Start-Sleep -Seconds 2
[System.Windows.Forms.SendKeys]::SendWait("% {UP}")  # Simulate Alt+Space, then Up for Maximize
Write-Host "Browser window maximized."

# Adjust browser zoom to 100% before signing in
Write-Host "Adjusting browser zoom to 100%..."
for ($i = 0; $i -lt 5; $i++) {  # Simulate 5 Ctrl+Plus to zoom in
    [System.Windows.Forms.SendKeys]::SendWait("^=")  # Ctrl+Plus
    Start-Sleep -Milliseconds 500
}
Write-Host "Browser zoom set to 100%."

# Copy the username to the clipboard
Set-Clipboard -Value "ahc_data_center@shands.ufl.edu"

# Simulate Ctrl+V to paste the username
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^v")

# Press Enter to move to the password field
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# Wait for the password field to load
Start-Sleep -Seconds 2

# Copy the password to the clipboard
Set-Clipboard -Value "Shands19?"

# Simulate Ctrl+V to paste the password
[System.Windows.Forms.SendKeys]::SendWait("^v")

# Press Enter to submit the form
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

# Wait for login processing
Start-Sleep -Seconds 5

# Move the mouse to the specified coordinates (84, 363) and left-click
Write-Host "Moving mouse to (84, 363) and clicking..."
[MouseSimulator]::LeftClick(84, 363)
Write-Host "Mouse clicked at (84, 363)."

# Adjust browser zoom to 80%
Write-Host "Adjusting browser zoom to 80%..."
for ($i = 0; $i -lt 2; $i++) {  # Simulate 2 Ctrl+Minus to zoom out
    [System.Windows.Forms.SendKeys]::SendWait("^-")  # Ctrl+Minus
    Start-Sleep -Milliseconds 500
}
Write-Host "Browser zoom set to 80%."

# Wait for 10 seconds
Start-Sleep -Seconds 10

# Open the Snipping Tool
Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Snipping Tool.lnk"

# Wait for the Snipping Tool to open
Start-Sleep -Seconds 2

# Simulate pressing "Alt+N" to create a new snip
[System.Windows.Forms.SendKeys]::SendWait("%n")

# Wait for the new snip overlay to appear
Start-Sleep -Seconds 2

# Perform a drag-and-drop operation from (11, 79) to (1875, 1019)
Write-Host "Performing drag-and-drop operation..."
[MouseSimulator]::DragAndDrop(11, 79, 1875, 1019)
Write-Host "Drag-and-drop operation completed."

# Wait for the drag operation to complete
Start-Sleep -Seconds 2

# Simulate Ctrl+C to copy the snip
[System.Windows.Forms.SendKeys]::SendWait("^c")
Write-Host "Screenshot copied to clipboard."

# Bring the Outlook email window into focus
try {
    $outlook = New-Object -ComObject Outlook.Application
    $mail = $outlook.ActiveInspector().CurrentItem
    if ($mail) {
        Write-Host "Outlook email draft found and brought to focus."
        # Bring the Outlook window into focus
        $wshell.AppActivate($mail.Subject)
        Start-Sleep -Seconds 1  # Wait a moment to ensure it's focused
    } else {
        Write-Host "No active Outlook email window found. Exiting script."
        exit
    }
} catch {
    Write-Host "Error accessing Outlook: $_"
    exit
}

# Move the cursor after "FYI" (2 lines down)
$wshell.SendKeys("{DOWN 2}")
Start-Sleep -Milliseconds 500

# Simulate Ctrl+V to paste the screenshot
$wshell.SendKeys("^v")
Write-Host "Screenshot pasted into the email body."
