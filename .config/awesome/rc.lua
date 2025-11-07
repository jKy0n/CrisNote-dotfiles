--[[
        jKyon (John Kennedy Loria Segundo)
        rc.lua – awesomeWM
        2025-11-07

        Purpose:
            Configuração personalizada e modularizada para o Crisnote,
            maximizando performance, aparência e aproveitamento de tela.

            Tailored and modular configuration for the Crisnote,
            maximizing performance, aesthetics, and efficient use of screen space.
--]]

--------------------------------------------------------------
-----------------------  First steps  ------------------------
-- Load luarocks
pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("/home/jkyon/.config/awesome/themes/jkyon-catppuccin-theme/theme.lua")

------------------------------------------------------------------------------
------------------------ Load Variables Definitions --------------------------
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-----------------------------------------------------------------------------
-------------------------------- Load Modules -------------------------------
local notify_manager = require("modules.notify_manager")
local errors_handling = require("modules.errors_handling")
local layouts = require("modules.layouts")
local tag_utils = require("modules.tag_utils")
local buttons = require("modules.buttons")
local taglist_buttons = buttons.taglist_buttons(modkey)
local tasklist_buttons = buttons.tasklist_buttons()
local tags = require("modules.tags")
local wibar_manager = require("modules.wibar_manager")
    wibar_manager.setup(taglist_buttons, tasklist_buttons)
local keys = require("modules.keys")
    root.keys(globalkeys)
local rules = require("modules.rules")
local signals = require("modules.signals")

------------------------  Autostart Applications  ---------------------
-- Set wallpaper
awful.spawn.with_shell("feh --bg-fill ~/Pictures/Wallpapers/galaxia-de-andromeda-4k.webp")
awful.spawn.once("xsettingsd")

-- Start awesome target on systemd (screensaver dependency)
-- awful.spawn.easy_async_with_shell(
--   "systemctl --user start awesomewm.target",
--   function() end
-- )
-- Start some applications
awful.spawn.with_shell("sh /home/jkyon/.config/awesome/autorun.sh")