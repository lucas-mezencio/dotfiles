#!/usr/bin/env bash

highest_ws=$(swaymsg -t get_workspaces | jq '[.[] | .num] | max')

current_ws=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .num')

if [[ $current_ws -eq $highest_ws ]] ; then
    workspace_dest=$((highest_ws + 1))
    swaymsg "move container to workspace number $workspace_dest; workspace number $workspace_dest"
else
    swaymsg "move container to workspace next; workspace next"
fi

