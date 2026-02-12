return {
	-- Editor enhancements
	{ "tpope/vim-sleuth" },
	{ "nvim-lua/plenary.nvim" },
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-z>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-x>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-c>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-v>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-S-N>", function()
				harpoon:list():next()
			end)
		end
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Press <Tab> to expand or jump to the next snippet placeholder
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					return "<Plug>luasnip-expand-or-jump"
				else
					return "<Tab>"
				end
			end, { expr = true, silent = true })
			-- Press <S-Tab> to jump backward in snippet
			vim.keymap.set("i", "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })
			vim.keymap.set("s", "<Tab>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set("s", "<S-Tab>", function()
				ls.jump(-1)
			end, { silent = true })
			-- For changing choices in choiceNodes
			vim.keymap.set("i", "<C-E>", function()
				if ls.choice_active() then
					return "<Plug>luasnip-next-choice"
				else
					return "<C-E>"
				end
			end, { expr = true, silent = true })
			vim.keymap.set("s", "<C-E>", function()
				if ls.choice_active() then
					return "<Plug>luasnip-next-choice"
				else
					return "<C-E>"
				end
			end, { expr = true, silent = true })
		end
	},
	-- Telescope fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local telescopeConfig = require("telescope.config")
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
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})
		end,
	},

	-- Treesitter for better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"javascript",
					"typescript",
					"go",
					"terraform",
					"markdown",
					"templ",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end
	},

	-- File explorer
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				delete_to_trash = true,
				skip_confirm_for_simple_edits = true,
				view_options = {
					show_hidden = true,
					natural_order = true,
				},
				win_options = {
					wrap = true
				},
				keymaps = {
					["<C-r>"] = "actions.refresh",
					["<C-l>"] = false, -- disable default refresh binding
				},
			})
		end
	},

	-- Code manipulation
	{ "tpope/vim-commentary" },
	{ "tpope/vim-surround" },

	-- Auto pairs
	{ "jiangmiao/auto-pairs" },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dim = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			picker = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scratch = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			zen = { enabled = true }
		},
		keys = {
			{ "<leader>z",  function() Snacks.zen() end,                desc = "Toggle Zen Mode" },
			{ "<leader>un", function() Snacks.notifier.hide() end,      desc = "Hide Notifier" },
			{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
			{ "<leader>gB", function() Snacks.gitbrowse() end,          desc = "Git browse",           mode = { "n", "v" } },
			{ "<leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit" },
			{ "<leader>.",  function() Snacks.scratch() end,            desc = "Toggle Scratch Buffer" },
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					Snacks.toggle.dim():map("<leader>uD")
				end
			})
		end
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)"
			}
		}
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({})
		end
	}
}
