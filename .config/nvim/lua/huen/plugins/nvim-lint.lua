return {
	"mfussenegger/nvim-lint",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			sql = { "sqlfluff" },
			zsh = { "zsh" },
			sh = { "shellcheck" },
			docker = { "hadolint" },
			json = { "jsonlint" },
			markdown = { "markdownlint" },
			yaml = { "yamllint" },
			lua = { "luacheck" },
			python = { "mypy" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
