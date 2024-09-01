do shell script "open -a 'Mission Control'"
tell application "System Events" to click (every button whose value of attribute "AXDescription" is "add desktop") of group 2 of group 1 of group 1 of process "Dock"
delay 0.5
tell application "System Events" to key code 53
