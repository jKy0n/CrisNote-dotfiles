local awful  = require("awful")
local wibox  = require("wibox")
local gears  = require("gears")

local battery_widget = wibox.widget.textbox()

battery_widget.font = "MesloLGS Nerd Font Bold 8"

local function get_battery_info()
  local cmd = [[acpi -b]]
  local fd  = io.popen(cmd)
  local out = fd:read("*all")
  fd:close()

  local level = out:match("(%d?%d?%d)%%") or "0"
  local charging = out:match("Charging")

  return tonumber(level), charging
end

local function update_widget()
  local level, charging = get_battery_info()
  local color
  if level < 33 then
    color = "#ED8796" -- vermelho
  elseif level < 50 then
    color = "#EED49F" -- amarelo
  else
    color = "#CAD3F5" -- branco
  end

  local symbol = charging and "🟢" or ""
  battery_widget.markup = string.format("<span foreground='%s'>%d%% %s</span>", color, level, symbol)
end

gears.timer.start_new(5, function()
  update_widget()
  return true
end)

update_widget()

return battery_widget