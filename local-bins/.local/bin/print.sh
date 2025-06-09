#!/bin/env bash

timestamp=$(date '+%Y-%M-%d_%H-%M-%S')
name="screenshot_$timestamp"

grim -g "$(slurp -d)" - | tee ~/Pictures/Screenshots/$name.png | wl-copy
