--[[
        jKyon (John Kennedy Loria Segundo)
        wibar_manager.lua – awesomeWM
        2025-07-10
        
        Purpose:
            Manages the creation and configuration of wibar (top bar) in AwesomeWM.
            Sets up widgets like taglist, tasklist, promptbox, and layoutbox for each screen.

            Gerencia a criação e configuração do wibar (barra superior) no AwesomeWM.
            Configura widgets como taglist, tasklist, promptbox e layoutbox para cada tela.
--]]

--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")
local gears = require("gears")

local wibar = require("modules.wibar")

----------------------------------------------------------------
--------------------  wibar_manager module  --------------------
local wibar_manager = {}


function wibar_manager.setup(taglist_buttons, tasklist_buttons)

awful.screen.connect_for_each_screen(function(s)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    wibar.setup(s)

    end)
end

return wibar_manager