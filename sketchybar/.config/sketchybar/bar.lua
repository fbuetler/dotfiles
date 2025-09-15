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

local settings = require("settings")

sbar.bar({
    position = settings.bar.position,
    display = settings.bar.display,
    topmost = settings.bar.topmost,
    sticky = settings.bar.sticky,

    height = settings.bar.height,
    blur_radius = settings.bar.blur_radius,
    color = settings.bar.color
})
