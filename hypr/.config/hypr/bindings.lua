-- Personal keybinding overrides (loaded after Omarchy defaults).
-- See current bindings and descriptions: omarchy menu keybindings --print

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
o.bind("SUPER + SHIFT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
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

-- 9. Notifications (Quickshell IPC; SEMICOLON family is free in Omarchy defaults)
o.bind("SUPER + semicolon", "Dismiss last notification", "omarchy-shell notifications dismissOne")
o.bind("SUPER + SHIFT + semicolon", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
o.bind("SUPER + CTRL + semicolon", "Toggle DND", "omarchy-toggle-notification-silencing")
o.bind("SUPER + ALT + semicolon", "Invoke last notification", "omarchy-shell notifications invokeLast")
o.bind("SUPER + SHIFT + ALT + semicolon", "Notification history", "omarchy-shell notifications showHistory")
