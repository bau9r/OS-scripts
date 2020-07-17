# ************************************ 
# script for configure Windows 10
# ************************************

# allow run scripts on this machine
# Set-ExecutionPolicy ByPass

# set time zone
tzutil /s "FLE Standard Time"

# sync time
w32tm /resync

# set power button action = hibernate when computer is plugged in
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 2

# set power button action = hibernate when computer is on battery
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 2

# set lid switch close action = hibernate when computer is plugged in
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 2

# set lid switch close action = hibernate when computer is on battery
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 2

# set sleep button action = hibernate when computer is plugged in
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 2

# set sleep button action = hibernate when computer is on battery
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 2

# apply all the powercfg changes
powercfg -SetActive SCHEME_CURRENT

# create local user
net user comp060 /add /active:yes /logonpasswordchg:no

# configure users
set-localuser -Name sadm -Password (ConvertTo-SecureString iGRUFjmB7Jhm -AsPlainText -Force)
set-localuser -Name comp060 -Password (ConvertTo-SecureString zXAnqAYk9Z6r -AsPlainText -Force) -PasswordNeverExpires 1 -UserMayChangePassword 0


# set hostname
rename-computer -newname comp060

# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; `
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
# install and configure saltstack
choco install saltminion --params="'/master:sm.fwtg.pp.ua /minion-name:comp060'" -Force -Y
$Text= gc 'C:\salt\conf\minion' -Raw
$Text-replace('\#id\:', 'id: comp060') | Set-Content 'C:\salt\conf\minion'
"comp060" | Set-Content 'C:\salt\conf\minion_id'
"default" | Set-Content 'C:\salt\conf\nickname'

# install software
choco install googlechrome -Y
choco install firefox -Y
choco install adobereader --version=11.0.02 -Y -Force --allow-empty-checksums
choco install filezilla -Y
choco install git -Y
choco install notepadplusplus -Y
choco install winrar -Y
choco install google-backup-and-sync -Y
choco install openvpn -Y
# choco install slack -Y
# choco install teamvewer -Y
choco install veracrypt -Y


# configure hardware monitoring tools
Copy-Item -Path "C:\telegraf-win\OpenHardwareMonitor\" -Destination "C:\Program Files\" -Recurse
Copy-Item -Path "C:\telegraf-win\telegraf\" -Destination "C:\Program Files\" -Recurse
Copy-Item -Path "C:\telegraf-win\Install\" -Destination "C:\" -Recurse
Copy-Item -Path "C:\telegraf-win\telegraf.conf" -Destination "C:\Program Files\telegraf" -Force
schtasks.exe /Create /TN openhardwaremonitor /RU "SYSTEM" /XML "C:\Program Files\OpenHardwareMonitor\openhardwaremonitor.xml"
schtasks.exe /Run /TN openhardwaremonitor
C:/"Program Files"/telegraf/telegraf.exe --service install

# clear downloads folder for sadm
Remove-Item -Path "C:\Users\sadm\Downloads\*" -Recurse

# deny run scripts on this machine
Set-ExecutionPolicy Undefined -Force
