return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"antosha417/nvim-lsp-file-operations",
		"echasnovski/mini.base16",
	},
	keys = {
		{
			"<leader>tt",
			"<cmd>NvimTreeToggle<cr>",
			desc = "Toggle file tree",
		},
		{
			"<leader>ft",
			"<cmd>NvimTreeFocus<cr>",
			desc = "Focus file tree",
		},
	},
	config = function()
		require("nvim-tree").setup({
			view = { side = "right", width = 40 },
			filters = { custom = { "^\\.git$" } },
		})
	end,
}
