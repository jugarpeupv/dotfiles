-- return {}

return {
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
    },
    version = "*",
    opts = { hide_numbers = false, open_mapping = [[<M-o>]], start_in_insert = true, persist_mode = false },
  },
  -- {
  --   "numToStr/FTerm.nvim",
  --   cmd = { "FTerm" },
  --   keys = {
  --     {
  --       "<leader>bb",
  --       mode = { "n", "t" },
  --       function()
  --         require("FTerm").toggle()
  --       end,
  --     },
  --     {
  --       "<leader>bb",
  --       mode = { "t" },
  --       '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>',
  --     },
  --   },
  --   opts = {
  --     -- border = "none",
  --     dimensions = {
  --       height = 0.35, -- Height of the terminal window
  --       width = 0.98, -- Width of the terminal window
  --       x = 0.3,   -- X axis of the terminal window
  --       y = 1,     -- Y axis of the terminal window
  --     },
  --   },
  -- },
  -- Lazy
  -- {
  --   '2kabhishek/termim.nvim',
  --   cmd = { 'Fterm', 'FTerm', 'Sterm', 'STerm', 'Vterm', 'VTerm' },
  -- },
  -- {
  --   "boltlessengineer/bufterm.nvim",
  --   -- event = { "BufReadPost", "BufNewFile" },
  --   -- event = { "VeryLazy" },
  --   keys = {
  --     {
  --       "<leader>bb",
  --       mode = { "n", "t" },
  --       function()
  --         vim.cmd("BufTermEnter")
  --       end,
  --     },
  --     {
  --       "<leader>bp",
  --       mode = { "n", "t" },
  --       function()
  --         vim.cmd("BufTermPrev")
  --       end,
  --     },
  --     {
  --       "<leader>bn",
  --       mode = { "n", "t" },
  --       function()
  --         vim.cmd("BufTermNext")
  --       end,
  --     },
  --   },
  --   -- vim.keymap.set("n", "<leader>bb", vim.cmd.BufTermEnter)
  --   -- vim.keymap.set("n", "<leader>bn", vim.cmd.BufTermNext)
  --   config = function()
  --     require("bufterm").setup({
  --       save_native_terms = true, -- integrate native terminals from `:terminal` command
  --       start_in_insert = true, -- start terminal in insert mode
  --       remember_mode = true,  -- remember vi_mode of terminal buffer
  --       enable_ctrl_w = true,  -- use <C-w> for window navigating in terminal mode (like vim8)
  --       terminal = {           -- default terminal settings
  --         buflisted = true,    -- whether to set 'buflisted' option
  --         termlisted = true,   -- list terminal in termlist (similar to buflisted)
  --         fallback_on_exit = true, -- prevent auto-closing window on terminal exit
  --         auto_close = true,   -- auto close buffer on terminal job ends
  --       },
  --     })
  --     local term = require("bufterm.terminal")
  --     local ui = require("bufterm.ui")
  --
  --     vim.keymap.set({ "n", "t" }, "<C-t>", function()
  --       local recent_term = term.get_recent_term()
  --       ui.toggle_float(recent_term.bufnr)
  --     end, {
  --       desc = "Toggle floating window with terminal buffers",
  --     })
  --   end,
  -- },
  -- { "akinsho/toggleterm.nvim", version = '*' },
}
