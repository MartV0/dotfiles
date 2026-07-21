--------------------------
------LSP STUFF-----------
--------------------------

-- Reserve a space in the gutter, this will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        function Opts(desc)
            local opts2 = {
                noremap = true,
                buffer = event.buf
            }
            opts2["desc"] = desc
            return opts2
        end
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, Opts("Show hover info"))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, Opts("Goto definition"))
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, Opts("Goto declaration"))
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, Opts("Goto implementation"))
        vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, Opts("Goto type definition"))
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, Opts("Goto references"))
        vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, Opts("Show detailed info"))
        vim.keymap.set('n', 'gl', vim.diagnostic.open_float, Opts("floating diagnostics window"))
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, Opts("Rename lsp symbol"))
        -- vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', Opts("")) -- set by conform
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, Opts("Show code actions"))
        -- ]d and [d are now default in nvim
    end,
})

local language_servers = { "lua_ls", "pyright", "csharp_ls", "ts_ls", "vuels", "hls", "nil_ls", "gopls", "java_language_server", "rust_analyzer" };

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists("/etc/NIXOS") then
    for _, server in ipairs(language_servers) do
        vim.lsp.enable(server)
    end
else
    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = language_servers,
    })

    local function ensure_installed_mason(names)
        for _, name in ipairs(names) do
            local success, value = pcall(function() return require('mason-registry').get_package(name) end)
            if success then
                value:install()
            end
        end
    end

    -- lsp's are already automatically installed by mason lspconfig
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
