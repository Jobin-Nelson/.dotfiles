return {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
        require('catppuccin').setup({
            flavour = 'mocha',
            background = {
                light = 'latte',
                dark = 'mocha',
            },
            transparent_background = false;
            term_colors = false,
            dim_inactive = {
                enabled = true,
                shade = "dark",
                percentage = 0.15,
            },
            styles = {
                comments = { 'italic' },
                conditionals = {},
                loops = {},
                functions = {},
                keywords = { 'bold' },
                strings = {},
                variables = {},
                numbers = {},
                booleans = { 'bold' },
                properties = {},
                types = {},
                operators = {},
            },
            integrations = {
                cmp = true,
                gitsigns = true,
                telescope = true,
                mason = true,
                treesitter = true,
            },
        })
        vim.cmd[[colorscheme catppuccin]]
    end,
}
