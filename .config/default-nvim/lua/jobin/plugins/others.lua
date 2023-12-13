return {
	{ "dhruvasagar/vim-table-mode", keys = { "<leader>tm" } },
	{ "dhruvasagar/vim-zoom", keys = { "<C-w>m" } },
	-- { 'folke/which-key.nvim',  event = 'VeryLazy',                      opts = {} },
	{ "numToStr/Comment.nvim", event = { "BufReadPost", "BufNewFile" }, config = true },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" }, config = true },
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
}
