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

		lint.linters.sqlfluff.args = { "lint", "--format=json", "--dialect=postgres", "-" }

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
