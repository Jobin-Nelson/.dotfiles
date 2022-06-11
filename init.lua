-- Options
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
vim.opt.wildignore:append('**/venv/**')
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.undodir = HOME .. '/.config/nvim/undodir'
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'

-- Keymaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>i', '<cmd>edit ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore<bar> vertical resize 30<CR>')
vim.keymap.set('n', '<C-Up>', '<cmd>resize +3<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -3<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +3<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -3<CR>')
vim.keymap.set('n', 'L', '<cmd>bnext<CR>')
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>')
vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>')

vim.cmd('autocmd filetype python nnoremap <F5> <cmd>w <bar> !python %<CR>')
vim.cmd('autocmd filetype javascript nnoremap <F5> <cmd>w <bar> !node %<CR>')

-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'

    -- cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'

    -- telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    -- git
    use 'lewis6991/gitsigns.nvim'

    -- snippet
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- utilities
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'EdenEast/nightfox.nvim'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Nvim-cmp config
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Lsp-installer config
require("nvim-lsp-installer").setup {}

-- Lsp config.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['pyright'].setup {
    capabilities = capabilities,
    on_attach = function()
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = 0})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = 0})
        vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {buffer = 0})
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = 0})
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer = 0})
        vim.keymap.set('n', '<leader>ld', vim.diagnostic.goto_next, {buffer = 0})
        vim.keymap.set('n', '<leader>lD', vim.diagnostic.goto_prev, {buffer = 0})
        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, {buffer = 0})
    end,
}

-- Treesitter config
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'python', 'javascript' },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
}

-- Nightfox config
require('nightfox').setup({
    options = {
        transparent = true,
        styles = {
            comments = 'italic',
            keywords = 'bold',
        }
    }
})
vim.cmd('colorscheme terafox')

-- Autopairs config
require('nvim-autopairs').setup {}

-- Comment config
require('Comment').setup{
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    mappings = {
        basic = true,
        extra = true,
    }
}

-- Gitsigns config
require('gitsigns').setup()
