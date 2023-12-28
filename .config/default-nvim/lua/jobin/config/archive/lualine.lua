
return {
	'nvim-lualine/lualine.nvim',
	event = { 'BufReadPre', 'BufNewFile', 'InsertEnter' },
	opts = {
		options = {
			theme = 'catppuccin',
			-- component_separators = '|',
			-- section_separators = '',
			globalstatus = true,
			disabled_filetypes = {
				statusline = {
					'TelescopePrompt',
				},
			},
		},
	},
}

-- return {
-- 	'nvim-lualine/lualine.nvim',
-- 	event = 'VeryLazy',
-- 	config = function()
-- 		require('core.config.lualine')
-- 	end,
-- }
