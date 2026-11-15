-- core/format.lua
-- Turns numbers into text for the screen. No UI here, so dev/check_slayer.lua can test it.

local Format = {}

-- A whole number in groups of three digits, as the game shows them: 19249 -> "19 249". A fraction is dropped.
function Format.credits(amount)
    local digits = tostring(math.floor(tonumber(amount) or 0))
    local sign = ""
    if string.sub(digits, 1, 1) == "-" then
        sign, digits = "-", string.sub(digits, 2)
    end
    local grouped = string.gsub(string.reverse(digits), "(%d%d%d)", "%1 ")
    grouped = string.gsub(string.reverse(grouped), "^ ", "")
    return sign .. grouped
end

return Format
