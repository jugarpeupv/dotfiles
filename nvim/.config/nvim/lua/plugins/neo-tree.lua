return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "\\", ":Neotree current<CR>" },
      { "<leader>nb", ":Neotree buffers<CR>" },
      { "<leader>ng", ":Neotree git_status<CR>" },
      { "<leader>nt", ":Neotree filesystem position=current<CR>" },
    },
    opts = {
      default_component_configs = {
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = true,
        },
      },
    },
    config = function()
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      -- vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
      -- vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
      -- vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
      -- vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

      -- vim.diagnostic.config({
      -- 	signs = {
      -- 		{ name = "DiagnosticSignError", text = " " },
      -- 		{ name = "DiagnosticSignWarn", text = " " },
      -- 		{ name = "DiagnosticSignInfo", text = " " },
      -- 		{ name = "DiagnosticSignHint", text = "󰌵" },
      -- 	},
      -- })

      require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        default_component_configs = {
          -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
          file_size = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          type = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          last_modified = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          created = {
            enabled = true,
            required_width = 64, -- min width of window required to show this column
          },
          symlink_target = {
            enabled = true,
          },
        },
      })
    end,
  },
}

