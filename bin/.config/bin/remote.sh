#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: remote <server>"
  exit 1
fi
ps cax | grep lemonade > /dev/null
if [ $? -eq 0 ]; then
  echo "lemonade is running."
else
  echo "lemonade is not running."
  # nohup lemonade server > /dev/null 2>&1 &
  lemonade server -allow 127.0.0.1 &
fi
ssh -R 2489:127.0.0.1:2489 $1

# ssh -R 2489:127.0.0.1:2489 remote.server.com
#
# then chmod +x ~/bin/remote
#
#   when you type `remote` it will open lemonade server locally, ssh tunnel the lemonade clipboard port.  
#
#   locally (like on my mac)  cmd-C to copy something.
#
#   this works between any two computers, even if one of them is a vm on the same machine 
#
#   remote -  $> lemonade paste
#
#   OR use the amazing neovim which has built-in lemonade support and just type "p" in neovim to paste the contents
#   of your local clipboard to your remote neovim session buffer.
#
#   for bonus points, modify the script to use a variable to invoke it with the remote server name:
