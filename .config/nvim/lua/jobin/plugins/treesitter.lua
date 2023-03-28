return {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'rust',
            'python',
            'bash',
            'markdown',
            'markdown_inline',
            'json',
            'yaml',
            'lua',
            'toml',
            'make',
            'html',
            'javascript',
            'help',
            'vim',
        },
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-Space>',
                node_incremental = '<C-Space>',
                scope_incremental = '<NOP>',
                node_decremental = '<BS>',
            },
        },
    })
    end,
}
