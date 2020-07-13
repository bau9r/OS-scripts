#!/bin/bash

# Install brew packet manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# set hostname
scutil --set HostName compXXX

# set power settings, hibernation at power button and lid switch
pmset -a hibernatemode 25
pmset -a standbydelay 10
pmset -a destroyfvkeyonstandby 1

# install iStats
gem install iStats

#install telegraf
brew install telegraf

# configure hardware monitoring tools
cp /telegraf-for-mac/telegraf.conf /usr/local/etc/
cp /telegraf-for-mac/mtmi.sh /usr/local/etc/
cp /telegraf-for-mac/mtct.sh /usr/local/etc/
cp /telegraf-for-mac/mtbt.sh /usr/local/etc/
cp /telegraf-for-mac/macos_istats_settings.rb /Library/Ruby/Gems/2.3.0/gems/iStats-1.6.1/lib/iStats/
cp /telegraf-for-mac/com.mxcl.telegraf.plist /Library/LaunchDaemons/
launchctl load /Library/LaunchDaemons/com.mxcl.telegraf.plist

