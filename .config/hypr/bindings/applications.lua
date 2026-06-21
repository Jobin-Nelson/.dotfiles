-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                       Global Keys                        ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local mainMod = 'SUPER'
-- local secondMod = mainMod .. ' + SHIFT'

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        Programs                          ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local terminal = 'uwsm app -- kitty --single-instance'
local menu = 'walker'
local browser =
'uwsm app -- chromium --new-window --ozone-platform=wayland --ozone-platform-hint=wayland --disable-features=WaylandWpColorManagerV1 --enable-features=WaylandWindowDecorations'
local browser_vpn = browser .. ' --user-data-dir="$HOME/.config/chromium-vpn" --class=chromium-vpn --incognito'
local webapp = browser .. ' --app='

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                          Binds                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

hl.bind(mainMod .. ' + return', hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. ' + F', hl.dsp.exec_cmd('uwsm app -- nautilus --new-window'))
hl.bind(mainMod .. ' + B', hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. ' + ALT + B', hl.dsp.exec_cmd(browser_vpn))
hl.bind(mainMod .. ' + space', hl.dsp.exec_cmd(menu))

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        Web Apps                          ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Switch to a submap called `webapps`.
hl.bind(mainMod .. ' + A', hl.dsp.submap('webapps'))
hl.define_submap('webapps', 'reset', function()
  hl.bind('A', hl.dsp.exec_cmd(webapp .. 'https://chatgpt.com'))
  hl.bind('G', hl.dsp.exec_cmd(webapp .. 'https://gemini.google.com/app'))
  hl.bind('W', hl.dsp.exec_cmd(webapp .. 'https://web.whatsapp.com'))
  hl.bind('T', hl.dsp.exec_cmd(webapp .. 'https://tasks.google.com'))
  hl.bind('M', hl.dsp.exec_cmd(webapp .. 'https://music.youtube.com'))
  hl.bind('I', hl.dsp.exec_cmd(webapp .. 'https://instagram.com'))
  hl.bind('h', hl.dsp.exec_cmd(webapp .. 'https://www.hotstar.com/in/mypage'))
  hl.bind('d', hl.dsp.exec_cmd(webapp .. 'https://discord.com/channels/@me'))
  hl.bind('F', hl.dsp.exec_cmd(webapp .. 'https://facebook.com'))

  hl.bind('escape', hl.dsp.submap('reset'))
  hl.bind('catchall', hl.dsp.submap('reset'))
end)
