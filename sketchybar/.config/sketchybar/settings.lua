#!/usr/bin/env lua

local colors = require("colors")

return {
    default = {
        padding_left = 1,
        padding_right = 1,

        icon = {
            padding_left = 1,
            padding_right = 1,
            font = {
                style = "Semibold",
                size = 14.0,
            },
            color = colors.white,
        },

        label = {
            padding_left = 1,
            padding_right = 1,
            font = {
                style = "Regular",
                size = 12.0,
            },
            color = colors.white,
        },

        font = {
            text = "Hack Nerd Font", -- Used for text
            -- numbers = "SF Mono", -- Used for numbers

            -- Unified font style map
            style_map = {
                ["Regular"] = "Regular",
                ["Semibold"] = "Semibold",
                ["Bold"] = "Bold",
                ["Heavy"] = "Heavy",
                ["Black"] = "Black",
            }
        }
    },

    bar = {
        height = 30,
        blur_radius = 30,
        color = colors.transparent_black,

        position = "bottom",
        display = "all",
        topmost = "window",
        sticky = true,
    },

    workspace = {
        icon = {
            align = "center",
            width = 26,
            padding = 8,
        },
        label = {
            width = 0,
        },
        background = {
            corner_radius = 5,
            height = 25,
            color = colors.transparent_grey,
            border = {
                color = colors.yellow,
                width = 0,
                width_focused = 3,
            },
        },
    },

    indicator = {
        display = "active",
        position = "center",

        icon = {
            padding = 0,
        },
        label = {
            align = "center",
            padding = 8,
            color = colors.black,
        },
        background = {
            height = 25,
            corner_radius = 5,
            color = colors.yellow,
        },
    },

    animation = {
        curve = "tanh",
        duration = 10,
    },
}
