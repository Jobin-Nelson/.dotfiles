return {
	'catppuccin/nvim',
	lazy = false,
  priority = 1000,
  config = function()
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
