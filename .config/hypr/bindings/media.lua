-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                       Global Keys                        ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local mainMod = 'SUPER'
-- local secondMod = mainMod .. ' + SHIFT'

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Media                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local osd_client = [[swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(osd_client .. ' --output-volume raise'),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(osd_client .. ' --output-volume lower'),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(osd_client .. ' --output-volume mute-toggle'),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(osd_client .. ' --input-volume mute-toggle'),
  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(osd_client .. " --playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(osd_client .. " --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(osd_client .. " --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(osd_client .. " --playerctl previous"), { locked = true })

-- Brightness
local brightness_raise = hl.dsp.exec_cmd(osd_client .. ' --brightness raise --device amdgpu_bl2')
local brightness_lower = hl.dsp.exec_cmd(osd_client .. ' --brightness lower --device amdgpu_bl2')
hl.bind("XF86MonBrightnessUp", brightness_raise, { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", brightness_lower, { locked = true, repeating = true })
hl.bind(mainMod .. ' + F3', brightness_raise, { locked = true, repeating = true })
hl.bind(mainMod .. ' + F2', brightness_lower, { locked = true, repeating = true })
