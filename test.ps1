# Install Slack
Invoke-WebRequest -Uri "https://slack.com/downloads/windows" -OutFile "$env:USERPROFILE\Downloads\SlackSetup.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\SlackSetup.exe"

# Install Zoom
Invoke-WebRequest -Uri "https://zoom.us/client/latest/ZoomInstaller.exe" -OutFile "$env:USERPROFILE\Downloads\ZoomInstaller.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\ZoomInstaller.exe"

# Install AnyDesk
Invoke-WebRequest -Uri "https://download.anydesk.com/AnyDesk.exe" -OutFile "$env:USERPROFILE\Downloads\AnyDesk.exe" -UseBasicParsing; Start-Process -Wait -FilePath "$env:admin\Downloads\AnyDesk.exe"
