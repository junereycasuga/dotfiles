vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
	close_if_last_window = true,
	enable_git_status = true,
	default_component_configs = {
		container = {
			enable_character_fade = true,
		},
		name = {
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
})

vim.cmd([[nnoremap <C-t> :Neotree toggle position=current<CR>]])
