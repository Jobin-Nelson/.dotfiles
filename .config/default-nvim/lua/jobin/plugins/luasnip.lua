return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	-- version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	config = function()
		require('luasnip.loaders.from_vscode').lazy_load()
		require('luasnip.loaders.from_lua').load({ paths = { vim.fn.stdpath('config') .. '/snippets' } })
	end
}


