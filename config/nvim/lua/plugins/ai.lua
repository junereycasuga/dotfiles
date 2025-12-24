return {
	-- AI
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	opts = {},
	-- 	dependencies = {
	-- 		"j-hui/fidget.nvim", -- Display status
	-- 		"ravitemer/codecompanion-history.nvim", -- Save and load conversation history
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	config = function()
	-- 		require("codecompanion").setup({
	-- 			extensions = {
	-- 				history = {
	-- 					enabled = true,
	-- 					opts = {
	-- 						keymap = "gh",
	-- 						save_chat_keymap = "sc",
	-- 						auto_save = false,
	-- 						auto_generate_title = true,
	-- 						continue_last_chat = false,
	-- 						delete_on_clearing_chat = false,
	-- 						picker = "snacks",
	-- 						enable_logging = false,
	-- 						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
	-- 					}
	-- 				},
	-- 				mcphub = {
	-- 					callback = "mcphub.extensions.codecompanion",
	-- 					opts = {
	-- 						show_result_in_chat = true,
	-- 						make_vars = true,
	-- 						make_slash_commands = true,
	-- 					}
	-- 				}
	-- 			},
	-- 			adapters = {
	-- 				openrouter = function()
	-- 					return require("codecompanion.adapters").extend("openai_compatible", {
	-- 						env = {
	-- 							api_key = "OPENROUTER_API_KEY",
	-- 							url = "https://openrouter.ai/api",
	-- 							chat_url = "/v1/chat/completions",
	-- 						},
	-- 						schema = {
	-- 							model = {
	-- 								default = "anthropic/claude-3.7-sonnet",
	-- 								choices = {
	-- 									"google/gemini-2.0-pro",
	-- 									"openai/gpt-40"
	-- 								}
	-- 							},
	-- 						},
	-- 					})
	-- 				end,
	-- 				openrouter_chat = function()
	-- 					return require("codecompanion.adapters").extend("openrouter", {
	-- 						schema = {
	-- 							model = {
	-- 								default = "google/gemini-2.5-pro",
	-- 							}
	-- 						}
	-- 					})
	-- 				end,
	-- 				openrouter_inline = function()
	-- 					return require("codecompanion.adapters").extend("openrouter", {
	-- 						schema = {
	-- 							model = {
	-- 								default = "openai/gpt-4.1"
	-- 							},
	-- 							temperature = {
	-- 								default = 0.2
	-- 							}
	-- 						}
	-- 					})
	-- 				end,
	-- 				openrouter_file = function()
	-- 					return require("codecompanion.adapters").extend("openrouter", {
	-- 						schema = {
	-- 							model = {
	-- 								default = "anthropic/claude-3.7-sonnet"
	-- 							}
	-- 						}
	-- 					})
	-- 				end,
	-- 				lm_studio = function()
	-- 					return require("codecompanion.adapters").extend("openai_compatible", {
	-- 						env = {
	-- 							url = "http://localhost:1234",
	-- 						},
	-- 						schema = {
	-- 							model = {
	-- 								default = "deepseek/deepseek-r1-0528-qwen3-8b"
	-- 							}
	-- 						}
	-- 					})
	-- 				end,
	-- 				ollama = function()
	-- 					return require("codecompanion.adapters").extend("ollama", {
	-- 						schema = {
	-- 							model = {
	-- 								default = "deepseek-coder-v2:16b"
	-- 							}
	-- 						}
	-- 					})
	-- 				end
	-- 			},
	-- 			strategies = {
	-- 				chat = {
	-- 					adapter = "openrouter_chat",
	-- 				},
	-- 				inline = {
	-- 					adapter = "openrouter_inline",
	-- 				},
	-- 				file = {
	-- 					adapter = "openrouter_file",
	-- 				},
	-- 			},
	-- 			keymaps = {
	-- 				chat = {
	-- 					change_adapter = "ga",
	-- 					submit = "<CR>"
	-- 				},
	-- 			},
	-- 			display = {
	-- 				chat = {
	-- 					window = {
	-- 						position = "right",
	-- 						-- Optional: width of the chat window
	-- 						width = 75,
	-- 					}
	-- 				}
	-- 			},
	-- 			-- Optional: Configure context collection
	-- 			context = {
	-- 				-- Enable collecting workspace info for better suggestions
	-- 				enable_workspace = true,
	-- 				-- Max number of files to include from workspace
	-- 				max_workspace_files = 5,
	-- 			},
	-- 			init = function()
	-- 				vim.cmd([[cab cc CodeCompanion]])
	-- 				require("spinner"):init()
	-- 			end,
	-- 		})
	-- 	end
	-- },
	-- {
	-- 	"ravitemer/mcphub.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
	-- 	config = function()
	-- 		require("mcphub").setup()
	-- 	end
	-- }
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},
	{
		"folke/sidekick.nvim",
		opts = {
			nes = { enabled = false },
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				}
			}
		},
		keys = {
			{
				"<tab>",
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>" -- fallback to normal tab
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
			},
			{
				"<c-.>",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle",
				mode = { "n", "t", "i", "x" },
			},
			{
				"<leader>aa",
				function() require("sidekick.cli").toggle() end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function() require("sidekick.cli").select() end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function() require("sidekick.cli").close() end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function() require("sidekick.cli").send({ msg = "{this}" }) end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function() require("sidekick.cli").send({ msg = "{file}" }) end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function() require("sidekick.cli").send({ msg = "{selection}" }) end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function() require("sidekick.cli").prompt() end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- Example of a keybinding to open OpenCode directly
			{
				"<leader>ao",
				function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
				desc = "Sidekick Toggle Claude",
			},
		},
	}
}
