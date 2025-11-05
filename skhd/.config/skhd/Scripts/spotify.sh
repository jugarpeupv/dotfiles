#!/bin/bash

open "/Applications/Spotify.app";

spotify_window=$(yabai -m query --windows | jq '.[] | select(.app == "Spotify") | .display')

echo $spotify_window

if [ "$spotify_window" == "1" ]; then
  /opt/homebrew/bin/cliclick c:566,671
fi

if [ "$spotify_window" == "2" ]; then
  /opt/homebrew/bin/cliclick c:2386,86
fi

