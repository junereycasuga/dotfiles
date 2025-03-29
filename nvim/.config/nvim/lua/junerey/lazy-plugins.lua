return {
    -- Git integration
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },

    -- Editor enhancements
    { "tpope/vim-sleuth" },
    { "nvim-lua/plenary.nvim" },

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
                    vimgrep_arguments = vimgrep_arguments
                },
                pikcers = {
                    find_files = {
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
                    }
                }
            })

            local keymap = vim.keymap
            keymap.set("n", "<leader>ff", builtin.find_files, {})
            keymap.set("n", "<leader>fg", builtin.live_grep, {})
            keymap.set("n", "<C-p>", builtin.git_files, {})
            keymap.set("n", "<leader>vh", builtin.help_tags, {})
        end
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
    { "catppuccin/nvim",                name = "catppuccin" },

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
}
