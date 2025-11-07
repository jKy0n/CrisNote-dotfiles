--[[
        jKyon (John Kennedy Loria Segundo)
        theme.lua – awesomeWM
        2025-11-07

        Purpose:
            AwesomeWM theme configuration.
            Configures colors, fonts, layouts, and other aesthetic aspects.

            Configuração do tema do AwesomeWM.
            Configura cores, fonte, formatos e demais aspectos estéticos.
--]]


local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local gears = require("gears")


local theme = {}

-- fonte do Awesome --
theme.font              =   "MesloLGS Nerd Font Bold 8"

-- Basicamente bg é fundo e fg é texto --
-- Cor de fundo da Wibar --
theme.bg_normal         =   "#1e2030"
theme.bg_focus          =   "#8aadf4"
theme.bg_urgent         =   "#ed8796"
theme.bg_minimize       =   "#181926"
theme.bg_systray        =   theme.bg_normal

-- Cor do texto da Wibar --
theme.fg_normal         =   "#cad3f5"
theme.fg_focus          =   "#1e2030"
theme.fg_urgent         =   "#1e2030"
theme.fg_minimize       =   "#6e738d"

-- Cor da borda das janelas/Clients --
theme.border_normal     =   "#1e2030"
theme.border_focus      =   "#8aadf4"
theme.border_active     =   "#8aadf4"
theme.border_marked     =   "#ed8796"

-- Cor do texto dos Tags --
theme.taglist_fg_empty  =   "#6e738d"

-- Tamanho do gap entre as janelas --
theme.useless_gap       =   dpi(2)

-- Tamanho da borda das janelas --
theme.border_width      =   dpi(3)

-- You can use your own layout icons like this:
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"

-- Defines shapes --
theme.tasklist_shape = gears.shape.rounded_rect
theme.taglist_shape = gears.shape.rounded_rect
theme.notification_shape = gears.shape.rounded_rect

return theme