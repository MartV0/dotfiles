--------------------------
------LSP STUFF-----------
--------------------------

-- Reserve a space in the gutter, this will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, Opts("floating diagnostics window"))
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        -- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts) -- set by conform
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, Opts("go to next diagnostic"))
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, Opts("go to previous diagnostic"))
    end,
})

local lspconfig_defaults = require('lspconfig').util.default_config

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

local language_servers = { "lua_ls", "pyright", "csharp_ls", "ts_ls", "vuels", "hls", "nil_ls" };

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists("/etc/NIXOS") then
    for _, server in ipairs(language_servers) do
        require('lspconfig')[server].setup({})
    end
else
    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = language_servers,
        handlers = {
            -- lua_ls = function()
            --     -- (Optional) Configure lua language server for neovim
            --     require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
            -- end,
            function(server_name)
                require('lspconfig')[server_name].setup({})
            end,
        }
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
end


local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        -- Super tab
        ['<Tab>'] = cmp.mapping(function(fallback)
            local col = vim.fn.col('.') - 1

            if cmp.visible() then
                cmp.select_next_item({ behavior = 'select' })
            elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
            else
                cmp.complete()
            end
        end, { 'i', 's' }),

        -- Super shift tab
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = 'select' })
            else
                fallback()
            end
        end, { 'i', 's' }),
    }
})

-- local vue_typescript_plugin = require('mason-registry')
--     .get_package('vue-language-server')
--     :get_install_path()
--     .. '/node_modules/@vue/language-server'
--     .. '/node_modules/@vue/typescript-plugin'
--
-- require('lspconfig').ts_ls.setup({
--     init_options = {
--         plugins = {
--             {
--                 name = "@vue/typescript-plugin",
--                 location = vue_typescript_plugin,
--                 languages = { 'javascript', 'typescript', 'vue' }
--             },
--         }
--     },
--     filetypes = {
--         'javascript',
--         'javascriptreact',
--         'javascript.jsx',
--         'typescript',
--         'typescriptreact',
--         'typescript.tsx',
--         'vue',
--     },
-- })
