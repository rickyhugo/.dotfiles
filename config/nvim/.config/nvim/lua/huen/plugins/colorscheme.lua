return {
	-- catppuccin
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "mocha",
			highlight_overrides = {
				mocha = function(mocha)
					return {
						LineNr = { fg = mocha.text },
						CursorLineNr = { fg = "#8f95aa" },
					}
				end,
			},
			integrations = {
				cmp = true,
				treesitter = true,
				which_key = true,
				lsp_saga = true,
				mason = true,
				alpha = true,
				nvimtree = true,
				telescope = { enabled = true },
				dadbod_ui = true,
				lsp_trouble = true,
			},
		})

		vim.cmd([[colorscheme catppuccin]])
	end,
}
