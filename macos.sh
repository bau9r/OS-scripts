#--------------------------------------------
#
# Script for configure MacOS
#
#-------------------------------------------
#
# Made by Artem Listopad
# comment line
#-------------------------------------------


#!/bin/bash


USERCOMP_NAME="comp066"
USERCOMP_PASSWORD="SpGbSrQDQsUW"
SADM_PASSWORD="7yF2xMqS2mFt"
NICKNAME="shark"

# Install brew packet manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null

# set hostname
echo $USERCOMP_PASSWORD | sudo -S scutil --set HostName $USERCOMP_NAME

# set power settings, hibernation at power button and lid switch
sudo pmset -a hibernatemode 25
sudo pmset -a standbydelay 10
sudo pmset -a destroyfvkeyonstandby 1

# install and configure saltstack
brew install saltstack
sudo cp -R /usr/local/etc/saltstack/ /etc/salt
sudo sed -i '' 's/#master: salt/master: sm.fwtg.pp.ua/' /etc/salt/minion
sudo sed -i '' "s/#id:/id: $USERCOMP_NAME/" /etc/salt/minion
# echo "$USERCOMP_NAME" > /etc/salt/minion_id
sudo touch /etc/salt/nickname
sudo chmod o+w /etc/salt/nickname
sudo echo $NICKNAME > /etc/salt/nickname

# install iStats
sudo gem install iStats

# install software
brew cask install google-chrome
brew cask install 1password
brew cask install openvpn-connect
brew cask install tunnelblick
brew cask install slack
brew cask install teamviewer
brew cask install google-drive-file-stream
brew cask install screaming-frog-seo-spider
brew cask install skype
brew cask install telegram
brew cask install whatsapp
brew cask install zoom
brew cask install thunderbird

# install HMA Pro VPN
brew cask install hma-pro-vpn
cd /usr/local/Caskroom/hma-pro-vpn/latest/
sudo installer -pkg Install\ HMA\!\ Pro\ VPN.pkg -target /

# install telegraf
brew install telegraf

# configure hardware monitoring tools
cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/telegraf.conf /usr/local/etc/
cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/mtmi.sh /usr/local/etc/
cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/mtct.sh /usr/local/etc/
cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/mtbt.sh /usr/local/etc/
sudo cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/macos_istats_settings.rb /Library/Ruby/Gems/2.6.0/gems/iStats-1.6.1/lib/iStats/
sudo cp /Users/$USERCOMP_NAME/Downloads/telegraf-mac/com.mxcl.telegraf.plist /Library/LaunchDaemons/
launchctl load /Library/LaunchDaemons/com.mxcl.telegraf.plist

#install and activate Microsoft Office 
brew cask install microsoft-office
sudo installer -pkg Microsoft_Office_2019_VL_Serializer.pkg -target /

# create admin user
echo yes | sudo sysadminctl -addUser sadm -password $SADM_PASSWORD -admin

# set timezone
sudo systemsetup -settimezone Europe/Kiev
