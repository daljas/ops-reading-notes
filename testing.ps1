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

# Function to remove application
function Remove-Application {
    param(
        [string]$appName
    )

    # Remove the application if it exists
    $appPath = Join-Path $installPath $appName
    if (Test-Path $appPath) {
        Remove-Item -Path $appPath -Recurse -Force
    }
}



# Install Zoom
Install-Application -url $zoomUrl -installPath $installPath

# Install AnyDesk
Install-Application -url $anydeskUrl -installPath $installPath

# Install WinFsp
Install-Application -url $winfspUrl -installPath $installPath

# Install SSHFS-Win
Install-Application -url $sshfsWinUrl -installPath $installPath

# Install SSHFS-Win-Manager
Install-Application -url $sshfsWinManagerUrl -installPath $installPath


# Create desktop shortcuts
$WshShell = New-Object -ComObject WScript.Shell

$WshShell.CreateShortcut("$desktopPath\Google Chrome.lnk").TargetPath = "$installPath\Google\Chrome\Application\chrome.exe"
$WshShell.CreateShortcut("$desktopPath\Zoom.lnk").TargetPath = "$installPath\Zoom\Zoom.exe"
$WshShell.CreateShortcut("$desktopPath\Thunderbird.lnk").TargetPath = "$installPath\Mozilla Thunderbird\thunderbird.exe"
$WshShell.CreateShortcut("$desktopPath\AnyDesk.lnk").TargetPath = "$installPath\AnyDesk\AnyDesk.exe"
$WshShell.CreateShortcut("$desktopPath\SSHFS-Win-Manager.lnk").TargetPath = "$installPath\SSHFS-Win-Manager\sshfs-wi
