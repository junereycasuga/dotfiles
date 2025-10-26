return {
	-- LSP configuration
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{
				"williamboman/mason.nvim",
				build = ":MasonUpdate",
			},
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "L3MON4D3/LuaSnip" },
		},
		config = function()
			local lsp = require("lsp-zero")

			lsp.on_attach(function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)
				vim.keymap.set("n", "<leader>ws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				vim.keymap.set("n", "<leader>ca", function()
					vim.lsp.buf.code_action()
				end, opts)
				vim.keymap.set("n", "<leader>rr", function()
					vim.lsp.buf.references()
				end, opts)
				vim.keymap.set("n", "<leader>rn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end)

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls",
					"terraformls",
					"tflint",
					"eslint",
					"bashls",
					"yamlls",
					"templ",
					"tailwindcss",
					"svelte",
					"sqlls",
					"rust_analyzer",
					"html",
					"htmx",
					"jsonls",
				},
				handlers = {
					lsp.default_setup,
					-- 	function(server_name) -- default handler (optional)
					-- 		-- https://github.com/neovim/nvim-lspconfig/pull/3232
					-- 		if server_name == "tsserver" then
					-- 			server_name = "ts_ls"
					-- 		end
					-- 		local capabilities = require("cmp_nvim_lsp").default_capabilities()
					-- 		require("lspconfig")[server_name].setup({

					-- 			capabilities = capabilities,
					-- 		})
					-- 	end,
				},
			})

			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<S-Space>"] = cmp.mapping.complete(),
			})

			-- cmp_mappings["<Tab>"] = nil
			-- cmp_mappings["<S-Tab>"] = nil

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp_mappings,
			})

			lsp.set_preferences({
				suggest_lsp_servers = false,
			})

			lsp.set_sign_icons({
				error = "",
				warning = "",
				hint = "",
				information = "",
			})

			vim.filetype.add({ extension = { templ = "templ" } })
		end
	},

	-- Formatting
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				debug = true,
				sources = {
					formatting.gofmt,
					formatting.goimports,
					formatting.terraform_fmt,
					formatting.prettier,
					-- formatting.codespell,
					formatting.yamlfmt,
					formatting.stylua,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
								vim.lsp.buf.format({
									bufnr = bufnr,
									async = false,
									-- filter = function(client)
									-- 	return client.name == "null-ls"
									-- end,
								})
							end,
						})
					end
				end,
			})
		end
	},
}
