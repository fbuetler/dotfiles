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

-- Equivalent to the --default domain
sbar.default({
    padding_left = settings.default.padding_left,
    padding_right = settings.default.padding_right,

    icon = {
        font = {
            family = settings.default.font.text,
            style = settings.default.font.style_map[settings.default.icon.font.style],
            size = settings.default.icon.font.size,
        },
        color = settings.default.icon.color,
        padding_left = settings.default.icon.padding_left,
        padding_right = settings.default.icon.padding_right,
    },

    label = {
        font = {
            family = settings.default.font.text,
            style = settings.default.font.style_map[settings.default.label.font.style],
            size = settings.default.label.font.size,
        },
        color = settings.default.label.color,
        padding_left = settings.default.label.padding_left,
        padding_right = settings.default.label.padding_right,
    },
})
