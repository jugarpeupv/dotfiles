tell application "System Events"
  set visible of every process whose visible is true and name is not "Kitty" and name is not "Xcode" and name is not "Slack" and name is not "MSTeams" and name is not "Simulator" and name is not "OBS" and name is not "deno" to false
end tell

-- tell application "System Events"
--     repeat with proc in (every process whose visible is true and name is not "Kitty" and name is not "Xcode" and name is not "Slack" and name is not "MSTeams" and name is not "Simulator" and name is not "OBS" and name is not "deno")
--         tell proc
--             repeat with win in (every window)
--                 set frontmost to true
--                 keystroke "m" using {command down}
--             end repeat
--         end tell
--     end repeat
-- end tell
--
-- tell application "Kitty" to activate

-- do shell script "bash ~/.config/skhd/Scripts/kitty.sh"
