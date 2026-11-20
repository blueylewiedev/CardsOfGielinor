-- dev/check_prettyui_auto.lua
-- Every PrettyUI component the plugin makes must say categoryID = "auto" in its options: PrettyUI's older allocation ("legacy") is
-- deprecated (it prints a notice when the plugin loads) and scans for a free id on every new component, which is slow enough that a few
-- hundred buttons at once ran past the client's one-second limit. This looks for a prettyui.<Widget>.new( call whose options, a few
-- lines around it, do not say so. The "Check cards" workflow runs it.
--
-- Run from the plugin's folder:  lua dev/check_prettyui_auto.lua

local files = {}
local list = io.popen("git ls-files main.lua core ui dev")
for line in list:lines() do
    if line:match("%.lua$") and not line:match("^dev/check_") and not line:match("^dev/fakeprettyui") and not line:match("parked_cards") then
        files[#files + 1] = line
    end
end
list:close()

local failures = 0
for _, path in ipairs(files) do
    local lines = {}
    for line in io.lines(path) do
        lines[#lines + 1] = line
    end
    for number, line in ipairs(lines) do
        if line:find("prettyui%.%w+%.new%(") and not line:match("^%s*%-%-") then
            local found = false
            for at = math.max(1, number - 8), math.min(#lines, number + 10) do
                if lines[at]:find('categoryID = "auto"', 1, true) then
                    found = true
                end
            end
            if not found then
                failures = failures + 1
                print("FAIL: " .. path .. ":" .. number .. " makes a PrettyUI component without categoryID = \"auto\"")
            end
        end
    end
end

if failures > 0 then
    os.exit(1)
end
print("OK: every PrettyUI component is made with categoryID = \"auto\"")
