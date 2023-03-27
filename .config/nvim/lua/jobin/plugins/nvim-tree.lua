return {
    'nvim-tree/nvim-tree.lua',
    keys = {
        { '<leader>e', '<cmd>NvimTreeToggle<CR>' },
    },
    config = function()
        vim.g.loaded = 1
        vim.g.loaded_netrwPlugin = 1
        require('nvim-tree').setup()
    end,
}
