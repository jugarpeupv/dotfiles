tell application "System Events"
    set zathuraProcList to (every process whose name is "zathura")
    if (count of zathuraProcList) = 0 then
        tell application "Terminal"
            do script "nohup zathura '/Users/jgarcia/Documents/ebook angular.pdf' &"
            delay 1 -- wait for the process to start
        end tell
    end if
end tell

on activate_open_instance()
  tell application "System Events"
    set zathuraProcList to a reference to (every process whose name is "zathura")
    repeat with proc in zathuraProcList
        set PID to proc's unix id 
        -- I needed to figure out if this is the instance of Zathura with the
        -- file on hand. And if it is, then focus on that window. Guess what?
        -- Apparently you cannot grab list of all windows for a process (through
        -- "System Events") if that process has fullscreen windows. It just not
        -- possible. You have to do something like:
        -- `tell application "zathura"`
        -- alas, Zathura is not a "Cocoa Application"
        -- so I had to run lsof for the process PID and strip down the output to contain only filenames 
        set myFiles to paragraphs of (do shell script "lsof -F -p " & PID & " | grep ^n/ | cut -c2-")
        tell proc 
          set frontmost to true
        end tell
        return true
    end repeat
  end tell
  
  return false
end activate_open_instance

activate_open_instance()


tell application "System Events" to tell process "Terminal"
    set frontmost to false
    delay 1 -- wait for the focus to change
end tell

tell application "Terminal"
    quit
end tell
