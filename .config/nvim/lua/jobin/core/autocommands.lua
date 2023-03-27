-- User commands
vim.api.nvim_create_user_command('DiffOrig', function()
    local start = vim.api.nvim_get_current_buf()
    vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')
    local scratch = vim.api.nvim_get_current_buf()

    vim.cmd('wincmd p | diffthis')

    -- Map `q` for both buffers to exit diff view and delete scratch buffer
    for _, buf in ipairs({ scratch, start }) do
        vim.keymap.set('n', 'q', function()
            vim.api.nvim_buf_delete(scratch, { force = true })
            vim.keymap.del('n', 'q', { buffer = start })
        end, { buffer = buf })
    end
end, {})

-- Autocommands
local my_group = vim.api.nvim_create_augroup('my_group', { clear = true })

-- for quick execution of python files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    command = 'nnoremap <F5> <cmd>w <bar> !python %<CR>',
    group = my_group,
})

-- for pretty markdown syntax
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    command = 'setlocal conceallevel=2',
    group = my_group,
})

-- for setting formatoptions only when in second_brain directory
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--     pattern = '*/second_brain*',
--     command = 'setlocal formatoptions+=a colorcolumn=80',
--     group = my_group,
-- })

