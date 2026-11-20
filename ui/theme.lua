-- ui/theme.lua
-- The colours the windows share (Vector4: each part 0 to 1), written once.

local Theme = {}

Theme.WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
Theme.GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
Theme.GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
Theme.DIM = Vector4.new(0.55, 0.55, 0.60, 1.0)                  -- text of a card the player does not have
Theme.PANEL_BACK = Vector4.new(0.08, 0.07, 0.06, 0.90)          -- the dark panel and brown border of the credits overlay and windows
Theme.PANEL_BORDER = Vector4.new(0.45, 0.36, 0.22, 0.95)
Theme.SELECTED_BORDER = Vector4.new(1.0, 1.0, 1.0, 0.95)

return Theme
