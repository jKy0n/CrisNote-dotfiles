
--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")

---------------------------------------------------------------
----------------------  layouts module  ----------------------
local layouts = {}

---------------------------------------------------------------
---------------------  layouts available  ---------------------

awful.layout.layouts = {
    
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,

    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,

    awful.layout.suit.max,

    -- awful.layout.suit.floating,
}

return layouts