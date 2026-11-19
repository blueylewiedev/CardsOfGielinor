-- dev/quiet.lua
-- The dev copy writes a lot to the client's console (every routine line the plugin writes while the dev tools are present,
-- the perf probe's PROBE lines, a line for each XP gain), which buries the lines you are looking for. This is one switch
-- for all of it, saved in PersistentDB, ON by default. Dev tools > Quiet console flips it, at once, no prl needed.
--
-- Quiet means the console keeps only
--   * failures (Logger.error), and the plugin's start-up milestones (Logger.note),
--   * what a dev tool button says in answer to being pressed (DEV, MEM, LAB, PROBE for the Perf probe button),
-- and drops the routine detail (Logger.debug), the automatic PROBE lines and the XP-gain lines. The player setting
-- "Detailed logging for bug reports" still turns the routine detail on, if it is ticked.
--
-- Dev copy only (this folder is not in the release).

local KEY = "dev_quiet-dev"            -- ends with the dev profile suffix, like the dev copy's other keys

local Quiet = { on = true }

do
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(KEY) end)
    if ok and type(saved) == "table" and saved.on == false then
        Quiet.on = false
    end
end

-- Applies the switch to the plugin's own logging: the dev copy always writes the routine detail, unless this is on.
function Quiet.apply()
    local ok, Logger = pcall(require, "core/logger")
    if ok and Logger ~= nil and Logger.setDevCopy ~= nil then
        Logger.setDevCopy(not Quiet.on)
    end
end

-- Flips it, saves it, applies it and says so.
function Quiet.toggle()
    Quiet.on = not Quiet.on
    pcall(function() PersistentDB:SetStructuredData(KEY, { on = Quiet.on }) end)
    Quiet.apply()
    log("DEV: the quiet console is now " .. (Quiet.on and "ON (only failures and what the dev buttons say)"
        or "OFF (every routine line is written)"))
    return Quiet.on
end

-- A line that is dropped while the console is quiet (the automatic ones). `loud` lines are always written.
function Quiet.line(text, loud)
    if loud or not Quiet.on then
        log(text)
    end
end

return Quiet
