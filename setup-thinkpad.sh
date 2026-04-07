#!/usr/bin/env bash
# setup-thinkpad.sh
# Dependency checker for the sway setup on Ubuntu 24.04 (work ThinkPad).
# Run this script to see what is missing — it installs nothing.
#
# Usage: bash ~/dotfiles/setup-thinkpad.sh

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

ok()      { printf "  ${GREEN}✓${RESET}  %s\n" "$1"; }
missing() { printf "  ${RED}✗${RESET}  %s\n" "$1"; MISSING_APT+=("$2"); }
manual()  { printf "  ${YELLOW}?${RESET}  %s\n" "$1"; MISSING_MANUAL+=("$2"); }
section() { printf "\n${BOLD}%s${RESET}\n" "$1"; }

MISSING_APT=()
MISSING_MANUAL=()

check_cmd() {
    local label="$1" cmd="$2" pkg="$3"
    if command -v "$cmd" &>/dev/null; then
        ok "$label  ($(command -v "$cmd"))"
    else
        missing "$label" "$pkg"
    fi
}

check_manual() {
    local label="$1" cmd="$2" note="$3"
    if command -v "$cmd" &>/dev/null; then
        ok "$label  ($(command -v "$cmd"))"
    else
        manual "$label — $note" "$note"
    fi
}

# ── Window manager & display ──────────────────────────────────────────────────
section "Window manager & display"

check_cmd "sway"      sway      sway
check_cmd "swaylock"  swaylock  swaylock
check_cmd "swayidle"  swayidle  swayidle
check_cmd "swaybg"    swaybg    swaybg
check_cmd "xwayland"  Xwayland  xwayland

# ── Notifications ─────────────────────────────────────────────────────────────
section "Notifications"

check_cmd "mako"         mako         mako-notifier
check_cmd "makoctl"      makoctl      mako-notifier
check_cmd "notify-send"  notify-send  libnotify-bin

# ── Status bar ────────────────────────────────────────────────────────────────
section "Status bar"

check_cmd "waybar"  waybar  waybar

# ── Night light ───────────────────────────────────────────────────────────────
section "Night light (blue-light filter)"

check_cmd "wlsunset"   wlsunset   wlsunset

# ── Audio (pipewire / wireplumber — same stack as omarchy) ───────────────────
section "Audio"

check_cmd "wpctl"      wpctl      wireplumber
check_cmd "pactl"      pactl      pipewire-pulse
check_cmd "playerctl"  playerctl  playerctl
check_cmd "pavucontrol" pavucontrol pavucontrol

# ── Brightness ────────────────────────────────────────────────────────────────
section "Brightness"

check_cmd "brightnessctl"  brightnessctl  brightnessctl

# ── Screenshot & clipboard ────────────────────────────────────────────────────
section "Screenshot & clipboard"

check_cmd "grim"      grim      grim
check_cmd "slurp"     slurp     slurp
check_cmd "wl-copy"   wl-copy   wl-clipboard

# ── App launcher (walker) ─────────────────────────────────────────────────────
section "App launcher"

check_manual "walker" walker \
    "download binary: https://github.com/abenz1267/walker/releases  →  ~/.local/bin/walker"

# ── Terminal ──────────────────────────────────────────────────────────────────
section "Terminal"

check_manual "ghostty" ghostty \
    "download .deb: https://github.com/ghostty-org/ghostty/releases"

# ── File manager & desktop integration ───────────────────────────────────────
section "Desktop integration"

check_cmd "nautilus"    nautilus    nautilus
check_cmd "xdg-open"    xdg-open    xdg-utils
check_cmd "xdg-mime"    xdg-mime    xdg-utils
check_cmd "dex"         dex         dex

# polkit agent (path check, not just command)
if [ -f /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    ok "polkit-gnome-agent  (/usr/lib/polkit-gnome/...)"
else
    missing "polkit-gnome-agent" policykit-1-gnome
fi

# ── Rust / Cargo ──────────────────────────────────────────────────────────────
section "Rust toolchain (needed to build walker from source)"

if command -v cargo &>/dev/null; then
    ok "cargo  ($(cargo --version))"
    ok "rustc  ($(rustc --version))"
else
    printf "  ${YELLOW}!${RESET}  cargo not found — install rustup:\n"
    printf "       curl -sSf https://sh.rustup.rs | sh\n"
    MISSING_MANUAL+=("rustup — https://rustup.rs")
fi

# ── Fonts ─────────────────────────────────────────────────────────────────────
section "Fonts"

if fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    ok "JetBrainsMono Nerd Font"
else
    printf "  ${RED}✗${RESET}  JetBrainsMono Nerd Font — needed by sway, waybar, swaylock, mako\n"
    MISSING_MANUAL+=("JetBrainsMono Nerd Font — https://www.nerdfonts.com/font-downloads  →  ~/.local/share/fonts/  then: fc-cache -fv")
fi

if fc-list | grep -qi "Font Awesome"; then
    ok "Font Awesome (waybar icons)"
else
    missing "Font Awesome (waybar icons)" fonts-font-awesome
fi

# ── Optional / nice-to-have ───────────────────────────────────────────────────
section "Optional"

# swayosd — on-screen display for volume/brightness (like omarchy uses)
if command -v swayosd-server &>/dev/null; then
    ok "swayosd  (OSD for volume/brightness)"
else
    printf "  ${YELLOW}-${RESET}  swayosd — not in Ubuntu repos; build from source:\n"
    printf "       https://github.com/ErikReider/SwayOSD\n"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
printf "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}\n"

if [ ${#MISSING_APT[@]} -eq 0 ] && [ ${#MISSING_MANUAL[@]} -eq 0 ]; then
    printf "${GREEN}All dependencies satisfied.${RESET}\n"
    printf "Run: ${BOLD}stow sway${RESET}  (from ~/dotfiles) to apply the config.\n"
else
    if [ ${#MISSING_APT[@]} -gt 0 ]; then
        printf "\n${BOLD}Install via apt:${RESET}\n"
        printf "  sudo apt install %s\n" "${MISSING_APT[*]}"
    fi

    if [ ${#MISSING_MANUAL[@]} -gt 0 ]; then
        printf "\n${BOLD}Install manually:${RESET}\n"
        for item in "${MISSING_MANUAL[@]}"; do
            printf "  • %s\n" "$item"
        done
    fi

    printf "\n${BOLD}After installing, re-run this script to verify.${RESET}\n"
    printf "Then: ${BOLD}stow sway${RESET}  (from ~/dotfiles)\n"
fi

printf "\n"
