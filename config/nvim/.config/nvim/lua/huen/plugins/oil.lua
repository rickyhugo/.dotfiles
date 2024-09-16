return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			columns = { "icon" },
			delete_to_trash = true,
			keymaps = {
				["<C-h>"] = false,
				["<C-j>"] = false,
				["<C-k>"] = false,
				["<C-l>"] = false,
				["<M-h>"] = "actions.select_split",
			},
			view_options = {
				show_hidden = true,
			},
		})

		vim.keymap.set("n", "-", "<cmd>oil<cr>", { desc = "Open parent directory" })
		vim.keymap.set(
			"n",
			"<space>-",
			require("oil").toggle_float,
			{ desc = "Open parent directory in floating window" }
		)
	end,
}
