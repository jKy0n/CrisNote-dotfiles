



--------------------------------------------------------------
----------------------  Load Libraries  ----------------------
local awful = require("awful")
local beautiful = require("beautiful")
local create_volatile_tag = require("modules.tag_utils").create_volatile_tag

------------------------------------------------------------
----------------------  rules module  ----------------------
local rules = {}

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


-- A
--
{ rule_any = { class = {"ark"} },
properties = { floating = true,
placement = awful.placement.centered },},

{ rule_any = { class = {"Arandr"} },
properties = { floating = true,
placement = awful.placement.centered },},

-- B
-- 
{ rule_any = { class = {"brasero", "Brasero"} },
properties = { floating = true,
placement = awful.placement.centered },},

-- C
-- 
-- D
-- 
{ rule_any = { class = {"dolphin", "dolphin"} },
properties = { floating = true,
placement = awful.placement.centered },},

-- E
-- 
-- F
-- 
{ rule = { class = "feh" },
properties = { floating = true, name = "feh",
width = 1536,     -- Defina o tamanho que deseja
height = 864,     -- Defina o tamanho que deseja
x = 192,          -- Posição x
y = 108,          -- Posição y
screen = 1  }},

-- G
-- 
{ rule_any = { class = {"gedit", "Gedit"} },
properties = { floating = true,
placement = awful.placement.centered },},

{ rule_any = { class = {"gimp", "Gimp"} },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " GIMP ", 1, awful.layout.suit.tile.left)
    end,},},

{ rule = { class = "Google-chrome" },
properties = { floating = false,
placement = awful.placement.centered },},

{ rule = { class = "gnome-calculator" },
properties = { floating = true,
placement = awful.placement.centered },},

{ rule_any = { class = {"Gnome-disks", "gnome-disks"} },
properties = { floating = true,
placement = awful.placement.centered },},

{ rule_any = { class = {"gpt4all-chat", "GPT4All"} },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile.left)
    end,},},

-- H
-- 
-- I
-- 
-- J
-- 
-- K
-- 
{ rule_any = { name = { "kclock", "kclock" } },
properties = { floating = true,
placement = awful.placement.centered,
tag = awful.screen.focused().tags[1], },},    

{ rule = { name = "KDE Connect" },
properties = { floating = true,
                tag = awful.screen.focused().tags[1],
placement = awful.placement.centered,},},    

{ rule_any = { name = { "krita", "krita" } },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " Krita ", 1, awful.layout.suit.tile)
end,},},

-- L
-- 
{ rule_any = { name = {"lm studio", "LM Studio" } },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " LLMs ", 1, awful.layout.suit.tile)
end,},},

{ rule = { class = "Lxappearance" },
properties = { floating = true,
placement = awful.placement.centered },},

-- M
--
{ rule = { class = "mpv" },
properties = { floating = true, name = "mpv",
                width = 1536,     -- Defina o tamanho que deseja
                height = 864,     -- Defina o tamanho que deseja
                screen = 1 },
callback = function(c)
    awful.placement.centered(c, { honor_workarea = true })
end },

{ rule_any = { name = {"mupdf", "MuPDF"} },
properties = { floating = true, name = "muPDF",
                width = 1536,     -- Defina o tamanho que deseja
                height = 864,     -- Defina o tamanho que deseja
                screen = 1 },
callback = function(c)
    awful.placement.centered(c, { honor_workarea = true })
end },

-- N
-- 
-- O
-- 
{ rule_any = {  class = { "obsidian", "obsidian" } },
properties = {  floating = false,
    tag = awful.screen.focused().tags[4],},},

{ rule_any = { name = { "okular", "okular" } },
properties = { floating = true, name = "muPDF",
                width = 1536,     -- Defina o tamanho que deseja
                height = 864,     -- Defina o tamanho que deseja
                screen = 1 },
callback = function(c)
    awful.placement.centered(c, { honor_workarea = true })
end },

{ rule = { class = "openrgb" },
properties = { floating = true,
placement = awful.placement.centered },},

-- P
-- 

{ rule_any = { class = {"pavucontrol", "Pavucontrol"} },
properties = { floating = false,
tag = awful.screen.focused().tags[4],},},
-- Q
-- 
{ rule = { class = "qt5ct" },
properties = { floating = true,
placement = awful.placement.centered },},

{ rule = { class = "qt6ct" },
properties = { floating = true,
placement = awful.placement.centered },},

-- R
-- 
{ rule = { class = "rambox" },
properties = { floating = false,
placement = awful.placement.centered,
-- tag = screen[2].tags[3],
},},

-- S
--
{ rule_any = { class = {"simple-scan", "simple-scan"} },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " Scan ", 1, awful.layout.suit.tile)
    end,},},

{ rule = { class = "Spotify" },
properties = { floating = false,
placement = awful.placement.centered,
tag = awful.screen.focused().tags[5],},},

{ rule_any = { class = {"snappergui", "Snapper-gui"} },
properties = { floating = true,
placement = awful.placement.centered,},},
-- T
-- 
{ rule_any = { class = {"Mail", "thunderbird"} },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " Mail ", 1, awful.layout.suit.tile)
    end,},},

-- U
-- 
-- V
-- 
{ rule_any = { class = {"virt-manager", "Virt-manager"} },
properties = { floating = false,
    callback = function(c)
        create_volatile_tag(c, " VMs ", 1, awful.layout.suit.tile)
    end,},},

    { rule_any = { class = {"code", "Code"} }, -- VSCode
properties = { floating = false,
placement = awful.placement.left,
tag = awful.screen.focused().tags[2],},},

-- W
-- 
-- X
-- 
-- Y
-- 
-- Z


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


return rules