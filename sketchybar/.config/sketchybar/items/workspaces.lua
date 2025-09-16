#!/usr/bin/env lua

local settings = require("settings")

local QUERY_WORKSPACES =
"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_VISIBLE_WORKSPACES =
"aerospace list-workspaces --visible --monitor all --format '%{workspace}' --json"

local QUERY_FOCUSED_WORKSPACES = "aerospace list-workspaces --focused"

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

local function getWorkspacesState(f)
    local workspace_has_apps = {}
    sbar.exec(QUERY_WINDOWS, function(workspace_and_app)
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

                local args = {
                    workspace_has_apps = workspace_has_apps,
                    workspace_is_visible = workspace_is_visible,
                    workspace_to_monitor = workspace_to_monitor
                }
                f(args)
            end)
        end)
    end)
end

local function toggleWorkspaceVisibility(workspace_index, args)
    local has_apps = args.workspace_has_apps[workspace_index]
    local is_visible = args.workspace_is_visible[workspace_index]
    local workspace_to_monitor = args.workspace_to_monitor

    -- show empty focused workspace/non-empty workspace
    if (not has_apps and is_visible) or (has_apps) then
        workspaces[workspace_index]:set({
            display = workspace_to_monitor[workspace_index],
        })
        return
    end

    -- hide empty unfocused workspace
    if not has_apps and not is_visible then
        workspaces[workspace_index]:set({
            display = 0,
        })
        return
    end
end

local function toggleWorkspaceVisibilities()
    getWorkspacesState(function(args)
        for workspace_index, _ in pairs(workspaces) do
            toggleWorkspaceVisibility(workspace_index, args)
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

        workspace:subscribe(WORKSPACE_CHANGE_EVENT, function(env)
            local focused_workspace = env.AEROSPACE_FOCUSED_WORKSPACE
            local is_focused = focused_workspace == workspace_index

            sbar.animate(settings.animation.curve, settings.animation.duration, function()
                workspace:set({
                    background = {
                        border_width = is_focused and settings.workspace.background.border.width_focused or
                            settings.workspace.background.border.width, -- tenary operation
                    },
                })
            end)
        end)
    end

    -- all combinations of workspace and monitor change events may happen:
    -- only workspace: change workspace on same monitor
    -- only monitor: move workspace between monitors
    -- both: change workspace on another monitor

    root:subscribe(WORKSPACE_CHANGE_EVENT, function()
        toggleWorkspaceVisibilities()
    end)

    root:subscribe(MONITOR_CHANGE_EVENT, function()
        toggleWorkspaceVisibilities()
    end)

    -- initial visibility
    toggleWorkspaceVisibilities()

    -- initial focus
    sbar.exec(QUERY_FOCUSED_WORKSPACES, function(focused_workspaces)
        local focused_workspace = focused_workspaces:match("^%s*(.-)%s*$")
        workspaces[focused_workspace]:set({
            background = { border_width = settings.workspace.background.border.width_focused },
        })
    end)
end)
