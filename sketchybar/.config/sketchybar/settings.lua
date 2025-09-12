#!/usr/bin/env lua

return {
    paddings = 4,

    animation = {
        curve = "tanh",
        duration = 10,
    },

    workspace = {
        label = {
            padding = 0,
        },
        icon = {
            padding = 8,
        },
        background = {
            corner_radius = 5,
            height = 25,
        },
        border = {
            width = 0,
            width_focused = 3,
        }
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
}
