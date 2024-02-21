local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	debug = true,
	sources = {
		formatting.gofmt,
		formatting.goimports,
		formatting.terraform_fmt,
		formatting.eslint_d,
		formatting.prettier,
		-- formatting.codespell,
		formatting.fixjson,
		formatting.yamlfmt,
		formatting.trim_whitespace,
		formatting.stylua,
		formatting.templ
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
