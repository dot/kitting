#!/usr/bin/env bash

# Command Line Tools for Xcode
xcode-select --install

# clone repo
WORKDIR=~/projects/github.com/dot/kitting
mkdir -p $WORKDIR
git clone https://github.com/dot/kitting.git $WORKDIR
cd $WORKDIR

# setup HomeBrew
if ! type brew >/dev/null 2>&1; then
  echo "start install and bundle brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/hoge/.zprofile
  eval $(/opt/homebrew/bin/brew shellenv)
fi
brew upgrade
cp Brewfile ~/.Brewfile
brew bundle --global

# setup VSCode
if type code >/dev/null 2>&1; then
  echo 'Setup VSCode'
  code --install-extension Shan.code-settings-sync --force
  echo "done"
fi

# restore via mackfile
if [ ! -e "~/.mackup.cfg" ]; then
  echo 'Setup Mackup'
  cat <<EOF > ~/.mackup.cfg
[storage]
engine = icloud
EOF
fi
cd $HOME
mackup restore -f

# setup OSX settings
sudo -v
killall System\ Preferences

# 起動音を消す
sudo nvram SystemAudioVolume=" "

# keyrepeat
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 15 # 150ms
defaults write -g KeyRepeat -int 2 # 15ms

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable auto capitalize
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Disable auto period insert
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable 'smart' quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# ネットワークボリュームに DS_Storeを作らない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# ライブラリフォルダを表示
sudo chflags nohidden ~/Library
sudo chflags nohidden /opt
sudo chflags nohidden /Volumes

# date and clock
defaults write com.apple.menuextra.clock 'DateFormat' -string 'M\u6708d\u65e5(EEE)  H:mm:ss'
defaults write com.apple.menuextra.clock FlashDateSeparators -bool true

# setup Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
# Don't show recents
defaults write com.apple.dock show-recents -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
#defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
#defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# ファンクションキーの設定
# see http://r7kamura.github.io/2014/08/03/as-standard-function-keys.html
defaults write -g com.apple.keyboard.fnState -bool true

# USB やネットワークストレージに .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# for Safari

# tremimnal
defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew"
defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

# touch pad behaviour
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1

#defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
# kill hardware chime for macbook when battery powered
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true

# restart
killall Finder
killall Dock
killall PowerChime
