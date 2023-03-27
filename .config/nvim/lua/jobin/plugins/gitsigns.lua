return {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
        vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>')
        vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>')
        vim.keymap.set('n', '<leader>go', '<cmd>Gitsigns preview_hunk<CR>')
        require('gitsigns').setup()
    end,
}
