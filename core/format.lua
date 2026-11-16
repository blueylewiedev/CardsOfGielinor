-- core/format.lua
-- Turns numbers and states into text for the screen. No UI here, so dev/check_slayer.lua and dev/check_format.lua
-- can test it.

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

-- What the settings page says about how the collection is saved, as a short line that fits beside an icon (28 letters
-- at most) and the longer explanation for the icon's tooltip. `kind` is how this session's collection is saved
-- ("tracking", "name" or nil while the collection is still loading) and `granted` is whether the Tracking permission is on now.
-- How the collection is saved is fixed at login, so when the two disagree the permission was changed since, and
-- takes effect at the next login. The permission is called Tracking, as the client's permission window calls it.
function Format.collectionLine(kind, granted)
    if kind == "tracking" and granted then
        return "Saved by tracking id",
            "Your collection is saved under your character's tracking id, so it stays with you if you rename your character."
    elseif kind == "tracking" then
        return "Changes at next login",
            "Tracking is off. From your next login your collection is saved under your character name. "
            .. "Turn Tracking on again to return to the collection saved under your tracking id."
    elseif kind == "name" and granted then
        return "Changes at next login",
            "Tracking is on. From your next login your collection is saved under your tracking id, so it survives "
            .. "a rename. The collection you have now is copied across."
    elseif kind == "name" then
        return "Saved by character name",
            "Your collection is saved under your character name. Turn on Tracking in this plugin's permissions "
            .. "to keep it if you rename your character."
    end
    return "Loading...", "Your collection is loading. This line says how it is saved once it has."
end

return Format
