#!/bin/bash

WEEK=$(date +%U)
DATE="$WEEK $(date +"%a, %d at %H:%M")"
THIS="W$WEEK $DATE"

THE_TEXT="

-------------------------------------------
$THIS
-------------------------------------------
**Noter**:Manages_knowledge_and_infomration
-------------------------------------------

"

echo "$THE_TEXT" | xclip -se c

sleep 0.1
xdotool key --clearmodifiers Ctrl+v




