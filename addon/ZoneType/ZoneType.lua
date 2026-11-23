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
-- Options (saved in ZoneTypeDB; the settings panel and slash commands both
-- go through GetOption/SetOption so they never disagree)
---------------------------------------------------------------------------

-- Area types that can pop up on screen, in the order they're shown.
-- label = short word on screen; name = what the settings checkbox says.
local FLASH = {
    { key = "forest",   label = "Grassland",   name = "Grassland (Forest & Grassland)", color = "ff00ff00" }, -- plain green
    { key = "desert",   label = "Desert",      name = "Desert" },
    { key = "waste",    label = "Wasteland",   name = "Wasteland" },
    { key = "haunted",  label = "Haunted",     name = "Haunted" },
    { key = "swamp",    label = "Swamp",       name = "Swamp" },
    { key = "mountain", label = "Mountainous", name = "Mountainous" },
    { key = "snowy",    label = "Snowy",       name = "Snowy" },
    { key = "city",     label = "City",        name = "Strongholds & Cities" },
    { key = "cave",     label = "Underground", name = "Cavernous/Underground" },
    fadeIn = 0.5, hold = 2.5, fadeOut = 1.5,
}
for _, f in ipairs(FLASH) do
    f.color = f.color or TYPE_BY_KEY[f.key].color -- same colors as the chat message
end
-- Tracked unless the player turns them off
local DEFAULT_TRACKED = { forest = true, desert = true, waste = true, haunted = true }

local blizzSettings = {} -- option id -> Blizzard setting object, once the Options page registers
local OptionChanged      -- defined after the on-screen text, which it updates

-- "flash" -> ZoneTypeDB.flash, "track_desert" -> ZoneTypeDB.track.desert
local function OptionSlot(id)
    if id:sub(1, 6) == "track_" then return ZoneTypeDB.track, id:sub(7) end
    return ZoneTypeDB, id
end

local function GetOption(id)
    local tbl, field = OptionSlot(id)
    return tbl[field]
end

local function SetOption(id, value)
    local bs = blizzSettings[id]
    -- Going through the Blizzard setting keeps its checkbox in sync and
    -- fires OptionChanged for us
    if bs and bs.SetValue and pcall(bs.SetValue, bs, value) then return end
    local tbl, field = OptionSlot(id)
    tbl[field] = value
    OptionChanged(id)
end

local function IsTracked(key)
    return ZoneTypeDB and ZoneTypeDB.track and ZoneTypeDB.track[key]
end

