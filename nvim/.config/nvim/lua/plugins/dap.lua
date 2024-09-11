return {
  {
    "Weissle/persistent-breakpoints.nvim",
    event = { "BufReadPre", "BufNewFile" },
    -- event = "VeryLazy",
    config = function()
      require("persistent-breakpoints").setup({
        save_dir = vim.fn.stdpath("data") .. "/nvim_checkpoints",
        -- when to load the breakpoints? "BufReadPost" is recommanded.
        load_breakpoints_event = { "BufReadPost" },
        -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
        perf_record = false,
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    -- event = "VeryLazy",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = function()
          require("nvim-dap-repl-highlights").setup()
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
          require("dapui").setup()
        end,
      },
      {
        "stevearc/overseer.nvim",
        opts = {},
        dependencies = { "mfussenegger/nvim-dap" },
        event = { "BufReadPre", "BufNewFile" },
        -- event = "VeryLazy",
        config = function()
          require("overseer").setup()
        end,
      },
      -- {
      --   "theHamsta/nvim-dap-virtual-text",
      --   config = function()
      --     require("nvim-dap-virtual-text").setup()
      --   end,
      -- },
      { "jbyuki/one-small-step-for-vimkind" },
    },
    config = function()
      local dap_status, dap = pcall(require, "dap")
      if not dap_status then
        return
      end

      local dapui = require("dapui")

      -- local mason_status, mason_nvim_dap = pcall(require, "mason-nvim-dap")
      -- if not mason_status then
      --   return
      -- end

      -- mason_nvim_dap.setup()

      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = {
          os.getenv("HOME")
          .. "/.local/share/nvim/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
        },
      }

      -- pwa-node
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          -- command = vim.fn.exepath("js-debug-adapter"),
          command = "node",
          args = {
            os.getenv("HOME")
            .. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      dap.adapters.node = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
      }

      for _, language in ipairs({ "typescript", "javascript" }) do
        dap.configurations[language] = {
          {
            name = "[node] Launch",
            type = "node",
            request = "launch",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            -- For this to work you need to make sure the node process is started with the `--inspect` flag.
            name = "[node] Attach to process",
            type = "node",
            request = "attach",
            processId = require("dap.utils").pick_process,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "[pwa-node] Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "[pwa-node] Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "[pwa-node] Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          -- Debug web applications (client side)
          {
            type = "chrome",
            request = "launch",
            name = "[chrome] Launch Chrome",
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({
                  prompt = "Enter URL: ",
                  default = "http://localhost:9222",
                }, function(url)
                  if url == nil or url == "" then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            userDataDir = false,
          },
          {
            type = "chrome",
            request = "attach",
            program = "${file}",
            name = "[chrome] Attach to Chrome",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}",
          },
        }
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }

      dap.adapters.nlua = function(callback, config)
        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
      end

      -- require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { ['node'] = { 'typescript' } })

      -- require('dap.ext.vscode').load_launchjs('.vscode/launch.json', { ['pwa-node'] = { 'typescript' } })
      require("dap.ext.vscode").json_decode = require("overseer.json").decode
      -- require("overseer").patch_dap(true)

      -- require('dapui').setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end

      -- dap.defaults.fallback.terminal_win_cmd = "vsplit new"
      -- vim.fn.sign_define("DapBreakpoint", { text = "✋", texthl = "", linehl = "", numhl = "" })
      -- vim.fn.sign_define('DapBreakpointRejected', { text = '🔵', texthl = '', linehl = '', numhl = '' })

      vim.api.nvim_set_hl(0, "DapBreakpoint2", { ctermbg = 0, fg = "#F38BA8", bg = "none" })
      vim.api.nvim_set_hl(0, "DapStopped2", { ctermbg = 0, fg = "#8ee2cf", bg = "none" })
      vim.api.nvim_set_hl(0, "DapStopped3", { ctermbg = 0, fg = "none", bg = "#3f4104" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint2", linehl = "", numhl = "" })

      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped2", linehl = "DiffAdd", numhl = "" })

      -- local dap = require('dap')
      -- local api = vim.api
      -- local keymap_restore = {}
      -- dap.listeners.after['event_initialized']['me'] = function()
      --   for _, buf in pairs(api.nvim_list_bufs()) do
      --     local keymaps = api.nvim_buf_get_keymap(buf, 'n')
      --     for _, keymap in pairs(keymaps) do
      --       if keymap.lhs == "K" then
      --         table.insert(keymap_restore, keymap)
      --         api.nvim_buf_del_keymap(buf, 'n', 'K')
      --       end
      --     end
      --   end
      --   api.nvim_set_keymap(
      --     'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
      -- end

      -- dap.listeners.after['event_terminated']['me'] = function()
      --   for _, keymap in pairs(keymap_restore) do
      --     api.nvim_buf_set_keymap(
      --       keymap.buffer,
      --       keymap.mode,
      --       keymap.lhs,
      --       keymap.rhs,
      --       { silent = keymap.silent == 1 }
      --     )
      --   end
      --   keymap_restore = {}
      -- end
    end,
  },
}
