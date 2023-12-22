return {
	{
		'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
      'xiyaowong/telescope-emoji.nvim',
		},
		config = function()
			require('telescope').setup({
				pickers = {
					buffers = {
						mappings = {
							n = {
								['d'] = 'delete_buffer',
							}
						}
					}
				},
				defaults = {
					path_display = { "truncate" },
					sorting_strategy = "ascending",
					layout_config = {
						horizontal = {
							prompt_position = "top",
							preview_width = 0.55,
						},
						vertical = {
							mirror = false,
						},
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
				}
			})
			require('telescope').load_extension('fzf')
			require('telescope').load_extension('emoji')
		end
	},
}
