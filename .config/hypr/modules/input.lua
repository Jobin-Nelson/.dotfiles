hl.config({
  input = {
    kb_layout    = "us",
    kb_variant   = "",
    kb_model     = "",
    kb_options   = "",
    kb_rules     = "",

    repeat_rate  = 25,
    repeat_delay = 500,
    follow_mouse = 1,

    sensitivity  = 0.35, -- -1.0 - 1.0, 0 means no modification.

    touchpad     = {
      natural_scroll = true,
      scroll_factor = 0.2,
    },
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})
