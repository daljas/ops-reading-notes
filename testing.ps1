<#
Script Name: Window Automation 
Author: Jason Dallas
Date of latest revision: 11/13/2023
Purpose: Perform basic tasks
#>
# Define the username and password
$userName = "User"
$password = "Password"

# Create a new user account
New-LocalUser -Name $userName -Password (ConvertTo-SecureString -String $password -AsPlainText -Force) -Description "Sample User Account"

# Add the user to the "Users" group
Add-LocalGroupMember -Group "Users" -Member $userName

# Force the user to change the password at the next login
net user $userName /logonpasswordchg:yes


# Changes background to Company Logo
# URL of the image
$imageUrl = "https://raw.githubusercontent.com/avalon-lake-tech/mrbeast-scripts/main/avalonlake-desktop.png"

# Path to save the image
$imagePath = "$env:TEMP\avalonlake-desktop.png"

# Download the image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Set the image as the desktop background
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
    }
"@

[Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)

# Clean up: Remove the downloaded image
Remove-Item $imagePath


# Define download URLs for the applications
$urls = @{
    'Zoom'          = 'https://zoom.us/client/latest/ZoomInstallerFull.msi'
    'AnyDesk'       = 'https://download.anydesk.com/AnyDesk.exe'
    'WinFsp'        = 'https://github.com/billziss-gh/winfsp/releases/download/winfsp-v1.10.2002/winfsp-1.10.2002.msi'
    'SSHFS-Win'     = 'https://github.com/billziss-gh/sshfs-win/releases/download/2021.1_Beta2/sshfs-win-2021.1-Beta2.msi'
    'SSHFS-Manager' = 'https://github.com/billziss-gh/sshfs-win-manager/releases/download/1.7/sshfs-win-manager-1.7.msi'
    'GoogleChrome'  = 'https://dl.google.com/chrome/install/GoogleChromeSetup.exe'
    'LibreOffice'   = 'https://download.documentfoundation.org/libreoffice/stable/7.2.2/win/x86_64/LibreOffice_7.2.2_Win_x64.msi'
    'Thunderbird'   = 'https://download-installer.cdn.mozilla.net/pub/thunderbird/releases/91.2.0/win64/en-US/Thunderbird%20Setup%2091.2.0.exe'
}

# Define installation paths
$installPath = "$env:ProgramFiles\"

# Define desktop shortcut path
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'))

# Function to install application asynchronously
function Install-ApplicationAsync {
    param(
        [string]$url,
        [string]$installPath
    )

    Start-Job -ScriptBlock {
        param($url, $installPath)

        $installerPath = Join-Path $installPath (Split-Path $url -Leaf)
        Invoke-WebRequest -Uri $url -OutFile $installerPath
        Start-Process -FilePath $installerPath -Wait
        Remove-Item -Path $installerPath -Force
    } -ArgumentList $url, $installPath
}

# Function to create desktop shortcut
function Create-DesktopShortcut {
    param(
        [string]$appName
    )

    $WshShell = New-Object -ComObject WScript.Shell
    $WshShell.CreateShortcut("$desktopPath\$appName.lnk").TargetPath = "$installPath\$appName\$appName.exe"
}

# Install applications asynchronously
$urls.GetEnumerator() | ForEach-Object {
    Install-ApplicationAsync -url $_.Value -installPath $installPath
}

# Wait for all installations to complete
Get-Job | Wait-Job | Remove-Job

# Create desktop shortcuts for specified applications
foreach ($appName in 'Zoom', 'AnyDesk', 'SSHFS-Manager', 'GoogleChrome', 'LibreOffice', 'Thunderbird') {
    $appPath = Join-Path $installPath $appName
    if (Test-Path $appPath) {
        Create-DesktopShortcut -appName $appName
    }
}
