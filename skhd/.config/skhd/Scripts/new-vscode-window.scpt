if application "Code" is not running then
  do shell script "zsh ~/.config/skhd/Scripts/vscode.sh"
else
    tell application "Code"
        activate
    end tell
end if


-- if application "Safari" is not running then
--   activate application "Safari"
-- else
--     tell application "Safari"
--         activate
--     end tell
-- end if
