if application "Sioyek" is not running then
	do shell script "open -a Sioyek"
else
	tell application "Sioyek"
		activate
	end tell
end if
