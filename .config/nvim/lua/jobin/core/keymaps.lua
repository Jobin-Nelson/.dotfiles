vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>i', '<cmd>edit $MYVIMRC<CR>')
vim.keymap.set('n', '<C-Up>', '<cmd>resize +3<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -3<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +3<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -3<CR>')
vim.keymap.set('n', 'L', '<cmd>bnext<CR>')
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<leader>rs', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
vim.keymap.set('n', '<leader>bo', '<cmd>update <bar> %bdelete <bar> edit# <bar> bdelete #<CR>')
vim.keymap.set('n', '<leader>bv', function ()
    local all_bufs = vim.tbl_filter(
        function(buf)
            return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
        end,
        vim.api.nvim_list_bufs()
    )
    local all_wins = vim.api.nvim_list_wins()
    local visible_bufs = {}
    for _, win in ipairs(all_wins) do
        visible_bufs[vim.api.nvim_win_get_buf(win)] = true
    end

    for _, buf in ipairs(all_bufs) do
        if visible_bufs[buf] == nil then
            vim.cmd.bwipeout({ count = buf, bang = true })
        end
    end
    print('All hidden buffers have been deleted')
end)
vim.keymap.set('n', '<leader>sc', function ()
    local buf_name = 'scratch'
    if vim.fn.bufexists(buf_name) == 1 then
        local buf_nr = vim.fn.bufnr(buf_name)
        local win_ids =  vim.fn.win_findbuf(buf_nr)
        if win_ids then
            for _, win_id in ipairs(win_ids) do
                if vim.api.nvim_win_is_valid(win_id) then
                    vim.api.nvim_set_current_win(win_id)
                    return
                end
            end
        end
        vim.cmd('vert sbuffer ' .. buf_nr)
        return
    end

    local buf_nr = vim.api.nvim_create_buf(false, true)
    vim.opt_local.buftype = 'nofile'
    vim.opt_local.bufhidden = 'hide'
    vim.opt_local.swapfile = false
    vim.api.nvim_buf_set_name(buf_nr, 'scratch')
    vim.cmd('vert sbuffer ' .. buf_nr)
end)
