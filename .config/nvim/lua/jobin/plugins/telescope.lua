return {
    'nvim-telescope/telescope.nvim',
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
        local telescope = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = '[F]ind [F]iles' })
        vim.keymap.set('n', '<leader>fo', telescope.oldfiles, { desc = '[F]ind [O]ld files' })
        vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = '[F]ind by [G]rep' })
        vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = '[F]ind [W]ord' })
        vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = '[F]ind [H]elp' })
        vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = '[F]ind [B]uffers' })
        vim.keymap.set('n', '<leader>fd', telescope.diagnostics, { desc = '[F]ind [D]iagnostics' })
        vim.keymap.set('n', '<leader>fr', telescope.resume, { desc = '[F]ind [R]esume' })
        require('telescope').setup {
            defaults = {
                file_ignore_patterns = { 'venv', '__pycache__', 'node_modules', 'target' }
            }
        }
        require('telescope').load_extension('fzf')
    end,
}