---------------------------------------------------------------------------
-- On-screen text (the area types, shown under the game's zone name)
---------------------------------------------------------------------------

local flashFrame = CreateFrame("Frame", nil, UIParent)
flashFrame:SetSize(520, 40)
flashFrame:SetFrameStrata("HIGH")
flashFrame:SetClampedToScreen(true)
flashFrame:SetMovable(true)
flashFrame:Hide()

-- Default spot: just under the subzone line of the game's zone text.
-- If the player has moved it, use their saved spot instead.
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

-- Size the font follows by default (the game's subzone text size)
local function DefaultSize()
    local _, size = flashText:GetFont()
    if zoneFont and zoneFont.GetFont then _, size = zoneFont:GetFont() end
    return math.floor((size or 26) + 0.5)
end
local DEFAULT_SIZE = DefaultSize()

-- Fit the frame (and the blue unlock box) to the text, with some padding,
-- so long lines don't hang off the edges
local function FitFlash()
    local w = flashText:GetStringWidth() or 0
    local h = flashText:GetStringHeight() or 0
    flashFrame:SetSize(math.max(200, w + 40), math.max(30, h + 16))
end

local function ApplyFlashSize()
    local file, _, flags = flashText:GetFont()
    if zoneFont and zoneFont.GetFont then file, _, flags = zoneFont:GetFont() end
    local size = (ZoneTypeDB and ZoneTypeDB.flashSize) or DEFAULT_SIZE
    if file then flashText:SetFont(file, size, flags or "OUTLINE") end
    FitFlash()
end

-- Shown only while unlocked: a see-through box and a hint, so there's
-- something to grab
local anchorBg = flashFrame:CreateTexture(nil, "BACKGROUND")
anchorBg:SetAllPoints()
anchorBg:SetColorTexture(0.2, 0.6, 1, 0.3)
anchorBg:Hide()
local anchorHint = flashFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
anchorHint:SetPoint("BOTTOM", flashFrame, "TOP", 0, 2)
anchorHint:SetText("ZoneType: drag the box, or type a position below")
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

-- Where the text's middle is, in pixels from the middle of the screen
-- (x: + is right, y: + is up). Rounded so the numbers are easy to type.
local function GetFlashOffset()
    local cx, cy = flashFrame:GetCenter()
    local ux, uy = UIParent:GetCenter()
    if not (cx and ux) then
        -- Hidden frames don't always know where they are; fall back to the saved spot
        local pos = ZoneTypeDB and ZoneTypeDB.flashPos
        if pos and pos.point == "CENTER" then return pos.x, pos.y end
        return 0, 0
    end
    return math.floor(cx - ux + 0.5), math.floor(cy - uy + 0.5)
end

-- Saved by the center, so when the box resizes to fit shorter or longer
-- text it grows evenly both ways and stays centered on the spot
local function SetFlashOffset(x, y)
    ZoneTypeDB.flashPos = { point = "CENTER", relPoint = "CENTER", x = x, y = y }
    flashFrame:ClearAllPoints()
    flashFrame:SetPoint("CENTER", UIParent, "CENTER", x, y)
end

local function FlashLine(set)
    local parts = {}
    for _, f in ipairs(FLASH) do
        if set[f.key] and IsTracked(f.key) then
            parts[#parts + 1] = "|c" .. f.color .. f.label .. "|r"
        end
    end
    -- Places often have several (Tirisfal is Grassland, Wasteland and Haunted),
    -- so keep them on one line instead of stacking down the screen
    return table.concat(parts, "  |cffffffff\194\183|r  "), #parts
end

-- Every type the player tracks, for previews (Grassland if they track none)
local function SampleSet()
    local set, any = {}, false
    for _, f in ipairs(FLASH) do
        if IsTracked(f.key) then set[f.key] = true; any = true end
    end
    if not any then set.forest = true end
    return set
end

-- set = area types like { forest = true, desert = true }. Returns true if shown.
local function ShowFlash(set, force)
    if unlocked then return false end -- don't fight the player while they move it
    local text, count = FlashLine(set)
    if count == 0 then
        if not force then return false end
        text = "|cff888888(no area types ticked in settings)|r"
    end
    flashText:SetText(text)
    FitFlash()
    flashElapsed = 0
    flashFrame:SetAlpha(0)
    flashFrame:Show()
    return true
end

---------------------------------------------------------------------------
-- Unlock panel: X / Y boxes and buttons under the blue box
---------------------------------------------------------------------------

local SetUnlocked -- defined below; the Lock button needs it

local posPanel = CreateFrame("Frame", nil, flashFrame)
posPanel:SetSize(330, 30)
posPanel:SetPoint("TOP", flashFrame, "BOTTOM", 0, -4)
posPanel:EnableMouse(true) -- clicks here shouldn't start a drag
local posBg = posPanel:CreateTexture(nil, "BACKGROUND")
posBg:SetAllPoints()
posBg:SetColorTexture(0, 0, 0, 0.6)
posPanel:Hide()

local function PosLabel(text, anchor, x)
    local fs = posPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    fs:SetText(text)
    fs:SetPoint("LEFT", anchor, anchor == posPanel and "LEFT" or "RIGHT", x, 0)
    return fs
end

local function PosBox(anchor)
    local eb = CreateFrame("EditBox", nil, posPanel, "InputBoxTemplate")
    eb:SetSize(48, 20)
    eb:SetAutoFocus(false)
    eb:SetMaxLetters(6)
    eb:SetPoint("LEFT", anchor, "RIGHT", 8, 0)
    return eb
end

local function PosButton(text, width, anchor)
    local b = CreateFrame("Button", nil, posPanel, "UIPanelButtonTemplate")
    b:SetSize(width, 22)
    b:SetText(text)
    b:SetPoint("LEFT", anchor, "RIGHT", 6, 0)
    return b
end

local xLabel = PosLabel("X", posPanel, 10)
local xBox = PosBox(xLabel)
local yLabel = PosLabel("Y", xBox, 10)
local yBox = PosBox(yLabel)
local setBtn = PosButton("Set", 46, yBox)
local centerBtn = PosButton("Center", 62, setBtn)
local lockBtn = PosButton("Lock", 52, centerBtn)

local function FillPosBoxes()
    local x, y = GetFlashOffset()
    xBox:SetText(tostring(x))
    yBox:SetText(tostring(y))
end

local function ApplyPosBoxes()
    local x, y = tonumber(xBox:GetText()), tonumber(yBox:GetText())
    if x and y then
        SetFlashOffset(x, y)
    else
        Print("Type a number in both X and Y (negative is fine, e.g. -120).")
    end
    xBox:ClearFocus()
    yBox:ClearFocus()
    FillPosBoxes()
end

for _, eb in ipairs({ xBox, yBox }) do
    eb:SetScript("OnEnterPressed", ApplyPosBoxes)
    eb:SetScript("OnEscapePressed", function(self) self:ClearFocus(); FillPosBoxes() end)
    eb:SetScript("OnTabPressed", function(self) (self == xBox and yBox or xBox):SetFocus() end)
end
setBtn:SetScript("OnClick", ApplyPosBoxes)
centerBtn:SetScript("OnClick", function()
    local _, y = GetFlashOffset()
    SetFlashOffset(0, y)
    FillPosBoxes()
end)
lockBtn:SetScript("OnClick", function() SetUnlocked(false) end)

flashFrame:SetScript("OnMouseDown", function(self, button)
    if unlocked and button == "LeftButton" then self:StartMoving() end
end)
flashFrame:SetScript("OnMouseUp", function(self)
    if not unlocked then return end
    self:StopMovingOrSizing()
    SetFlashOffset(GetFlashOffset())
    FillPosBoxes()
end)

function SetUnlocked(on)
    unlocked = on
    flashFrame:EnableMouse(on)
    if on then
        flashText:SetText((FlashLine(SampleSet()))) -- extra parens: only the text, not the count
        FitFlash()
        anchorBg:Show()
        anchorHint:Show()
        posPanel:Show()
        FillPosBoxes()
        flashFrame:SetAlpha(1)
        flashFrame:Show()
        Print("Unlocked. Drag the blue box or type a position, then click Lock (or left-click the minimap button).")
    else
        xBox:ClearFocus()
        yBox:ClearFocus()
        anchorBg:Hide()
        anchorHint:Hide()
        posPanel:Hide()
        flashFrame:Hide()
        Print("Locked.")
    end
end

local lastFlashKey -- zone + shown types, so towns inside the same zone don't re-flash

local function CheckFlash()
    if not ZoneTypeDB or not ZoneTypeDB.flash then return end
    local names = GetLocationNames()
    local set = CombinedTypes(Lookup(names))
    local zone = names.zone
    if IsSecret(zone) then zone = "?" end
    local key = tostring(zone)
    for _, f in ipairs(FLASH) do
        if set[f.key] and IsTracked(f.key) then key = key .. "|" .. f.key end
    end
    if key == lastFlashKey then return end
    lastFlashKey = key
    ShowFlash(set)
end

---------------------------------------------------------------------------
-- Settings (Esc > Options > AddOns > ZoneType, or right-click the minimap
-- button). Falls back to our own small window if the Settings API differs.
---------------------------------------------------------------------------

local UpdateMinimapButton -- defined in the Minimap section

function OptionChanged(id)
    if id == "flashSize" then
        ApplyFlashSize()
        if not unlocked then ShowFlash(SampleSet(), true) end -- preview the new size
    elseif id == "showMinimap" then
        UpdateMinimapButton()
    elseif id:sub(1, 6) == "track_" then
        lastFlashKey = nil
        if unlocked then
            flashText:SetText((FlashLine(SampleSet())))
            FitFlash()
        end
    end
end

local SIZE_MIN, SIZE_MAX = 12, 60

local blizzCategory

local function RegisterBlizzardSettings()
    if not (Settings and Settings.RegisterVerticalLayoutCategory and Settings.RegisterAddOnSetting
            and Settings.CreateCheckbox and Settings.RegisterAddOnCategory) then
        return false
    end
    local ok = pcall(function()
        local category, layout = Settings.RegisterVerticalLayoutCategory("ZoneType")

        local function Header(text)
            if layout and CreateSettingsListSectionHeaderInitializer then
                layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(text))
            end
        end

        local function Register(id, name, default)
            local tbl, field = OptionSlot(id)
            local setting = Settings.RegisterAddOnSetting(category, "ZoneType_" .. id, field, tbl, type(default), name, default)
            setting:SetValueChangedCallback(function() OptionChanged(id) end)
            blizzSettings[id] = setting
            return setting
        end

        local function Check(id, name, default, tooltip)
            Settings.CreateCheckbox(category, Register(id, name, default), tooltip)
        end

        Header("On-screen text")
        Check("flash", "Pop up area types on screen", true,
            "Shows the area types under the zone name when you enter a new zone.\nTo move the text, left-click the minimap button or type /zt unlock.")

        -- Text size: a slider if this client has one, otherwise a drop-down
        local sizeSetting = Register("flashSize", "Text size", DEFAULT_SIZE)
        local sliderOk = Settings.CreateSlider and Settings.CreateSliderOptions and pcall(function()
            local options = Settings.CreateSliderOptions(SIZE_MIN, SIZE_MAX, 1)
            if MinimalSliderWithSteppersMixin and options.SetLabelFormatter then
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
            end
            Settings.CreateSlider(category, sizeSetting, options, "Size of the on-screen text. The game's own subzone text is " .. DEFAULT_SIZE .. ".")
        end)
        if not sliderOk and Settings.CreateDropdown and Settings.CreateControlTextContainer then
            Settings.CreateDropdown(category, sizeSetting, function()
                local c = Settings.CreateControlTextContainer()
                c:Add(18, "Small")
                c:Add(DEFAULT_SIZE, "Normal")
                c:Add(36, "Large")
                c:Add(48, "Huge")
                return c:GetData()
            end, "Size of the on-screen text.")
        end

        Header("Area types to pop up")
        for _, f in ipairs(FLASH) do
            Check("track_" .. f.key, f.name, DEFAULT_TRACKED[f.key] or false,
                "Show |c" .. f.color .. f.label .. "|r on screen when you enter an area of this type.")
        end

        Header("Other")
        Check("auto", "Chat message when the area type changes", true,
            "Prints the area types in chat when you move somewhere different.")
        Check("showMinimap", "Show minimap button", true,
            "If hidden, bring it back with /zt minimap.")

        Settings.RegisterAddOnCategory(category)
        blizzCategory = category
    end)
    if not ok then blizzCategory = nil end
    return ok
end

-- Our own small settings window, only used if the Blizzard panel didn't register
local ownSettings

local function BuildOwnSettings()
    local f = CreateFrame("Frame", "ZoneTypeSettingsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
    f:SetSize(280, 120 + 26 * (#FLASH + 3))
    f:SetPoint("CENTER")
    f:SetFrameStrata("DIALOG")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    if f.SetBackdrop then
        f:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 },
        })
        f:SetBackdropColor(0.05, 0.05, 0.07, 0.95)
    end
    tinsert(UISpecialFrames, "ZoneTypeSettingsFrame") -- Esc closes it

    local title = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -12)
    title:SetText("ZoneType")
    local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", 0, 0)

    local y = -40
    local function Section(text)
        local fs = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", 16, y)
        fs:SetText(text)
        y = y - 20
    end
    local function Check(id, label)
        local cb = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        cb:SetSize(24, 24)
        cb:SetPoint("TOPLEFT", 16, y)
        y = y - 26
        local fs = cb.Text or cb.text
        if not fs then
            fs = cb:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            fs:SetPoint("LEFT", cb, "RIGHT", 2, 0)
        end
        fs:SetText(label)
        cb:SetScript("OnShow", function(self) self:SetChecked(GetOption(id) and true or false) end)
        cb:SetScript("OnClick", function(self) SetOption(id, self:GetChecked() and true or false) end)
    end

    Section("On-screen text")
    Check("flash", "Pop up area types on screen")
    -- Text size:  [-]  26  [+]
    local sizeLabel = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    sizeLabel:SetPoint("TOPLEFT", 22, y - 4)
    local function SizeButton(text, delta, x)
        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetSize(24, 20)
        b:SetText(text)
        b:SetPoint("TOPLEFT", x, y)
        b:SetScript("OnClick", function()
            local size = (ZoneTypeDB.flashSize or DEFAULT_SIZE) + delta
            SetOption("flashSize", math.max(SIZE_MIN, math.min(SIZE_MAX, size)))
            sizeLabel:SetText("Text size: " .. ZoneTypeDB.flashSize)
        end)
    end
    SizeButton("-", -2, 130)
    SizeButton("+", 2, 158)
    sizeLabel:SetScript("OnShow", function(self) self:SetText("Text size: " .. (ZoneTypeDB.flashSize or DEFAULT_SIZE)) end)
    sizeLabel:SetText("Text size: " .. (ZoneTypeDB.flashSize or DEFAULT_SIZE))
    y = y - 30

    Section("Area types to pop up")
    for _, ft in ipairs(FLASH) do Check("track_" .. ft.key, "|c" .. ft.color .. ft.name .. "|r") end

    Section("Other")
    Check("auto", "Chat message when the area type changes")
    Check("showMinimap", "Show minimap button")

    f:SetHeight(-y + 16)
    f:Hide()
    return f
end

-- Open settings: the Blizzard AddOns page if it registered, otherwise our own window
local function OpenSettings()
    local panel = SettingsPanel
    -- Clicking again closes it
    if panel and panel:IsShown() then
        HideUIPanel(panel)
        return
    end
    if ownSettings and ownSettings:IsShown() then
        ownSettings:Hide()
        return
    end
    if blizzCategory then
        local id = (blizzCategory.GetID and blizzCategory:GetID()) or blizzCategory.ID
        -- Try the different ways this has worked across game versions, and
        -- check the panel actually appeared after each one.
        if Settings and Settings.OpenToCategory then pcall(Settings.OpenToCategory, id) end
        if panel and not panel:IsShown() and panel.OpenToCategory then
            pcall(panel.OpenToCategory, panel, id)
        end
        if panel and not panel:IsShown() then
            pcall(ShowUIPanel, panel)
            if panel:IsShown() and panel.SelectCategory then pcall(panel.SelectCategory, panel, blizzCategory) end
        end
        if panel and panel:IsShown() then return end
    end
    ownSettings = ownSettings or BuildOwnSettings()
    ownSettings:Show()
end

---------------------------------------------------------------------------
-- Minimap button: left-click = unlock/lock the text, right-click = settings,
-- drag = move
---------------------------------------------------------------------------

local mm = CreateFrame("Button", "ZoneTypeMinimapButton", Minimap)
mm:SetSize(31, 31)
mm:SetFrameStrata("MEDIUM")
mm:SetFrameLevel(8)
mm:RegisterForClicks("LeftButtonUp", "RightButtonUp")
mm:RegisterForDrag("LeftButton")
mm:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local mmBg = mm:CreateTexture(nil, "BACKGROUND")
mmBg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
mmBg:SetSize(20, 20)
mmBg:SetPoint("TOPLEFT", 7, -5)

local mmIcon = mm:CreateTexture(nil, "ARTWORK")
mmIcon:SetSize(18, 18)
mmIcon:SetPoint("TOPLEFT", 7, -6)
mmIcon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
mmIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- trim the icon's built-in border

local mmBorder = mm:CreateTexture(nil, "OVERLAY")
mmBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
mmBorder:SetSize(53, 53)
mmBorder:SetPoint("TOPLEFT")

local function UpdateMinimapPosition()
    local angle = math.rad(ZoneTypeDB.minimapAngle or 200)
    local radius = (Minimap:GetWidth() / 2) + 5
    mm:ClearAllPoints()
    mm:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

function UpdateMinimapButton()
    mm:SetShown(ZoneTypeDB.showMinimap and true or false)
    UpdateMinimapPosition()
end

mm:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        ZoneTypeDB.minimapAngle = math.deg(math.atan2(py / scale - my, px / scale - mx))
        UpdateMinimapPosition()
    end)
