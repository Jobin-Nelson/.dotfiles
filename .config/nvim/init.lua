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
vim.opt.undofile = true
vim.opt.undodir = HOME .. '/.config/nvim/undodir'
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.python3_host_prog = '$HOME/.pyenv/versions/3.11.0/bin/python'

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

-- Autocommands
local my_group = vim.api.nvim_create_augroup('my_group', { clear = true })
vim.api.nvim_create_autocmd('FileType', { -- for quick execution of python files
    pattern = 'python',
    command = 'nnoremap <F5> <cmd>w <bar> !python %<CR>',
    group = my_group,
})
vim.api.nvim_create_autocmd('FileType', { -- for removing empty netrw buffers
    pattern = 'netrw',
    command = 'setlocal bufhidden=wipe',
    group = my_group,
})
vim.api.nvim_create_autocmd('FileType', { -- for pretty markdown syntax
    pattern = 'markdown',
    command = 'setlocal conceallevel=2',
    group = my_group,
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, { -- for setting formatoptions only when in second_brain directory
    pattern = '*/second_brain*',
    command = 'setlocal formatoptions+=a colorcolumn=80',
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
    use 'sainnhe/gruvbox-material'
    use { 'catppuccin/nvim', as = 'catppuccin' }
    use 'numToStr/Comment.nvim'
    use 'windwp/nvim-autopairs'
    use 'tpope/vim-surround'
    use 'dhruvasagar/vim-zoom'
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
})

-- Mason(lsp installer) setup
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'bashls',
        'pyright',
        'tsserver',
        'sumneko_lua',
        'emmet_ls',
    }
})

-- Lsp config.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function()
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = 0 })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set('n', '<leader>ld', vim.diagnostic.show, { buffer = 0 })
    vim.keymap.set('n', '<leader>lD', vim.diagnostic.hide, { buffer = 0 })
    vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { buffer = 0 })
    vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { buffer = 0 })
    vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { buffer = 0 })
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { buffer = 0 })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = 0 })
end
local servers = {
    'bashls',
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
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Telescope config
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>')
vim.keymap.set('n', '<leader>fo', '<cmd>Telescope oldfiles<CR>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>')
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

-- Catppuccing config
require('catppuccin').setup({
    flavour = 'mocha',
    background = {
        light = 'latte',
        dark = 'mocha',
    },
    transparent_background = true;
    term_colors = false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
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
        nvimtree = true,
        telescope = true,
        mason = true,
        treesitter = true,
    },
})
vim.cmd('colorscheme catppuccin')

-- Gruvbox-material config
vim.g.gruvbox_material_background = 'medium'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_diagnostic_text_highlight = 1

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

