# Adds App Shortcuts
# Define download URLs for the applications
$zoomUrl = "https://zoom.us/client/latest/ZoomInstallerFull.msi"
$anydeskUrl = "https://download.anydesk.com/AnyDesk.exe"
$winfspUrl = "https://github.com/billziss-gh/winfsp/releases/download/winfsp-v1.10.2002/winfsp-1.10.2002.msi"
$sshfsWinUrl = "https://github.com/billziss-gh/sshfs-win/releases/download/2021.1_Beta2/sshfs-win-2021.1-Beta2.msi"
$sshfsWinManagerUrl = "https://github.com/billziss-gh/sshfs-win-manager/releases/download/1.7/sshfs-win-manager-1.7.msi"

# Define installation paths
$installPath = "$env:ProgramFiles\"

# Define desktop shortcut paths
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

# Function to download file using BITS
function Download-File {
    param (
        [string]$url,
        [string]$destination
    )

    $Job = Start-BitsTransfer -Source $url -Destination $destination -Asynchronous
    $Job | Wait-BitsTransfer -Complete
}

# Function to install application
function Install-Application {
    param (
        [string]$url,
        [string]$installPath
    )

    # Download the installer asynchronously
    $installerPath = Join-Path $installPath (Split-Path $url -Leaf)
    Download-File -url $url -destination $installerPath

    # Install the application
    Start-Process -FilePath $installerPath -Wait

    # Remove the installer (optional)
    Remove-Item -Path $installerPath -Force
}

# Function to remove application
function Remove-Application {
    param (
        [string]$appName
    )

    # Remove the application if it exists
    $appPath = Join-Path $installPath $appName
    if (Test-Path $appPath) {
        Remove-Item -Path $appPath -Recurse -Force
    }
}

# Install applications
Install-Application -url $zoomUrl -installPath $installPath
Install-Application -url $anydeskUrl -installPath $installPath
Install-Application -url $winfspUrl -installPath $installPath
Install-Application -url $sshfsWinUrl -installPath $installPath
Install-Application -url $sshfsWinManagerUrl -installPath $installPath

# Create desktop shortcuts
$WshShell = New-Object -ComObject WScript.Shell

$WshShell.CreateShortcut("$desktopPath\Google Chrome.lnk").TargetPath = "$installPath\Google\Chrome\Application\chrome.exe"
$WshShell.CreateShortcut("$desktopPath\Zoom.lnk").TargetPath = "$installPath\Zoom\Zoom.exe"
$WshShell.CreateShortcut("$desktopPath\Thunderbird.lnk").TargetPath = "$installPath\Mozilla Thunderbird\thunderbird.exe"
$WshShell.CreateShortcut("$desktopPath\AnyDesk.lnk").TargetPath = "$installPath\AnyDesk\AnyDesk.exe"
$WshShell.CreateShortcut("$desktopPath\SSHFS-Win-Manager.lnk").TargetPath = "$installPath\SSHFS-Win-Manager\sshfs-win"
