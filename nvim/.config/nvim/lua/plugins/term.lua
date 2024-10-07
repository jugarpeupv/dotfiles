-- return {}
return {
  -- {
  --   "s1n7ax/nvim-terminal",
  --   config = function()
  --     vim.o.hidden = true
  --     require("nvim-terminal").setup({
  --       window = {
  --         -- Do `:h :botright` for more information
  --         -- NOTE: width or height may not be applied in some "pos"
  --         position = "botright",
  --
  --         -- Do `:h split` for more information
  --         split = "sp",
  --
  --         -- Width of the terminal
  --         width = 50,
  --
  --         -- Height of the terminal
  --         height = 15,
  --       },
  --
  --       -- keymap to disable all the default keymaps
  --       disable_default_keymaps = false,
  --
  --       -- keymap to toggle open and close terminal window
  --       toggle_keymap = "<M-o>",
  --
  --       -- increase the window height by when you hit the keymap
  --       window_height_change_amount = 2,
  --
  --       -- increase the window width by when you hit the keymap
  --       window_width_change_amount = 2,
  --
  --       -- keymap to increase the window width
  --       increase_width_keymap = "<leader><leader>+",
  --
  --       -- keymap to decrease the window width
  --       decrease_width_keymap = "<leader><leader>-",
  --
  --       -- keymap to increase the window height
  --       increase_height_keymap = "<leader>+",
  --
  --       -- keymap to decrease the window height
  --       decrease_height_keymap = "<leader>-",
  --
  --       terminals = {
  --         -- keymaps to open nth terminal
  --         { keymap = "<leader><leader>1" },
  --         { keymap = "<leader><leader>2" },
  --         { keymap = "<leader><leader>3" },
  --         { keymap = "<leader><leader>4" },
  --         { keymap = "<leader><leader>5" },
  --       },
  --     })
  --   end,
  -- },
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
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },         -- deletes a terminal buffer
            ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },         -- provides a prompt to rename a terminal
          },
          n = {
            ["<CR>"] = { action = actions.open_term, exit_on_action = true },
            ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = true }, -- creates a new terminal buffer
            ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },         -- deletes a terminal buffer
            ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },         -- provides a prompt to rename a terminal
          },
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    -- cmd = { "ToggleTerm" },
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
        "<leader>tt",
        mode = { "n" },
        "<cmd>ToggleTerm direction=tab<cr>",
      },
      {
        "<leader>tv",
        mode = { "n" },
        "<cmd>ToggleTerm direction=vertical<cr>",
      },
      -- {
      --
      --   "<leader>tn",
      --   mode = { "n", "t" },
      --   function()
      --     go_next_term()
      --   end,
      -- },
      -- {
      --
      --   "<leader>tp",
      --   mode = { "n", "t" },
      --   function()
      --     go_prev_term()
      --   end,
      -- },

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
      direction = "horizontal",
      hide_numbers = true,
      open_mapping = [[<M-o>]],
      start_in_insert = true,
      persist_mode = false,
      persist_size = true,
      autochdir = true,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      local function get_term_index(current_id, terms)
        local idx
        for i, v in ipairs(terms) do
          if v.id == current_id then
            idx = i
          end
        end
        return idx
      end

      local function go_prev_term()
        local current_id = vim.b.toggle_number
        if current_id == nil then
          return
        end

        local terms = require("toggleterm.terminal").get_all(true)
        local prev_index

        local index = get_term_index(current_id, terms)
        if index > 1 then
          prev_index = index - 1
        else
          prev_index = #terms
        end
        require("toggleterm").toggle(terms[index].id)
        require("toggleterm").toggle(terms[prev_index].id)
      end

      local function go_next_term()
        local current_id = vim.b.toggle_number
        if current_id == nil then
          return
        end

        local terms = require("toggleterm.terminal").get_all(true)
        local next_index

        local index = get_term_index(current_id, terms)
        if index == #terms then
          next_index = 1
        else
          next_index = index + 1
        end
        require("toggleterm").toggle(terms[index].id)
        require("toggleterm").toggle(terms[next_index].id)
      end

      vim.keymap.set({ "n", "t" }, "<F11>", function()
        go_next_term()
      end, { desc = "Toggle term" })

      vim.keymap.set({ "n", "t" }, "<F12>", function()
        go_prev_term()
      end, { desc = "Toggle term" })
    end,
  }
  -- {
  --   "boltlessengineer/bufterm.nvim",
  --   opts = {
  --     save_native_terms = true, -- integrate native terminals from `:terminal` command
  --     start_in_insert = true, -- start terminal in insert mode
  --     remember_mode = true,  -- remember vi_mode of terminal buffer
  --     enable_ctrl_w = true,  -- use <C-w> for window navigating in terminal mode (like vim8)
  --     terminal = {           -- default terminal settings
  --       buflisted = true,   -- whether to set 'buflisted' option
  --       termlisted = true,   -- list terminal in termlist (similar to buflisted)
  --       fallback_on_exit = true, -- prevent auto-closing window on terminal exit
  --       auto_close = true,   -- auto close buffer on terminal job ends
  --     },
  --   },
  -- },
}