end)
mm:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)

mm:SetScript("OnClick", function(_, button)
    if button == "RightButton" then
        OpenSettings()
    else
        SetUnlocked(not unlocked)
    end
end)

mm:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("ZoneType")
    GameTooltip:AddLine(unlocked and "Left-click: lock the on-screen text" or "Left-click: unlock and move the on-screen text", 1, 1, 1)
    GameTooltip:AddLine("Right-click: settings", 1, 1, 1)
    GameTooltip:AddLine("Drag: move this button", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
mm:SetScript("OnLeave", GameTooltip_Hide)
mm:Hide() -- shown once settings load

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
            local db = ZoneTypeDB
            if db.auto == nil then db.auto = true end
            if db.flash == nil then db.flash = true end
            if db.showMinimap == nil then db.showMinimap = true end
            if db.flashSize == nil then db.flashSize = DEFAULT_SIZE end
            db.track = db.track or {}
            for _, f in ipairs(FLASH) do
                if db.track[f.key] == nil then db.track[f.key] = DEFAULT_TRACKED[f.key] or false end
            end
            PlaceFlash() -- saved position is only readable now
            ApplyFlashSize()
            RegisterBlizzardSettings()
            UpdateMinimapButton()
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
        SetOption("auto", not ZoneTypeDB.auto)
        Print("Chat message when the area type changes:", ZoneTypeDB.auto and "ON" or "OFF")
    elseif cmd == "flash" then
        if rest == "test" then
            ShowFlash(SampleSet(), true)
            Print("Showing a sample.")
        else
            SetOption("flash", not ZoneTypeDB.flash)
            Print("Pop up area types on screen:", ZoneTypeDB.flash and "ON" or "OFF")
        end
    elseif cmd == "settings" or cmd == "config" or cmd == "options" then
        OpenSettings()
    elseif cmd == "minimap" then
        SetOption("showMinimap", not ZoneTypeDB.showMinimap)
        Print("Minimap button:", ZoneTypeDB.showMinimap and "shown" or "hidden")
    elseif cmd == "unlock" or cmd == "move" then
        SetUnlocked(not unlocked)
    elseif cmd == "lock" then
        if unlocked then SetUnlocked(false) else Print("Already locked.") end
    elseif cmd == "pos" then
        -- /zt pos 0 150, /zt pos 0,150, /zt pos center (x = 0, keep y)
        local cx, cy = GetFlashOffset()
        local x, y = rest:match("^(%-?[%d%.]+)[%s,]+(%-?[%d%.]+)$")
        if rest == "center" then
            x, y = 0, cy
        elseif x then
            x, y = tonumber(x), tonumber(y)
        end
        if x and y then
            SetFlashOffset(x, y)
            if unlocked then FillPosBoxes() else ShowFlash(SampleSet(), true) end
            Print(("On-screen text moved to x %d, y %d (from the middle of the screen)."):format(x, y))
        else
            Print(("On-screen text is at x %d, y %d (pixels from the middle of the screen; + is right/up)."):format(cx, cy))
            Print("Type /zt pos <x> <y> to move it, e.g. /zt pos 0 200, or /zt pos center.")
        end
    elseif cmd == "resetpos" then
        ZoneTypeDB.flashPos = nil
        PlaceFlash()
        if unlocked then FillPosBoxes() end
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
        Print("  /zt settings - open settings (or right-click the minimap button)")
        Print("  /zt unlock / lock - move the on-screen text (or left-click the minimap button)")
        Print("  /zt pos <x> <y> - place the on-screen text by numbers (/zt pos center centers it)")
        Print("  /zt resetpos - put the on-screen text back under the zone name")
        Print("  /zt flash - turn the on-screen pop-up on/off")
        Print("  /zt flash test - show a sample")
        Print("  /zt auto - turn the zone-change chat message on/off")
        Print("  /zt minimap - show/hide the minimap button")
        Print("  /zt list [type] - places that count as a type (e.g. /zt list desert)")
        Print("  /zt where - what the game reports about this spot (for bug reports)")
        Print("  /zt test - check the addon is working")
    end
end
