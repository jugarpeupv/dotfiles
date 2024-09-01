if application "IntelliJ IDEA" is not running then
  do shell script "open -na 'IntelliJ IDEA CE.app'"
else
    tell application "IntelliJ IDEA"
        activate
    end tell
end if
