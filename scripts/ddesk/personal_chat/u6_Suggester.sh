#!/bin/bash

WEEK=$(date +%U)
DATE="$WEEK $(date +"%a, %d at %H:%M")"
THIS="W$WEEK $DATE"

THE_TEXT="

--------------------------------------------
$THIS
--------------------------------------------
**Suggester**:Gives_Suggestions_and_says_why
--------------------------------------------

"

echo "$THE_TEXT" | xclip -se c

sleep 0.1
xdotool key --clearmodifiers Ctrl+v




