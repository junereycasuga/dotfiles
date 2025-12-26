vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw file explorer" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- nope
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- splitting and resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "_", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "+", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", ">", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- indent
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("i", "jj", "<Esc>", { noremap = false, desc = "Escape insert mode" })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false, desc = "Escape insert mode" })

-- Telescope
vim.keymap.set("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<C-p>", function()
	require("telescope.builtin").git_files()
end, { desc = "Find git files" })
vim.keymap.set("n", "<leader>vh", function()
	require("telescope.builtin").help_tags()
end, { desc = "Telescope help tags" })

-- Git Merge
-- Shortcuts for Git merge conflicts
-- Press <leader>dl to get changes from the local branch (ours).
vim.keymap.set('n', '<leader>dl', ':diffget //2<CR>', {
	noremap = true,
	silent = true,
	desc = '[D]iff [G]et [L]ocal (ours)'
})

-- Press <leader>dr to get changes from the remote branch (theirs).
vim.keymap.set('n', '<leader>dr', ':diffget //3<CR>', {
	noremap = true,
	silent = true,
	desc = '[D]iff [G]et [R]emote (theirs)'
})

-- CodeCompanion
vim.keymap.set("n", "<leader>cc", ":CodeCompanionChat Toggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle CodeCompanion chat" })
