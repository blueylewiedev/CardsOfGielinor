-- ui/bars.lua
-- A progress bar with a label and "owned / total (percent)" over it, for the Stats window: the label at the left and the
-- numbers at the right of one line, a thin bar under them that fills as the share grows.
--
--   local bar = Bars.new(parent, x, y, w, "Rare", colour, labelColour)   -- `colour` fills the bar
--   bar.set(owned, total)
--   bar.destroy()
-- A bar is Bars.HEIGHT tall.

local Kit = require("ui/kit")
local Format = require("core/format")

local Bars = {}

Bars.HEIGHT = 36

local LINE_H = 18
local BAR_H = 12
local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local TRACK = Vector4.new(0.16, 0.14, 0.12, 1.0)
local BORDER = Vector4.new(0.45, 0.36, 0.22, 0.95)
local GOLD_FILL = Vector4.new(0.85, 0.68, 0.16, 1.0)

-- A 0xRRGGBBAA colour number (as core/cards.lua keeps the rarity colours) as a Vector4.
function Bars.colour(hex)
    if type(hex) ~= "number" then
        return GOLD_FILL
    end
    return Vector4.new(((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, 1.0)
end

function Bars.new(parent, x, y, w, label, colour, labelColour)
    local bar = { parts = {} }
    local function rectangle(px, py, pw, ph, fill, rgba, thickness)
        local rect = ui.Rectangle.new(parent)
        rect:SetPos(px, py)
        rect:SetSize(pw, ph)
        rect.fill = fill
        if not fill then
            rect.outlineThickness = thickness or 1
        end
        rect.colour = rgba
        bar.parts[#bar.parts + 1] = rect
        return rect
    end
    -- A box as tall as the text, so the label at its top and the numbers at its bottom are level.
    bar.label = Kit.text(parent, x, y, w, LINE_H, label, labelColour or WHITE, ui.AlignMode.TOPLEFT)
    bar.value = Kit.text(parent, x, y, w, LINE_H, "", GREY, ui.AlignMode.BOTTOMRIGHT)
    local barY = y + LINE_H + 2
    rectangle(x, barY, w, BAR_H, true, TRACK)
    bar.fill = rectangle(x + 1, barY + 1, 1, BAR_H - 2, true, colour or GOLD_FILL)
    bar.fill.hidden = true
    rectangle(x, barY, w, BAR_H, false, BORDER)
    bar.inner = w - 2

    local shownText, shownWidth = nil, nil
    -- Shows `owned` of `total`: the numbers, and the bar filled to that share.
    function bar.set(owned, total)
        local percent = (total > 0) and (100 * owned / total) or 0
        local text = Format.credits(owned) .. " / " .. Format.credits(total) .. "   " .. string.format("%.1f", percent) .. "%"
        if text ~= shownText then
            shownText = text
            bar.value.content = text
        end
        local width = math.floor(bar.inner * ((total > 0) and (owned / total) or 0))
        if owned > 0 and width < 2 then
            width = 2                         -- a sliver shows at once
        end
        if width ~= shownWidth then
            shownWidth = width
            bar.fill.hidden = (width == 0)
            bar.fill:SetSize(math.max(width, 1), BAR_H - 2)
        end
    end

    function bar.destroy()
        for _, part in ipairs(bar.parts) do
            pcall(function() part:Destroy() end)
        end
        pcall(function() bar.label:Destroy() end)
        pcall(function() bar.value:Destroy() end)
        bar.parts = {}
    end
    return bar
end

return Bars
