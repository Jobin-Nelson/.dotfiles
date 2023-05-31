return {
	'nvim-treesitter/nvim-treesitter',
	event = { 'BufReadPost', 'BufNewFile' },
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	config = function()
		require('nvim-treesitter.configs').setup({
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
				'css',
				'javascript',
				'typescript',
				'tsx',
				'vim',
				'commonlisp',
				'org',
				'query'
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { 'org' },
			},
			indent = { enable = true, disable = { 'python' } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<c-space>',
					node_incremental = '<c-space>',
					scope_incremental = '<c-s>',
					node_decremental = '<M-space>',
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
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
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']c'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']C'] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[c'] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[C'] = '@class.outer',
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
		})
	end
}
