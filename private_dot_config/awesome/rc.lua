-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


beautiful.init(theme_path)


local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
-- local todo_widget = require("awesome-wm-widgets.todo-widget.todo")

local vicious = require("vicious")
local lain = require "lain"
local mymem = lain.widget.mem()


local mem = lain.widget.mem {
    settings = function()
        widget:set_markup("RAM " .. mem_now.perc .. "%")
    end
}



-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/jkyon/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-------------------  Tags Manipulation Functions  -------------------

local function add_tag()
    awful.tag.add(" NewTag ", {
        screen = awful.screen.focused(),
        layout = awful.layout.suit.tile,
        volatile = true
    }):view_only()
end 

local function delete_tag()
    local t = awful.screen.focused().selected_tag
    if not t then return end
    t:delete()
end

local function rename_tag()
    awful.prompt.run {
        prompt       = "New tag name: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(new_name)
            if not new_name or #new_name == 0 then return end

            local t = awful.screen.focused().selected_tag
            if t then
                t.name = new_name
            end
        end
    }
end

local function move_to_new_tag()
    local c = client.focus
    if not c then return end

    local t = awful.tag.add(c.class,{screen= c.screen, layout = awful.layout.suit.tile, volatile = true })
    c:tags({t})
    t:view_only()
end

-------------------  Tags Manipulation Functions  -------------------

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

-- local function set_wallpaper(s)
--     -- Wallpaper
--     if beautiful.wallpaper then
--         local wallpaper = beautiful.wallpaper
--         -- If wallpaper is a function, call it with the screen
--         if type(wallpaper) == "function" then
--             wallpaper = wallpaper(s)
--         end
--         gears.wallpaper.maximized(wallpaper, s, true)
--     end
-- end

-- -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

-- Função para configurar as tags apenas quando há mais de um monitor
-- local function setup_tags()
    -- Para a tela principal (screen 1)
    awful.tag.add( "Monitor (1) ", {
        layout = awful.layout.suit.max,
        selected = false,
        screen = screen[1]
    })

    awful.tag.add( "Music (2) ", {
        layout = awful.layout.suit.tile.right,
        selected = false,
        screen = screen[1]
    })

    awful.tag.add( "Krita (3) ", {
        layout = awful.layout.suit.max,
        selected = true,
        screen = screen[1]
    })

    awful.tag.add( "Reference (4) ", {
        layout = awful.layout.suit.tile.right,
        selected = false,
        screen = screen[1]
    })

    awful.tag.add( "System (5) ", {
        layout = awful.layout.suit.tile.right,
        selected = false,
        screen = screen[1]
    })

    awful.tag.add( "etc (6) ", {
        layout = awful.layout.suit.tile.right,
        selected = false,
        screen = screen[1]
    })

    -- -- Verifica se há mais de um monitor conectado
    -- if screen:count() > 1 then
    --     -- Para a segunda tela (screen 2)
        awful.tag.add(" System (1) ", {
            layout = awful.layout.suit.tile.right,
            selected = true,
            screen = screen[2]
        })

        -- awful.tag.add(" Teste (2) ", {
        --     layout = awful.layout.suit.tile.right,
        --     selected = false,
        --     screen = screen[2]
        -- })
--     end
-- end

-- Conecta o sinal para criar as tags dinamicamente quando a tela muda
-- screen.connect_signal("added", function() setup_tags() end)
-- screen.connect_signal("removed", function() setup_tags() end)

