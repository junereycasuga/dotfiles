local copilot_chat = require("CopilotChat")

copilot_chat.setup({
	show_help = "yes",
	debug = false,
	disable_extra_info = "no",
	language = "English",
	build = function()
		vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart neovim")
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
		{ "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
		{
			"<leader>ccT",
			"<cmd>CopilotChatVsplitToggle<cr>",
			desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
		},
		{
			"<leader>ccv",
			":CopilotChatVisual",
			mode = "x",
			desc = "CopilotChat - Open in vertical split",
		},
		{
			"<leader>ccx",
			":CopilotChatInPlace<cr>",
			mode = "x",
			desc = "CopilotChat - Run in-place code",
		},
		{
			"<leader>ccf",
			"<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
			desc = "CopilotChat - Fix diagnostic",
		},
		{
			"<leader>ccr",
			"<cmd>CopilotChatReset<cr>", -- Reset chat history and clear buffer.
			desc = "CopilotChat - Reset chat history and clear buffer",
		},
	},
})
