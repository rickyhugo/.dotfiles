return {
	"mfussenegger/nvim-lint",
	lazy = true,
	opts = {
		events = { "BufWritePost", "BufReadPost", "InsertLeave" },
		linters_by_ft = {
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
			go = { "golangcilint" },
		},
	},
	config = function(_, opts)
		local M = {}

		function M.debounce(ms, fn)
			local timer = vim.uv.new_timer()
			return function(...)
				local argv = { ... }
				timer:start(ms, 0, function()
					timer:stop()
					vim.schedule_wrap(fn)(unpack(argv))
				end)
			end
		end

		function M.lint()
			local lint = require("lint")
			lint.try_lint()
			lint.try_lint("codespell")
		end

		vim.api.nvim_create_autocmd(opts.events, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = M.debounce(100, M.lint),
		})
	end,
}
