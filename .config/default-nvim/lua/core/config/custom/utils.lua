local M = {}

M.delete_hidden_buffers = function()
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
end

M.scratch_buffer = function()
  if vim.g.scratch_nr then
    local buf_nr = vim.g.scratch_nr
    local win_ids = vim.fn.win_findbuf(buf_nr)
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
  vim.api.nvim_buf_set_name(buf_nr, 'scratch')
  vim.g.scratch_nr = buf_nr
  vim.cmd.vnew()
  vim.api.nvim_win_set_buf(0, buf_nr)
end

M.rename_buffer = function()
  local original_filename = vim.api.nvim_buf_get_name(0)
  local prompt = 'Rename: '

  local new_filename = vim.fn.input({
    prompt = prompt,
    default = original_filename,
    completion = 'file',
  })

  if new_filename == '' then
    return
  end

  vim.cmd('update | saveas ++p ' .. new_filename)
  local alternate_bufnr = vim.fn.bufnr('#')
  if vim.fn.bufexists(alternate_bufnr) then
    vim.api.nvim_buf_delete(alternate_bufnr, {})
  end
  vim.fn.delete(original_filename)
  print('Renamed to ' .. new_filename)
end

M.start_journal = function()
  local journal_dir = '~/playground/projects/second_brain/Resources/journal/'
  local journal_path = vim.fs.normalize(string.format('%s/%s.md', journal_dir, os.date('%Y-%m-%d')))
  vim.cmd('tabedit ' .. journal_path)
end

function M.set_indent()
  local ok, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if not ok then return end
  local indent = tonumber(input)
  if not indent or indent == 0 then return end
  vim.bo.expandtab = (indent > 0)
  indent = math.abs(indent)
  vim.bo.tabstop = indent
  vim.bo.softtabstop = indent
  vim.bo.shiftwidth = indent
end

-- vim.keymap.set('n', '<leader>rt', M.rename_buffer)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
