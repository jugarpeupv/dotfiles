tell application "System Events"
  set visible of every process whose visible is true and name is not "Kitty" and name is not "Slack" and name is not "MSTeams" and name is not "OBS" to false
end tell

-- tell application "Kitty" to activate

do shell script "bash ~/.config/skhd/Scripts/kitty.sh"
