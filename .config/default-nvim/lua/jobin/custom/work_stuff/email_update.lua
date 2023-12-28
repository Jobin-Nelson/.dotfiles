local function get_alias_command()
  local bashrc = io.open(vim.fn.expand("~/.bashrc"))

  if bashrc == nil then
    error("No bashrc file found")
  end

  local command = ""
  for line in bashrc:lines() do
    if string.match(line, "^alias eup=") then
      command = string.match(line, ".*='%${EDITOR:%-nvim} (.*)'$")
      break
    end
  end
  bashrc:close()

  if command == "" then
    error('No alias "eup" found in bashrc file')
  end
  return command
end

local function has_previous_update(current_update)
  local previous_file, number_of_files = nil, 0
  for file in vim.fs.dir(vim.fs.dirname(current_update)) do
    if number_of_files == 2 then
      break
    end
    previous_file = file
    number_of_files = number_of_files + 1
  end
  local current_file = os.date("%Y-%m-%d") .. ".txt"
  local not_current_file = previous_file and previous_file ~= current_file
  return number_of_files == 2 or not_current_file
end

local function get_previous_update(current_update)
  if not has_previous_update(current_update) then
    return
  end
  local parent_dir = vim.fs.dirname(current_update)
  local current_date_string = vim.fn.fnamemodify(current_update, ":t:r")
  local one_day_in_sec = 24 * 60 * 60
  local current_time = vim.tbl_map(tonumber, {
    current_date_string:match("(%d+)-(%d+)-(%d+)"),
  })
  local previous_date = os.time({
    year = current_time[1],
    month = current_time[2],
    day = current_time[3],
  })

  local previous_update = nil
  for _ = 1, 10 do
    previous_date = previous_date - one_day_in_sec
    local previous_date_string = os.date("%Y-%m-%d", previous_date)
    previous_update = string.format("%s/%s.txt", parent_dir, previous_date_string)
    if vim.loop.fs_stat(previous_update) then
      break
    end
  end
  return previous_update
end

local function setup_email(current_update, previous_update)
  if previous_update then
    vim.cmd(string.format("tabedit %s | vsplit %s", previous_update, current_update))
  else
    vim.cmd("tabedit " .. current_update)
    print("No previous update found since 10 days ago")
  end
end

local function email_win_leave_callback()
  local tab_bufs = vim.fn.tabpagebuflist()
  vim.cmd("tabclose")
  vim.print("Updated today's email")

  if tab_bufs == 0 then
    return
  end
  for _, buf in ipairs(tab_bufs) do
    vim.api.nvim_buf_delete(buf, { force = true })
  end
end

local function setup_keymap()
  vim.keymap.set("n", "q", function()
    email_win_leave_callback()
  end, { buffer = 0, noremap = true })
end

local function capture_email(_, data)
  local current_update = vim.fs.normalize(data[1])
  local previous_update = get_previous_update(current_update)
  setup_email(current_update, previous_update)
  setup_keymap()
end

local M = {}

M.open = function()
  local command = get_alias_command()
  vim.fn.jobstart("echo " .. command, {
    stdout_buffered = true,
    on_stdout = capture_email,
  })
end

-- vim.keymap.set("n", "<leader>rt", open)
-- vim.keymap.set("n", "<leader>rr", ":update | luafile %<cr>")

return M
