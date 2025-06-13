#!/usr/bin/env bash

FOCUSED_WS=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .num')
PREVIOUS_WS=$((FOCUSED_WS - 1))
echo $PREVIOUS_WS
swaymsg "move container to workspace number $PREVIOUS_WS; workspace number $PREVIOUS_WS"

