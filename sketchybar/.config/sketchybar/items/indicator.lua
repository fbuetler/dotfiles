#!/usr/bin/env lua

local settings = require("settings")

local indicator = sbar.add("item", {
    display = settings.indicator.display,
    position = settings.indicator.position,
    drawing = false,

    icon = {
        padding_left = settings.indicator.icon.padding,
        padding_right = settings.indicator.icon.padding,
    },
    label = {
        string = "",
        align = settings.indicator.label.align,
        padding_left = settings.indicator.label.padding,
        padding_right = settings.indicator.label.padding,
        color = settings.indicator.label.color,
    },
    background = {
        color = settings.indicator.background.color,
        corner_radius = settings.indicator.background.corner_radius,
        height = settings.indicator.background.height,
    },
})

indicator:subscribe("show_indicator", function(event)
    indicator:set({
        label = event.INDICATOR,
        drawing = true,
    })
end)

indicator:subscribe("hide_indicator", function()
    indicator:set({
        label = "",
        drawing = false,
    })
end)
