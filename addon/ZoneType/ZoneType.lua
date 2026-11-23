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

    -- Several matches, e.g. a town inside a zone (Everlook in Winterspring).
    -- One line, most specific place first: "Everlook, Winterspring: ..."
    -- (Lookup finds the zone before the subzone, so walk it backwards.)
    local placeNames = {}
    for i = #matches, 1, -1 do placeNames[#placeNames + 1] = matches[i].place.name end
    Print(table.concat(placeNames, ", ") .. ": " .. TypeText(CombinedTypes(matches)))
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
-- On-screen flash (Grassland / Desert / Wasteland / Haunted)
---------------------------------------------------------------------------

-- Big text under the game's own zone name, for the area types Cole cares
-- about most. Same feel as the zone text: fade in, hold, fade out.
local FLASH = {
    { key = "forest", label = "Grassland", color = "ff00ff00" }, -- plain green
    { key = "desert", label = "Desert",    color = "ffffd060" }, -- same as chat
    { key = "waste",  label = "Wasteland", color = "ffb08a5a" }, -- same as chat
    { key = "haunted", label = "Haunted",  color = "ffa78bd6" }, -- same as chat
    fadeIn = 0.5, hold = 2.5, fadeOut = 1.5,
}

local flashFrame = CreateFrame("Frame", nil, UIParent)
flashFrame:SetSize(520, 40)
flashFrame:SetFrameStrata("HIGH")
flashFrame:SetClampedToScreen(true)
flashFrame:SetMovable(true)
flashFrame:Hide()

-- Default spot: just under the subzone line of the game's zone text.
-- If the player has moved it (/zt unlock), use their saved spot instead.
local function PlaceFlash()
    flashFrame:ClearAllPoints()
    local pos = ZoneTypeDB and ZoneTypeDB.flashPos
    if pos then
        flashFrame:SetPoint(pos.point, UIParent, pos.relPoint, pos.x, pos.y)
    elseif SubZoneTextString then
        flashFrame:SetPoint("TOP", SubZoneTextString, "BOTTOM", 0, -4)
    else
        flashFrame:SetPoint("TOP", UIParent, "TOP", 0, -330)
    end
end
PlaceFlash()

local flashText = flashFrame:CreateFontString(nil, "OVERLAY")
-- Same font as the game's subzone line ("Southfury River"), so ours reads
-- like a second line of the game's own zone text
local zoneFont = _G.SubZoneTextFont or _G.ZoneTextFont or _G.GameFontNormalLarge
if zoneFont then flashText:SetFontObject(zoneFont) end
flashText:SetTextColor(1, 1, 1) -- real colors come from the color codes
flashText:SetPoint("CENTER")
flashText:SetJustifyH("CENTER")

-- Shown only while unlocked: a see-through box and a hint, so there's
-- something to grab
local anchorBg = flashFrame:CreateTexture(nil, "BACKGROUND")
anchorBg:SetAllPoints()
anchorBg:SetColorTexture(0.2, 0.6, 1, 0.3)
anchorBg:Hide()
local anchorHint = flashFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
anchorHint:SetPoint("BOTTOM", flashFrame, "TOP", 0, 2)
anchorHint:SetText("ZoneType: drag to move, then type /zt lock")
anchorHint:Hide()

local unlocked = false
local flashElapsed = 0
flashFrame:SetScript("OnUpdate", function(self, dt)
    if unlocked then return end -- stay fully visible while moving it
    flashElapsed = flashElapsed + dt
    local t = flashElapsed
    if t < FLASH.fadeIn then
        self:SetAlpha(t / FLASH.fadeIn)
    elseif t < FLASH.fadeIn + FLASH.hold then
        self:SetAlpha(1)
    elseif t < FLASH.fadeIn + FLASH.hold + FLASH.fadeOut then
        self:SetAlpha(1 - (t - FLASH.fadeIn - FLASH.hold) / FLASH.fadeOut)
    else
        self:Hide()
    end
end)

flashFrame:SetScript("OnMouseDown", function(self, button)
    if unlocked and button == "LeftButton" then self:StartMoving() end
end)
flashFrame:SetScript("OnMouseUp", function(self)
    if not unlocked then return end
    self:StopMovingOrSizing()
    -- Save the spot by its center, so when the box later resizes to fit
    -- shorter or longer text it grows evenly both ways and stays centered
    local cx, cy = self:GetCenter()
    local ux, uy = UIParent:GetCenter()
    if cx and ux then
        ZoneTypeDB.flashPos = { point = "CENTER", relPoint = "CENTER", x = cx - ux, y = cy - uy }
        self:ClearAllPoints()
        self:SetPoint("CENTER", UIParent, "CENTER", cx - ux, cy - uy)
    end
end)

