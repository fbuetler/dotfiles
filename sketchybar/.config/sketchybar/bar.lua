#!/usr/bin/env lua

-- ##### Bar Appearance #####
-- # Configuring the general appearance of the bar.
-- # These are only some of the options available. For all options see:
-- # https://felixkratz.github.io/SketchyBar/config/bar
-- # If you are looking for other colors, see the color picker:
-- # https://felixkratz.github.io/SketchyBar/config/tricks#color-picker
-- bar=(
--     position=bottom
--     display=all
--     topmost=window
--     sticky=on

--     height=30
--     blur_radius=30
--     color=0x40000000
-- )
-- sketchybar --bar "${bar[@]}"

local colors = require("colors")

sbar.bar({
    position = "bottom",
    display = "all",
    topmost = "window",
    sticky = "on",

    height = 30,
    blur_radius = 30,
    color = colors.bar.background
})
