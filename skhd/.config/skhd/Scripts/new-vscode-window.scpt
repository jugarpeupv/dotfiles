if application "Code" is not running then
  do shell script "zsh ~/.config/skhd/Scripts/vscode.sh"
else
    tell application "Code"
        activate
    end tell
end if
