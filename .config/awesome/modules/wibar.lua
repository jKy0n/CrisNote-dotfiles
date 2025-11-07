--[[
        jKyon (John Kennedy Loria Segundo)
        wibar.lua – awesomeWM
        2025-11-07

        Purpose:
            Defines the wibar (top bar) for AwesomeWM.
            Configures widgets, layouts, and appearance for the wibar, enhancing user interaction.

            Define a wibar (barra superior) para o AwesomeWM.
            Configura widgets, layouts e aparência da wibar, melhorando a interação do usuário.
--]]

--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")
local wibox = require("wibox")

-- my widgets
local cpu_monitor = require("jkyon-widgets.cpu_monitor")
local ram_monitor = require("jkyon-widgets.ram_monitor")
local battery_widget = require("jkyon-widgets.battery_widget")
local internet_widget = require("jkyon-widgets.internet_widget")
local dnd_widget = require("jkyon-widgets.DoNotDisturb_widget")
local update_checker = require("jkyon-widgets.paru_update_checker")

local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")

local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

--------------------------------------------------------------
tbox_separator_space = wibox.widget.textbox (" ")
tbox_separator_pipe = wibox.widget.textbox (" | ")
tbox_separator_dash = wibox.widget.textbox (" - ")

local function styled_textbox(text, font_size, margins)
    return wibox.widget {
        text = text,
        font = 'MesloLGS Nerd Font ' .. font_size,
        widget = wibox.widget.textbox,
        margins = margins
    }
end

local cpu_icon = styled_textbox('  ', 11, 2)
local mem_icon = styled_textbox('   ', 11, 2)
-- local gpu_icon = styled_textbox(' 󰢮 ', 16, 1)
local temp_icon = styled_textbox('  ', 11, 1)
-- local psu_icon = styled_textbox(' 󰚥 ', 11, 1)
local battery_icon = styled_textbox('  ', 11, 1)
--------------------------------------------------------------

-- mytextclock = wibox.widget.textclock()
mytextclock = wibox.widget.textclock(' %a, %d %b - %H:%M ', 59)

local cw = calendar_widget({
    theme = 'naughty',
    placement = 'top_right',
    start_sunday = false,
    radius = 8,
--  with customized next/previous (see table above)
    previous_month_button = 1,
    next_month_button = 3,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)


local wibar = {}

function wibar.setup(s)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            tbox_separator_space,
            s.mylayoutbox,
            tbox_separator_space,
            tbox_separator_space,
            s.mytaglist,
            tbox_separator_space,
            s.mypromptbox,
            tbox_separator_space,
        },
        
        s.mytasklist, -- Middle widget
        
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,

            internet_widget,
            update_checker,
            tbox_separator_space,
            cpu_monitor({ "usage", "freq", "temp" }),
            tbox_separator_pipe, -- |
            cpu_widget(),            
            tbox_separator_pipe, -- |
            ram_monitor({ "usage_available" }),
            tbox_separator_pipe, -- |
            battery_icon,
            battery_widget,
            tbox_separator_space,

            volume_widget({
                widget_type = 'arc',
                thickness = 2,
                step = 5,
                mixer_cmd = 'pavucontrol',
                device = '@DEFAULT_SINK@',
                tooltip = 'false'
            }),

            tbox_separator_space,
            todo_widget(),
            tbox_separator_space,
            wibox.widget.systray(),
            tbox_separator_space,
            tbox_separator_space,
            dnd_widget,
            tbox_separator_space,
            mytextclock,
            tbox_separator_space,

            logout_menu_widget{
                font = 'MesloLGS Nerd Font Bold 10',
                onlogout   =  function() awful.spawn.with_shell("loginctl terminate-user $USER") end,
                onlock     =  function() awful.spawn.with_shell('light-locker-command --lock') end,
                onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
            },
            tbox_separator_space
        },
    }
end

return wibar