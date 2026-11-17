-- dev/check_kit_names.lua
-- Every function ui/kit.lua defines must have a name of its own: a second `function Kit.tabs` quietly replaces the first,
-- and whatever used the first breaks without any error until it is run (this happened once, with the tag picker).
--
-- Run from the plugin's folder:  lua dev/check_kit_names.lua

local seen, failures = {}, 0
local lineNumber = 0
for line in io.lines("ui/kit.lua") do
    lineNumber = lineNumber + 1
    local name = line:match("^function Kit%.([%w_]+)") or line:match("^Kit%.([%w_]+)%s*=")
    if name then
        if seen[name] then
            failures = failures + 1
            print("FAIL: Kit." .. name .. " is defined twice (lines " .. seen[name] .. " and " .. lineNumber .. ")")
        else
            seen[name] = lineNumber
        end
    end
end

if failures == 0 then
    print("OK: every Kit function is defined once")
else
    os.exit(1)
end
