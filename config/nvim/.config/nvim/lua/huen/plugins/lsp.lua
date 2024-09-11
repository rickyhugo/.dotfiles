return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Required
		{ "williamboman/mason.nvim" }, -- Required
		{ "williamboman/mason-lspconfig.nvim" }, -- Required
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" }, -- Required
		{ "onsails/lspkind.nvim" }, -- Required

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" }, -- Required
		{ "hrsh7th/cmp-nvim-lsp" }, -- Required
		{ "hrsh7th/cmp-buffer" }, -- Optional
		{ "hrsh7th/cmp-path" }, -- Optional
		{ "saadparwaiz1/cmp_luasnip" }, -- Optional
		{ "hrsh7th/cmp-nvim-lua" }, -- Optional

		-- Snippets
		{ "L3MON4D3/LuaSnip" }, -- Required
		{ "rafamadriz/friendly-snippets" }, -- Optional

		-- typescript
		{ "yioneko/nvim-vtsls" },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
		local keymap = vim.keymap.set

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }
				local client = vim.lsp.get_client_by_id(event.data.client_id)

				keymap("n", "gd", vim.lsp.buf.definition, opts)
				keymap("n", "gt", vim.lsp.buf.type_definition, opts)
				keymap("n", "gD", vim.lsp.buf.declaration, opts)
				keymap("n", "gi", vim.lsp.buf.implementation, opts)
				keymap("n", "gw", vim.lsp.buf.document_symbol, opts)
				keymap("n", "gW", vim.lsp.buf.workspace_symbol, opts)
				keymap("n", "<leader>vd", vim.diagnostic.open_float, opts)

				-- NOTE: LSP saga keymaps
				keymap("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
				keymap("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
				keymap("n", "<leader>ld", "<Cmd>Lspsaga show_line_diagnostics<CR>")
				keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
				keymap("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", opts)
				keymap("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
				keymap("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", opts)

				if client ~= nil and client.server_capabilities.codeActionProvider then
					keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
					keymap("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
				end
			end,
		})

		vim.diagnostic.config({
			virtual_text = true,
			underline = { severity_limit = vim.diagnostic.severity.ERROR },
			signs = true,
			update_in_insert = false,
			severity_sort = true,
		})

		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettierd",
				"eslint_d",
				"shfmt",
				"shellharden", -- NOTE: requires rust
				"shellcheck",
				"hadolint",
				"markdownlint",
				"jsonlint",
				"yamllint",
				"stylua",
				"luacheck",
				"sqlfluff",
				"codespell",
				"cspell",
			},
		})

		-- LSP configs
		-- lua
		local function default_setup(server)
			lspconfig[server].setup({
				capabilities = lsp_capabilities,
			})
		end

		local function lua_ls()
			require("lspconfig").lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})
		end

		-- python
		local function pyright()
			require("lspconfig").pyright.setup({
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "pyrightconfig.json"),
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			})
		end

		local function ruff_lsp()
			require("lspconfig").ruff_lsp.setup({
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml"),
				settings = {
					-- Any extra CLI arguments for `ruff` go here.
					args = { "--config", "pyproject.toml" },
				},
			})
		end

		-- typescript
		local ts_augroup = vim.api.nvim_create_augroup("TypescriptAutocmds", { clear = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = ts_augroup,
			pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
			command = "VtsExec organize_imports",
			desc = "Organize imports [JS/TS]",
		})

		vim.api.nvim_create_autocmd("BufWritePost", {
			group = ts_augroup,
			pattern = { "package.json" },
			command = "LspRestart eslint",
			desc = "Restart eslint upon changes in 'package.json' [JS/TS]",
		})

		local function vtsls()
			require("lspconfig").vtsls.setup({
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						preferences = {
							importModuleSpecifier = "non-relative",
						},
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
			})
		end

		require("mason-lspconfig").setup({
			ensure_installed = {
				"vtsls",
				"eslint",
				"tailwindcss",
				"lua_ls",
				"bashls",
				"yamlls",
				"dockerls",
				"docker_compose_language_service",
				"taplo",
				"marksman",
				"pyright",
				"ruff_lsp",
				"rust_analyzer",
				"ansiblels",
			},
			automatic_installation = true,
			handlers = {
				default_setup,
				lua_ls = lua_ls,
				pyright = pyright,
				ruff_lsp = ruff_lsp,
				vtsls = vtsls,
			},
		})
	end,
}
