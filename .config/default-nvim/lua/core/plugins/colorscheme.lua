return {
	'catppuccin/nvim',
	lazy = false,
  priority = 1000,
  config = function()
    require('catppuccin').setup({
      transparent_background = false,
      dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.15,
      },
      integrations = {
        nvimtree = false,
        ts_rainbow = false,
        aerial = true,
        dap = { enabled = true, enable_ui = true },
        mason = true,
        neotree = true,
        notify = true,
        semantic_tokens = true,
        symbols_outline = true,
        telescope = true,
        which_key = true,
      },
    })
    vim.cmd.colorscheme 'catppuccin'
  end,
	name = 'catppuccin',
}
-- return {
--   'navarasu/onedark.nvim',
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd.colorscheme 'onedark'
--   end,
-- }
