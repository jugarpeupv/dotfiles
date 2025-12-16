-- tell application "System Events" to tell process "Google Chrome"
--     perform action "AXRaise" of window 2
--     set frontmost to true
--     keystroke "º" using {command down}
-- end tell

if application "Google Chrome" is not running then
  -- activate application "Brave"
  do shell script "open \"/Applications/Google Chrome.app\";"

else
    tell application "Google Chrome"
        activate
        tell application "System Events"
            keystroke "l" using {command down}
            -- keystroke "l" using {command down, option down, shift down}
            key code 53
            key code 53
            key code 53
            -- key code 53
        end tell
    end tell
end if

