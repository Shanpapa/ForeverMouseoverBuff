-- Purpose: every text wrapped in L("...") has a distinct English entry with equal placeholders.
-- Input: the manifest's Lua sources and the registered English table; output: PASS/FAIL and exit status.
-- Invariants: no game, network or private data; German output is asserted by the other suites.
-- Debug: lua tests/test_locale_english.lua; the first offending key or entry is printed.
local SKIP = {["Locale.lua"] = true, ["LocaleEnglish.lua"] = true, ["FeberdinDiagnostics.lua"] = true}
local function fail(message) io.stderr:write("FAIL ", message, "\n"); os.exit(1) end
local function readAll(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local data = file:read("*a"); file:close()
    return data
end
local function manifestSources()
    local toc = assert(readAll("src/ForeverMouseoverBuff/ForeverMouseoverBuff.toc"), "manifest missing")
    local names = {}
    for line in toc:gmatch("[^\r\n]+") do
        local name = line:match("^(%S+%.lua)%s*$")
        if name and not SKIP[name] then names[#names + 1] = name end
    end
    return names
end
-- Decode the escapes a Lua source literal may use, so keys compare to runtime strings.
local escapes = {n = "\n", t = "\t", ["\\"] = "\\", ['"'] = '"', ["'"] = "'"}
local function decode(raw)
    return (raw:gsub("\\(.)", function(c) return escapes[c] or ("\\" .. c) end))
end
-- L("...") resolves a text; K("...") marks a key kept in a file-scope table and
-- resolved later through L(variable). Both are English-table keys.
local function scan(source, name, keys, order)
    for _, marker in ipairs({'L("', 'K("'}) do
        local position = 1
        while true do
            local start = source:find(marker, position, true)
            if not start then break end
            local index, raw = start + #marker, {}
            while true do
                local c = source:sub(index, index)
                if c == "" then fail(name .. ": unterminated " .. marker .. "...\") near byte " .. start) end
                if c == "\\" then raw[#raw + 1] = c .. source:sub(index + 1, index + 1); index = index + 2
                elseif c == '"' then break
                else raw[#raw + 1] = c; index = index + 1 end
            end
            local key = decode(table.concat(raw))
            if key == "" then fail(name .. ": empty " .. marker .. "\") near byte " .. start) end
            if not keys[key] then keys[key] = name; order[#order + 1] = key end
            position = index + 1
        end
    end
    if source:find("L('", 1, true) or source:find("K('", 1, true) then
        fail(name .. ": use double quotes inside L(...) and K(...) so this scanner sees the key")
    end
end
local function placeholders(text)
    local counts = {}
    for marker in text:gmatch("%%[sd%%]") do counts[marker] = (counts[marker] or 0) + 1 end
    return counts
end
local function samePlaceholders(a, b)
    local pa, pb = placeholders(a), placeholders(b)
    for marker, count in pairs(pa) do if pb[marker] ~= count then return false end end
    for marker, count in pairs(pb) do if pa[marker] ~= count then return false end end
    return true
end

local keys, order = {}, {}
for _, name in ipairs(manifestSources()) do
    local source = assert(readAll("src/ForeverMouseoverBuff/" .. name), name .. " missing")
    scan(source, name, keys, order)
end
assert(#order >= 50, "scanner found only " .. #order .. " wrapped keys; the scan itself is suspect")

local ns = {db = {}}
_G.GetLocale = function() return "enUS" end
assert(loadfile("src/ForeverMouseoverBuff/Locale.lua"))("ForeverMouseoverBuff", ns)
local english = loadfile("src/ForeverMouseoverBuff/LocaleEnglish.lua")
if not english then fail("src/ForeverMouseoverBuff/LocaleEnglish.lua is missing") end
english("ForeverMouseoverBuff", ns)
local entries = ns.Locale.Entries("en")
local missing, identical, mismatched = 0, 0, 0
for _, key in ipairs(order) do
    local text = entries[key]
    if text == nil then missing = missing + 1; io.stderr:write("MISSING ", keys[key], ": ", key, "\n")
    elseif text == key then identical = identical + 1; io.stderr:write("UNTRANSLATED ", keys[key], ": ", key, "\n")
    elseif not samePlaceholders(key, text) then mismatched = mismatched + 1; io.stderr:write("PLACEHOLDERS ", keys[key], ": ", key, "\n") end
    if text ~= nil and ns.L[key] ~= text then fail("lookup does not return the entry for: " .. key) end
end
local stray = 0
for key in pairs(entries) do
    if not keys[key] then stray = stray + 1; io.stderr:write("STRAY entry (no L(...) uses it): ", key, "\n") end
end
_G.GetLocale = function() return "deDE" end
for _, key in ipairs(order) do
    if ns.L[key] ~= key then fail("German must return the key unchanged: " .. key) end
end
if missing + identical + mismatched + stray > 0 then
    fail(string.format("%d missing, %d untranslated, %d placeholder mismatches, %d stray entries",
        missing, identical, mismatched, stray))
end
print(string.format("PASS %d wrapped keys all have distinct English entries with equal placeholders; no stray entries", #order))
