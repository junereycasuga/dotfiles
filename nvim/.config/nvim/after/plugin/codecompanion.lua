require("codecompanion").setup({
  adapters = {
    openrouter_claude = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = "https://openrouter.ai/api",
          api_key = "echo $OPENROUTER_API_KEY",
          chat_url = "/v1/chat/completions",
        },
        schema = {
          model = {
            default = "anthropic/claude-3.7-sonnet",
          },
        },
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
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    file = {
      adapter = "ollama",
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
  -- Optional: Configure context collection
  context = {
    -- Enable collecting workspace info for better suggestions
    enable_workspace = true,
    -- Max number of files to include from workspace
    max_workspace_files = 5,
  }
})

