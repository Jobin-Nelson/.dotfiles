-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  local uwsm_apps = {
    'hypridle',
    'hyprsunset',
    'mako',
    'waybar',
    -- 'swaybg -i $(find ~/Wallpapers -type f | shuf -n 1) -m fill',
    'awww-daemon',
    'swayosd-server',
    'walker --gapplication-service',
  }
  for _, apps in ipairs(uwsm_apps) do
    hl.exec_cmd("uwsm app -- " .. apps)
  end


  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("~/.config/hypr/bin/hypr-cmd-first-run.sh")

  -- Slow app launch fix -- set systemd vars
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd('dbus-update-activation-environment --systemd --all')
end)
