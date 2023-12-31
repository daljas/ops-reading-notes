# Install Slack
Invoke-WebRequest -Uri "https://downloads.slack-edge.com/releases/windows/4.35.126/prod/x64/SlackSetup.exe" -OutFile "$env:USERPROFILE\Downloads\SlackSetup.exe" -UseBasicParsing
Start-Process -Wait -FilePath "$env:USERPROFILE\Downloads\SlackSetup.exe"

# Install Zoom
Invoke-WebRequest -Uri "https://zoom.us/client/5.16.6.24712/ZoomInstallerFull.exe?archType=x64" -OutFile "$env:USERPROFILE\Downloads\ZoomInstaller.exe" -UseBasicParsing
Start-Process -Wait -FilePath "$env:USERPROFILE\Downloads\ZoomInstaller.exe"

# Install AnyDesk
Invoke-WebRequest -Uri "https://anydesk.com/en/downloads/thank-you?dv=win_exe" -OutFile "$env:USERPROFILE\Downloads\AnyDesk.exe" -UseBasicParsing
Start-Process -Wait -FilePath "$env:USERPROFILE\Downloads\AnyDesk.exe"
