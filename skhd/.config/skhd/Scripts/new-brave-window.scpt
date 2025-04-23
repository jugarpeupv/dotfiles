
if application "Brave" is not running then
  -- activate application "Brave"
  do shell script "bash ~/.config/skhd/Scripts/brave.sh"
else
    delay 0.03
    tell application "Brave"
        activate
        tell application "System Events"
            keystroke "l" using {command down}
            key code 53 -- escape key
            -- simulate control tab
            -- key code 48 using {control down}
            -- key code 48 using {control down, shift down}
        end tell
    end tell
end if

