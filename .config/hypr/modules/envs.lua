-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local envs = {
  -- Cursor env
  XCURSOR_SIZE = '24',
  HYPRCURSOR_SIZE = '24',
  HYPRCURSOR_THEME = 'Bibata-Modern-Ice',
  -- hyprctl setcursor Bibata-Modern-Classic 24
  XDG_CURRENT_DESKTOP = 'Hyprland',

  -- Force all apps to use wayland
  GDK_BACKEND = 'wayland,x11,*',
  QT_QPA_PLATFORM = 'wayland;xcb',
  QT_STYLE_OVERRIDE = 'kvantum',
  SDL_VIDEODRIVER = 'wayland',
  MOZ_ENABLE_WAYLAND = '1',
  ELECTRON_OZONE_PLATFORM_HINT = 'auto',
  OZONE_PLATFORM = 'wayland',

  -- Nvidia env
  NVD_BACKEND = 'direct',
  LIBVA_DRIVER_NAME = 'nvidia',
  __GLX_VENDOR_LIBRARY_NAME = 'nvidia',

  -- Kitty
  QT_QPA_PLATFORMTHEME = 'xdgdesktopportal',
  GTK_USE_PORTAAL = '1',
}

for key, val in pairs(envs) do
  hl.env(key, val)
end
