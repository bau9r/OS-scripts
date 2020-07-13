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

# apply all the powercfg changes
powercfg -SetActive SCHEME_CURRENT

# create local user
new-localuser -name compXXX

# configure users
set-localuser -Name sadm -Password (ConvertTo-SecureString <password> -AsPlainText -Force)
set-localuser -Name compXXX -Password (ConvertTo-SecureString <password> -AsPlainText -Force) -PasswordNeverExpires 1 -UserMayChangePassword 0

# set hostname
rename-computer -newname compXXX

# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; `
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
# install software
choco install googlechrome -Y
choco install firefox -Y
choco install adobereader -Y
choco install filezilla -Y
choco install git -Y
choco install notepadplusplus -Y
choco install winrar -Y
choco install google-backup-and-sync -Y
choco install veracrypt -Y
