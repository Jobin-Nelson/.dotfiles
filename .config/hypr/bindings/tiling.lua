-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                       Global Keys                        ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local mainMod = 'SUPER'
local secondMod = mainMod .. ' + SHIFT'

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Window                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(secondMod .. '+ ALT + Q', hl.dsp.exec_cmd('uwsm stop'))
hl.bind(mainMod .. ' + Q', hl.dsp.window.close())
hl.bind(mainMod .. ' + V', hl.dsp.window.float({ action = 'toggle' }))
hl.bind(mainMod .. ' + F11', hl.dsp.window.fullscreen({ action = 'toggle' }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. ' + H', hl.dsp.focus({ direction = 'l' }))
hl.bind(mainMod .. ' + L', hl.dsp.focus({ direction = 'r' }))
hl.bind(mainMod .. ' + K', hl.dsp.focus({ direction = 'u' }))
hl.bind(mainMod .. ' + J', hl.dsp.focus({ direction = 'd' }))

-- Cycle windows
hl.bind('ALT + Tab', function()
  local ws = hl.get_active_workspace()
  if not ws then return end
  local dispatch = ws.tiled_layout == 'monocle' and hl.dsp.layout('cyclenext') or hl.dsp.window.cycle_next()
  hl.dispatch(dispatch)
end)
hl.bind('ALT + SHIFT + Tab', function()
  local ws = hl.get_active_workspace()
  if not ws then return end
  local dispatch = ws.tiled_layout == 'monocle' and hl.dsp.layout('cycleprev') or
      hl.dsp.window.cycle_next({ next = false })
  hl.dispatch(dispatch)
end)

-- Swap window with mainMod + SHIFT + arrow keys
hl.bind(secondMod .. ' + H', hl.dsp.window.move({ direction = 'l', group_aware = true }))
hl.bind(secondMod .. ' + L', hl.dsp.window.move({ direction = 'r', group_aware = true }))
hl.bind(secondMod .. ' + K', hl.dsp.window.move({ direction = 'u', group_aware = true }))
hl.bind(secondMod .. ' + J', hl.dsp.window.move({ direction = 'd', group_aware = true }))

-- Move window to another monitor
hl.bind('CTRL + ALT + L', hl.dsp.focus({ monitor = '+1' }))
hl.bind('CTRL + ALT + H', hl.dsp.focus({ monitor = '-1' }))
hl.bind('CTRL + ALT + left', hl.dsp.focus({ monitor = '+1' }))
hl.bind('CTRL + ALT + right', hl.dsp.focus({ monitor = '-1' }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(secondMod .. ' + N', hl.dsp.window.move({ workspace = 'emptynm', follow = true }))
hl.bind(secondMod .. ' + ALT + N', hl.dsp.window.move({ workspace = 'emptynm' }))
hl.bind(secondMod .. ' + P', hl.dsp.window.pin()) -- window has to be floating

-- Groups
hl.bind(mainMod .. ' + bracketright', hl.dsp.group.next())
hl.bind(mainMod .. ' + bracketleft', hl.dsp.group.prev())
hl.bind(secondMod .. ' + bracketleft', hl.dsp.group.move_window({ forward = false }))
hl.bind(secondMod .. ' + bracketright', hl.dsp.group.move_window({ forward = true }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag())
hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize())

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                        Workspace                         ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. ' + ' .. key, hl.dsp.focus({ workspace = i, on_current_monitor = true }))
  hl.bind(secondMod .. ' + ' .. key, hl.dsp.window.move({ workspace = i, follow = true }))
end

hl.bind(mainMod .. ' + N', hl.dsp.focus({ workspace = '+1' }))
hl.bind(mainMod .. ' + P', hl.dsp.focus({ workspace = '-1' }))
hl.bind(mainMod .. ' + Tab', hl.dsp.focus({ workspace = 'previous_per_monitor' }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. ' + C', hl.dsp.workspace.toggle_special('magic'))
hl.bind(secondMod .. ' + C', hl.dsp.window.move({ workspace = 'special:magic' }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e-1' }))
hl.bind(mainMod .. ' + mouse_up', hl.dsp.focus({ workspace = 'e+1' }))


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Layout                           ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

local available_layouts = { 'master', 'monocle', 'dwindle', 'scrolling' }

---@return string?, integer?
local function next_layout()
  local ws = hl.get_active_workspace()
  if not ws then return end
  local current_layout = ws.tiled_layout
  local next_index = 1
  for i, layout in ipairs(available_layouts) do
    if layout == current_layout then
      next_index = (i % #available_layouts) + 1
      break
    end
  end

  return available_layouts[next_index], ws.id
end

-- Change layout
hl.bind(mainMod .. ' + ALT + L', function()
  local new_layout, id = next_layout()
  if not new_layout then return end
  hl.workspace_rule({ workspace = tostring(id), layout = new_layout })
  hl.notification.create({ text = 'Layout changed to ' .. new_layout, duration = 5000, icon = 1, font_size = 25 })
end, { desc = 'Cycle layouts per workspace' })

-- Change global layout
hl.bind(secondMod .. ' + ALT + L', function()
  local new_layout = next_layout()
  if not new_layout then return end
  hl.notification.create({ text = 'Layout changed to ' .. new_layout, duration = 5000, icon = 1, font_size = 25 })
  hl.config({ general = { layout = new_layout } })
end, { desc = 'Cycle layouts' })

-- Master
hl.bind(mainMod .. ' + O', hl.dsp.layout('orientationcycle'))
hl.bind(mainMod .. ' + CTRL + Tab', hl.dsp.layout('rollnext'))
hl.bind(mainMod .. ' + CTRL + SHIFT + Tab', hl.dsp.layout('rollprev'))
hl.bind(mainMod .. ' + SHIFT + Equal', hl.dsp.layout('addmaster'))
hl.bind(mainMod .. ' + minus', hl.dsp.layout('removemaster'))


-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Monitor                          ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

hl.bind(mainMod .. ' + CTRL + SHIFT + M', hl.dsp.exec_cmd('hyprctl keyword monitor HDMI-A-1,disable,1'))
hl.bind(mainMod .. ' + CTRL + M', hl.dsp.exec_cmd('hyprctl keyword monitor HDMI-A-1,1920x1080@144,0x0,1'))
hl.bind(mainMod .. ' + SHIFT + M', hl.dsp.exec_cmd('sleep 1 && hyprctl dispatch dpms toggle HDMI-A-1'))

hl.bind('CTRL + SHIFT + ALT + L', hl.dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = '+1' }))
hl.bind('CTRL + SHIFT + ALT + H', hl.dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = '-1' }))
hl.bind('CTRL + SHIFT + ALT + right', hl.dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = '+1' }))
hl.bind('CTRL + SHIFT + ALT + left', hl.dsp.workspace.swap_monitors({ monitor1 = 'current', monitor2 = '-1' }))

-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Submaps                          ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

-- Group
hl.bind(mainMod .. ' + G', hl.dsp.submap('group'))
hl.define_submap('group', 'reset', function()
  hl.bind('G', hl.dsp.group.toggle())
  hl.bind('l', hl.dsp.group.lock_active())

  hl.bind('escape', hl.dsp.submap('reset'))
  hl.bind('catchall', hl.dsp.submap('reset'))
end)

-- Resize windows
hl.bind(mainMod .. ' + R', hl.dsp.submap('resize'))
hl.define_submap('resize', function()
  -- Set repeating binds for resizing the active window.
  hl.bind('l', hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind('h', hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind('k', hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind('j', hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

  -- Use `reset` to go back to the global submap
  hl.bind('escape', hl.dsp.submap('reset'))
  hl.bind('catchall', hl.dsp.submap('reset'))
end)
