-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("tpope/vim-fugitive")

	use("lewis6991/gitsigns.nvim")

	use("tpope/vim-sleuth")

	--  Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Telescope for fuzzy finder
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Post-install/update hook with neovim command
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- Tree
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	-- Tmux navigation
	use({ "alexghergh/nvim-tmux-navigation" })

	-- color schemes
	use({ "rafi/awesome-vim-colorschemes" })

	-- LSP
	use({
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			{                         -- Optional
				"williamboman/mason.nvim",
				run = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },  -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "L3MON4D3/LuaSnip" },  -- Required
		},
	})

	-- format using none-ls, new null-ls
	use({
		"nvimtools/none-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- commentary
	use("tpope/vim-commentary")

	-- surroundings
	use("tpope/vim-surround")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use("jiangmiao/auto-pairs")

	use("lukas-reineke/indent-blankline.nvim")

	use({
		"folke/trouble.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	use("folke/zen-mode.nvim")

	use("github/copilot.vim")

	use("CopilotC-Nvim/CopilotChat.nvim")

	use("ThePrimeagen/vim-be-good")
end)
