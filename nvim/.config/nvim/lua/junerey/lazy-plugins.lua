return {
	-- Git integration
	{ "tpope/vim-fugitive" },
	{ "lewis6991/gitsigns.nvim" },

	-- Editor enhancements
	{ "tpope/vim-sleuth" },
	{ "nvim-lua/plenary.nvim" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	-- Telescope fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")

			local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

			table.insert(vimgrep_arguments, "--hidden")
			table.insert(vimgrep_arguments, "--glob")
			table.insert(vimgrep_arguments, "!**/.git/*")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = {
								actions.move_selection_next,
								type = "action",
								opts = { nowait = true, silent = true },
							},
							["<C-k>"] = {
								actions.move_selection_previous,
								type = "action",
								opts = { nowait = true, silent = true },
							},
						},
					},
					vimgrep_arguments = vimgrep_arguments,
				},
				pikcers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})

			local keymap = vim.keymap
			keymap.set("n", "<leader>ff", builtin.find_files, {})
			keymap.set("n", "<leader>fg", builtin.live_grep, {})
			keymap.set("n", "<C-p>", builtin.git_files, {})
			keymap.set("n", "<leader>vh", builtin.help_tags, {})
		end,
	},

	-- Treesitter for better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
	},

	-- File explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
	},

	-- Tmux integration
	{ "alexghergh/nvim-tmux-navigation" },

	-- Color schemes
	{ "rafi/awesome-vim-colorschemes" },
	{ "catppuccin/nvim", name = "catppuccin" },

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
	},

	-- Formatting
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Code manipulation
	{ "tpope/vim-commentary" },
	{ "tpope/vim-surround" },

	-- Status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Auto pairs
	{ "jiangmiao/auto-pairs" },

	-- Indentation
	{ "lukas-reineke/indent-blankline.nvim" },

	-- Diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Alpha (greeter)
	{
		"goolord/alpha-nvim",
		-- dependencies = { 'echasnovski/mini.icons' },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.dashboard").config)
		end,
	},

	{
		"mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>Rs", desc = "Send request" },
			{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>Rb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			-- your configuration comes here
			global_keymaps = false,
		},
	},
	{
		"folke/zen-mode.nvim",
	},
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		dependencies = {
			"j-hui/fidget.nvim", -- Display status
			"ravitemer/codecompanion-history.nvim", -- Save and load conversation history
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"Davidyz/VectorCode", -- Index and search code in your repositories
				version = "*",
				build = "pipx upgrade vectorcode",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
	},
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
		config = function()
			require("mcphub").setup()
		end
	}
}
