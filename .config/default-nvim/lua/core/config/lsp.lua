local on_attach = function(_, bufnr)
	local nmap = function(keys, func, desc)
		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	nmap('<leader>lr', vim.lsp.buf.rename, 'Lsp Rename')
	nmap('<leader>la', vim.lsp.buf.code_action, 'Lsp code Action')

	nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
	nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
	nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
	nmap('<leader>gT', vim.lsp.buf.type_definition, 'Goto Type definition')
	nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, 'Lsp Document Symbols')
	nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Lsp Workspace Symbols')
	nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
	nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
	nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')
	nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Lsp Workspace Add folder')
	nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Lsp Workspace Remove folder')
	nmap('<leader>lwl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, 'Lsp Workspace List folders')
	nmap('<leader>lf', vim.lsp.buf.format, 'Lsp Format buffer')

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })
end

local servers = {
	bashls = {},
	clangd = {},
	pyright = {},
	tsserver = {},
	emmet_ls = {},
	marksman = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
	ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		}
	end,
}

require('lspconfig')['rust_analyzer'].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = require('lspconfig.util').root_pattern("Cargo.toml"),
})
