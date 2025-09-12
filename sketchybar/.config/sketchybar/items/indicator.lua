#!/usr/bin/env lua

local indicator = sbar.add("item", {
    display = "active",
    position = "center",
    drawing = false,

    icon = {
        padding_left = 0,
        padding_right = 0,
    },
    label = {
        string = "",
        color = 0xff000000,
        align = "center",
        padding_left = 8,
        padding_right = 8,
    },
    background = {
        color = 0xffffcc00,
        corner_radius = 5,
        height = 25,
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
