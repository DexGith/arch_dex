#!/bin/bash

SCREENSHOT_DIR='/home/dex/Pictures/Screenshots/'

while true; do
	scrot -a 0,0,1920,1080 --silent "$SCREENSHOT_DIR"screenshot_%Y-%m-%d_%H-%M-%S.png

    # to know more about sleep check out `oo ""obsidian://open?vault=pg&file=bash~sleep"`
	sleep 2m

done
