#!/bin/sh
QUERY="$1"
if [ -z "$QUERY" ]; then
  # Fallback: show all addresses (or adjust as needed)
  QUERY="mapfre|izertis"
fi

LOGFILE="$HOME/.config/bin/neomutt/query_command.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') QUERY=$QUERY" >> "$LOGFILE"

CMD="notmuch address 'from:/$QUERY/'"
echo "$(date '+%Y-%m-%d %H:%M:%S') CMD=$CMD" >> "$LOGFILE"
{ echo ""; eval $CMD; }


