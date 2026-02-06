#!/bin/bash
open -a "/Applications/Microsoft Teams.app";

# osascript -e 'tell application "Microsoft Teams" to activate'

# osascript -e 'tell application "Microsoft Teams" to activate'

# teams_displayed_window=$(yabai -m query --windows | jq '.[] | select(.app == "Microsoft Teams") | .display')
#
# echo $teams_displayed_window
#
# if [ "$teams_displayed_window" == "1" ]; then
#   /opt/homebrew/bin/cliclick c:566,671
# fi
#
# if [ "$teams_displayed_window" == "2" ]; then
#   # /opt/homebrew/bin/cliclick c:2872,481
#   /opt/homebrew/bin/cliclick c:3204,741
# fi
#
