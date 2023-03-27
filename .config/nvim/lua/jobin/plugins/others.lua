return {
    { 'nvim-tree/nvim-web-devicons', lazy = true },
    { 'echasnovski/mini.comment', event = 'VeryLazy', config = function() require('mini.comment').setup() end },
    { 'echasnovski/mini.pairs', event = 'VeryLazy', config = function() require('mini.pairs').setup() end },
    'tpope/vim-surround',
    'dhruvasagar/vim-zoom',
    'dhruvasagar/vim-table-mode',
}
