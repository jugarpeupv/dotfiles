#!/bin/bash

open "/Applications/Google Chrome.app";

chrome_window=$(yabai -m query --windows | jq '.[] | select(.app == "Google Chrome") | .display')

if [ "$chrome_window" == "1" ]; then
  # /opt/homebrew/bin/cliclick c:52,164
  /opt/homebrew/bin/cliclick c:57,175
  # /opt/homebrew/bin/cliclick c:55,176
  # /opt/homebrew/bin/cliclick c:50,169
fi

if [ "$chrome_window" == "2" ]; then
  /opt/homebrew/bin/cliclick c:2361,109
fi

