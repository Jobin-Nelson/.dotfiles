-- local tt_path = vim.fn.expand('~/playground/dev/illumina/ticket_notes/work_org_files/ICI/ici-on-prem/test_tracking/test_case_tracking.org')
-- local csv_path = vim.fs.dirname(tt_path) .. '/tracking.csv'

local function get_tests()
  local tt_path = vim.fn.expand('%:p')
  local tt_file = io.open(tt_path)
  if tt_file == nil then error(string.format('No file %s found',tt_path)) end

  local tests = {}
  for line in tt_file:lines() do
    local heading = string.match(line, '^%* (.*)$')
    local test_no = string.match(line, '^(%d+)%.')
    local test_status = string.match(line, '^%d+%.%s+%[([%a%s]?)%]')
    local test_link = string.match(line, '%[%[(.*)%]%[.*%]%]')
    local test_name = string.match(line, '%[%[.*%]%[(.*)%]%]')
    if test_name == nil then
      test_name = string.match(line, '%[[%a%s]?%] (.*)$')
    end
    local test = {
      test_no,
      test_status,
      test_name,
      test_link,
      heading
    }
    table.insert(tests, test)
  end
  tt_file:close()
  return tests
end

local function create_csv(tests)
  local lines = {'Test No.,Test Status,Test Name,Test Jira Link'}
  for _, test in ipairs(tests) do
    local test_no, test_status, test_name, test_link, heading = test[1], test[2], test[3], test[4], test[5]
    local line = ''
    if heading then
      table.insert(lines, '')
      line = string.format(',,%s', heading)
    elseif test_name then
      line = string.format(
        '%s,%s,%s,%s',
        test_no,
        test_status == 'X' and 'Done' or '',
        test_name,
        test_link
      )
    end
    table.insert(lines, line)
  end

  vim.cmd('tabnew')
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

local M = {}

M.generate_csv = function()
  local tests = get_tests()
  create_csv(tests)
end

-- vim.keymap.set('n', '<leader>rt', M.generate_csv)
-- vim.keymap.set('n', '<leader>rr', ':update | luafile %<cr>')

return M
