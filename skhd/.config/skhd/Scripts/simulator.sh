# Pass the PID as the 1st (and only) argument.
activateByPid()
{
  osascript -e "
    tell application \"System Events\"
      set frontmost of the first process whose unix id is ${1} to true
    end tell
  "
}

activateByPid $(pgrep -x 'qemu-system-aarch64');
