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
		vimgrep_arguments = vimgrep_arguments
	},
	pickers = {
		find_files = {
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
		}
	}
})

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
