-- core/settings.lua
-- Plugin-wide options the player can switch on and off (the settings page is in
-- ui/settingspage.lua). They are saved once for the whole plugin, not per character.
--
-- Other files ask with Settings.get("glow"). The difficulty is not here: it is chosen per
-- character and lives in that character's collection (see core/storage.lua).

local Settings = {}

local KEY = "card_settings"

-- Every option, with what it does and whether it starts on, in the order they are listed on the
-- settings page. A `dev` option is only shown while the development tools are there (the dev
-- folder, which the released plugin leaves out). PrettyUI cuts a checkbox's label off at about
-- 35 characters (it doesn't wrap), so keep labels shorter than that.
Settings.options = {
    { id = "glow", label = "Glow behind rare cards when flipped", default = true },
    { id = "burst", label = "Colour burst as a card is revealed", default = true },
    { id = "releasePreview", label = "Preview as released", default = false, dev = true },
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
