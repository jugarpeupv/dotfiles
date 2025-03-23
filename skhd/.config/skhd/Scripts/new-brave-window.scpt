-- do shell script "bash ~/.config/skhd/Scripts/brave.sh"

if application "Brave" is not running then
  activate application "Brave"
else
    tell application "Brave"
        do shell script "defaults write com.apple.keyboard.fnState -bool true"
        activate
        tell application "System Events"
            keystroke "l" using {command down}
            key code 53 -- escape key
            do shell script "defaults write com.apple.keyboard.fnState -bool false"
        end tell
    end tell
end if

