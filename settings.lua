-- settings.lua
-- Plugin-wide options the player can switch on and off (the settings page is in
-- settingspage.lua). They are saved once for the whole plugin, not per character.
--
-- Other files ask with Settings.get("shine"). The difficulty is not here: it is chosen per
-- character and lives in that character's collection (see storage.lua).

local Settings = {}

local KEY = "card_settings"

-- Every option, with what it does and whether it starts on. `order` is the order they are
-- listed on the settings page.
Settings.options = {
    { id = "shine", label = "Holo and reverse holo shine", default = true },
    { id = "glow", label = "Glow behind rare cards when flipped", default = true },
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
