return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        {'j-hui/fidget.nvim', opts = {}},
        'folke/neodev.nvim',
    },
    config = function()
        -- Mason(lsp installer) setup
        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'bashls',
                'clangd',
                'pyright',
                'tsserver',
                'lua_ls',
                'emmet_ls',
                'marksman',
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
            nmap(']d', vim.diagnostic.goto_next, 'Next Diagnostic')
            nmap('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
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
            'marksman',
        }

        for _, server in ipairs(servers) do
            require('lspconfig')[server].setup {
                capabilities = capabilities,
                on_attach = on_attach,
            }
        end
        require('neodev').setup()

        require('lspconfig')['rust_analyzer'].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = {
                "rustup", "run", "stable", "rust-analyzer"
            }
        }

        require('lspconfig')['lua_ls'].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                },
            },
        }

        require('lspconfig')['emmet_ls'].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { 'html', 'htmldjango', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss' },
        })
    end,
}

