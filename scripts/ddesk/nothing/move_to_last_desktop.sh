#!/bin/sh

# make sure you have https://imgur.com/a/s1wPArz a setup to save like cache so this woorks 

# Define the file where we store the number of the last desktop.
# Using the .cache directory is good practice for temporary data.
LAST_DESKTOP_FILE="$HOME/.cache/last_desktop"

# Check if the file exists and has something in it.
if [ -s "$LAST_DESKTOP_FILE" ]; then
    # Read the desktop number from the file.
    PREV_DESKTOP=$(cat "$LAST_DESKTOP_FILE")
    
    # Before we jump, save our CURRENT location so we can come back again.
    xdotool get_desktop > "$LAST_DESKTOP_FILE"

    # Go to the previously saved desktop.
    xdotool set_desktop "$PREV_DESKTOP"
fi
