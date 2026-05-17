-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                       Global Keys                        ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local mainMod = 'SUPER'
local secondMod = mainMod .. ' + SHIFT'

-- Helper
hl.bind(secondMod .. ' + code:61', hl.dsp.exec_cmd('~/.config/hypr/bin/menu-keybindings.sh')) -- Question mark
hl.bind(secondMod .. ' + SPACE', hl.dsp.exec_cmd('pkill -SIGUSR1 waybar'))                    -- toggle waybar
hl.bind(secondMod .. ' + F5', hl.dsp.exec_cmd('hyprctl reload'))

-- Notifications
hl.bind(mainMod .. ' + comma', hl.dsp.exec_cmd('makoctl dismiss'))
hl.bind(secondMod .. ' + comma', hl.dsp.exec_cmd('makoctl dismiss --all'))
hl.bind(mainMod .. ' + comma',
  hl.dsp.exec_cmd(
    [[makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send "Silenced notifications" || notify-send "Enabled notifications"]]))

-- Powermenu
hl.bind(mainMod .. ' + escape', hl.dsp.exec_cmd('hyprlock'))
hl.bind(secondMod .. ' + escape', hl.dsp.exec_cmd('~/.config/hypr/bin/menu-power.sh'))

-- Toggle idle
hl.bind(mainMod .. ' + CTRL + i', hl.dsp.exec_cmd('~/.config/hypr/bin/toggle-idle.sh'))

-- Screenshots
hl.bind('PRINT', hl.dsp.exec_cmd('~/.config/hypr/bin/hypr-cmd-screenshot.sh'))
hl.bind('ALT + PRINT', hl.dsp.exec_cmd('~/.config/hypr/bin/hypr-cmd-screenshot.sh window'))
hl.bind('CTRL + PRINT', hl.dsp.exec_cmd('~/.config/hypr/bin/hypr-cmd-screenshot.sh output'))

-- Color picker
hl.bind(mainMod .. ' + PRINT', hl.dsp.exec_cmd('hyprpicker -a'))

-- Trigger when the switch is toggled
local lid_switch = '559434a3af40'
hl.bind('switch:' .. lid_switch, hl.dsp.exec_cmd('hyprlock'), { locked = true })
-- trigger when the switch is turning on
hl.bind('switch:on:' .. lid_switch, hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-2, 1920x1080@120, 0x0, 1"'),
  { locked = true })
-- trigger when the switch is turning off
hl.bind('switch:off:' .. lid_switch, hl.dsp.exec_cmd('hyprctl keyword monitor "eDP-2, disable"'), { locked = true })

-- Waybar
hl.bind(secondMod .. ' + B', hl.dsp.exec_cmd('~/.local/bin/reload.sh -b'))
