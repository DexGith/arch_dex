#!/bin/sh

# The destination desktop number is the first argument passed to the script.
DESTINATION_DESKTOP="$1"

# --- SCRIPT LOGIC ---
# 1. Check if an argument was provided. If not, exit with an error.
if [ -z "$DESTINATION_DESKTOP" ]; then
    echo "Error: No destination desktop specified." >&2
    exit 1
fi

# 2. Define the file where we store the last desktop number.
LAST_DESKTOP_FILE="$HOME/.cache/last_desktop"

# 3. Get the desktop number we are currently on.
CURRENT_DESKTOP=$(xdotool get_desktop)

# 4. **THE SMART PART:** Only save the current desktop if we are
#    actually moving to a *different* desktop.
if [ "$CURRENT_DESKTOP" -ne "$DESTINATION_DESKTOP" ]; then
    echo "$CURRENT_DESKTOP" > "$LAST_DESKTOP_FILE"
fi

# 5. Finally, perform the switch to the destination.
xdotool set_desktop "$DESTINATION_DESKTOP"
