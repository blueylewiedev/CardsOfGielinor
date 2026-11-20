-- dev/check_style.lua
-- Looks at how readable the shipped Lua is (main.lua, core/ and ui/) and says where it drifts from the house style in
-- CONTRIBUTING.md ("How the code is written"). It only WARNS: a long file or function is sometimes the right thing, so
-- this never fails the "Check cards" workflow. It exits 0 whatever it finds; read the list.
--
-- Run from the plugin's folder:  lua dev/check_style.lua            (the warnings and a summary)
--                                lua dev/check_style.lua --quiet    (the summary only)

local MAX_FILE = 450            -- lines in a file
local MAX_FUNCTION = 80         -- lines in a function
local MAX_COMMENT_SHARE = 12    -- percent of a file's non-blank lines that are comments (only checked above MIN_COMMENTS)
local MIN_COMMENTS = 25         -- ...so a short file with a proper header is left alone
local MAX_LINE = 140            -- columns

local quiet = arg ~= nil and arg[1] == "--quiet"

local files = {}
local list = io.popen("git ls-files main.lua core ui")
for line in list:lines() do
    if line:match("%.lua$") then
        files[#files + 1] = line
    end
end
list:close()
table.sort(files)

local warnings, byKind = {}, {}
local function warn(kind, path, line, text)
    warnings[#warnings + 1] = path .. (line and (":" .. line) or "") .. ": " .. text
    byKind[kind] = (byKind[kind] or 0) + 1
end

-- The length of each function, from the compiler's own listing (luac -l prints "function <file:first,last>").
local function functionLengths(path)
    local out = {}
    local listing = io.popen("luac -l -l -p " .. path .. " 2>&1")
    for line in listing:lines() do
        local first, last = line:match("^function <[^:]+:(%d+),(%d+)>")
        if first then
            out[#out + 1] = { first = tonumber(first), length = tonumber(last) - tonumber(first) + 1 }
        end
    end
    listing:close()
    os.remove("luac.out")
    return out
end

local totals = { files = 0, lines = 0, comments = 0, code = 0 }
for _, path in ipairs(files) do
    local count, comments, code, long, headed = 0, 0, 0, 0, false
    for line in io.lines(path) do
        count = count + 1
        if count == 1 then
            headed = line:match("^%-%-") ~= nil
        end
        local text = line:match("^%s*(.-)%s*$")
        if text ~= "" then
            if text:match("^%-%-") then comments = comments + 1 else code = code + 1 end
        end
        if #line > MAX_LINE then long = long + 1 end
    end
    totals.files, totals.lines = totals.files + 1, totals.lines + count
    totals.comments, totals.code = totals.comments + comments, totals.code + code
    if count > MAX_FILE then
        warn("long file", path, nil, count .. " lines (more than " .. MAX_FILE .. "): is it doing more than one job?")
    end
    if not headed then
        warn("no header", path, 1, "a file starts with a comment saying what it is for")
    end
    local share = 100 * comments // math.max(1, comments + code)
    if share > MAX_COMMENT_SHARE and comments > MIN_COMMENTS then
        warn("comment share", path, nil, share .. "% of its lines are comments (more than " .. MAX_COMMENT_SHARE
            .. "%): history and measurements belong in dev/DESIGN.md")
    end
    if long > 0 then
        warn("long lines", path, nil, long .. " lines are longer than " .. MAX_LINE .. " columns")
    end
    for _, fn in ipairs(functionLengths(path)) do
        if fn.length > MAX_FUNCTION then
            warn("long function", path, fn.first, "a function of " .. fn.length .. " lines (more than " .. MAX_FUNCTION .. ")")
        end
    end
end

if not quiet then
    for _, message in ipairs(warnings) do
        print("warning: " .. message)
    end
end
local kinds = {}
for kind, n in pairs(byKind) do
    kinds[#kinds + 1] = n .. " " .. kind
end
table.sort(kinds)
print(string.format("style: %d files, %d lines, %d%% comments; %d warnings%s", totals.files, totals.lines,
    100 * totals.comments // math.max(1, totals.comments + totals.code), #warnings,
    #kinds > 0 and (" (" .. table.concat(kinds, ", ") .. ")") or ""))
