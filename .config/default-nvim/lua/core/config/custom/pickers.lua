local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local utils = require('telescope.utils')
local dropdown_theme = require('telescope.themes').get_dropdown()

local function get_dotfiles()
  local econf_file = vim.fn.expand('~/.local/bin/econf.sh')

  local econf = io.open(econf_file, 'r')
  if econf == nil then
    error('No econf.sh file found')
  end

  -- Seek till Files=(
  for line in econf:lines() do
    if string.match(line, '^%s*FILES=%(') then break end
  end

  -- Read in dotfiles
  local dotfiles = {}
  for line in econf:lines() do
    if string.match(line, '^%s*$') then break end
    local file_path = string.match(line, '.* - (.*)"$')
    table.insert(dotfiles, file_path)
  end

  if vim.tbl_isempty(dotfiles) then
    error('No dotfiles found in array FILES in econf.sh')
  end

  econf:close()
  return dotfiles
end

local function get_projects()
  local project_dir = vim.fs.normalize('~/playground/projects')
  local projects = {}

  if not vim.fn.isdirectory(project_dir) then
    error(string.format('Directory %s not found', project_dir))
  end
  for name, type in vim.fs.dir(project_dir) do
    if type == 'directory' then
      table.insert(projects, {
        name,
        table.concat({ project_dir, name }, '/'),
      })
    end
  end

  return projects
end

local function zoxide_entry_maker(entry)
  local trimmed = string.gsub(entry, '^%s*(.-)%s*$', '%1')
  local path = string.gsub(trimmed, '^[^%s]* (.*)$', '%1')
  local z_score = tonumber(string.gsub(trimmed, '^([^%s]*) .*$', '%1'), 10)

  return {
    value = path,
    ordinal = path,
    display = path,
    z_score = z_score,
    path = path,
  }
end

local M = {}

M.find_projects = function()
  local opts = dropdown_theme
  pickers.new(opts, {
    prompt_title = 'Projects',
    finder = finders.new_table({
      results = get_projects(),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd.cd(selection.value[2])
        print('Directory changed to ' .. selection.value[1])
      end)
      return true
    end
  }):find()
end

M.find_zoxide = function()
  local opts = dropdown_theme
  pickers.new(opts, {
    prompt_title = 'Zoxide',
    finder = finders.new_table({
      results = utils.get_os_command_output(vim.fn.split('zoxide query -ls')),
      entry_maker = zoxide_entry_maker,
    }),
    sorter = sorters.get_generic_fuzzy_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd.cd(selection.path)
        print('Directory changed to ' .. selection.path)
      end)
      return true
    end
  }):find()
end

M.find_config = function()
  require('telescope.builtin').find_files({
    search_dirs = {
      '~/.config/default-nvim/init.lua',
      '~/.config/default-nvim/lua',
    },
    prompt_title = 'Find Config',
  })
end

M.find_org_files = function()
  require('telescope.builtin').find_files({
    search_dirs = {
      '~/playground/projects/org_files/',
      '~/playground/dev/illumina/ticket_notes/work/',
    },
    prompt_title = 'Org Files',
  })
end

M.find_second_brain_files = function()
  require('telescope.builtin').find_files({
    search_dirs = { '~/playground/projects/second_brain' },
    prompt_title = 'Second Brain Files',
  })
end

M.find_dotfiles = function()
  require('telescope.builtin').find_files({
    search_dirs = get_dotfiles(),
    prompt_title = 'Find Dotfiles',
  })
end

M.find_journal = function()
  local journal_dir = '~/playground/projects/second_brain/Resources/journal/'
  require('telescope.builtin').live_grep({
    prompt_title = 'Find Journal',
    search_dirs = {journal_dir}
  })
end

return M
