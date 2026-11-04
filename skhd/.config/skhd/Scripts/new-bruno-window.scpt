if application "Bruno" is not running then
	do shell script "open -a Bruno"
else
	tell application "Bruno"
		activate
	end tell
end if
