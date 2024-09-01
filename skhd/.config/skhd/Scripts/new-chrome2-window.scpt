tell application "System Events" to tell process "Google Chrome"
    perform action "AXRaise" of window 2
    set frontmost to true
    keystroke "º" using {command down}
end tell

