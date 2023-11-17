# Function to check if an application is installed
function Is-Installed {
    param (
        [string]$appName
    )

    $installed = Get-Command $appName -ErrorAction SilentlyContinue
    return ($installed -ne $null)
}

# Function to install an application
function Install-Application {
    param (
        [string]$appName,
        [string]$installerPath
    )

    Start-Process -FilePath $installerPath -Wait
}

# Function to create a desktop shortcut
function Create-DesktopShortcut {
    param (
        [string]$appName,
        [string]$executablePath
    )

    $desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "$appName.lnk")

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($desktopPath)
    $Shortcut.TargetPath = $executablePath
    $Shortcut.Save()
}

# Application information
$applications = @(
    @{
        Name = "Google Chrome"
        InstallerPath = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    },
    @{
        Name = "Zoom"
        InstallerPath = "https://zoom.us/client/latest/ZoomInstaller.exe"
    },
    @{
        Name = "LibreOffice"
        InstallerPath = "https://download.documentfoundation.org/libreoffice/stable/7.2.3/win/x86_64/LibreOffice_7.2.3_Win_x64.msi"
    },
    # Add similar entries for other applications
)

# Loop through applications
foreach ($app in $applications) {
    $appName = $app.Name
    $installerPath = $app.InstallerPath

    if (-not (Is-Installed $appName)) {
        Write-Host "$appName is not installed. Installing..."
        Install-Application -appName $appName -installerPath $installerPath
    }

    # Create desktop shortcut for the application
    $executablePath = (Get-Command $appName).Source
    Create-DesktopShortcut -appName $appName -executablePath $executablePath
}

Write-Host "Script execution completed."
