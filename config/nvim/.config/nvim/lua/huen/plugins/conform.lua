return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				svelte = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				sh = { "shfmt", "shellharden" },
				sql = { "sqlfluff" },
				toml = { "taplo" },
				rust = { "rustfmt", lsp_format = "fallback" },
				go = { "gofumpt", "goimports-reviser" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		-- NOTE: use rustfmt nightly: `rustup toolchain install nightly`
		require("conform").formatters.rustfmt = {
			command = "cargo +nightly fmt",
		}
	end,
}
