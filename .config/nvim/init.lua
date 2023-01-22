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
vim.opt.fileformat = 'unix'
vim.opt.listchars = { eol = '↲', tab = '▸ ', trail = '·' }
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.python3_host_prog = '$HOME/.pyenv/versions/3.11.1/bin/python'

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

-- Keymaps
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>i', '<cmd>edit $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore 25<CR>')
vim.keymap.set('n', '<C-Up>', '<cmd>resize +3<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -3<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +3<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -3<CR>')
vim.keymap.set('n', 'L', '<cmd>bnext<CR>')
vim.keymap.set('n', 'H', '<cmd>bprevious<CR>')
vim.keymap.set('n', '<leader>s', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>')
-- vim.keymap.set('v', 'p', '"_dP')
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Autocommands
local my_group = vim.api.nvim_create_augroup('my_group', { clear = true })
 -- for quick execution of python files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    command = 'nnoremap <F5> <cmd>w <bar> !python %<CR>',
    group = my_group,
})
 -- for removing empty netrw buffers
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'netrw',
    command = 'setlocal bufhidden=wipe',
    group = my_group,
})
 -- for pretty markdown syntax
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    command = 'setlocal conceallevel=2',
    group = my_group,
})
 -- for setting formatoptions only when in second_brain directory
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
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

if packer_bootstrap then
    print '=================================='
    print '    Plugins are being installed'
    print '    Wait until Packer completes,'
    print '       then restart nvim'
    print '=================================='
    return
end

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
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
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
        'clangd',
        'pyright',
        'tsserver',
        'sumneko_lua',
        'emmet_ls',
    }
})

-- Lsp config.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('<leader>gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ld', vim.diagnostic.show, 'Show Diagnostic')
    nmap('<leader>lD', vim.diagnostic.hide, 'Hide Diagnostic')
    nmap('<leader>do', vim.diagnostic.open_float, 'Open Diagnostic')
    nmap('<leader>dn', vim.diagnostic.goto_next, 'Next Diagnostic')
    nmap('<leader>dp', vim.diagnostic.goto_prev, 'Previous Diagnostic')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('<leader>wl', function() vim.pretty_print(vim.lsp.buf.list_workspace_folders()) end, '[W]orkspace [L]ist [F]olders')
    nmap('<leader>lf', vim.lsp.buf.format, 'Format buffer')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
end
local servers = {
    'bashls',
    'clangd',
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

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init..lua')

require('lspconfig')['sumneko_lua'].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = runtime_path,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
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
        'help',
        'vim',
    },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = '<C-s>',
            node_decremental = '<C-backspace>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = false,
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer,'
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
                ['<leader>A'] = '@parameter.inner',
            },
        },
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
    transparent_background = false;
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
        telescope = true,
        mason = true,
        treesitter = true,
    },
})
vim.cmd[[colorscheme catppuccin]]

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

-- User commands
function Rename()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.fn.input('New name: ')

    vim.fn.saveas(bufnr)
end

vim.api.nvim_create_user_command('Rename', Rename, {})
