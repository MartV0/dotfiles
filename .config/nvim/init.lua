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
-- folding with treesitter:
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

-- install plugins using lazy
local plugins = require("plugins")
require("lazy").setup(plugins)

-- setup lsp
require("lsp-setup")

-- setup dap
require("dap-setup")

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

require('evil_lualine')
