-- ZoneType: tells you which area types (Desert, Swamp, Haunted...) the place
-- you're standing in counts as, for Forever's area-bonus items.
--
-- The game doesn't expose area types through the API (as far as we know), so
-- the zone lists below are copied from the area lists in the Forever 1.60.1
-- game files. A place can belong to several types (Tirisfal Glades is Forest,
-- Wasteland and Haunted).

local ADDON_NAME = ...

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

local function Print(...)
    print("|cff33ff99ZoneType:|r", ...)
end

local function IsSecret(v)
    return issecretvalue ~= nil and issecretvalue(v)
end

-- Lowercase, drop punctuation and a leading "the " so small differences
-- ("The Barrens" vs "Barrens", ' vs ’) still match.
local function Normalize(name)
    if type(name) ~= "string" or name == "" or IsSecret(name) then return nil end
    local s = name:lower()
    s = s:gsub("\226\128\153", "")   -- curly apostrophe
    s = s:gsub("[%p]", "")
    s = s:gsub("%s+", " ")
    s = strtrim(s)
    s = s:gsub("^the ", "")
    if s == "" then return nil end
    return s
end

---------------------------------------------------------------------------
-- Data
---------------------------------------------------------------------------

-- Display order, label and chat color for each area type.
local TYPES = {
    { key = "swamp",    label = "Swamp",                 color = "ff5fa85f" },
    { key = "forest",   label = "Forest & Grassland",    color = "ff3fd23f" },
    { key = "waste",    label = "Wasteland",             color = "ffb08a5a" },
    { key = "haunted",  label = "Haunted",               color = "ffa78bd6" },
    { key = "mountain", label = "Mountainous",           color = "ffaaaaaa" },
    { key = "snowy",    label = "Snowy",                 color = "ffbfe8ff" },
    { key = "desert",   label = "Desert",                color = "ffffd060" },
    { key = "city",     label = "Strongholds & Cities",  color = "ff6fa8ff" },
    { key = "cave",     label = "Cavernous/Underground", color = "ffc08040" },
    { key = "volcanic", label = "Volcanic",              color = "ffff5030" },
}

local TYPE_BY_KEY = {}
for i, t in ipairs(TYPES) do t.order = i; TYPE_BY_KEY[t.key] = t end

-- Places for each type: open world first, then dungeons/raids/cities/towns.
-- Volcanic has no list in the game files yet, so it's empty on purpose.
local LISTS = {
    swamp = {
        "Darkshore", "Dustwallow Marsh", "Feralas", "Riverglades", "Swamp of Sorrows",
        "Un'Goro Crater", "Wetlands",
        "Excavation Site: Wetlands", "Maraudon", "The Drowned City", "The Shaper's Terrace",
        "The Temple of Atal'Hakkar", "Wailing Caverns",
    },
    forest = {
        "Arathi Highlands", "Ashenvale", "Azshara", "Darkshore", "Darkspear Islands", "Dun Morogh",
        "Duskwood", "Dustwallow Marsh", "Eastern Plaguelands", "Elwynn Forest", "Felwood", "Feralas",
        "Hillsbrad Foothills", "Loch Modan", "Moonglade", "Mount Hyjal", "Mulgore",
        "Redridge Mountains", "Riverglades", "Shen'dralas", "Silverpine Forest",
        "Stonetalon Mountains", "Stranglethorn Vale", "Swamp of Sorrows", "Teldrassil", "Thalanaar",
        "The Hinterlands", "Tirisfal Glades", "Un'Goro Crater", "Western Plaguelands", "Westfall",
        "Wetlands", "Winterspring", "Zephras Isle",
        "Alterac Valley", "Arathi Basin", "Blackmaw Hold", "Booty Bay", "Darnassus", "Dire Maul",
        "Excavation Site: Wetlands", "Gilneas", "Krol'dok Stronghold", "Ruins of Gilneas",
        "Shadowfang Keep", "Stormwind City", "The Shaper's Terrace", "Valanaar", "Warsong Gulch",
        "Zul'Gurub",
    },
    waste = {
        "Badlands", "Blasted Lands", "Burning Steppes", "Deadwind Pass", "Desolace", "Durotar",
        "Eastern Plaguelands", "Felwood", "Searing Gorge", "Shen'dralas", "Silithus",
        "Silverpine Forest", "Tanaris", "The Barrens", "Tirisfal Glades", "Western Plaguelands",
        "Westfall",
        "Orgrimmar", "Razorfen Downs", "Razorfen Kraul", "Ruins of Lordaeron", "Stratholme",
        "Undercity", "Zul'Farrak",
    },
    haunted = {
        "Deadwind Pass", "Duskwood", "Eastern Plaguelands", "Felwood", "Shen'dralas",
        "Silverpine Forest", "Swamp of Sorrows", "Tirisfal Glades", "Western Plaguelands",
        "Dire Maul", "Gilneas", "Maraudon", "Naxxramas", "Razorfen Downs", "Ruins of Gilneas",
        "Ruins of Lordaeron", "Scarlet Monastery", "Scholomance", "Shadowfang Keep", "Stratholme",
        "The Drowned City", "The Hall of Thanes", "The Temple of Atal'Hakkar", "Undercity",
        "Zul'Farrak", "Zul'Gurub",
    },
    mountain = {
        "Alterac Mountains", "Arathi Highlands", "Azshara", "Badlands", "Burning Steppes",
        "Deadwind Pass", "Dun Morogh", "Hillsbrad Foothills", "Loch Modan", "Mount Hyjal", "Mulgore",
        "Redridge Mountains", "Searing Gorge", "Stonetalon Mountains", "Stranglethorn Vale",
        "The Barrens", "The Hinterlands", "Thousand Needles", "Winterspring", "Zephras Isle",
        "Alterac Valley", "Arathi Basin", "Blackmaw Hold", "Blackrock Mountain",
        "Krol'dok Stronghold", "Thunder Bluff",
    },
    snowy = {
        "Alterac Mountains", "Dun Morogh", "Winterspring",
        "Alterac Valley",
    },
    desert = {
        "Badlands", "Blasted Lands", "Desolace", "Durotar", "Silithus", "Tanaris", "The Barrens",
        "Thousand Needles",
        "Ahn'Qiraj", "Gates of Ahn'Qiraj", "Orgrimmar", "Ruins of Ahn'Qiraj", "Temple of Ahn'Qiraj",
        "Uldaman", "Zul'Farrak",
    },
    city = {
        "Ahn'Qiraj", "Alcaz Prison", "Blackfathom Deeps", "Blackmaw Hold", "Blackrock Depths",
        "Blackrock Mountain", "Blackrock Spire", "Blackwing Lair", "Booty Bay", "City of Dalaran",
        "Darnassus", "Dire Maul", "Everlook", "Gadgetzan", "Gates of Ahn'Qiraj", "Gilneas",
        "Gnomeregan", "Ironforge", "Krol'dok Stronghold", "Naxxramas", "Orgrimmar",
        "Razorfen Downs", "Razorfen Kraul", "Ruins of Ahn'Qiraj", "Ruins of Gilneas",
        "Ruins of Lordaeron", "Scarlet Monastery", "Scholomance", "Shadowfang Keep",
        "Stormwind City", "Stratholme", "Temple of Ahn'Qiraj", "The Deadmines", "The Drowned City",
        "The Hall of Thanes", "The Stockade", "The Temple of Atal'Hakkar", "Thunder Bluff",
        "Uldaman", "Undercity", "Valanaar", "Warsong Gulch", "Zul'Farrak", "Zul'Gurub",
    },
    cave = {
        "Alcaz Prison", "Blackmaw Hold", "Blackrock Depths", "Blackrock Spire", "Blackwing Lair",
        "Gnomeregan", "Ironforge", "Maraudon", "Molten Core", "Onyxia's Lair", "Ragefire Chasm",
        "The Deadmines", "The Hall of Thanes", "The Stockade", "Uldaman", "Undercity",
        "Wailing Caverns",
    },
    volcanic = {},
}

-- PLACES[normalized name] = { name = "Display Name", types = { key = true, ... } }
local PLACES = {}
for key, names in pairs(LISTS) do
    for _, name in ipairs(names) do
        local n = Normalize(name)
        local p = PLACES[n]
        if not p then p = { name = name, types = {} }; PLACES[n] = p end
        p.types[key] = true
    end
end

-- Sorted list of type keys for a set like { desert = true, waste = true }
local function SortedKeys(set)
    local out = {}
    for k in pairs(set) do out[#out + 1] = k end
    table.sort(out, function(a, b) return TYPE_BY_KEY[a].order < TYPE_BY_KEY[b].order end)
    return out
end

local function TypeText(set)
    local parts = {}
    for _, k in ipairs(SortedKeys(set)) do
        local t = TYPE_BY_KEY[k]
        parts[#parts + 1] = "|c" .. t.color .. t.label .. "|r"
    end
    return table.concat(parts, ", ")
end

-- Everything the game says about where we are. Inside an instance the
-- zone text is the instance name; GetInstanceInfo is checked too in case
-- the two differ (Forever has surprised us with instance labels before).
local function GetLocationNames()
    local inInstance, instanceType = IsInInstance()
    local instName = GetInstanceInfo and select(1, GetInstanceInfo()) or nil
    return {
        zone     = GetRealZoneText and GetRealZoneText() or nil,
        zoneText = GetZoneText and GetZoneText() or nil,
        subzone  = GetSubZoneText and GetSubZoneText() or nil,
        minimap  = GetMinimapZoneText and GetMinimapZoneText() or nil,
        instance = inInstance and instName or nil,
        instanceType = instanceType,
    }
end

-- Returns a list of matches { place = PLACES entry, source = "zone"/"subzone"/... }
-- with duplicates (the same place found twice) removed.
local function Lookup(names)
    local matches, seen = {}, {}
    for _, field in ipairs({ "instance", "zone", "zoneText", "subzone", "minimap" }) do
        local n = Normalize(names[field])
        local p = n and PLACES[n]
        if p and not seen[p] then
            seen[p] = true
            matches[#matches + 1] = { place = p, source = field }
        end
    end
    return matches
end

-- Union of every matched place's types
local function CombinedTypes(matches)
    local set = {}
    for _, m in ipairs(matches) do
        for k in pairs(m.place.types) do set[k] = true end
    end
    return set
end

---------------------------------------------------------------------------
-- Reporting
---------------------------------------------------------------------------

local lastSignature -- so the automatic message only shows when something changed

local function Report(auto)
    local names = GetLocationNames()
    local matches = Lookup(names)
    local here = names.zone or names.zoneText or "this area"
    if IsSecret(here) then here = "this area" end

    local sig = here
    for _, m in ipairs(matches) do sig = sig .. "|" .. m.place.name end
    if auto and sig == lastSignature then return end
    lastSignature = sig

    if #matches == 0 then
        Print(here .. ": no area type known. (Volcanic has no zone list in the game files yet.)")
        return
    end

    if #matches == 1 then
        local m = matches[1]
        Print(m.place.name .. ": " .. TypeText(m.place.types))
        return
    end

    -- Several matches, e.g. a town inside a zone (Booty Bay in Stranglethorn).
    -- We don't know for sure whether the game counts both, so show each.
    Print("You count as: " .. TypeText(CombinedTypes(matches)))
    for _, m in ipairs(matches) do
        Print("   " .. m.place.name .. ": " .. TypeText(m.place.types))
    end
end

local function ListType(query)
    local q = Normalize(query)
    local found
    for _, t in ipairs(TYPES) do
        local label = Normalize(t.label)
        if q and (t.key == q or label == q or label:find(q, 1, true)) then found = t; break end
    end
    if not found then
        local labels = {}
        for _, t in ipairs(TYPES) do labels[#labels + 1] = t.label end
        Print("Area types: " .. table.concat(labels, ", "))
        Print("Type /zt list <type>, e.g. /zt list desert")
        return
    end
    local list = LISTS[found.key]
    if #list == 0 then
        Print("|c" .. found.color .. found.label .. "|r: the game files don't list any places for this yet.")
        return
    end
    Print("|c" .. found.color .. found.label .. "|r (" .. #list .. "): " .. table.concat(list, ", "))
end

local function Where()
    local n = GetLocationNames()
    local mapID = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
    local _, _, _, _, maxPlayers, _, _, instanceID = GetInstanceInfo()
    local function s(v) if IsSecret(v) then return "(secret)" end return "[" .. tostring(v) .. "]" end
    Print("Where am I (for bug reports):")
    Print("  GetRealZoneText " .. s(n.zone) .. "  GetZoneText " .. s(n.zoneText))
    Print("  GetSubZoneText " .. s(n.subzone) .. "  GetMinimapZoneText " .. s(n.minimap))
    Print("  instance " .. s(n.instance) .. "  type " .. s(n.instanceType)
        .. "  instanceID " .. s(instanceID) .. "  maxPlayers " .. s(maxPlayers))
    Print("  uiMapID " .. s(mapID))
    local matches = Lookup(n)
    if #matches == 0 then Print("  matched: nothing") end
    for _, m in ipairs(matches) do
        Print("  matched " .. m.place.name .. " (from " .. m.source .. "): " .. TypeText(m.place.types))
    end
end

---------------------------------------------------------------------------
-- Test
---------------------------------------------------------------------------

-- Feeds made-up locations through the real Lookup and checks the answers.
local function RunTest()
    local cases = {
        { names = { zone = "Tirisfal Glades" },                      want = { "forest", "waste", "haunted" } },
        { names = { zone = "Tanaris", subzone = "Gadgetzan" },       want = { "waste", "desert", "city" } },
        { names = { zone = "Stranglethorn Vale", subzone = "Booty Bay" }, want = { "forest", "mountain", "city" } },
        { names = { zone = "Barrens" },                              want = { "waste", "mountain", "desert" } },
        { names = { zone = "Un’Goro Crater" },                       want = { "swamp", "forest" } },
        { names = { zone = "Uldaman", instance = "Uldaman" },        want = { "desert", "city", "cave" } },
        { names = { zone = "Dun Morogh", subzone = "Coldridge Valley" }, want = { "forest", "mountain", "snowy" } },
        { names = { zone = "Nowhere Special" },                      want = {} },
    }
    local failures = 0
    for _, c in ipairs(cases) do
        local got = SortedKeys(CombinedTypes(Lookup(c.names)))
        local wantSet = {}
        for _, k in ipairs(c.want) do wantSet[k] = true end
        local want = SortedKeys(wantSet)
        if table.concat(got, ",") ~= table.concat(want, ",") then
            failures = failures + 1
            Print("|cffff4040Mismatch|r for " .. tostring(c.names.subzone or c.names.zone)
                .. ": got {" .. table.concat(got, ",") .. "} want {" .. table.concat(want, ",") .. "}")
        end
    end
    if failures == 0 then
        Print("|cff40ff40Test passed|r (" .. #cases .. " places checked).")
    end
    Print("Right here:")
    Report(false)
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
events:RegisterEvent("ZONE_CHANGED")        -- subzone changes (walking into Booty Bay)
events:RegisterEvent("ZONE_CHANGED_INDOORS")

local pending = false
local function QueueAutoReport(delay)
    if not ZoneTypeDB or not ZoneTypeDB.auto or pending then return end
    pending = true
    -- Zone text isn't always ready the instant the event fires
    C_Timer.After(delay or 1, function()
        pending = false
        Report(true)
    end)
end

events:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        if ... == ADDON_NAME then
            ZoneTypeDB = ZoneTypeDB or {}
            if ZoneTypeDB.auto == nil then ZoneTypeDB.auto = true end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Instance info can lag behind after a loading screen
        QueueAutoReport(3)
    else
        QueueAutoReport(1)
    end
end)

---------------------------------------------------------------------------
-- Slash commands
---------------------------------------------------------------------------

SLASH_ZONETYPE1 = "/zt"
SLASH_ZONETYPE2 = "/zonetype"
SlashCmdList.ZONETYPE = function(msg)
    local raw = strtrim(msg or "")
    local cmd, rest = raw:lower():match("^(%S*)%s*(.-)$")
    if cmd == "" then
        Report(false)
    elseif cmd == "auto" then
        ZoneTypeDB.auto = not ZoneTypeDB.auto
        Print("Announce area type when you change zones:", ZoneTypeDB.auto and "ON" or "OFF")
    elseif cmd == "list" then
        ListType(rest)
    elseif cmd == "where" then
        Where()
    elseif cmd == "test" then
        RunTest()
    else
        Print("Commands:")
        Print("  /zt - what area type you're in")
        Print("  /zt list [type] - places that count as a type (e.g. /zt list desert)")
        Print("  /zt auto - turn the zone-change message on/off")
        Print("  /zt where - what the game reports about this spot (for bug reports)")
        Print("  /zt test - check the addon is working")
    end
end
