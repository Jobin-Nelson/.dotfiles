return {
	'nvim-lualine/lualine.nvim',
	event = 'VeryLazy',
	opts = {
		options = {
			theme = 'catppuccin',
			globalstatus = true,
			disabled_filetypes = {
				statusline = {
					'TelescopePrompt',
					'alpha',
				},
			},
		},
		sections = {
			lualine_y = {
				{ "progress", separator = " ", padding = { left = 1, right = 0 } },
				{ "location", padding = { left = 0, right = 1 } },
			},
			lualine_z = {
				function()
					return " " .. os.date("%R")
				end
			}
		}
	},
}
