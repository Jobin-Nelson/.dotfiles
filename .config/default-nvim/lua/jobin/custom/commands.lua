local M = {}

M.diff_original = function()
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
end

return M
