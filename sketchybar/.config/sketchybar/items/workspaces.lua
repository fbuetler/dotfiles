#!/usr/bin/env lua

local settings = require("settings")

local QUERY_VISIBLE_WORKSPACES =
"aerospace list-workspaces --visible --monitor all --format '%{workspace}' --json"

local QUERY_WINDOWS = "aerospace list-windows --monitor all --format '%{workspace}' --json"

local QUERY_WORKSPACES_AND_SCREENS =
"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_SCREENS_AND_DISPLAYS = [[
swift -e '
    import AppKit;
    import CoreGraphics;
    import Foundation;

    struct ScreenInfo: Encodable {
        let nsscreenId: Int
        let displayId: Int

        enum CodingKeys: String, CodingKey {
            case nsscreenId = "monitor-appkit-nsscreen-screens-id"
            case displayId = "display-id"
        }
    }

    var screensInfo = [ScreenInfo]()

    for (i, scr) in NSScreen.screens.enumerated() {
        let n = scr.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber
        let screen = ScreenInfo(nsscreenId: i + 1, displayId: n.intValue)
        screensInfo.append(screen)
    }

    do {
        let jsonData = try JSONEncoder().encode(screensInfo)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    } catch {
        print("Error encoding JSON: \(error)")
    }
'
]]

local QUERY_DISPLAYS_ARRANGEMENTS = "sketchybar --query displays"

local WORKSPACE_KEY = "workspace"
local SCREEN_KEY = "monitor-appkit-nsscreen-screens-id"
local DISPLAY_KEY = "display-id"
local DIRECT_ID = "DirectDisplayID"
local ARRANGEMENT_KEY = "arrangement-id"

local WORKSPACE_CHANGE_EVENT = "aerospace_workspace_change"
local MONITOR_CHANGE_EVENT = "aerospace_display_change"

-- Add dummy item as global events receiver
local root = sbar.add("item", {
    width = 0,
})

local workspaces = {}

local function getState(callback)
    sbar.exec(QUERY_WINDOWS, function(workspace_and_app)
        local workspace_has_apps = {}
        for _, entry in ipairs(workspace_and_app) do
            local workspace_index = entry[WORKSPACE_KEY]
            workspace_has_apps[workspace_index] = true
        end

        sbar.exec(QUERY_VISIBLE_WORKSPACES, function(visible_workspaces)
            local workspace_is_visible = {}
            for _, entry in ipairs(visible_workspaces) do
                local workspace_index = entry[WORKSPACE_KEY]
                workspace_is_visible[workspace_index] = true
            end

            -- the following part is real ugly
            -- * aerospace uses NSScreen to display its workspaces on
            -- * sketchybar uses DirectScreen to display its items on
            -- * both have their internal numeration of monitors: monitor-id (aerospace)/arrangement-id (sketchybar)
            -- * they do not share an ordering
            -- hence, in order to map a aerospace workspace to a sketchybar item, we need
            -- * to query the OS to get a mapping from NSScreen to DirectScreen
            -- then we can create the mapping:
            -- workspace (monitor-id) -> NSScreen -> DirectScreen -> item (arrangement-id)

            -- workspace (aerospace) on NSScreen
            sbar.exec(QUERY_WORKSPACES_AND_SCREENS, function(workspaces_and_screens)
                local workspace_to_screen = {}
                for _, entry in ipairs(workspaces_and_screens) do
                    local workspace_index = entry[WORKSPACE_KEY]
                    local screen_id = entry[SCREEN_KEY]
                    workspace_to_screen[workspace_index] = screen_id
                end

                -- NSScreen to Direct
                sbar.exec(QUERY_SCREENS_AND_DISPLAYS, function(screens_and_displays)
                    local screen_to_display = {}
                    for _, entry in ipairs(screens_and_displays) do
                        local screen_id = entry[SCREEN_KEY]
                        local display_id = entry[DISPLAY_KEY]
                        screen_to_display[screen_id] = display_id
                    end


                    -- Direct to arrangement (sketchybar)
                    sbar.exec(QUERY_DISPLAYS_ARRANGEMENTS, function(displays_and_arrangements)
                        local display_to_arrangement = {}
                        for _, entry in ipairs(displays_and_arrangements) do
                            local display_id = entry[DIRECT_ID]
                            local arrangement_id = entry[ARRANGEMENT_KEY]
                            display_to_arrangement[display_id] = arrangement_id
                        end

                        -- workspace (aerospace) to arrangement (sketchybar)
                        local workspace_to_arrangement = {}
                        for workspace_index, screen_id in pairs(workspace_to_screen) do
                            workspace_to_arrangement[workspace_index] = display_to_arrangement
                                [screen_to_display[screen_id]]
                        end

                        local state = {
                            workspace_has_apps = workspace_has_apps,
                            workspace_is_visible = workspace_is_visible,
                            workspace_to_arrangement = workspace_to_arrangement
                        }
                        callback(state)
                    end)
                end)
            end)
        end)
    end)
end

local function setVisibility(workspace, has_apps, is_visible, display)
    -- show empty focused workspace/non-empty workspace
    if (not has_apps and is_visible) or (has_apps) then
        workspace:set({
            display = display,
        })
        return
    end

    -- hide empty unfocused workspace
    if not has_apps and not is_visible then
        workspace:set({
            display = 0,
        })
        return
    end
end

local function setHighlight(workspace, is_visible)
    sbar.animate(settings.animation.curve, settings.animation.duration, function()
        workspace:set({
            background = {
                border_width = is_visible and settings.workspace.background.border.width_focused or
                    settings.workspace.background.border.width,
            },
        })
    end)
end

local function update()
    getState(function(state)
        for workspace_index, workspace in pairs(workspaces) do
            setVisibility(
                workspace,
                state.workspace_has_apps[workspace_index],
                state.workspace_is_visible[workspace_index],
                state.workspace_to_arrangement[workspace_index]
            )

            setHighlight(
                workspace,
                state.workspace_is_visible[workspace_index]
            )
        end
    end)
end

sbar.exec(QUERY_WORKSPACES_AND_SCREENS, function(workspaces_and_monitors)
    for _, entry in ipairs(workspaces_and_monitors) do
        local workspace_index = entry.workspace

        local workspace = sbar.add("item", {
            icon = {
                align = settings.workspace.icon.align,
                width = settings.workspace.icon.width,
                padding_left = settings.workspace.icon.padding,
                padding_right = settings.workspace.icon.padding,
                string = workspace_index,
            },
            label = {
                width = settings.workspace.label.width,
            },
            background = {
                color = settings.workspace.background.color,
                corner_radius = settings.workspace.background.corner_radius,
                height = settings.workspace.background.height,

                border_color = settings.workspace.background.border.color,
                border_width = settings.workspace.background.border.width,
            },
            display = 0,
            click_script = "aerospace workspace " .. workspace_index,
        })

        workspaces[workspace_index] = workspace
    end

    -- initial
    update()

    -- all combinations of workspace and monitor change events may happen:
    -- only workspace: switch to workspace on same monitor
    -- only monitor: move workspace between monitors
    -- both: switch to workspace on another monitor

    root:subscribe(WORKSPACE_CHANGE_EVENT, function()
        update()
    end)

    root:subscribe(MONITOR_CHANGE_EVENT, function()
        update()
    end)
end)
