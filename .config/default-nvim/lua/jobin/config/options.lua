vim.o.hlsearch = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.breakindentopt = 'list:2,min:20,sbr'
-- vim.o.showbreak = '> '
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.updatecount = 0
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.conceallevel = 2
vim.o.signcolumn = 'yes'
vim.o.laststatus = 3
-- vim.o.winbar = '%=%m %t'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.scrolloff = 8
vim.o.sidescrolloff = 10
vim.o.smartindent = true
vim.o.wrap = false
vim.o.incsearch = true
vim.o.undodir = vim.fn.stdpath('config') .. '/undodir'
vim.o.undofile = true
vim.o.swapfile = false
vim.o.pumheight = 10
vim.o.pumblend = 10
-- vim.opt.iskeyword = vim.opt.iskeyword + '-'
-- vim.o.foldcolumn = '3'
-- vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldclose:'
vim.opt.formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore
vim.g.git_worktrees = {
  {
    toplevel = vim.env.HOME,
    gitdir = vim.env.HOME .. "/.dotfiles",
  },
}

-- Disabled
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
