# Define the URLs for the installers
$zoomUrl = "https://zoom.us/client/latest/ZoomInstaller.exe"
$slackUrl = "https://slack.com/downloads/windows"
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"

# Define the installation directory
$installDir = "C:\Program Files\InstalledApps"

# Create the installation directory if it doesn't exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Force -Path $installDir
}

# Function to install an application
function Install-Application($url, $installDir) {
    $installerPath = Join-Path $installDir (Split-Path $url -Leaf)

    # Download installer
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    # Install the application
    Start-Process -Wait -FilePath $installerPath
}

# Install each application
Install-Application -url $zoomUrl -installDir $installDir

Start-Process $slackUrl -Wait

Install-Application -url $anydeskUrl -installDir $installDir

# Function to create a desktop shortcut
function Create-Shortcut($targetPath, $shortcutPath) {
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
}

# Create shortcuts for each application
Create-Shortcut -targetPath (Join-Path $installDir "Zoom.exe") -shortcutPath "$env:USERPROFILE\Desktop\Zoom.lnk"
Create-Shortcut -targetPath "C:\Users\$env:USERNAME\AppData\Local\slack\slack.exe" -shortcutPath "$env:USERPROFILE\Desktop\Slack.lnk"
Create-Shortcut -targetPath (Join-Path $installDir "AnyDesk.exe") -shortcutPath "$env:USERPROFILE\Desktop\AnyDesk.lnk"

# Wait for installations to complete before launching applications
Start-Sleep -Seconds 30

# Start each application
Start-Process (Join-Path $installDir "Zoom.exe")
Start-Process "C:\Users\$env:USERNAME\AppData\Local\slack\slack.exe"
Start-Process (Join-Path $installDir "AnyDesk.exe")
