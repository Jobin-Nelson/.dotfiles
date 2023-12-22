vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('jobin.config.options')
require('jobin.config.mappings')
require('jobin.config.commands')

require('lazy').setup({
  { import = 'jobin.plugins'},
}, {
  install = {
    colorscheme = {'catppuccin'},
  },
  checker = {
    enabled = true,
    notify = false,
  },
	defaults = {
		lazy = true,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			}
		}
	}
})


