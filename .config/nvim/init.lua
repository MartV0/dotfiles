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
vim.opt.foldtext = 'getline(v:foldstart)'
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
                ensure_installed = {
                    "lua", "javascript", "python", "haskell", "c_sharp",
                    "markdown", "vue", "typescript", "css", "html", "json"
                },
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
        "shaunsingh/nord.nvim"
    },
    {
        "folke/tokyonight.nvim"
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
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup()
            require('evil_lualine')
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
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
        'stevearc/aerial.nvim', --TODO vervang met trouble wanneer v3 uit is
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require("aerial").setup({
                -- optionally use on_attach to set keymaps when aerial has attached to a buffer
                on_attach = function(bufnr)
                    -- Jump forwards/backwards with '{' and '}'
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
                end,
            })
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
            local conform = require("conform")
            conform.setup({
                formatters_by_ft = {
                    python = { "black" },
                },
            })
            conform.formatters.shfmt = {
                prepend_args = { "--line-length", "80" },
            }
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
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
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

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, Opts("lsp floating info"))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, Opts("go to definition"))
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, Opts("go to declaration"))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, Opts("list all the implementations"))
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, Opts("go to type_definition"))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, Opts("list all references"))
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, Opts("display signature information"))
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, Opts("floating diagnostics window"))
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, Opts("rename symbol"))
    --vim.keymap.set('n', '<F3>', vim.lsp.buf.format, opts) --replaced by conform
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, Opts("code actions"))
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, Opts("go to next diagnostic"))
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, Opts("go to previous diagnostic"))
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
    ensure_installed = { "lua_ls", "pyright", "csharp_ls", "tsserver", "volar" },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
    },
})

require('lspconfig').volar.setup({})
local vue_typescript_plugin = require('mason-registry')
    .get_package('vue-language-server')
    :get_install_path()
    .. '/node_modules/@vue/language-server'
    .. '/node_modules/@vue/typescript-plugin'

require('lspconfig').tsserver.setup({
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_typescript_plugin,
                languages = { 'javascript', 'typescript', 'vue' }
            },
        }
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
    },
})

-- using mason:
-- - black
-- - csharp-language-server
-- - debugpy
-- - flake8
-- - mypy
-- - prettier
-- - pyright
-- - rust-anylyzer
-- - typescript-language-server
-- - vue-language-server

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
--Automatische mason installs
--voor telescope grep en file search ook een versie die gitignore skipt
--keybindings om config te openen
--tree sitter volgensmij  native tegenwoording?
--lazy initialisatie misschien veranderd?
--lsp zero updaten naar v4 of misschien manual installatie, lsp keybinds zijn nu ook dubbel
--make fugitive open fullscreen instead of split
--nvim context ignore comments
--plugin voor inline git diff
--nvim context andere achtergrond kleur

----------------------------
-------KEYMAPS--------------
----------------------------
-- leader key defined above under options
-- define common options
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

function Opts(desc)
    -- function that creates default keybindings with description
    local opts2 = {
        noremap = true, -- non-recursive
        silent = true,  -- do not show message
    }
    opts2["desc"] = desc
    return opts2
end

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
vim.keymap.set('n', '<leader>r', builtin.oldfiles, opts)
vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>sg', builtin.lsp_dynamic_workspace_symbols, opts)
vim.keymap.set('n', '<leader>p', builtin.git_files, opts)
vim.keymap.set('n', '<leader>g', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, opts)
vim.keymap.set("n", "]t", require("todo-comments").jump_next)
vim.keymap.set("n", "[t", require("todo-comments").jump_prev)
vim.keymap.set({ 'n', 'v' }, '<leader>c', '<plug>NERDCommenterToggle', opts)
vim.keymap.set("n", '<leader>e', ":Telescope emoji<CR>", opts)
vim.keymap.set("n", "<leader>so", "<cmd>AerialToggle!<CR>")
vim.keymap.set("n", '<leader>J', require('treesj').toggle, opts)
vim.keymap.set({ "n", "x" }, 'ga', '<Plug>(EasyAlign)', opts)
vim.keymap.set("n", '<F3>', function()
    require("conform").format({ lsp_fallback = true })
end, opts)

vim.api.nvim_create_user_command('DebugUi',
    function() require("dapui").toggle() end,
    {})


vim.opt.background = "dark" -- set this to dark or light
--vim.cmd.colorscheme("oxocarbon")
vim.cmd.colorscheme("catppuccin-mocha")
--vim.cmd [[colorscheme onedarkhc]]
--vim.cmd [[colorscheme nord]]
--vim.cmd [[colorscheme tokyonight-night]]
