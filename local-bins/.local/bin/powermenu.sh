#!/bin/bash

# Define options for Wofi
# We use Sudo for reboot/shutdown, as these usually require root.
# You might need to configure sudoers for passwordless execution of these
# specific commands if you don't want to type a password each time.
# Or, rely on logind/polkit if your system is configured for it.
# Icons (optional, Nerd Fonts recommended):  Logout,  Suspend,  Lock,  Reboot,  Shutdown

ROFI=/usr/bin/wofi

OPTIONS="Logout\nSuspend\nLock Screen\nReboot\nShutdown"

# Prompt the user to select an option using Wofi
# Adjust Wofi parameters as needed (e.g., --style, --width, --height)
CHOICE=$(echo -e "$OPTIONS" | "$ROFI" --dmenu -prompt "Power Menu:" -insensitive)

# Execute the chosen action
case "$CHOICE" in
    "Logout")
        hyprctl dispatch exit
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Lock Screen")
        hyprlock
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    *)
        # If the user cancels or types something invalid, do nothing
        ;;
esac
