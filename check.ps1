# Define download URLs for the applications
$urls = @{
    'Zoom'          = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'
    'AnyDesk'       = 'https://download.anydesk.com/AnyDesk.exe'
    'WinFsp'        = 'https://github.com/billziss-gh/winfsp/releases/download/winfsp-v1.10.2002/winfsp-1.10.2002.msi'
    'SSHFS-Win'     = 'https://github.com/billziss-gh/sshfs-win/releases/download/2021.1_Beta2/sshfs-win-2021.1-Beta2.msi'
    'SSHFS-Manager' = 'https://github.com/billziss-gh/sshfs-win-manager/releases/download/1.7/sshfs-win-manager-1.7.msi'
    'GoogleChrome'  = 'https://dl.google.com/chrome/install/GoogleChromeSetup.exe'
    'LibreOffice'   = 'https://download.documentfoundation.org/libreoffice/stable/7.2.2/win/x86_64/LibreOffice_7.2.2_Win_x64.msi'
}

# Define installation paths
$installPath = "$env:ProgramFiles\"

# Define desktop shortcut path
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

# Function to install application
function Install-Application {
    param(
        [string]$url,
        [string]$installPath
    )

    # Download the installer
    $installerPath = Join-Path $installPath (Split-Path $url -Leaf)
    Invoke-WebRequest -Uri $url -OutFile $installerPath

    # Install the application
    Start-Process -FilePath $installerPath -Wait

    # Remove the installer (optional)
    Remove-Item -Path $installerPath -Force
}

# Function to create desktop shortcut
function Create-DesktopShortcut {
    param(
        [string]$appName
    )

    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.CreateShortcut("$desktopPath\$appName.lnk").TargetPath = "$installPath\$appName\$appName.exe"
}

# Install applications synchronously
foreach ($url in $urls.Values) {
    Install-Application -url $url -installPath $installPath
}

# Create desktop shortcuts for specified applications
foreach ($appName in 'Zoom', 'AnyDesk', 'SSHFS-Manager', 'GoogleChrome', 'LibreOffice') {
    if (Test-Path (Join-Path $installPath $appName)) {
        Create-DesktopShortcut -appName $appName
    }
}
