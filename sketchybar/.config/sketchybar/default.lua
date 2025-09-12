#!/usr/bin/env lua

-- ##### Changing Defaults #####
-- # We now change some default values, which are applied to all further items.
-- # For a full list of all available item properties see:
-- # https://felixkratz.github.io/SketchyBar/config/items

-- default=(
--     padding_left=5
--     padding_right=5

--     label.font="Hack Nerd Font:Bold:14.0"
--     label.color=0xffffffff
--     label.padding_left=4
--     label.padding_right=4

--     icon.font="Hack Nerd Font:Bold:17.0"
--     icon.color=0xffffffff
--     icon.padding_left=4
--     icon.padding_right=4
-- )
-- sketchybar --default "${default[@]}"

local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
    padding_left = 5,
    padding_right = 5,

    label = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14.0
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
    },

    icon = {
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 17.0
        },
        color = colors.white,
        padding_left = settings.paddings,
        padding_right = settings.paddings,
    },
})
