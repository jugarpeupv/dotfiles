-- return {}

return {
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    keys = {
      {
        "<leader>to",
        mode = { "n" },
        "<cmd>Telescope toggleterm_manager<CR>",
      },
    },
    -- config = true,
    config = function()
      local toggleterm_manager = require("toggleterm-manager")
      local actions = toggleterm_manager.actions

      toggleterm_manager.setup({
        results = {
          fields = { "state", { "term_icon", "Type" }, "term_name", "space", "bufname" },
        },
        mappings = {
          i = {
            ["<CR>"] = { action = actions.open_term, exit_on_action = true },
            ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = true }, -- creates a new terminal buffer
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },   -- deletes a terminal buffer
            ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },   -- provides a prompt to rename a terminal
          },
          n = {
            ["<CR>"] = { action = actions.open_term, exit_on_action = true },
            ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = true }, -- creates a new terminal buffer
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },   -- deletes a terminal buffer
            ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },   -- provides a prompt to rename a terminal
          },
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    keys = {
      {
        "<M-o>",
        mode = { "n", "t" },
        "<cmd>ToggleTerm<CR>",
      },
      {
        "<M-o>",
        mode = { "t" },
        "<C-\\><C-n><cmd>ToggleTerm<CR>",
      },
      {
        "<leader>th",
        mode = { "n" },
        "<cmd>ToggleTerm direction=horizontal<cr>",
      },
      {
        "<leader>tn",
        mode = { "n" },
        "<cmd>ToggleTerm direction=tab<cr>",
      },
      {
        "<leader>tv",
        mode = { "n" },
        "<cmd>ToggleTerm direction=vertical<cr>",
      },

      -- normal terms
      {
        "<leader>Tv",
        mode = { "n" },
        "<cmd>vsp|term<cr>",
      },
      {
        "<leader>Th",
        mode = { "n" },
        "<cmd>sp|term<cr>",
      },
      {
        "<leader>Tn",
        mode = { "n" },
        "<cmd>tabnew|term<cr>",
      },
    },

    version = "*",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      direction = "tab",
      hide_numbers = false,
      open_mapping = [[<M-o>]],
      start_in_insert = true,
      persist_mode = false,
      persist_size = false,
      autochdir = true,
    },
  },
}
