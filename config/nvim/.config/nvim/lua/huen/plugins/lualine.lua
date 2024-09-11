return {
	"nvim-lualine/lualine.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local icons = require("huen.core.icons")
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				disabled_filetypes = { "NvimTree" },
			},
			sections = {
				lualine_b = {
					"branch",
					"diff",
				},
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
				},
			},
		})
	end,
}
