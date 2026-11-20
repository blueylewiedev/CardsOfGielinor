-- ui/util.lua
-- Small helpers the windows share.

local Util = {}

-- Hides or shows a component (a failure, such as a component that is already gone, is ignored).
function Util.setHidden(component, hidden)
    pcall(function() component.hidden = hidden end)
end

-- Sets a text's words only when they differ (so refreshing every tick does no needless work). A nil widget is ignored.
function Util.setText(widget, text)
    if widget ~= nil and widget.content ~= text then
        widget.content = text
    end
end

-- Destroys a component, if there is one.
function Util.destroy(component)
    if component ~= nil then
        pcall(function() component:Destroy() end)
    end
end

-- Destroys every component in `list`, last first, and empties it.
function Util.destroyAll(list)
    for index = #list, 1, -1 do
        pcall(function() list[index]:Destroy() end)
        list[index] = nil
    end
end

-- 0xRRGGBBAA as the Vector4 the components take; `alpha` (0 to 1) replaces the colour's own.
function Util.toVec4(hex, alpha)
    return Vector4.new(((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255,
        alpha or (hex & 0xFF) / 255)
end

function Util.clamp(value, low, high)
    return math.max(low, math.min(high, value))
end

-- A number the client gives, or nil if the call fails or gives something else (or 0 or less).
function Util.readNumber(read)
    local ok, value = pcall(read)
    return (ok and type(value) == "number" and value > 0) and value or nil
end

return Util
