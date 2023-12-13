return {
	"lukas-reineke/indent-blankline.nvim",
	event = { "BufReadPost", "BufNewFile" },
	main = "ibl",
	opts = {
		indent = { char = "▏" },
		scope = {
			show_start = false,
			show_end = false,
			-- include = {
			-- 	node_type = {
			-- 		["*"] = { "*" },
			-- 	},
			-- },
		},
		exclude = {
			buftypes = {
				"nofile",
				"terminal",
				"quickfix",
				"prompt",
			},
			filetypes = {
				"help",
				"aerial",
				"alpha",
				"lazy",
				"neogitstatus",
				"NvimTree",
				"neo-tree",
				"Trouble",
				"checkhealth",
			},
		},
	},
}
