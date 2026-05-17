-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local active_border_color = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }
local inactive_border_color = "rgba(595959aa)"


hl.config({
  general = {
    gaps_in          = 5,
    gaps_out         = 10,
    border_size      = 2,

    col              = {
      active_border   = active_border_color,
      inactive_border = inactive_border_color,
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
    allow_tearing    = true,

    layout           = "master",
  },
  decoration = {
    -- See https://wiki.hyprland.org/Configuring/Variables/ for more  rounding
    rounding = 5,
    -- https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true,
      size = 2,
      passes = 2,
      special = true,
      brightness = 0.60,
      contrast = 0.75,
    },
    shadow = {
      enabled = true,
      range = 2,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    }
  },
  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  binds = {
    allow_workspace_cycles = true,
    hide_special_on_workspace_change = true
  },
  master = {
    new_on_top = false
  },

  group = {
    auto_group = false,
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
      border_locked_active = "rgba(4a4a4aff)",
      border_locked_inactive = "rgba(2f2f2fff)",
    },
    groupbar = {
      font_size = 15,
      font_family = "JetBrainsMono Nerd Font",
      font_weight_active = "ultraheavy",
      font_weight_inactive = "normal",

      indicator_height = 0,
      indicator_gap = 5,
      height = 15,
      gaps_in = 5,
      gaps_out = 0,

      text_color = "rgb(ffffff)",
      text_color_inactive = "rgba(ffffff90)",
      col = {
        active = "rgba(000000ff)",
        inactive = "rgba(000000ff)",
      },

      gradients = true,
      gradient_rounding = 0,
      gradient_round_only_edges = false,
    }
  }

})
