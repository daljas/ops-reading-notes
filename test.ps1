# Install Slack
Invoke-WebRequest -Uri "https://downloads.slack-edge.com/releases/windows/4.35.126/prod/x64/SlackSetup.exe" -OutFile "$env:admin\Downloads\SlackSetup.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\SlackSetup.exe"

# Install Zoom
Invoke-WebRequest -Uri "https://zoom.us/client/5.16.6.24712/ZoomInstallerFull.exe?archType=x64" -OutFile "$env:admin\Downloads\ZoomInstaller.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\ZoomInstaller.exe"

# Install AnyDesk
Invoke-WebRequest -Uri "https://anydesk.com/en/downloads/thank-you?dv=win_exe" -OutFile "$env:admin\Downloads\AnyDesk.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\AnyDesk.exe"
