on activate_open_instance()
  tell application "System Events"
    set denoProcList to a reference to (every process whose name is "deno")
    repeat with proc in denoProcList
        set PID to proc's unix id 
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
