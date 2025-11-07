




--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")

--------------------------------------------------------------
-------------------------  tags module  ----------------------
local tags = {}

awful.tag.add(" system (1) ", {
    layout = awful.layout.suit.max,
    selected = false,
    -- screen = s,
})

awful.tag.add(" code (2) ", {
    layout = awful.layout.suit.max,
    selected = true,
    -- screen = s,
})

awful.tag.add(" www (3) ", {
    layout = awful.layout.suit.tile,
    selected = false,
    -- screen = s,
})

awful.tag.add(" notes (4) ", {
    layout = awful.layout.suit.tile,
    selected = false,
    -- screen = s,
})

awful.tag.add(" music (5) ", {
    layout = awful.layout.suit.tile,
    selected = false,
    -- screen = s,
})

awful.tag.add(" term (6) ", {
    layout = awful.layout.suit.tile.left,
    selected = false,
    -- screen = s,
})

return tags