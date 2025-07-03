return {
    "ThePrimeagen/vim-be-good",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                -- folding zooi staat bij options
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "lua", "javascript", "python", "haskell", "c_sharp",
                    "markdown", "vue", "typescript", "css", "html", "json",
                    "scss", "vimdoc", "nix", "c", "cpp", "rust"
                },
            })
        end
    },
    --- LSP STUFF ---
    { 'mason-org/mason.nvim' },
    { 'mason-org/mason-lspconfig.nvim' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    -----------------
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function() require("catppuccin").setup({ transparent_background = false }) end
    },
    "rebelot/kanagawa.nvim",
    {
        "bluz71/vim-moonfly-colors",
        lazy = false,
        priority = 1000
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "Shatur/neovim-ayu"
    },
    {
        "shaunsingh/nord.nvim"
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'BurntSushi/ripgrep',
            'sharkdp/fd',
            'nvim-tree/nvim-web-devicons'
        }
    },
    {
        'mbbill/undotree'
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup()
        end,
    },
    {
        "NMAC427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim", 'BurntSushi/ripgrep',
            "folke/trouble.nvim", 'nvim-telescope/telescope.nvim' },
        opts = {
            highlight = { pattern = [[.*<(KEYWORDS)\s*]] },
            search = { pattern = [[\b(KEYWORDS)\b]] }
        }
    },
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble"
    },
    {
        "toppair/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")
            lint.linters_by_ft = {
                python = { 'flake8' },
                typescript = { 'eslint' },
                javascript = { 'eslint' }
            }
            -- Turn eslint errors into warnings
            lint.linters.eslint = require("lint.util").wrap(lint.linters.eslint, function(diagnostic)
                if diagnostic.severity == vim.diagnostic.severity.ERROR then
                    diagnostic.severity = vim.diagnostic.severity.WARN
                end
                return diagnostic
            end)
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    -- Do not run on python files if flake8 is unavailable
                    if vim.fn.executable("flake8") == 1 or vim.bo.filetype ~= "python" then
                        require("lint").try_lint()
                    end
                end,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    python = { "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    vue = { "prettier" },
                    css = { "prettier" },
                    scss = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                },
            })
        end,

    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    'michaeljsmith/vim-indent-object',
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter"
        },
        config = function()
            require 'treesitter-context'.setup {
                multiline_threshold = 4,
            }
        end
    },
    {
        "Wansmer/treesj"
    },
    {
        "https://github.com/hiphish/rainbow-delimiters.nvim",
        config = function()
            vim.g.rainbow_delimiters = {
                highlight = {
                    "Number",
                    "Keyword",
                    "String",
                    "Tag",
                    "Error"
                },
            }
        end,
    },
    {
        "tpope/vim-fugitive",
        dependencies = {
            -- not really dependencies but add github/gitlab support
            "tpope/vim-rhubarb",
            "shumphrey/fugitive-gitlab.vim"
        }
    },
    {
        "xiyaowong/telescope-emoji.nvim",
        config = function() require("telescope").load_extension("emoji") end
    },
    {
        "junegunn/vim-easy-align"
    },
    {
        "rbong/vim-flog",
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {
            "tpope/vim-fugitive",
        },
    },
    {
        'stevearc/oil.nvim',
        opts = {
            --clean up buffers after a minute, so they stay in the jumplist
            cleanup_delay_ms = 60 * 1000,
            win_options = {
                wrap = true
            }
        },
        config = function()
            require("oil").setup({ keymaps = { ["<BS>"] = "actions.parent" } })
        end,
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
    },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                themes = vim.fn.getcompletion('', 'color'),
                livePreview = true,
            })
        end
    }
}
