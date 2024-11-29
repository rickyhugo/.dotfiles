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

				keymap("n", "gd", vim.lsp.buf.definition, { buffer = event.buf, desc = "Go to definition" })
				keymap("n", "gt", vim.lsp.buf.type_definition, { buffer = event.buf, desc = "Go to type definition" })
				keymap("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf, desc = "Go to declaration" })
				keymap("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf, desc = "Go to implementation" })
				keymap("n", "gw", vim.lsp.buf.document_symbol, { buffer = event.buf, desc = "List document symbols" })
				keymap("n", "gW", vim.lsp.buf.workspace_symbol, { buffer = event.buf, desc = "List workspace symbols" })
				keymap(
					"n",
					"<leader>vd",
					vim.diagnostic.open_float,
					{ buffer = event.buf, desc = "Show diagnostic in floating window" }
				)

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
		local function basedpyright()
			require("lspconfig").basedpyright.setup({
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "pyrightconfig.json"),
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = false,
							diagnosticMode = "openFilesOnly",
						},
					},
				},
			})
		end

		local function ruff()
			require("lspconfig").ruff.setup({
				root_dir = require("lspconfig.util").root_pattern("pyproject.toml"),
				trace = "messages",
				init_options = {
					settings = {
						logLevel = "error",
					},
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

		-- rust
		local function rust_analyzer()
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						rustfmt = {
							extraArgs = { "+nightly" },
						},
						check = {
							command = "clippy",
						},
						diagnostics = {
							enable = true,
						},
						imports = {
							granularity = {
								group = "module",
							},
							prefix = "self",
						},
						cargo = {
							buildScripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			})
		end

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
				"basedpyright",
				"ruff",
				"rust_analyzer",
				"ansiblels",
			},
			automatic_installation = true,
			handlers = {
				default_setup,
				lua_ls = lua_ls,
				basedpyright = basedpyright,
				ruff = ruff,
				vtsls = vtsls,
				rust_analyzer = rust_analyzer,
			},
		})
	end,
}
