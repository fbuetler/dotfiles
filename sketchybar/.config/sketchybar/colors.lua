#!/usr/bin/env lua

return {
    -- solid
    white = 0xffffffff,
    black = 0xff000000,
    yellow = 0xffffcc00,

    -- transparent
    transparent_grey = 0x40ffffff,
    transparent_black = 0x40000000,

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
}