local function FlashLine(set)
    local parts = {}
    for _, f in ipairs(FLASH) do
        if set[f.key] then parts[#parts + 1] = "|c" .. f.color .. f.label .. "|r" end
    end
    -- Places often have several (Tirisfal is Grassland, Wasteland and Haunted),
    -- so keep them on one line instead of stacking down the screen
    return table.concat(parts, "  |cffffffff\194\183|r  "), #parts
end

local SAMPLE = { forest = true, desert = true, waste = true, haunted = true }

-- Fit the frame (and the blue unlock box) to the text, with some padding,
-- so long lines like all four types don't hang off the edges
local function FitFlash()
    local w = flashText:GetStringWidth() or 0
    local h = flashText:GetStringHeight() or 0
    flashFrame:SetSize(math.max(200, w + 40), math.max(30, h + 16))
end

-- set = area types like { forest = true, desert = true }. Returns true if shown.
local function ShowFlash(set)
    if unlocked then return false end -- don't fight the player while they move it
    local text, count = FlashLine(set)
    if count == 0 then return false end
    flashText:SetText(text)
    FitFlash()
    flashElapsed = 0
    flashFrame:SetAlpha(0)
    flashFrame:Show()
    return true
end

local function SetUnlocked(on)
    unlocked = on
    flashFrame:EnableMouse(on)
    if on then
        flashText:SetText((FlashLine(SAMPLE))) -- extra parens: only the text, not the count
        FitFlash()
        anchorBg:Show()
        anchorHint:Show()
        flashFrame:SetAlpha(1)
        flashFrame:Show()
        Print("Unlocked. Drag the blue box to move the on-screen text, then type /zt lock.")
    else
        anchorBg:Hide()
        anchorHint:Hide()
        flashFrame:Hide()
        Print("Locked. Type /zt resetpos to put the text back under the zone name.")
    end
end

local lastFlashKey -- zone + flash types, so towns inside the same zone don't re-flash

local function CheckFlash()
    if not ZoneTypeDB or not ZoneTypeDB.flash then return end
    local names = GetLocationNames()
    local set = CombinedTypes(Lookup(names))
    local zone = names.zone
    if IsSecret(zone) then zone = "?" end
    local key = tostring(zone)
    for _, f in ipairs(FLASH) do
        if set[f.key] then key = key .. "|" .. f.key end
    end
    if key == lastFlashKey then return end
    lastFlashKey = key
    ShowFlash(set)
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
    if not ZoneTypeDB or pending then return end
    pending = true
    -- Zone text isn't always ready the instant the event fires
    C_Timer.After(delay or 1, function()
        pending = false
        CheckFlash()
        if ZoneTypeDB.auto then Report(true) end
    end)
end

events:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        if ... == ADDON_NAME then
            ZoneTypeDB = ZoneTypeDB or {}
            if ZoneTypeDB.auto == nil then ZoneTypeDB.auto = true end
            if ZoneTypeDB.flash == nil then ZoneTypeDB.flash = true end
            PlaceFlash() -- saved position is only readable now
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
    elseif cmd == "flash" then
        if rest == "test" then
            ShowFlash(SAMPLE)
            Print("Showing a sample flash.")
        else
            ZoneTypeDB.flash = not ZoneTypeDB.flash
            Print("Flash area types on screen:", ZoneTypeDB.flash and "ON" or "OFF")
        end
    elseif cmd == "unlock" or cmd == "move" then
        SetUnlocked(not unlocked)
    elseif cmd == "lock" then
        if unlocked then SetUnlocked(false) else Print("Already locked.") end
    elseif cmd == "resetpos" then
        ZoneTypeDB.flashPos = nil
        PlaceFlash()
        Print("On-screen text moved back under the zone name.")
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
        Print("  /zt flash - turn the on-screen area-type flash on/off")
        Print("  /zt flash test - show a sample flash")
        Print("  /zt unlock / lock - move the on-screen text")
        Print("  /zt resetpos - put the on-screen text back under the zone name")
        Print("  /zt where - what the game reports about this spot (for bug reports)")
        Print("  /zt test - check the addon is working")
    end
end
