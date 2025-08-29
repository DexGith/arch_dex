#!/bin/bash

WEEK=$(date +%U)
DATE="$WEEK $(date +"%a, %d at %H:%M")"
THIS="W$WEEK $DATE"

THE_TEXT="

------------------------------------------------------
$THIS
------------------------------------------------------
**Watcher**:3rd_perspective_me_when_I_read_users_output
------------------------------------------------------

"

echo "$THE_TEXT" | xclip -se c

sleep 0.1
xdotool key --clearmodifiers Ctrl+v




