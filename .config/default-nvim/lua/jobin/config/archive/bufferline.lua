return {
	'akinsho/bufferline.nvim',
	event = 'VeryLazy',
	version = "*",
	dependencies = 'nvim-tree/nvim-web-devicons',
	opts = {
		options = {
			offsets = {
				{
					filetype = 'NvimTree',
					text = 'Nvim-tree',
					highlight = 'Directory',
					text_align = 'center',
					seperator = true,
				}
			}
		}
	}
}
