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
vim.opt.fixendofline = false
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
-- note automatic downloading/updating broken because of oil.nvim: https://github.com/stevearc/oil.nvim/issues/483
vim.opt.spelllang = 'en,nl'
vim.opt.spell = true
--folding with treesitter:
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.foldtext = 'getline(v:foldstart)'
vim.g.vimtex_fold_enabled = 1
--tabs are 4 spaces
--TODO mischien vervangen met verschillende opties per taal
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- mapping related stuff
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank {higroup=\"Search\", timeout=500}")
----------------------------
-------LAZY/PLUGINS---------
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
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
                    "markdown", "vue", "typescript", "css", "html", "json",
                    "scss", "vimdoc", "nix"
                },
            })
        end
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
                python = { 'flake8' }
            }
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
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
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
                multiline_threshold = 3,
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
    ensure_installed = { "lua_ls", "pyright", "csharp_ls", "ts_ls", "volar",
        "hls", "nil_ls" },
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
        end,
    },
})

local function ensure_installed_mason(names)
    for _, name in ipairs(names) do
        local success, value = pcall(function() return require('mason-registry').get_package(name) end)
        if success then
            value:install()
        end
    end
end

-- lsp's are already automatically installed with lsp zero
ensure_installed_mason({
    -- formatters
    "black",
    "prettier",
    -- linters
    "flake8",
    -- dap
    "debugpy",
    "netcoredbg" })

require('lspconfig').volar.setup({})
local vue_typescript_plugin = require('mason-registry')
    .get_package('vue-language-server')
    :get_install_path()
    .. '/node_modules/@vue/language-server'
    .. '/node_modules/@vue/typescript-plugin'

require('lspconfig').ts_ls.setup({
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

----------------------------
-------DAP-STUFF------------
----------------------------
require("dapui").setup()

local dap = require('dap')

dap.adapters.coreclr = {
    type = 'executable',
    command = require('mason-registry').get_package('netcoredbg'):get_install_path() .. '/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}

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

-- simple rebinds
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)

-- telescope stuff
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, opts)
vim.keymap.set('n', '<leader>p',
    function() builtin.find_files { cwd = vim.fn.stdpath("config") } end,
    opts)
vim.keymap.set('n', '<leader>F',
    function() builtin.find_files { no_ignore = true, no_ignore_parent = true, hidden = true } end,
    opts)
vim.keymap.set('n', '<leader>r', builtin.oldfiles, opts)
vim.keymap.set('n', '<leader>R', builtin.resume, opts)
vim.keymap.set('n', '<leader>g', builtin.live_grep, opts)
vim.keymap.set('n', '<leader>G',
    function()
        builtin.live_grep { vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-uu' } }
    end,
    opts)
vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, opts)
vim.keymap.set('n', '<leader>cg', builtin.lsp_dynamic_workspace_symbols, opts)
vim.keymap.set("n", '<leader>e', ":Telescope emoji<CR>", opts)

-- code stuff, for more see lsp stuff above
vim.keymap.set('n', '<leader>cD', "<cmd>Trouble diagnostics toggle<cr>", opts)
vim.keymap.set('n', '<leader>cd', "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
vim.keymap.set('n', '<leader>ct', "<cmd>Trouble symbols toggle<cr>", opts)
vim.keymap.set('n', '<leader>cr', "<cmd>LspRestart<cr>", opts)

-- plugin stuff
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, opts)
vim.keymap.set("n", "]t", require("todo-comments").jump_next)
vim.keymap.set("n", "[t", require("todo-comments").jump_prev)
vim.keymap.set("n", '<leader>J', require('treesj').toggle, opts)
vim.keymap.set({ "n", "x" }, 'ga', '<Plug>(EasyAlign)', opts)
vim.keymap.set("n", '<F3>', function()
    require("conform").format({ lsp_fallback = true })
end, opts)
local oil = require('oil')
vim.keymap.set("n", '<leader>T', oil.open, opts)
vim.keymap.set("n", '<leader>t', function() oil.open(vim.fn.getcwd()) end, opts)


-- git stuff
local gitsigns = require('gitsigns')
vim.keymap.set("n", '<leader>vf', '<cmd>tab G<cr>', Opts("open fugitive"))
vim.keymap.set("n", '<leader>vF', '<cmd>Flog -auto-update -all<cr>', Opts("open flog"))
vim.keymap.set('n', '<leader>vs', gitsigns.stage_hunk, Opts("stage hunk"))
vim.keymap.set('n', '<leader>vr', gitsigns.reset_hunk, Opts("reset hunk"))
vim.keymap.set('v', '<leader>vs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
    Opts("stage selection"))
vim.keymap.set('v', '<leader>vr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
    Opts("reset selection"))
vim.keymap.set('n', '<leader>vu', gitsigns.undo_stage_hunk, Opts("undo stage hunk"))
vim.keymap.set('n', '<leader>vp', gitsigns.preview_hunk, Opts("preview hunk"))
vim.keymap.set('n', '<leader>vb', function() gitsigns.blame_line { full = true } end, Opts("full blame"))
vim.keymap.set('n', '<leader>vB', gitsigns.toggle_current_line_blame, Opts("toggle inline blame"))
vim.keymap.set('n', '<leader>vd', gitsigns.diffthis, Opts("open git diff"))

-- harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
for i = 1, 9, 1 do
    vim.keymap.set("n", string.format("<leader>%d", i), function() harpoon:list():select(i) end)
end

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "[h", function() harpoon:list():prev() end)
vim.keymap.set("n", "]h", function() harpoon:list():next() end)

vim.api.nvim_create_user_command('DebugUi',
    function() require("dapui").toggle() end,
    {})

-- dap stuff
vim.keymap.set("n", "<F5>", require 'dap'.continue, opts)
vim.keymap.set("n", "<F10>", require 'dap'.step_over, opts)
vim.keymap.set("n", "<F11>", require 'dap'.step_into, opts)
vim.keymap.set("n", "<F12>", require 'dap'.step_out, opts)
vim.keymap.set("n", "<leader>db", require 'dap'.toggle_breakpoint, opts)
vim.keymap.set("n", "<leader>dc", function() require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
    opts)
vim.keymap.set("n", "<leader>dr", require 'dap'.run, opts)
vim.keymap.set("n", "<leader>dl", require 'dap'.run_last, opts)

-- toggle spelling checking
vim.keymap.set("n", "<leader>C", function() vim.opt.spell = not vim.opt.spell:get() end, Opts("toggle spelling checking"))

vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme("kanagawa-wave")
require('evil_lualine')
