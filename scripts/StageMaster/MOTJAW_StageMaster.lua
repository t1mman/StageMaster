--[[
    ============================================================
                     MOTJAW StageMaster v2.1.1
                     Background Metadata Script
    ============================================================

    Description:
      This script runs continuously in REAPER and generates all
      metadata required by the MOTJAW StageMaster interface.
      It extracts lyrics, regions, colors, setlist, next track,
      and timing information, then publishes it as JSON via ExtState.

    Files in this version:
      • MOTJAW_Background_v2.1.1.lua
      • MOTJAW_StageMaster_v2.1.1.html
      • MOTJAW StageMaster_DEV_NOTES.md
      • MOTJAW StageMaster_RELEASE_NOTES.md
      • MOTJAW StageMaster_Changelog.md

    Documentation:
      See the Dev Notes and Changelog for architecture, JSON schema,
      data flow, and version history.

    Contact:
      Tommy Turbide — tntconseil@gmail.com

    Project Summary:
      MOTJAW StageMaster is a live performance system that connects
      REAPER project metadata to a stage‑ready HTML interface. It
      provides auto‑scrolling lyrics, setlist navigation, region‑aware
      progress tracking, and real‑time transport feedback.

    ============================================================
]]


local last_proj = nil
local track = nil

------------------------------------------------------------
-- Build JSON and push to ExtState
------------------------------------------------------------
function BuildJSON()
    if not track then return end

    local count_track_items = reaper.CountTrackMediaItems(track)

    ------------------------------------------------------------
    -- 1. Find EndTrack marker
    ------------------------------------------------------------
    local end_pos = reaper.GetProjectLength(0)
    local _, num_markers, num_regions = reaper.CountProjectMarkers(0)

    for i = 0, num_markers + num_regions - 1 do
        local retval, isrgn, pos, rgnend, name = reaper.EnumProjectMarkers(i)
        if not isrgn and name == "EndTrack" then
            end_pos = pos
            break
        end
    end

    ------------------------------------------------------------
    -- 2. Find next project tab
    ------------------------------------------------------------
    local next_name = "END OF SET"
    local i = 0
    local found_active = false

    while true do
        local proj, name = reaper.EnumProjects(i, "")
        if not proj then break end

        if found_active then
            next_name = name:match("([^/\\]+)%.[Rr][Pp][Pp]$") or name
            break
        end

        if proj == last_proj then found_active = true end
        i = i + 1
    end

    ------------------------------------------------------------
    -- 3. Collect lyrics
    ------------------------------------------------------------
    local t = {}

    for i = 0, count_track_items - 1 do
        local item = reaper.GetTrackMediaItem(track, i)
        local ok, notes = reaper.GetSetMediaItemInfo_String(item, "P_NOTES", "", false)

        if ok and notes ~= "" then
            local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

            table.insert(t, {
                text = notes,
                pos_start = pos,
                pos_end = pos + len
            })
        end
    end

    -- Sort lyrics by start time
    table.sort(t, function(a,b) return a.pos_start < b.pos_start end)

    ------------------------------------------------------------
    -- 4. Collect regions + colors
    ------------------------------------------------------------
    local regions = {}
    local _, nm, nr = reaper.CountProjectMarkers(0)

    for i = 0, nm + nr - 1 do
        local retval, isrgn, pos, rgnend, name, idx, color = reaper.EnumProjectMarkers3(0, i)
        if isrgn then
            local r, g, b = reaper.ColorFromNative(color)
            table.insert(regions, {
                start = pos,
                endpos = rgnend,
                color = string.format("#%02X%02X%02X", r, g, b),
                name = name or ""
            })
        end
    end

    -- Sort regions by start time
    table.sort(regions, function(a,b) return a.start < b.start end)

    ------------------------------------------------------------
    -- 5. Build SETLIST array (NEW)
    ------------------------------------------------------------
    local setlist = {}
    local i = 0

    while true do
        local proj, name = reaper.EnumProjects(i, "")
        if not proj then break end

        local clean = name:match("([^/\\]+)%.[Rr][Pp][Pp]$")
        table.insert(setlist, clean or name)

        i = i + 1
    end

    ------------------------------------------------------------
    -- 6. Build JSON
    ------------------------------------------------------------
    local lines = {
        "{",
        "\"next_project\": \"" .. next_name:gsub('"','\\"') .. "\",",
        "\"end_time\": " .. end_pos .. ",",
    }

    ------------------------------------------------------------
    -- Add lyrics
    ------------------------------------------------------------
    table.insert(lines, "\"entry\": [")

    for i, v in ipairs(t) do
        local line = string.format(
            "{\"pos_start\": %f, \"pos_end\": %f, \"text\": \"%s\"}",
            v.pos_start, v.pos_end,
            v.text:gsub("\n","<br>"):gsub("\r",""):gsub('"','\\"')
        )
        if i < #t then line = line .. "," end
        table.insert(lines, line)
    end

    table.insert(lines, "],")

    ------------------------------------------------------------
    -- Add regions
    ------------------------------------------------------------
    table.insert(lines, "\"regions\": [")

    for i, r in ipairs(regions) do
        local line = string.format(
            "{\"start\": %f, \"end\": %f, \"color\": \"%s\", \"name\": \"%s\"}",
            r.start, r.endpos, r.color, r.name:gsub('"','\\"')
        )
        if i < #regions then line = line .. "," end
        table.insert(lines, line)
    end

    table.insert(lines, "],")

    ------------------------------------------------------------
    -- Add SETLIST (NEW)
    ------------------------------------------------------------
    table.insert(lines, "\"setlist\": [")

    for i, s in ipairs(setlist) do
        local line = string.format("\"%s\"", s:gsub('"','\\"'))
        if i < #setlist then line = line .. "," end
        table.insert(lines, line)
    end

    table.insert(lines, "]")
    table.insert(lines, "}")

    ------------------------------------------------------------
    -- Push JSON to ExtState
    ------------------------------------------------------------
    local json = table.concat(lines, "\n")
    reaper.SetExtState("XR_Lyrics", "json", json, false)
    reaper.SetExtState("XR_Lyrics", "need_refresh", "true", false)
end

------------------------------------------------------------
-- Detect project tab changes
------------------------------------------------------------
function InitProject()
    local proj = reaper.EnumProjects(-1, "")
    if proj ~= last_proj then
        last_proj = proj

        track = reaper.GetTrack(0, 0)
        if track then
            reaper.SetOnlyTrackSelected(track)
        end

        BuildJSON()
    end
end

------------------------------------------------------------
-- Main loop
------------------------------------------------------------
function Main()
    InitProject()
    BuildJSON()
    reaper.defer(Main)
end

Main()

