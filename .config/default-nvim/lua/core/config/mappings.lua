vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore 30<cr>', { desc = 'Open Explorer' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Buffer
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>', { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })

-- Git
vim.keymap.set('n', '[g', '<cmd>lua require("gitsigns").prev_hunk()<cr>', { desc = 'Goto Previous Hunk' })
vim.keymap.set('n', ']g', '<cmd>lua require("gitsigns").next_hunk()<cr>', { desc = 'Goto Next Hunk' })
vim.keymap.set('n', '<leader>gp', '<cmd>lua require("gitsigns").preview_hunk()<cr>', { desc = 'Preview Hunk' })

-- Telescope
vim.keymap.set('n', '<leader>fo', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { desc = 'Find Oldfiles' })
vim.keymap.set('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fc', '<cmd>lua require("telescope.builtin").grep_string()<cr>',
  { desc = 'Find word under Cursor' })
vim.keymap.set('n', '<leader>fw', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { desc = 'Find words' })
vim.keymap.set('n', '<leader>fa', '<cmd>lua require("core.config.custom.pickers").find_config()<cr>',
  { desc = 'Find Config' })

-- Lsp
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostics' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostics' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open Diagnostic' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>ld', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', { desc = 'Lsp Diagnostics' })
