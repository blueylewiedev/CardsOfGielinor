-- core/settings.lua
-- Plugin-wide options the player can switch (ui/settingspage.lua), saved once for the whole plugin, read with
-- Settings.get("glow"). Per-character things are not here: they live in that character's collection
-- (core/storage.lua).

local Settings = {}

local KEY = "card_settings"

-- Every option, with its default, in the order of the settings page. A `dev` option shows only in the development
-- copy; a `hidden` one is remembered but not listed (a button changes it). PrettyUI cuts a checkbox label off at
-- about 35 characters, so keep labels shorter.
Settings.options = {
    { id = "glow", label = "Glow behind rare cards", default = true },
    { id = "burst", label = "Colour burst on card reveal", default = true },
    { id = "shine", label = "Shine on foil cards", default = true },
    { id = "releasePreview", label = "Preview as released", default = false, dev = true },
    { id = "creditsWindow", label = "Show the credits overlay", default = true },
    { id = "debugLogging", label = "Detailed logging for bug reports", default = false },
    { id = "mainOpen", label = "Open the main window at start", default = true, hidden = true },
    { id = "tutorialSeen", label = "The tutorial has been shown", default = false, hidden = true },
}

local values = {}
for _, option in ipairs(Settings.options) do
    values[option.id] = option.default
end

-- Reads the saved options. Anything missing or not true/false keeps its default.
function Settings.load()
    local saved = PersistentDB:GetStructuredData(KEY)
    if type(saved) == "table" then
        for _, option in ipairs(Settings.options) do
            if type(saved[option.id]) == "boolean" then
                values[option.id] = saved[option.id]
            end
        end
    end
end

-- True if the option is on. An unknown option counts as on.
function Settings.get(name)
    local value = values[name]
    if value == nil then
        return true
    end
    return value
end

-- Turns an option on or off and saves it.
function Settings.set(name, value)
    if values[name] == nil then
        return
    end
    values[name] = (value == true)
    local ok = PersistentDB:SetStructuredData(KEY, values)
    if not ok then
        log("settings save FAILED")
    end
end

return Settings
