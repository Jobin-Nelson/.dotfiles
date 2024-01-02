return {
  {
	  'nvim-treesitter/nvim-treesitter',
	  event = { 'VeryLazy' },
	  dependencies = {
		  'nvim-treesitter/nvim-treesitter-textobjects',
	  },
	  build = ':TSUpdate',
	  config = function()
		  require('nvim-treesitter.configs').setup({
			  ensure_installed = {
				  'rust',
          'go',
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
				  -- keymaps = {
				  -- 	init_selection = '<c-space>',
				  -- 	node_incremental = '<c-space>',
				  -- 	scope_incremental = '<c-s>',
				  -- 	node_decremental = '<M-space>',
				  -- },
			  },
			  textobjects = {
				  select = {
					  enable = true,
					  lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["ak"] = { query = "@block.outer", desc = "around block" },
              ["ik"] = { query = "@block.inner", desc = "inside block" },
              ["ac"] = { query = "@class.outer", desc = "around class" },
              ["ic"] = { query = "@class.inner", desc = "inside class" },
              ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
              ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
              ["af"] = { query = "@function.outer", desc = "around function " },
              ["if"] = { query = "@function.inner", desc = "inside function " },
              ["al"] = { query = "@loop.outer", desc = "around loop" },
              ["il"] = { query = "@loop.inner", desc = "inside loop" },
              ["aa"] = { query = "@parameter.outer", desc = "around argument" },
              ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
            },
          },
				  move = {
					  enable = true,
					  set_jumps = true, -- whether to set jumps in the jumplist
					  goto_next_start = {
              ["]k"] = { query = "@block.outer", desc = "Next block start" },
              ["]f"] = { query = "@function.outer", desc = "Next function start" },
              ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
					  },
					  goto_next_end = {
              ["]K"] = { query = "@block.outer", desc = "Next block end" },
              ["]F"] = { query = "@function.outer", desc = "Next function end" },
              ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
					  },
					  goto_previous_start = {
              ["[k"] = { query = "@block.outer", desc = "Previous block start" },
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
              ["[c"] = { query = "@class.outer", desc = "Previous class start" },
					  },
					  goto_previous_end = {
              ["[K"] = { query = "@block.outer", desc = "Previous block end" },
              ["[F"] = { query = "@function.outer", desc = "Previous function end" },
              ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
              ["[C"] = { query = "@class.outer", desc = "Previous class end" },
					  },
				  },
				  swap = {
					  enable = true,
					  swap_next = {
              [">K"] = { query = "@block.outer", desc = "Swap next block" },
              [">F"] = { query = "@function.outer", desc = "Swap next function" },
              [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
					  },
					  swap_previous = {
              ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
              ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
              ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
					  },
				  },
			  },
		  })
	  end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPre', 'BufNewFile'},
    opts = { mode = "cursor", max_lines = 3 },
  },
}

