#!/usr/bin/env lua

local settings = require("settings")

local QUERY_WORKSPACES =
"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_VISIBLE_WORKSPACES =
"aerospace list-workspaces --visible --monitor all --format '%{workspace}' --json"

local QUERY_WINDOWS = "aerospace list-windows --monitor all --format '%{workspace}' --json"

local MONITOR_KEY = "monitor-appkit-nsscreen-screens-id"
local WORKSPACE_KEY = "workspace"

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

            sbar.exec(QUERY_WORKSPACES, function(workspaces_and_monitors)
                local workspace_to_monitor = {}
                for _, entry in ipairs(workspaces_and_monitors) do
                    local workspace_index = entry[WORKSPACE_KEY]
                    local monitor_id = entry[MONITOR_KEY]
                    workspace_to_monitor[workspace_index] = monitor_id
                end

                local state = {
                    workspace_has_apps = workspace_has_apps,
                    workspace_is_visible = workspace_is_visible,
                    workspace_to_monitor = workspace_to_monitor
                }
                callback(state)
            end)
        end)
    end)
end

local function setVisibility(workspace, has_apps, is_visible, monitor)
    -- show empty focused workspace/non-empty workspace
    if (not has_apps and is_visible) or (has_apps) then
        workspace:set({
            display = monitor,
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
                state.workspace_to_monitor[workspace_index]
            )

            setHighlight(
                workspace,
                state.workspace_is_visible[workspace_index]
            )
        end
    end)
end

sbar.exec(QUERY_WORKSPACES, function(workspaces_and_monitors)
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