-- Configura as tags na inicialização
-- setup_tags()


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
        buttons = tasklist_buttons,
        style   = {
             shape  = gears.shape.rounded_bar,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
	    s.mylayoutbox,
	            wibox.widget.textbox('   '),
            s.mytaglist,
            --    wibox.widget.textbox('   '),
            s.mypromptbox,
                wibox.widget.textbox('   '),
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
                    wibox.widget.textbox('   '),
                        wibox.widget.textbox('   '),
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/dwmBlocksCpuUsage"', 1),
                    wibox.widget.textbox(' | '),
                        wibox.widget.textbox('   '),    
--            mem.widget,
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/memoryUsage-widget.sh"', 1),
                    wibox.widget.textbox(' | '),
                        wibox.widget.textbox('  '),
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/CrisNoteCPUtemp.sh"', 1),
                    wibox.widget.textbox(' | '),
                        wibox.widget.textbox('   '),
            awful.widget.watch('bash -c "sh /home/jkyon/ShellScript/battery-widget.sh"', 5),
                    wibox.widget.textbox(' |  '),

            volume_widget({ 
                widget_type = 'arc',
                thickness   = 2 ,
                step        = 5 ,
                mixer_cmd   = 'pavucontrol',
                device      = '@DEFAULT_SINK@',
                tooltip     = false
                }),

                wibox.widget.textbox('   '),
                wibox.widget.textbox(' | '),
                wibox.widget.textbox('   '),
                    
            -- todo_widget(),

            wibox.widget.systray(),
                    wibox.widget.textbox('  '),
            wibox.widget.textclock(" %a, %d %B - %H:%M  ",10),
                    wibox.widget.textbox(' '),
            logout_menu_widget{
                -- font = 'Noto Sans semibold 9',
                 onlogout   =  function() awesome.quit() end,
                --  onlock     =  function() awful.spawn.with_shell('xscreensaver-command -lock') end,
                 onsuspend  =  function() awful.spawn.with_shell("systemctl suspend") end,
                 onreboot   =  function() awful.spawn.with_shell("systemctl reboot") end,
                 onpoweroff =  function() awful.spawn.with_shell("systemctl poweroff") end,
            },
                    wibox.widget.textbox(' '),
            -- mytextclock,
            -- s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --          {description = "show the menubar", group = "launcher"})
    -- Rofi
	awful.key({ modkey }, "p",
	    function() awful.spawn("rofi -show combi -combi-modi drun,window -icon-theme \"Papirus\" -show-icons")
		end),

    awful.key({ }, "Print", function() awful.util.spawn("gnome-screenshot --interactive") end),


---------------------  Tags Manipulation keybinds  ---------------------
------------------------------------------------------------------------

    awful.key({ modkey,           }, "a", add_tag,
        {description = "add a tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "a", delete_tag,
        {description = "delete the current tag", group = "tag"}),
    awful.key({ modkey, "Shift"   }, "r", rename_tag,
        {description = "rename the current tag", group = "tag"}),
    awful.key({ modkey, "Control"   }, "a", move_to_new_tag,
        {description = "add a tag with the focused client", group = "tag"})

------------------------------------------------------------------------


)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})

        -- KeyBinds Media
    awful.key({}, "XF86AudioRaiseVolume", function() volume_widget:inc(5) end),
    awful.key({}, "XF86AudioLowerVolume", function() volume_widget:dec(5) end),
    awful.key({}, "XF86AudioMute", function() volume_widget:toggle() end),

    awful.key({}, "XF86AudioPrev", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous") end),
    awful.key({}, "XF86AudioNext", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next") end),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause") end),
    awful.key({}, "XF86AudioStop", function() awful.util.spawn("dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause") end),
)
    
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },


        ---------------------------------------------
        -----------------  My Rules ----------------- 
        ---------------------------------------------

