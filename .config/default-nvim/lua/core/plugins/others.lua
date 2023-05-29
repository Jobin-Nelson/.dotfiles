return {
  { 'dhruvasagar/vim-table-mode', keys = { '<leader>tm'} },
  { 'dhruvasagar/vim-zoom', keys = { '<C-w>m'} },
  { 'folke/which-key.nvim',  event = 'BufEnter',                      opts = {} },
  { 'numToStr/Comment.nvim', event = { 'BufReadPost', 'BufNewFile' }, opts = {} },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  { 'kylechui/nvim-surround', event = { 'BufReadPost', 'BufNewFile' }, opts = {} },
	{ 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle'},
}
