----------------------------
-------OPTIONS--------------
----------------------------
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.hlsearch = true
vim.opt.history = 2000
vim.opt.scrolloff = 5
vim.opt.hidden = true
vim.opt.ttimeoutlen = 150
vim.opt.sidescrolloff = 10
vim.opt.sidescroll = 6
vim.opt.startofline = true
vim.opt.linebreak = true
vim.opt.colorcolumn = '80'
--folding with treesitter:
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.foldnestmax = 3
--tabs are 4 spaces
--TODO mischien vervangen met verschillende opties per taal
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- mapping related stuff
vim.g.mapleader = ' '
vim.g.NERDCreateDefaultMappings = 0

vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank {higroup=\"Search\", timeout=500}")
----------------------------
-------LAZY/PLUGINS---------
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
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
                ensure_installed = { "lua", "javascript", "python", "haskell", "c_sharp", "markdown" },
            })
        end
    },
    { "fabi1cazenave/kalahari.vim",      name = 'kalahari' },
    { "pacokwon/onedarkhc.vim",          name = "onedarkhc" },
    { "nyoom-engineering/oxocarbon.nvim" },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function() require("catppuccin").setup({ transparent_background = true }) end
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup {}
        end,
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
    'nvim-tree/nvim-web-devicons',
    {
        'preservim/nerdcommenter',
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
    },
    'nvim-lualine/lualine.nvim',
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        'simrat39/symbols-outline.nvim',
        config = function()
            require("symbols-outline").setup()
        end,
    },
    ----------LSP zero stuff----------------
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    --- Uncomment these if you want to manage LSP servers from neovim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    -- LSP Support
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        }
    },
    --------------------------------------
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                python = { 'flake8', }
            }
            vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    python = { "black" },
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
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap"
        }
    },
    "jay-babu/mason-nvim-dap.nvim",
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
        }
    },
    {
        "Wansmer/treesj"
    },
    {
        "https://github.com/hiphish/rainbow-delimiters.nvim"
    },
    {
        "tpope/vim-fugitive"
    },
    {
        "xiyaowong/telescope-emoji.nvim",
        config = function() require("telescope").load_extension("emoji") end
    }
}
require("lazy").setup(plugins)
----------------------------
-------LSP-ZERO-STUFF-------
----------------------------
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr, preserve_mappings = true })

    local opts = {
        noremap = true, -- non-recursive
        silent = true,  -- do not show message
    }
    -- automatically reselect after indenting
    vim.keymap.set('v', '<', '<gv', opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    --vim.keymap.set('n', '<F3>', vim.lsp.buf.format, opts) --replaced by conform
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end)

lsp.extend_cmp()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.tab_complete(),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
    }
})

require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = { "lua_ls", "pyright", "csharp_ls", "hls" },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
    },
})
----------------------------
-------DAP-STUFF------------
----------------------------
require("dapui").setup()
require("mason-nvim-dap").setup({
    ensure_installed = { 'csharp', 'python' },
    handlers = {
        function(config)
            -- all sources with no handler get passed here
            -- Keep original functionality
            require('mason-nvim-dap').default_setup(config)
        end,
        --python = function (config)
        --config.runInTerminal = true
        --end,
        --coreclr = function (config)
        --config.runInTerminal = true
        --end
    },
})

----------------------------
-------TODO things----------
----------------------------
--DAP ui input in de terminal
--setup voor python pipenv en c sharp
--pyright zo maken dat het suggesties van pipenv kan krijgen
--snippets
--maybe add later stuff:
--easy align maybe
--telescope extensie -> zoek door text
--harpoon
--leet buddy foor leetcode challenges

require('lualine').setup()
----------------------------
-------KEYMAPS--------------
----------------------------
-- leader key defined above under options
-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}
-- automatically reselect after indenting
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('n', '<leader>p', '"+p', opts)
vim.keymap.set('n', '<leader>y', '"+y', opts)
vim.keymap.set('n', 'yp', '"0p', opts)
vim.keymap.set('i', 'jj', '<Esc>', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)

vim.keymap.set('n', '<leader>t', vim.cmd.NvimTreeToggle, opts)
vim.keymap.set('n', '<leader>o', 'o<Esc>', opts)
vim.keymap.set('n', '<leader>O', 'O<Esc>', opts)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, opts)
vim.keymap.set('n', '<leader>g', builtin.git_files, opts)
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, opts)
vim.keymap.set("n", "]t", require("todo-comments").jump_next)
vim.keymap.set("n", "[t", require("todo-comments").jump_prev)
vim.keymap.set({ 'n', 'v' }, '<leader>c', '<plug>NERDCommenterToggle', opts)
vim.keymap.set("n", '<leader>gs', ':SymbolsOutline<CR>', opts)
vim.keymap.set("n", '<leader>ge', ":Telescope emoji<CR>", opts)
vim.keymap.set("n", '<leader>J', require('treesj').toggle, opts)
vim.keymap.set("n", '<F3>', function()
    require("conform").format({ lsp_fallback = true })
    print("helpppp???")
end, opts)

vim.api.nvim_create_user_command('DebugUi',
    function() require("dapui").toggle() end,
    {})


vim.opt.background = "dark" -- set this to dark or light
--vim.cmd.colorscheme("oxocarbon")
vim.cmd.colorscheme("catppuccin-mocha")
--vim.cmd [[colorscheme onedarkhc]]
