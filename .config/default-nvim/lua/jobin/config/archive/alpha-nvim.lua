if true then return {} end
return {
	"goolord/alpha-nvim",
	event = 'VimEnter',
	config = function()
		local dashboard = require "alpha.themes.dashboard"
		dashboard.section.header.val = {
			[[                               __                ]],
			[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
			"",
			"                [[ Jobin Nelson ]]",
		}
		dashboard.section.header.opts.hl = "DashboardHeader"
		local button = dashboard.button

		dashboard.section.buttons.val = {
			button("e", "  New file", "<cmd>ene <CR>"),
			button("SPC f f", "󰈞  Find file"),
			button("SPC f o", "󰊄  Find Oldfiles"),
			button("SPC f a", "⚙  Find Config"),
			button("SPC f w", "󰈬  Find word"),
			button("SPC f m", "  Find bookmarks"),
		}

		dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
		dashboard.config.layout[3].val = 5
		dashboard.config.opts.noautocmd = true

		require('alpha').setup(dashboard.config)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			desc = "Add Alpha dashboard footer",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
				dashboard.section.footer.val =
				{ " ", " ", " ", "Neovim loaded " .. stats.count .. " plugins  in " .. ms .. "ms" }
				dashboard.section.footer.opts.hl = "DashboardFooter"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
