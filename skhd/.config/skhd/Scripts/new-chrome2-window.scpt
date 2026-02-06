-- tell application "System Events" to tell process "Google Chrome"
--     perform action "AXRaise" of window 2
--     set frontmost to true
--     keystroke "º" using {command down}
-- end tell

if application "Google Chrome" is not running then
  -- activate application "Brave"
  do shell script "open \"/Applications/Google Chrome.app\";"

else
    -- tell application "Google Chrome"
    --     activate
    --     tell application "System Events"
    --         keystroke "l" using {command down}
    --         -- keystroke "l" using {command down, option down, shift down}
    --         key code 53
    --         key code 53
    --         key code 53
    --         -- key code 53
    --     end tell
    -- end tell

    tell application "Google Chrome"
        activate
    end tell

    -- delay 0.05
    --
    tell application "System Events" to tell process "Google Chrome"
            key code 126 using {command down, option down}
            -- keystroke "l" using {command down, option down}
            -- keystroke "l" using {command down, option down, shift down}
            key code 53
            key code 53
    end tell
end if




-- In AppleScript, you can send Command + Option + Up Arrow like this:
--
-- ```applescript
-- tell application "System Events"
-- key code 126 using {command down, option down}
-- end tell
-- ```
--
-- Or using the more explicit syntax:
--
-- ```applescript
-- tell application "System Events"
-- keystroke (ASCII character 30) using {command down, option down}
-- end tell
-- ```
--
-- ## Key Code Reference
--
-- - **Up Arrow**: `key code 126`
-- - **Down Arrow**: `key code 125`
-- - **Left Arrow**: `key code 123`
-- - **Right Arrow**: `key code 124`
--
-- ## Modifier Keys
--
-- - `command down` - Command/Cmd key
-- - `option down` - Option/Alt key
-- - `control down` - Control/Ctrl key
-- - `shift down` - Shift key
