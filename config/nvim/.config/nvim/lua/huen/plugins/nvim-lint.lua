return {
	"mfussenegger/nvim-lint",
	lazy = true,
	events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function(_, opts)
		local lint = require("lint")
		lint.linters_by_ft = {
			sql = { "sqlfluff" },
			zsh = { "zsh" },
			sh = { "shellcheck" },
			docker = { "hadolint" },
			json = { "jsonlint" },
			markdown = { "markdownlint", "cspell" },
			yaml = { "yamllint" },
			lua = { "luacheck" },
			python = { "mypy" },
			ansible = { "ansible_lint" },
		}

		vim.api.nvim_create_autocmd(opts.events, {
			callback = function()
				lint.try_lint()
				lint.try_lint("codespell")
			end,
		})
	end,
}
