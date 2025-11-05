-- if application "Microsoft Teams (work or school)" is not running then
--   activate application "Microsoft Teams"
--   -- if windows is not {} then perform action "AXRaise" of item 1 of windows
-- else
--     tell application "Microsoft Teams"
--         activate
--     end tell
-- end if
--
-- delay 0.1
-- do shell script "/opt/homebrew/bin/cliclick c:."
-- do shell script "/opt/homebrew/bin/cliclick c:58,84"



do shell script "bash ~/.config/skhd/Scripts/teams.sh"

