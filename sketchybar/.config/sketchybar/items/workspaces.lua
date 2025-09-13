#!/usr/bin/env lua

local colors = require("colors")
local settings = require("settings")

local QUERY_WORKSPACES =
"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_VISIBLE_WORKSPACES =
"aerospace list-workspaces --visible --monitor all --format '%{workspace}' --json"

local QUERY_FOCUSED_WORKSPACES = "aerospace list-workspaces --focused"

local QUERY_WINDOWS = "aerospace list-windows --monitor all --format '%{workspace}%{app-name}' --json"

local MONITOR_KEY = "monitor-appkit-nsscreen-screens-id"
local WORKSPACE_KEY = "workspace"
local APP_NAME_KEY = "app-name"

local WORKSPACE_CHANGE_EVENT = "aerospace_workspace_change"
local MONITOR_CHANGE_EVENT = "aerospace_display_change"

-- Add padding to the left
local root = sbar.add("item", {
    width = 0,
})

local workspaces = {}

local function getWorkspacesState(f)
    local open_windows = {}
    sbar.exec(QUERY_WINDOWS, function(workspace_and_app)
        for _, entry in ipairs(workspace_and_app) do
            local workspace_index, app = entry[WORKSPACE_KEY], entry[APP_NAME_KEY]
            if open_windows[workspace_index] == nil then
                open_windows[workspace_index] = {}
            end
            table.insert(open_windows[workspace_index], app)
        end

        sbar.exec(QUERY_FOCUSED_WORKSPACES, function(focused_workspaces)
            local focused_workspace = focused_workspaces:match("^%s*(.-)%s*$")
            sbar.exec(QUERY_VISIBLE_WORKSPACES, function(visible_workspaces)
                sbar.exec(QUERY_WORKSPACES, function(workspaces_and_monitors)
                    local workspace_to_monitor = {}
                    for _, entry in ipairs(workspaces_and_monitors) do
                        local workspace_index = entry[WORKSPACE_KEY]
                        local monitor_id = entry[MONITOR_KEY]
                        workspace_to_monitor[workspace_index] = monitor_id
                    end

                    local args = {
                        open_windows = open_windows,
                        focused_workspace = focused_workspace,
                        visible_workspaces = visible_workspaces,
                        workspace_to_monitor = workspace_to_monitor
                    }
                    f(args)
                end)
            end)
        end)
    end)
end

local function toggleWorkspaceVisibility(workspace_index, args)
    local open_windows = args.open_windows[workspace_index]
    local focused_workspace = args.focused_workspace
    local visible_workspaces = args.visible_workspaces
    local workspace_to_monitor = args.workspace_to_monitor

    if open_windows == nil then
        open_windows = {}
    end

    -- TODO maybe pass no_app directly
    local no_app = true
    for _, _ in ipairs(open_windows) do
        no_app = false
    end
    local has_apps = not no_app

    local is_visible = false
    for _, visible_workspace in ipairs(visible_workspaces) do
        if workspace_index == visible_workspace[WORKSPACE_KEY] then
            is_visible = true
            break
        end
    end

    -- show empty focused workspace/non-empty workspace
        workspaces[workspace_index]:set({
            display = workspace_to_monitor[workspace_index],
        })
        return
    end

    -- hide empty unfocused workspace
    if no_app and workspace_index ~= focused_workspace then
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
                align = "center",
                padding_left = settings.workspace.icon.padding,
                padding_right = settings.workspace.icon.padding,
                string = workspace_index,
            },
            label = {
                align = "center",
                padding_left = settings.workspace.label.padding,
                padding_right = settings.workspace.label.padding,
            },
            background = {
                color = colors.workspace.background,
                corner_radius = settings.workspace.background.corner_radius,
                height = settings.workspace.background.height,

                border_color = colors.workspace.border,
                border_width = settings.workspace.border.width,
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
                        border_width = is_focused and settings.workspace.border.width_focused or
                            settings.workspace.border.width, -- tenary operation
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
            background = { border_width = settings.workspace.border.width_focused },
        })
    end)
end)
