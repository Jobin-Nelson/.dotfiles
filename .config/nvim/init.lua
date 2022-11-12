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
vim.opt.wildignore:append { '*/venv/*', '*/node_modules/*' }
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.swapfile = false
vim.opt.undodir = HOME .. '/.config/nvim/undodir'
vim.opt.undofile = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.g.python3_host_prog = '/home/jobin/.pyenv/versions/3.11.0/bin/python'

-- Wsl clipboard
vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf"
    },
    paste = {
        ["+"] = "win32yank.exe -o --crlf",
        ["*"] = "win32yank.exe -o --crlf"
    },
    cache_enable = 0,
}
-- Keymaps
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>i', '<cmd>edit ~/.config/nvim/init.lua<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore 25<CR>')
vim.keymap.set('n', '<C-Up>', '<cmd>resize +3<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -3<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +3<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -3<CR>')
vim.keymap.set('n', 'L', '<cmd>bnext<CR>')
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>')
-- vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- vim.cmd('autocmd FileType python nnoremap <F5> <cmd>w <bar> !python %<CR>')
-- vim.cmd('autocmd FileType javascript nnoremap <F5> <cmd>w <bar> !node %<CR>')
local my_group = vim.api.nvim_create_augroup('my_group', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    command = 'nnoremap <F5> <cmd>w <bar> !python %<CR>',
    group = my_group,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    command = 'setl bufhidden=delete',
    group = my_group,
})

-- Automatically install packer
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'

    -- lsp
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'onsails/lspkind.nvim'

    -- snippets
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
    }

    -- telescope
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'

    -- git
    use 'lewis6991/gitsigns.nvim'

    -- statusline
    use 'nvim-lualine/lualine.nvim'

    -- utilities
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'kyazdani42/nvim-web-devicons'
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-surround'
    use 'dhruvasagar/vim-table-mode'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- Nvim-cmp config
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-F>'] = cmp.mapping.scroll_docs(-4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
    }),
    formatting = {
        format = require('lspkind').cmp_format({
            max_width = 50,
            ellipsis_char = '...',
        })
    }
})

-- Mason(lsp installer) setup
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright',
        'tsserver',
        'sumneko_lua',
        'emmet_ls',
        'html',
    }
})

-- Lsp config.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function()
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = 0 })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.show, { buffer = 0 })
    vim.keymap.set('n', '<leader>lD', vim.diagnostic.hide, { buffer = 0 })
    vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { buffer = 0 })
    vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { buffer = 0 })
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = 0 })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = 0 })
end
local servers = {
    'pyright',
    'tsserver',
    'rust_analyzer',
}

for _, server in ipairs(servers) do
    require('lspconfig')[server].setup {
        capabilities = capabilities,
        on_attach = on_attach,
    }
end

require('lspconfig')['sumneko_lua'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('config') .. '/lua'] = true,
                }
            }
        }
    }
}

require('lspconfig')['emmet_ls'].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'html', 'htmldjango', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss' },
})

-- Treesitter config
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'rust',
        'python',
        'bash',
        'markdown',
        'markdown_inline',
        'json',
        'yaml',
        'lua',
        'toml',
        'make',
        'html',
        'javascript',
    },
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Telescope config
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>')
require('telescope').setup {
    defaults = {
        file_ignore_patterns = { 'venv', '__pycache__', 'node_modules', 'target' }
    }
}

-- Gitsigns config
vim.keymap.set('n', '<leader>gn', '<cmd>Gitsigns next_hunk<CR>')
vim.keymap.set('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', '<leader>go', '<cmd>Gitsigns preview_hunk<CR>')
require('gitsigns').setup()

-- Catppuccin config
require('catppuccin').setup({
    flavour = 'mocha',
    background = {
        light = 'latte',
        dark = 'mocha',
    },
    dim_inactive = {
        enabled = true,
        shade = 'dark',
        percentage = 0.15,
    },
    transaprent_background = false,
    term_colors = false,
    styles = {
        comments = { 'italic' },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = { 'bold' },
        strings = {},
        variables = {},
        numbers = {},
        booleans = { 'bold' },
        properties = {},
        types = {},
        operators = {},
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        telescope = true,
        treesitter = true,
    }
})
vim.cmd('colorscheme catppuccin')

-- Lualine config
require('lualine').setup({
    options = { theme = 'catppuccin' }
})

-- Autopairs config
require('nvim-autopairs').setup {}

-- Comment config
require('Comment').setup {
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    mappings = {
        basic = true,
        extra = true,
    }
}
