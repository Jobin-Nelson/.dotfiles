return {
	'nvim-lualine/lualine.nvim',
	event = 'VeryLazy',
	opts = {
		options = {
			globalstatus = true,
			disabled_filetypes = {
				statusline = {
					'TelescopePrompt',
				},
			},
		},
		-- sections = {
		-- 	lualine_y = {
		-- 		{ "progress", separator = " ", padding = { left = 1, right = 0 } },
		-- 		{ "location", padding = { left = 0, right = 1 } },
		-- 	},
		-- 	lualine_z = {
		-- 		function()
		-- 			return " " .. os.date("%R")
		-- 		end
		-- 	}
		-- },
		-- inactive_sections = {
		-- 	lualine_a = {},
		-- 	lualine_c = { 'filename' },
		-- 	lualine_x = { 'location' },
		-- }
	},
}

-- return {
-- 	'nvim-lualine/lualine.nvim',
-- 	event = 'VeryLazy',
-- 	config = function()
-- 		require('core.config.lualine')
-- 	end,
-- }
