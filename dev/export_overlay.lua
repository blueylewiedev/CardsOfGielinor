-- dev/export_overlay.lua
-- Writes every live card of the deck as one line of JSON, by id (see dev/overlay_lines.lua). The overlay is made
-- from two of these: the deck at the last approved version and the deck now (dev/build_overlay.py).
--
-- Run from the root of a plugin folder (this script can sit in a different checkout from the folder it is run
-- in, so an older version of the deck can be exported with this version of the script):
--     lua dev/export_overlay.lua            the lines go to the screen
--     lua dev/export_overlay.lua FILE       the lines go to FILE

local here = (arg and arg[0] or ""):match("^(.*)[/\\][^/\\]*$") or "."
package.path = "./?.lua;" .. here .. "/?.lua;" .. package.path

function log() end          -- the client's log function

local Cards = require("core/cards")
local Lines = require("overlay_lines")

local ok, lines = pcall(Lines.cards, Cards)
if not ok then
    io.stderr:write("Cannot export the deck: " .. tostring(lines) .. "\n")
    os.exit(1)
end
local problems = Cards.loadProblems or {}          -- (an older version of the deck has no such list)
if #problems > 0 then
    io.stderr:write("The deck has " .. #problems .. " problem(s) and those cards are not exported; the first: "
        .. problems[1] .. "\n")
end

local text = table.concat(lines, "\n") .. "\n"
if arg[1] then
    local file, err = io.open(arg[1], "wb")
    if file == nil then
        io.stderr:write("Cannot write " .. arg[1] .. ": " .. tostring(err) .. "\n")
        os.exit(1)
    end
    file:write(text)
    file:close()
    io.stderr:write(#lines .. " cards written to " .. arg[1] .. "\n")
else
    io.write(text)
end
