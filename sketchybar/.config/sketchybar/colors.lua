#!/usr/bin/env lua

return {
    white = 0xffffffff,

    bar = {
        background = 0x40000000, -- transparent
    },

    workspace = {
        background = 0x40ffffff, -- grey
        border = 0xffffcc00,     -- yellow
    },

    with_alpha = function(color, alpha)
        if alpha > 1.0 or alpha < 0.0 then return color end
        return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
    end,
}
