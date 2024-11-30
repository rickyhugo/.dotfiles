return {
	{
		"mfussenegger/nvim-treehopper",
		keys = { { "m", mode = { "o", "x" } } },
		config = function()
			vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "BufReadPre",
		config = true,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		lazy = vim.fn.argc(-1) == 0,
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"dockerfile",
				"gitignore",
				"markdown",
				"markdown_inline",
				"python",
				"printf",
				"regex",
				"sql",
				"vim",
				"vimdoc",
				"toml",
				"yaml",
				"json",
				"jsonc",
				"javascript",
				"jsx",
				"typescript",
				"tsx",
				"jsdoc",
				"lua",
				"luadoc",
				"luap",
				"rust",
				"query",
				"xml",
				"go",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			ignore_install = {},
		},
	},
}
