return {
	-- AI
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
		config = function()
			require("codecompanion").setup({
				extensions = {
					history = {
						enabled = true,
						opts = {
							keymap = "gh",
							save_chat_keymap = "sc",
							auto_save = false,
							auto_generate_title = true,
							continue_last_chat = false,
							delete_on_clearing_chat = false,
							picker = "snacks",
							enable_logging = false,
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
						}
					},
					vectorcode = {
						opts = {
							add_tool = true,
						}
					},
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							show_result_in_chat = true,
							make_vars = true,
							make_slash_commands = true,
						}
					}
				},
				adapters = {
					openrouter = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								api_key = "OPENROUTER_API_KEY",
								url = "https://openrouter.ai/api",
								chat_url = "/v1/chat/completions",
							},
							schema = {
								model = {
									default = "anthropic/claude-3.7-sonnet",
									choices = {
										"google/gemini-2.0-pro",
										"openai/gpt-40"
									}
								},
							},
						})
					end,
					openrouter_chat = function()
						return require("codecompanion.adapters").extend("openrouter", {
							schema = {
								model = {
									default = "google/gemini-2.5-pro",
								}
							}
						})
					end,
					openrouter_inline = function()
						return require("codecompanion.adapters").extend("openrouter", {
							schema = {
								model = {
									default = "openai/gpt-4.1"
								},
								temperature = {
									default = 0.2
								}
							}
						})
					end,
					openrouter_file = function()
						return require("codecompanion.adapters").extend("openrouter", {
							schema = {
								model = {
									default = "anthropic/claude-3.7-sonnet"
								}
							}
						})
					end,
					lm_studio = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "http://localhost:1234",
							},
							schema = {
								model = {
									default = "deepseek/deepseek-r1-0528-qwen3-8b"
								}
							}
						})
					end,
					ollama = function()
						return require("codecompanion.adapters").extend("ollama", {
							schema = {
								model = {
									default = "deepseek-coder-v2:16b"
								} 
							}
						})
					end
				},
				strategies = {
					chat = {
						adapter = "openrouter_chat",
					},
					inline = {
						adapter = "openrouter_inline",
					},
					file = {
						adapter = "openrouter_file",
					},
				},
				keymaps = {
					chat = {
						change_adapter = "ga",
						submit = "<CR>"
					},
				},
				display = {
					chat = {
						window = {
							position = "right",
							-- Optional: width of the chat window
							width = 75,
						}
					}
				},
				-- Optional: Configure context collection
				context = {
					-- Enable collecting workspace info for better suggestions
					enable_workspace = true,
					-- Max number of files to include from workspace
					max_workspace_files = 5,
				},
				init = function()
					vim.cmd([[cab cc CodeCompanion]])
					require("spinner"):init()
				end,
			})
		end
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
