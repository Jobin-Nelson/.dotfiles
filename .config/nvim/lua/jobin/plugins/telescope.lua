return {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
        {'<leader>ff', '<cmd>Telescope find_files<CR>', { desc = '[F]ind [F]iles' }},
        {'<leader>fo', '<cmd>Telescope oldfiles<CR>', { desc = '[F]ind [O]ld files' }},
        {'<leader>fg', '<cmd>Telescope live_grep<CR>', { desc = '[F]ind by [G]rep' }},
        {'<leader>fw', '<cmd>Telescope grep_string<CR>', { desc = '[F]ind [W]ord' }},
        {'<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = '[F]ind [H]elp' }},
        {'<leader>fb', '<cmd>Telescope buffers<CR>', { desc = '[F]ind [B]uffers' }},
        {'<leader>fd', '<cmd>Telescope diagnostics<CR>', { desc = '[F]ind [D]iagnostics' }},
        {'<leader>fr', '<cmd>Telescope resume<CR>', { desc = '[F]ind [R]esume' }},
    },
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
                return vim.fn.executable 'make' == 1
            end,
        },
    },
    config = function()
        require('telescope').setup {
            defaults = {
                file_ignore_patterns = { 'venv', '__pycache__', 'node_modules', 'target' }
            }
        }
        require('telescope').load_extension('fzf')
    end,
}
