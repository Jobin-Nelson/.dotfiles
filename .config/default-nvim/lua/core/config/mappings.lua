vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- vim.keymap.set('n', '<leader>e', '<cmd>Lexplore 30<cr>', { desc = 'Open Explorer' })
vim.keymap.set('n', '<leader>e', '<cmd>lua require("nvim-tree.api").tree.toggle({find_file=true})<cr>', { desc = 'Open Explorer' })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('v', '<', '<gv', { silent = true, desc = 'Indent Inward' })
vim.keymap.set('v', '>', '>gv', { silent = true, desc = 'Indent Outward' })

-- Buffer
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '[q', '<cmd>cprevious<cr>', { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<cr>', { desc = 'Next Quickfix' })
vim.keymap.set('n', '<leader>bo', '<cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>', { desc = 'Delete Other buffers' })
vim.keymap.set('n', '<leader>bh', '<cmd>lua require("core.config.custom.utils").delete_hidden_buffers()<cr>', { desc = 'Delete Hidden buffers' })
vim.keymap.set('n', '<leader>br', '<cmd>lua require("core.config.custom.utils").rename_buffer()<cr>', { desc = 'Buffer Rename' })
vim.keymap.set('n', '<leader>bk', '<cmd>call delete(expand("%:p")) <bar> bdelete!<cr>', { desc = 'Buffer Kill' })

-- Git
vim.keymap.set('n', '[c', '<cmd>lua require("gitsigns").prev_hunk()<cr>', { desc = 'Goto Previous Hunk' })
vim.keymap.set('n', ']c', '<cmd>lua require("gitsigns").next_hunk()<cr>', { desc = 'Goto Next Hunk' })
vim.keymap.set('n', '<leader>gp', '<cmd>lua require("gitsigns").preview_hunk()<cr>', { desc = 'Preview Hunk' })
vim.keymap.set('n', '<leader>grb', '<cmd>lua require("gitsigns").reset_buffer()<cr>', { desc = 'Git Reset Buffer' })
vim.keymap.set('n', '<leader>grh', '<cmd>lua require("gitsigns").reset_hunk()<cr>', { desc = 'Git Reset Hunk' })
vim.keymap.set('n', '<leader>gl', '<cmd>lua require("gitsigns").blame_line()<cr>', { desc = 'Git blame Line' })
vim.keymap.set('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<cr>', { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gs', '<cmd>lua require("telescope.builtin").git_status()<cr>', { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gt', '<cmd>lua require("telescope.builtin").git_stash()<cr>', { desc = 'Git sTash' })
vim.keymap.set('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<cr>', { desc = 'Git Commits' })
vim.keymap.set('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<cr>', { desc = 'Git Commits' })

-- Telescope
vim.keymap.set('n', '<leader>f<cr>', '<cmd>lua require("telescope.builtin").resume()<cr>', { desc = 'Find Oldfiles' })
vim.keymap.set('n', '<leader>fo', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', { desc = 'Find Oldfiles' })
vim.keymap.set('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>', { desc = 'Find Buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fc', '<cmd>lua require("telescope.builtin").grep_string()<cr>', { desc = 'Find word under Cursor' })
vim.keymap.set('n', '<leader>fw', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { desc = 'Find words' })
vim.keymap.set('n', '<leader>fC', '<cmd>lua require("telescope.builtin").commands()<cr>', { desc = 'Find Commands' })
vim.keymap.set('n', '<leader>fk', '<cmd>lua require("telescope.builtin").keymaps()<cr>', { desc = 'Find Keymaps' })
vim.keymap.set('n', '<leader>ft', '<cmd>lua require("telescope.builtin").colorscheme()<cr>', { desc = 'Find Themes' })
vim.keymap.set('n', '<leader>fD', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>fa', '<cmd>lua require("core.config.custom.pickers").find_config()<cr>', { desc = 'Find Config' })
vim.keymap.set('n', '<leader>fd', '<cmd>lua require("core.config.custom.pickers").find_dotfiles()<cr>', { desc = 'Find Dotfiles' })
vim.keymap.set('n', '<leader>fz', '<cmd>lua require("core.config.custom.pickers").find_zoxide()<cr>', { desc = 'Find Zoxide' })
vim.keymap.set('n', '<leader>fs', '<cmd>lua require("core.config.custom.pickers").find_second_brain_files()<cr>', { desc = 'Find Second brain files' })
vim.keymap.set('n', '<leader>fO', '<cmd>lua require("core.config.custom.pickers").find_org_files()<cr>', { desc = 'Find Org files' })
vim.keymap.set('n', '<leader>fp', '<cmd>lua require("core.config.custom.pickers").find_projects()<cr>', { desc = 'Find Projects' })

-- Lsp
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostics' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostics' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open Diagnostic' })
vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<leader>ld', '<cmd>lua require("telescope.builtin").diagnostics()<cr>', { desc = 'Lsp Diagnostics' })

-- Packages
vim.keymap.set('n', '<leader>ps', '<cmd>Lazy<cr>', { desc = 'Plugin Status' })
vim.keymap.set('n', '<leader>pm', '<cmd>Mason<cr>', { desc = 'Mason Installer' })

-- Terminal
vim.keymap.set('n', '<A-h>', '<cmd>ToggleTerm size=20 direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
vim.keymap.set('n', '<A-v>', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
vim.keymap.set('t', '<A-h>', '<C-\\><C-n><cmd>ToggleTerm direction=horizontal<cr>', { desc = 'ToggleTerm Horizontal' })
vim.keymap.set('t', '<A-v>', '<C-\\><C-n><cmd>ToggleTerm direction=vertical<cr>', { desc = 'ToggleTerm Vertical' })
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Terminal window command' })

-- Other
vim.keymap.set('n', '<leader>sc', '<cmd>lua require("core.config.custom.utils").scratch_buffer()<cr>', { desc = 'Scratch buffer' })
vim.keymap.set('n', '<leader>se', '<cmd>lua require("core.config.custom.email_update").open()<cr>', { desc = 'Send Email' })
vim.keymap.set('n', '<leader>st', '<cmd>lua require("core.config.custom.get_ticket").populate_ticket()<cr>', { desc = 'Source Ticket' })
vim.keymap.set('n', '<leader>oT', '<cmd>lua require("core.config.custom.org-tangle").tangle()<cr>', { desc = 'Org Tangle' })
