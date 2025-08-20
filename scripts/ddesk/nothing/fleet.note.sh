#!/bin/bash

# Define the target directory for your fleeting notes
FLEET_DIR="/home/dex/fleet"

# Check if the Fleet directory exists, create it if it doesn't
if [ ! -d "$FLEET_DIR" ]; then
  mkdir -p "$FLEET_DIR"
  echo "Created directory: $FLEET_DIR"
fi

# Get the current date and time in YYYY-MM-DD_HH-MM-SS format
FILENAME=$(date +%Y-%m-%d_%H-%M-%S).fleet.md
FULL_PATH="$FLEET_DIR/$FILENAME"

# Launch Alacritty and open the new file in nvim
# The -e or --command argument tells Alacritty to execute the specified command.
# We use sh -c "..." to ensure proper command parsing within Alacritty.
alacritty -e sh -c "cd '$FLEET_DIR' && nvim '$FILENAME'" &