-- A
--
        { rule_any = { class = {"ark"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- B
--
-- C
--
-- D
--

        { rule = { class = "discord" },
            properties = {
                floating = false,
                callback = function(c)
                    -- Monitor desejado
                    local screen_index = 1 -- Substitua pelo índice do monitor desejado
                    -- Crie uma nova tag volátil
                    local tag_name = " Chat " -- Nome base da tag
                    local new_tag = awful.tag.add(tag_name, {
                        screen = screen_index,
                        layout = awful.layout.suit.max,
                        volatile = true, })
                    -- Adiciona o número da tag no nome
                    local tag_index = new_tag.index
                    new_tag.name = tag_name .. " (" .. tag_index .. ") "
                    -- Move o cliente para a nova tag
                    c:move_to_tag(new_tag)
                    -- Alterna para a nova tag
                    new_tag:view_only()
                end, }, },


        -- { rule = { class = "discord" },
        -- properties = { floating = false,
        -- placement = awful.placement.centered },},
       
        { rule = { class = "dolphin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- E
--
-- F
--
        { rule = { class = "feh" },
        properties = { floating = true, name = "feh",
            width = 1720,     -- Defina o tamanho que deseja
            height = 880,     -- Defina o tamanho que deseja
            x = 100,          -- Posição x
            y = 100,          -- Posição y
            placement = awful.placement.centered
--        screen = 1  }},
        },},
-- G
--
        { rule_any = { class = {"gedit", "Gedit"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        -- { rule = { class = "Google-chrome" },
        -- properties = { floating = false,
        -- placement = awful.placement.centered },},

        { rule = { class = "Google-chrome" },
            properties = {
                floating = false,
                callback = function(c)
                    -- Monitor desejado
                    local screen_index = 1 -- Substitua pelo índice do monitor desejado
                    -- Crie uma nova tag volátil
                    local tag_name = " Videos " -- Nome base da tag
                    local new_tag = awful.tag.add(tag_name, {
                        screen = screen_index,
                        layout = awful.layout.suit.max,
                        volatile = true, })
                    -- Adiciona o número da tag no nome
                    local tag_index = new_tag.index
                    new_tag.name = tag_name .. " (" .. tag_index .. ") "
                    -- Move o cliente para a nova tag
                    c:move_to_tag(new_tag)
                    -- Alterna para a nova tag
                    new_tag:view_only()
                end, }, },

        { rule = { class = "gnome-calculator" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule_any = { class = {"Gnome-disks", "gnome-disks"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "gpartedbin" },
        properties = { floating = true,
        placement = awful.placement.centered },},
        
        { rule = { class = "Gnome-screenshot" },
        properties = { floating = true,
        placement = awful.placement.centered },},        
-- H
--
        { rule_any = { class = {"Heroic Games Launcher", "heroic"} },
        properties = { floating = false,
        placement = awful.placement.centered },},
-- I
--
-- J
--
-- K
--
        { rule = { name = "KDE Connect" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "Krita" },       
        properties = { floating = false,          
        placement = awful.placement.centered, 
        tag = screen[1].tags[3] },},

-- L
--
        { rule = { name = "Lutris" },
        properties = { floating = true,
        placement = awful.placement.centered },},
    
        { rule = { class = "Lxappearance" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- M
--
        { rule_any = { class = {"mpv"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { name = "MuPDF" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- N
--      
        { rule = { class = "openrgb" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- O
--
-- P
--        
        { rule_any = { class = {"pavucontrol", "Pavucontrol"} },
        properties = { floating = false,
        tag = screen[1].tags[2] },},
        
        { rule = { class = "PrismLauncher" },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule_any = { class = {"ProtonUp-Qt"} },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- Q
-- 
-- R
--      
        { rule = { class = "rambox" },
        properties = { floating = false,
        placement = awful.placement.centered },},
-- S
--
        { rule = { class = "Spotify" },
        properties = { floating = false,
        placement = awful.placement.centered,
        tag = screen[1].tags[2] },},

        { rule_any = { class = {"snappergui", "Snapper-gui"} },
        properties = { floating = true,
        placement = awful.placement.centered },},

        { rule = { class = "steam" },
        properties = { floating = true,
        placement = awful.placement.right },},

-- T
--
        { rule = { class = "Thunar" },
        properties = { floating = true, placement = awful.placement.centered },},
        
        { rule = { class = "thunderbird" },
        properties = { floating = false,
        placement = awful.placement.left },},
        
        { rule = { class = "Timeshift" },
        properties = { floating = true,
        placement = awful.placement.centered },},
-- U
--
-- V
--
        { rule_any = { class = {"virt-manager", "Virt-manager"} },
        properties = { floating = true,
        placement = awful.placement.centered,},},

        { rule_any = { class = {"code", "Code"} },     -- vsCode
        properties = { floating = false,
        placement = awful.placement.centered,},},
-- W
--
-- X
--
-- Y
--
--        { rule = { class = "yakuake" },
--        properties = { floating = true, ontop = true, focus = true },
--        callback = function(c)
--            c:geometry({x=1450, y=25})
--            c:connect_signal("unmanage", function() free_focus = true end)
--        end },
-- Z
--          


    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

--    awful.titlebar(c) : setup {
--        { -- Left
--            awful.titlebar.widget.iconwidget(c),
--            buttons = buttons,
--            layout  = wibox.layout.fixed.horizontal
--        },
--        { -- Middle
--            { -- Title
--                align  = "center",
--                widget = awful.titlebar.widget.titlewidget(c)
--            },
--            buttons = buttons,
--            layout  = wibox.layout.flex.horizontal
--        },
--        { -- Right
--            awful.titlebar.widget.floatingbutton (c),
--            awful.titlebar.widget.maximizedbutton(c),
--            awful.titlebar.widget.stickybutton   (c),
--            awful.titlebar.widget.ontopbutton    (c),
--            awful.titlebar.widget.closebutton    (c),
--            layout = wibox.layout.fixed.horizontal()
--        },
--        layout = wibox.layout.align.horizontal
--    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--

awful.spawn.with_shell("sh /home/jkyon/.config/awesome/awesomeStartupApps.sh")
