return {
    'nvim-tree/nvim-tree.lua',
    keys = {
        { '<leader>e', '<cmd>NvimTreeToggle<CR>' },
    },
    config = function()
        vim.g.loaded = 1
        vim.g.loaded_netrwPlugin = 1
        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>')
        require('nvim-tree').setup()
    end,
}
