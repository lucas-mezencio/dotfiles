-- Tile the main Steam client and Friends List
o.window({ class = "steam", title = "^Steam$" }, { float = false, tile = true })
o.window({ class = "steam", title = "^Friends List$" }, { float = false, tile = true })

-- Keep Steam's right-click context menus and popups floating
-- (they have empty titles; this is independent of Omarchy defaults)
o.window({ class = "steam", title = "^$" }, { float = true })