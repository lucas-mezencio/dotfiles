-- Personal keybinding overrides (loaded after Omarchy defaults).
-- See current bindings and descriptions: omarchy menu keybindings --print

-- Disable Omarchy's notification bindings (comma family in
-- /usr/share/omarchy/default/hypr/bindings/utilities.lua lines 24-28).
-- They stacked with the workspace vim-style overrides below and kept
-- triggering the notification handlers. We don't use notifications at all.
hl.unbind("SUPER + comma")
hl.unbind("SUPER + SHIFT + comma")
hl.unbind("SUPER + CTRL + comma")
hl.unbind("SUPER + ALT + comma")
hl.unbind("SUPER + SHIFT + ALT + comma")

-- 1. Kill Omarchy's "Monitor scaling up". SLASH stays unbound.
hl.unbind("SUPER + slash")
o.bind("SUPER + slash", "System menu", "omarchy menu")

-- 2. Workspace navigation (vim-style; lowercase comma/period to match xkbcommon keysyms)
hl.unbind("SUPER + CTRL + period")
o.bind("SUPER + comma", "Previous workspace", hl.dsp.focus({ workspace = "r-1" }))
o.bind("SUPER + period", "Next workspace", hl.dsp.focus({ workspace = "r+1" }))
o.bind("SUPER + CTRL + comma", "Move window to previous workspace", hl.dsp.window.move({ workspace = "r-1" }))
o.bind("SUPER + CTRL + period", "Move window to next workspace", hl.dsp.window.move({ workspace = "r+1" }))

-- 3. Vim-style focus / swap / resize (25px steps match Omarchy's "a little" increments)
hl.unbind("SUPER + J") -- Omarchy: Toggle window split
hl.unbind("SUPER + L") -- Omarchy: Toggle workspace layout
hl.unbind("SUPER + K") -- Omarchy: Keybindings menu (rebound on CTRL+ALT+K below)
hl.unbind("SUPER + CTRL + H") -- Omarchy: Group focus left (replaced by Swap left)
hl.unbind("SUPER + ALT + H")
hl.unbind("SUPER + ALT + J")
hl.unbind("SUPER + ALT + K")
hl.unbind("SUPER + ALT + L")
o.bind("SUPER + H", "Focus left", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + J", "Focus down", hl.dsp.focus({ direction = "d" }))
o.bind("SUPER + K", "Focus up", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + L", "Focus right", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + CTRL + H", "Swap left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + CTRL + J", "Swap down", hl.dsp.window.swap({ direction = "d" }))
o.bind("SUPER + CTRL + K", "Swap up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + CTRL + L", "Swap right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + ALT + H", "", hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
o.bind("SUPER + ALT + J", "", hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })
o.bind("SUPER + ALT + K", "", hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
o.bind("SUPER + ALT + L", "", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })

-- 4. Reallocate keys unbinded but lost
o.bind("SUPER + SHIFT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + CTRL + ALT + L", "Lock system", "omarchy system lock")

-- 5. Close window on SUPER + C (silently shadows Omarchy's Universal copy)
o.bind("SUPER + C", "Close window", hl.dsp.window.close())

-- 6. Helper menus
o.bind("SUPER + CTRL + ALT + K", "Keybindings helper", "omarchy menu keybindings")
o.bind("SUPER + M", "System menu", "omarchy menu toggle system")

-- 7. Screenrecording (gamepad-share safe)
hl.unbind("ALT + PRINT")
o.bind("SUPER + ALT + PRINT", "Screenrecording", "omarchy menu screenrecord")

-- 8. Scratchpad (your variant; Omarchy's SUPER+S toggle and SUPER+ALT+S move still bound)
o.bind("SUPER + SHIFT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad" }))

-- 9. Cross-monitor SHIFT (focus + window + workspace between monitors).
-- SHIFT acts as a "decorator" on top of the existing SUPER + HJKL/comma-period pattern:
--   SUPER            : focus direction / cycle workspace
--   SUPER + CTRL     : swap window / move window between workspaces
--   SUPER + SHIFT    : focus jumps to the adjacent monitor (direction or cycle)
--   SUPER + CTRL + SHIFT : active window moves to the adjacent monitor
--   SUPER + ALT + SHIFT  : current workspace itself moves to the adjacent monitor
-- Direction (H/L) and cycle (comma/period) are kept in parallel so the pattern holds for >2 monitors.
-- J/K are intentionally not bound here (reserved for future vertical-monitor layouts).
hl.unbind("SUPER + SHIFT + L") -- Omarchy: Swap window right (now Focus right monitor)
o.bind("SUPER + SHIFT + H", "Focus left monitor", hl.dsp.focus({ monitor = "l" }))
o.bind("SUPER + SHIFT + L", "Focus right monitor", hl.dsp.focus({ monitor = "r" }))
o.bind("SUPER + SHIFT + comma", "Focus previous monitor", hl.dsp.focus({ monitor = "-1" }))
o.bind("SUPER + SHIFT + period", "Focus next monitor", hl.dsp.focus({ monitor = "+1" }))
o.bind("SUPER + SHIFT + Z", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + CTRL + SHIFT + H", "Move window to left monitor", hl.dsp.window.move({ monitor = "l" }))
o.bind("SUPER + CTRL + SHIFT + L", "Move window to right monitor", hl.dsp.window.move({ monitor = "r" }))
o.bind("SUPER + CTRL + SHIFT + comma", "Move window to previous monitor", hl.dsp.window.move({ monitor = "-1" }))
o.bind("SUPER + CTRL + SHIFT + period", "Move window to next monitor", hl.dsp.window.move({ monitor = "+1" }))
o.bind("SUPER + ALT + SHIFT + comma", "Move workspace to previous monitor", hl.dsp.workspace.move({ monitor = "-1" }))
o.bind("SUPER + ALT + SHIFT + period", "Move workspace to next monitor", hl.dsp.workspace.move({ monitor = "+1" }))
