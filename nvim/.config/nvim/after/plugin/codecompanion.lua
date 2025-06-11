require("codecompanion").setup({
  adapters = {
    openrouter_claude = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://openrouter.ai/api",
          api_key = "cmd:op read op://Personal/CodeCompanion-OpenRouter/credential --no-newline",
          chat_url = "/v1/chat/completions",
        },
        schema = {
          model = {
            default = "anthropic/claude-3.7-sonnet",
          },
        },
      })
    end
  },
  strategies = {
    chat = {
      adapter = "openrouter_claude",
    },
    inline = {
      adapter = "openrouter_claude",
    },
    -- Add file strategy (generates content for entire files)
    file = {
      adapter = "openrouter_claude",
    },
  },
  display = {
    chat = {
      window = {
        position = "right",
        -- Optional: width of the chat window
        width = 50,
      }
    }
  },
  -- Optional: Configure keymaps
  keymaps = {
    -- Inline completion toggle
    toggle_inline = "<leader>i",
    -- Open chat
    open_chat = "<leader>ac",
    -- Close chat
    close_chat = "<leader>cq",
  },
  -- Optional: Configure context collection
  context = {
    -- Enable collecting workspace info for better suggestions
    enable_workspace = true,
    -- Max number of files to include from workspace
    max_workspace_files = 5,
  }
})

