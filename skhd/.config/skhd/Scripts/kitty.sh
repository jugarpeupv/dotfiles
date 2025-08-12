#!/bin/bash
# Get the list of application names on display 1
# display1_apps=$(yabai -m query --windows | jq -r '.[] | select(.display == 1 and .app != "kitty") | .app' | sort -u | awk '{printf "\"%s\", ", $0}' | sed 's/, $//')

display1_apps=$(yabai -m query --windows | jq -r ' [ .[] | select(.display == 1 and .app != "kitty") | .app ] | unique | map("\"" + . + "\"") | join(", ")')


display1_apps=${display1_apps//"Microsoft Teams"/"MSTeams"}

# Run the AppleScript with the dynamically populated list
osascript <<EOF
tell application "System Events"
    set display1Apps to {$display1_apps}
    -- display dialog "display1Apps: " & display1Apps as string

    repeat with proc in (every process whose visible is true)
        -- display dialog "proc: " & name of proc as string
        if name of proc is in display1Apps then
            -- display dialog "pasando por aqui: " & name of proc as string
            set visible of proc to false
        end if
    end repeat
end tell
EOF

open "/Applications/kitty.app"
