----------------------------
-------DAP-STUFF------------
----------------------------
require("dapui").setup()

-- local dap = require('dap')
--
-- dap.adapters.coreclr = {
--     type = 'executable',
--     command = require('mason-registry').get_package('netcoredbg'):get_install_path() .. '/netcoredbg',
--     args = { '--interpreter=vscode' }
-- }
--
-- dap.configurations.cs = {
--     {
--         type = "coreclr",
--         name = "launch - netcoredbg",
--         request = "launch",
--         program = function()
--             return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
--         end,
--     },
-- }
