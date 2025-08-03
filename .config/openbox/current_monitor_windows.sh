#!/bin/bash

# --- Absolute paths to commands ---
WMCTRL="/bin/wmctrl"
GREP="/bin/grep"
SED="/bin/sed"
LOG_FILE="/home/dex/openbox_script.log"

# --- Start of Logging ---
# This creates a log file so we can see what's happening.
echo "--- Script started at $(date) by user $(whoami) ---" > "$LOG_FILE"
echo "--- DISPLAY variable is: $DISPLAY ---" >> "$LOG_FILE"

# --- Main Logic ---
echo '<openbox_pipe_menu>' >> "$LOG_FILE" # Log what we are about to output

# Use full paths for all commands
$WMCTRL -lG | $GREP -vE "pcmanfm-desktop|LXQt Panel" | while read -r W_ID D_ID X Y W H HOST TITLE; do
  
  if [ "$X" -lt "1920" ]; then
    
    SAFE
