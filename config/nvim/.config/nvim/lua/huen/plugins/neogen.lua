return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	version = "*",
	opts = {
		enabled = true,
		snippet_engine = "luasnip",
		languages = {
			python = {
				template = {
					annotation_convention = "numpydoc",
				},
			},
		},
	},
	keys = {
		{
			"<leader>nf",
			function()
				require("neogen").generate()
			end,
			desc = "Generate docstring in current context",
		},
	},
}
