#!/usr/bin/env lua

local colors = require("colors")
local settings = require("settings")

local QUERY_WORKSPACES =
"aerospace list-workspaces --all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_VISIBLE_WORKSPACES =
"aerospace list-workspaces --visible --monitor all --format '%{workspace}%{monitor-appkit-nsscreen-screens-id}' --json"

local QUERY_FOCUSED_WORKSPACES = "aerospace list-workspaces --focused"

local QUERY_WINDOWS = "aerospace list-windows --monitor all --format '%{workspace}%{app-name}' --json"

local MONITOR_KEY = "monitor-appkit-nsscreen-screens-id"
local WORKSPACE_KEY = "workspace"
local APP_NAME_KEY = "app-name"

local WORKSPACE_CHANGE_EVENT = "aerospace_workspace_change"
local MONITOR_CHANGE_EVENT = "aerospace_display_change"
local FOCUS_CHANGE_EVENT = "aerospace_focus_change"

-- Add padding to the left
local root = sbar.add("item", {
    width = 0,
})

local workspaces = {}

local function withWindows(f)
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
            sbar.exec(QUERY_VISIBLE_WORKSPACES, function(visible_workspaces)
                local args = {
                    open_windows = open_windows,
                    focused_workspaces = focused_workspaces,
                    visible_workspaces = visible_workspaces
                }
                f(args)
            end)
        end)
    end)
end

local function updateWindow(workspace_index, args)
    local open_windows = args.open_windows[workspace_index]
    local focused_workspaces = args.focused_workspaces
    local visible_workspaces = args.visible_workspaces

    if open_windows == nil then
        open_windows = {}
    end

    -- TODO maybe pass no_app directly
    local no_app = true
    for _, _ in ipairs(open_windows) do
        no_app = false
    end

    sbar.animate(settings.animation.curve, settings.animation.duration, function()
        -- show empty focused workspace
        for _, visible_workspace in ipairs(visible_workspaces) do
            if no_app and workspace_index == visible_workspace[WORKSPACE_KEY] then
                local monitor_id = visible_workspace[MONITOR_KEY]

                workspaces[workspace_index]:set({
                    icon = { drawing = true },
                    label = { drawing = true },
                    background = { drawing = true },
                    display = monitor_id, -- TODO needed?
                })
                return
            end
        end

        -- hide empty unfocused workspace
        if no_app and workspace_index ~= focused_workspaces then
            workspaces[workspace_index]:set({
                icon = { drawing = false },
                label = { drawing = false },
                background = { drawing = false },
            })
            return
        end

        -- show empty focused workspace (TODO redundant?)
        if no_app and workspace_index == focused_workspaces then
            workspaces[workspace_index]:set({
                icon = { drawing = true },
                label = { drawing = true },
                background = { drawing = true },
            })
        end

        -- show by default (TODO needed?)
        workspaces[workspace_index]:set({
            label = { drawing = true },
            icon = { drawing = true },
            background = { drawing = true },
        })
    end)
end

local function updateWindows()
    withWindows(function(args)
        for workspace_index, _ in pairs(workspaces) do
            updateWindow(workspace_index, args)
        end
    end)
end

local function updateWorkspaceMonitor()
    local workspace_monitor = {}
    sbar.exec(QUERY_WORKSPACES, function(workspaces_and_monitors)
        for _, entry in ipairs(workspaces_and_monitors) do
            local workspace_index = entry[WORKSPACE_KEY]
            local monitor_id = entry[MONITOR_KEY]
            workspace_monitor[workspace_index] = monitor_id
        end

        for workspace_index, _ in pairs(workspaces) do
            workspaces[workspace_index]:set({
                display = workspace_monitor[workspace_index],
            })
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
                            settings.workspace.border.width,
                    },
                })
            end)
        end)
    end

    root:subscribe(FOCUS_CHANGE_EVENT, function()
        updateWindows()
    end)

    root:subscribe(MONITOR_CHANGE_EVENT, function()
        updateWindows()
        updateWorkspaceMonitor()
    end)

    -- initial setup
    updateWindows()
    updateWorkspaceMonitor()

    -- initial focus
    sbar.exec(QUERY_FOCUSED_WORKSPACES, function(focused_workspace)
        local focused_workspace = focused_workspace:match("^%s*(.-)%s*$")
        workspaces[focused_workspace]:set({
            background = { border_width = settings.workspace.border.width_focused },
        })
    end)
end)
