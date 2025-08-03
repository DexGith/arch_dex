#!/bin/bash

SCREENSHOT_DIR='/home/dex/Pictures/Screenshots/'

while true; do
	scrot -a 0,0,1920,1080 --silent "$SCREENSHOT_DIR"screenshot_%Y-%m-%d_%H-%M-%S.png

	sleep 30

done
