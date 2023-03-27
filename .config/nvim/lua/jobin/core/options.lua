HOME = os.getenv('HOME')
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.sidescrolloff = 10
vim.opt.scrolloff = 8
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.path:append('**')
vim.opt.wildmenu = true
vim.opt.wildignore:append { '*/venv/*', '*/node_modules/*' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = HOME .. '/.config/nvim/undodir'
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.fileformat = 'unix'
vim.opt.fileencoding = 'utf-8'
vim.opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
vim.opt.autoread = true
vim.opt.cpoptions:append('>')
vim.opt.spelllang = 'en_us'
vim.g.python3_host_prog = '$HOME/.pyenv/versions/3.11.1/bin/python'
-- vim.g.netrw_altv = 1
-- vim.g.netrw_liststyle = 3

-- Wsl clipboard
-- vim.g.clipboard = {
--     name = "win32yank-wsl",
--     copy = {
--         ["+"] = "win32yank.exe -i --crlf",
--         ["*"] = "win32yank.exe -i --crlf"
--     },
--     paste = {
--         ["+"] = "win32yank.exe -o --crlf",
--         ["*"] = "win32yank.exe -o --crlf"
--     },
--     cache_enable = 0,
-- }
