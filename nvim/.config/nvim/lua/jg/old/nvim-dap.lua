return {}
-- return {
--   {
--     "stevearc/overseer.nvim",
--     opts = {},
--     dependencies = { "mfussenegger/nvim-dap" },
--     event = "VeryLazy",
--     config = function()
--       require("overseer").setup()
--     end,
--   },
--   {
--     "mfussenegger/nvim-dap",
--     event = "VeryLazy",
--     config = function()
--       local dap_status, dap = pcall(require, "dap")
--       if not dap_status then
--         return
--       end

--       local dapui = require("dapui")

--       -- local mason_status, mason_nvim_dap = pcall(require, "mason-nvim-dap")
--       -- if not mason_status then
--       --   return
--       -- end

--       -- mason_nvim_dap.setup()

--       -- node-debug2
--       dap.adapters.node2 = function(cb, config)
--         if config.preLaunchTask then
--           vim.fn.system(config.preLaunchTask)
--         end
--         local adapter = {
--           type = "executable",
--           command = "node",
--           args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
--         }
--         cb(adapter)
--       end

--       dap.configurations.javascript = {
--         {
--           name = "[node-debug2] [javascript]: Launch",
--           type = "node2",
--           request = "launch",
--           program = "${file}",
--           cwd = vim.fn.getcwd(),
--           sourceMaps = true,
--           protocol = "inspector",
--           console = "integratedTerminal",
--         },
--         {
--           -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--           name = "[node-debug2] [javascript]: Attach to process",

--           type = "node2",
--           request = "attach",
--           processId = require("dap.utils").pick_process,
--         },
--       }

--       dap.configurations.typescript = {
--         {
--           name = "[node-debug2] [typescript]: Launch",
--           type = "node2",
--           request = "launch",
--           program = "${file}",
--           cwd = vim.fn.getcwd(),
--           sourceMaps = true,
--           protocol = "inspector",
--           console = "integratedTerminal",
--         },
--         {
--           -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--           name = "[node-debug2] [typescript]: Attach to process",
--           type = "node2",
--           request = "attach",
--           processId = require("dap.utils").pick_process,
--         },
--       }

--       -- pwa-node
--       require("dap").adapters["pwa-node"] = {
--         type = "server",
--         host = "localhost",
--         port = "${port}",
--         executable = {
--           command = "node",
--           args = {
--             os.getenv("HOME") .. "/.local/share/nvim/lazy/vscode-js-debug/out/src/vsDebugServer.js",
--             "${port}",
--           },
--         },
--       }

--       dap.configurations.javascript = {
--         {
--           type = "pwa-node",
--           request = "launch",
--           name = "[pwa-node] [javascript] Launch file",
--           program = "${file}",
--           cwd = "${workspaceFolder}",
--         },
--       }

--       dap.configurations.typescript = {
--         {
--           type = "pwa-node",
--           request = "launch",
--           name = "[pwa-node] [typescript] Launch file",
--           program = "${file}",
--           cwd = "${workspaceFolder}",
--         },
--       }

--       dap.adapters.node = function(cb, config)
--         if config.preLaunchTask then
--           vim.fn.system(config.preLaunchTask)
--         end
--         local adapter = {
--           type = "executable",
--           command = "node",
--           args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
--         }
--         cb(adapter)
--       end

--       dap.configurations.javascript = {
--         {
--           name = "[node] [javascript]: Launch",
--           type = "node",
--           request = "launch",
--           program = "${file}",
--           cwd = vim.fn.getcwd(),
--           sourceMaps = true,
--           protocol = "inspector",
--           console = "integratedTerminal",
--         },
--         {
--           -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--           name = "[node] [javascript]: Attach to process",

--           type = "node",
--           request = "attach",
--           processId = require("dap.utils").pick_process,
--         },
--       }

--       dap.configurations.typescript = {
--         {
--           name = "[node] [typescript]: Launch",
--           type = "node",
--           request = "launch",
--           program = "${file}",
--           cwd = vim.fn.getcwd(),
--           sourceMaps = true,
--           protocol = "inspector",
--           console = "integratedTerminal",
--         },
--         {
--           -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--           name = "[node] [typescript]: Attach to process",
--           type = "node",
--           request = "attach",
--           processId = require("dap.utils").pick_process,
--         },
--       }

--       -- require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { ['node'] = { 'typescript' } })

--       -- require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { ['pwa-node'] = { 'typescript' } })
--       require("dap.ext.vscode").json_decode = require("overseer.json").decode
--       -- require("overseer").patch_dap(true)

--       -- require('dapui').setup()

--       dap.listeners.after.event_initialized["dapui_config"] = function()
--         dapui.open()
--       end
--       dap.listeners.before.event_terminated["dapui_config"] = function()
--         dapui.close()
--       end
--       dap.listeners.before.event_exited["dapui_config"] = function()
--         dapui.close()
--       end

--       dap.defaults.fallback.terminal_win_cmd = "vsplit new"
--       -- vim.fn.sign_define("DapBreakpoint", { text = "✋", texthl = "", linehl = "", numhl = "" })

--       vim.api.nvim_set_hl(0, "DapBreakpoint2", { ctermbg = 0, fg = "#F38BA8", bg = "none" })
--       vim.api.nvim_set_hl(0, "DapStopped2", { ctermbg = 0, fg = "#8ee2cf", bg = "none" })

--       vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint2", linehl = "", numhl = "" })
--       -- vim.fn.sign_define('DapBreakpointRejected', { text = '🔵', texthl = '', linehl = '', numhl = '' })
--       vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped2", linehl = "DiffAdd", numhl = "" })

--       -- local dap = require('dap')
--       -- local api = vim.api
--       -- local keymap_restore = {}
--       -- dap.listeners.after['event_initialized']['me'] = function()
--       --   for _, buf in pairs(api.nvim_list_bufs()) do
--       --     local keymaps = api.nvim_buf_get_keymap(buf, 'n')
--       --     for _, keymap in pairs(keymaps) do
--       --       if keymap.lhs == "K" then
--       --         table.insert(keymap_restore, keymap)
--       --         api.nvim_buf_del_keymap(buf, 'n', 'K')
--       --       end
--       --     end
--       --   end
--       --   api.nvim_set_keymap(
--       --     'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
--       -- end

--       -- dap.listeners.after['event_terminated']['me'] = function()
--       --   for _, keymap in pairs(keymap_restore) do
--       --     api.nvim_buf_set_keymap(
--       --       keymap.buffer,
--       --       keymap.mode,
--       --       keymap.lhs,
--       --       keymap.rhs,
--       --       { silent = keymap.silent == 1 }
--       --     )
--       --   end
--       --   keymap_restore = {}
--       -- end
--     end,
--   },
-- }
