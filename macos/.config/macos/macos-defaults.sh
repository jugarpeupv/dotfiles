#!/bin/bash

# Disable Mission Control / Spaces Ctrl+Arrow shortcuts (34/35) and Input Sources (60/61)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 35 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "<dict><key>enabled</key><false/></dict>"
# Unbind Input Sources: 60 = Select previous input source, 61 = Select next source in Input menu
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"


# Do not store gpg info in keychain
defaults write org.gpgtools.common DisableKeychain -bool yes


# Move focus to next window: Cmd+º (keycode 10 = non_us_backslash, Karabiner remaps physical º)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>65535</integer><integer>10</integer><integer>1048576</integer></array></dict></dict>"

# Key repeat: fast repeat, short delay until repeat
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

defaults write com.apple.finder AppleShowAllFiles -bool true

# Scroll direction: disable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Apply shortcut changes without restarting
/System/Library/PrivateFrameworks/SystemAdministration.framework/Versions/A/Resources/activateSettings -u 2>/dev/null || \
  /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
# Flush prefs cache so `defaults read` and System Settings see the change
killall cfprefsd 2>/dev/null || true
# Close System Settings so it re-reads on next open (otherwise UI shows stale state)
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
killall "System Settings" 2>/dev/null || true

echo "macOS defaults applied. Quit and reopen System Settings to verify; some shortcuts need log-out/in."
