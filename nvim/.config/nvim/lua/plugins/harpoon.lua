return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    commit = "e76cb03",
    -- event = "VeryLazy",
    keys = {
      -- { "<leader>A", function() require("harpoon"):list():append() end, desc = "harpoon file", },
      {
        "<leader>aa",
        function()
          require("harpoon"):list():add()
        end,
        desc = "harpoon file",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "harpoon file list toggle",
      },
      { "<leader>ha", "<cmd>Telescope harpoon marks<cr>", desc = "harpoon quick menu" },
      -- { "<leader>a", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "harpoon quick menu", },
      {
        "<leader>1",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "harpoon to file 1",
      },
      {
        "<leader>2",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "harpoon to file 2",
      },
      {
        "<leader>3",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "harpoon to file 3",
      },
      {
        "<leader>4",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "harpoon to file 4",
      },
      {
        "<leader>5",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "harpoon to file 5",
      },
    },
    config = function()
      local harpoon = require("harpoon")

      harpoon.setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
          key = function()
            local parent_path = vim.loop.cwd() .. "/../"
            local exists_bare_dir = vim.fn.isdirectory(parent_path .. ".bare")
            local parent_dir = vim.fn.fnamemodify(vim.fn.getcwd() .. "/..", ":p")
            if exists_bare_dir ~= 0 then
              return parent_dir
            end
            return vim.loop.cwd()
          end,
        },
        menu = {
          width = vim.api.nvim_win_get_width(0) - 48,
        },
      })

      -- harpoon:extend(require("harpoon.extensions").builtins.command_on_nav('UfoEnableFold'))

      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })
      -- Harpoon
      -- keymap("n", "<Leader>ha", "<cmd>Telescope harpoon marks<cr>", opts)
      -- keymap("n", "<Leader>aa", "<cmd>lua require('harpoon.mark').add_file()<cr>", opts)
      -- keymap("n", "<Leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
      -- keymap("n", "<Leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", opts)
      -- keymap("n", "<Leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", opts)
      -- keymap("n", "<Leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", opts)
      -- keymap("n", "<Leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", opts)
      -- keymap("n", "<Leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", opts)
      -- keymap("n", "<Leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", opts)
      -- keymap("n", "<Leader>7", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", opts)
      -- keymap("n", "<Leader>8", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", opts)
      -- keymap("n", "<Leader>9", "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", opts)

      -- vim.keymap.set("n", "<leader>aa", function()
      --   harpoon:list():add()
      -- end)

      -- vim.keymap.set("n", "<Leader>ha", "<cmd>Telescope harpoon marks<cr>")
      -- vim.keymap.set("n", "<leader>hh", function()
      --   harpoon.ui:toggle_quick_menu(harpoon:list())
      -- end)

      -- vim.keymap.set("n", "<Leader>1", function()
      --   harpoon:list():select(1)
      -- end)
      -- vim.keymap.set("n", "<Leader>2", function()
      --   harpoon:list():select(2)
      -- end)
      -- vim.keymap.set("n", "<Leader>3", function()
      --   harpoon:list():select(3)
      -- end)
      -- vim.keymap.set("n", "<Leader>4", function()
      --   harpoon:list():select(4)
      -- end)
      -- vim.keymap.set("n", "<Leader>5", function()
      --   harpoon:list():select(5)
      -- end)
      -- vim.keymap.set("n", "<Leader>6", function()
      --   harpoon:list():select(6)
      -- end)

      -- Toggle previous & next buffers stored within Harpoon list
      -- vim.keymap.set("n", "<C-k>", function() harpoon:list():prev() end)
      -- vim.keymap.set("n", "<C-j>", function() harpoon:list():next() end)
    end,
  },
}
