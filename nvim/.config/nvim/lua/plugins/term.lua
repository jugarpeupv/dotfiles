-- return {}
return {
  {
    "rebelot/terminal.nvim",
    keys = {
      {
        "<D-l>",
        mode = { "n", "t" },
        function()
          -- require'terminal'.run("", { layout = { open_cmd = "float", border = "single" } })
          local get_terminal_bufs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.fn.getbufvar(bufnr, "&buftype") == "terminal" and vim.fn.getbufvar(bufnr, "&ft") == ""
            end, vim.api.nvim_list_bufs())
          end

          local terminals = get_terminal_bufs()

          local there_are_no_terminal_buffers = next(terminals) == nil

          if there_are_no_terminal_buffers then
            vim.cmd("15sp|term")
            return
          else -- there are terminal buffers
            local term_map = require("terminal.mappings")
            term_map.toggle()
          end
        end,
      },
      {
        "<M-l>",
        mode = { "n", "t" },
        function()
          -- require'terminal'.run("", { layout = { open_cmd = "float", border = "single" } })
          local get_terminal_bufs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.fn.getbufvar(bufnr, "&buftype") == "terminal" and vim.fn.getbufvar(bufnr, "&ft") == ""
            end, vim.api.nvim_list_bufs())
          end

          local terminals = get_terminal_bufs()

          local there_are_no_terminal_buffers = next(terminals) == nil

          if there_are_no_terminal_buffers then
            vim.cmd("15sp|term")
            return
          else -- there are terminal buffers
            local term_map = require("terminal.mappings")
            term_map.toggle()
          end
        end,
      },
      {
        "<leader>ti",
        function ()
          local term = require"terminal"
          local index = term.current_term_index()
          term.set_target(index)
        end
      },
      {
        "<leader>tl",
        mode = { "n" },
        "<cmd>vsp|term<cr>",
      },
      {
        "<leader>th",
        mode = { "n" },
        "<cmd>15sp|term<cr>",
      },
      {
        "<leader>tT",
        mode = { "n" },
        "<cmd>tabnew|term<cr>",
      },
      {
        "<leader>tj",
        mode = { "n" },
        function()
          local term_map = require("terminal.mappings")
          term_map.cycle_next()
        end,
      },
      {
        "<leader>tk",
        mode = { "n" },
        function()
          local term_map = require("terminal.mappings")
          term_map.cycle_prev()
        end,
      },
      {
        "<leader>tF",
        mode = { "n" },
        function()
          local term_map = require("terminal.mappings")
          term_map.move({ open_cmd = "float" })
        end,
      },
    },
    config = function()
      require("terminal").setup({
        layout = {
          open_cmd = "botright 15 new",
          border = "rounded",
        },
      })

      local term_map = require("terminal.mappings")
      -- vim.keymap.set({ "n", "x" }, "<leader>ts", term_map.operator_send, { expr = true })
      -- vim.keymap.set("n", "<leader>tr", term_map.run)
      -- vim.keymap.set("n", "<leader>tR", term_map.run(nil, { layout = { open_cmd = "enew" } }))
      vim.keymap.set("n", "<leader>tx", term_map.kill)
      vim.keymap.set("n", "<leader>tj", term_map.cycle_next)
      vim.keymap.set("n", "<leader>tk", term_map.cycle_prev)
      -- vim.keymap.set("n", "<leader>tl", term_map.move({ open_cmd = "belowright vnew" }))
      -- vim.keymap.set("n", "<leader>tL", term_map.move({ open_cmd = "botright vnew" }))
      -- vim.keymap.set("n", "<leader>th", term_map.move({ open_cmd = "belowright new" }))
      -- vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }))
      -- vim.keymap.set("n", "<leader>tf", term_map.move({ open_cmd = "float", border = "rounded" }))
    end,
  },

  -- {
  --   "s1n7ax/nvim-terminal",
  --   keys = {
  --     { "<M-o>",  mode = { "n" },     ':lua NTGlobal["terminal"]:toggle()<cr>', silent = true },
  --     { "<M-o>",  mode = { "t" },     '<C-\\><C-n>:lua NTGlobal["terminal"]:toggle()<cr>', silent = true },
  --     { "<M-r>", mode = { "n" }, "<C-\\><C-n>:keepalt file term://", silent = true },
  --     { "<M-r>", mode = { "n" }, ":keepalt file term://",            silent = true },
  --     -- { "1<M-o>", mode = { "n", "t" }, silent = true },
  --     -- { "2<M-o>", mode = { "n", "t" }, silent = true },
  --     -- { "3<M-o>", mode = { "n", "t" }, silent = true },
  --     -- { "4<M-o>", mode = { "n", "t" }, silent = true },
  --     -- { "5<M-o>", mode = { "n", "t" }, silent = true },
  --     { "1<M-o>", mode = { "n" }, silent = true },
  --     { "2<M-o>", mode = { "n" }, silent = true },
  --     { "3<M-o>", mode = { "n" }, silent = true },
  --     { "4<M-o>", mode = { "n" }, silent = true },
  --     { "5<M-o>", mode = { "n" }, silent = true },
  --     {
  --       "<leader>fl",
  --       mode = { "n" },
  --       "<cmd>vsp|term<cr>",
  --     },
  --     {
  --       "<leader>fh",
  --       mode = { "n" },
  --       "<cmd>15sp|term<cr>",
  --     },
  --     {
  --       "<leader>fn",
  --       mode = { "n" },
  --       "<cmd>tabnew|term<cr>",
  --     },
  --   },
  --   config = function()
  --     vim.o.hidden = true
  --
  --     -- To rename a buffer run
  --     -- concatenate watch to term buf name
  --     -- keepalt file %:watch
  --
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
  --       toggle_keymap = "<leader>to",
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
  --         { keymap = "1<M-o>" },
  --         { keymap = "2<M-o>" },
  --         { keymap = "3<M-o>" },
  --         { keymap = "4<M-o>" },
  --         { keymap = "5<M-o>" },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "ryanmsnyder/toggleterm-manager.nvim",
  --   keys = {
  --     {
  --       "<leader>to",
  --       mode = { "n" },
  --       "<cmd>Telescope toggleterm_manager<CR>",
  --     },
  --   },
  --   -- config = true,
  --   config = function()
  --     local toggleterm_manager = require("toggleterm-manager")
  --     local actions = toggleterm_manager.actions
  --
  --     toggleterm_manager.setup({
  --       results = {
  --         fields = { "state", { "term_icon", "Type" }, "term_name", "space", "bufname" },
  --       },
  --       mappings = {
  --         i = {
  --           ["<CR>"] = { action = actions.open_term, exit_on_action = true },
  --           ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = true }, -- creates a new terminal buffer
  --           ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },         -- deletes a terminal buffer
  --           ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },         -- provides a prompt to rename a terminal
  --         },
  --         n = {
  --           ["<CR>"] = { action = actions.open_term, exit_on_action = true },
  --           ["<C-n>"] = { action = actions.create_and_name_term, exit_on_action = true }, -- creates a new terminal buffer
  --           ["<C-d>"] = { action = actions.delete_term, exit_on_action = false },         -- deletes a terminal buffer
  --           ["<C-r>"] = { action = actions.rename_term, exit_on_action = false },         -- provides a prompt to rename a terminal
  --         },
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   "akinsho/toggleterm.nvim",
  --   -- cmd = { "ToggleTerm" },
  --   keys = {
  --     {
  --       "<M-o>",
  --       mode = { "n", "t" },
  --       "<cmd>ToggleTerm<CR>",
  --     },
  --     {
  --       "<M-o>",
  --       mode = { "t" },
  --       "<C-\\><C-n><cmd>ToggleTerm<CR>",
  --     },
  --     {
  --       "<leader>th",
  --       mode = { "n" },
  --       "<cmd>ToggleTerm direction=horizontal<cr>",
  --     },
  --     {
  --       "<leader>tt",
  --       mode = { "n" },
  --       "<cmd>ToggleTerm direction=tab<cr>",
  --     },
  --     {
  --       "<leader>tv",
  --       mode = { "n" },
  --       "<cmd>ToggleTerm direction=vertical<cr>",
  --     },
  --     {
  --       "<leader>tV",
  --       mode = { "n" },
  --       "<cmd>vsp|term<cr>i",
  --     },
  --     {
  --       "<leader>tH",
  --       mode = { "n" },
  --       "<cmd>sp|term<cr>i",
  --     },
  --     -- {
  --     --
  --     --   "<leader>tn",
  --     --   mode = { "n", "t" },
  --     --   function()
  --     --     go_next_term()
  --     --   end,
  --     -- },
  --     -- {
  --     --
  --     --   "<leader>tp",
  --     --   mode = { "n", "t" },
  --     --   function()
  --     --     go_prev_term()
  --     --   end,
  --     -- },
  --
  --     -- normal terms
  --     {
  --       "<leader>Tv",
  --       mode = { "n" },
  --       "<cmd>vsp|term<cr>",
  --     },
  --     {
  --       "<leader>Th",
  --       mode = { "n" },
  --       "<cmd>sp|term<cr>",
  --     },
  --     {
  --       "<leader>Tn",
  --       mode = { "n" },
  --       "<cmd>tabnew|term<cr>",
  --     },
  --   },
  --
  --   version = "*",
  --   opts = {
  --     size = function(term)
  --       if term.direction == "horizontal" then
  --         return 15
  --       elseif term.direction == "vertical" then
  --         return vim.o.columns * 0.4
  --       end
  --     end,
  --     direction = "horizontal",
  --     hide_numbers = true,
  --     open_mapping = [[<M-o>]],
  --     start_in_insert = true,
  --     persist_mode = false,
  --     persist_size = true,
  --     autochdir = true,
  --   },
  --   config = function(_, opts)
  --     require("toggleterm").setup(opts)
  --     local function get_term_index(current_id, terms)
  --       local idx
  --       for i, v in ipairs(terms) do
  --         if v.id == current_id then
  --           idx = i
  --         end
  --       end
  --       return idx
  --     end
  --
  --     local function go_prev_term()
  --       local current_id = vim.b.toggle_number
  --       if current_id == nil then
  --         return
  --       end
  --
  --       local terms = require("toggleterm.terminal").get_all(true)
  --       local prev_index
  --
  --       local index = get_term_index(current_id, terms)
  --       if index > 1 then
  --         prev_index = index - 1
  --       else
  --         prev_index = #terms
  --       end
  --       require("toggleterm").toggle(terms[index].id)
  --       require("toggleterm").toggle(terms[prev_index].id)
  --     end
  --
  --     local function go_next_term()
  --       local current_id = vim.b.toggle_number
  --       if current_id == nil then
  --         return
  --       end
  --
  --       local terms = require("toggleterm.terminal").get_all(true)
  --       local next_index
  --
  --       local index = get_term_index(current_id, terms)
  --       if index == #terms then
  --         next_index = 1
  --       else
  --         next_index = index + 1
  --       end
  --       require("toggleterm").toggle(terms[index].id)
  --       require("toggleterm").toggle(terms[next_index].id)
  --     end
  --
  --     vim.keymap.set({ "n", "t" }, "<F11>", function()
  --       go_next_term()
  --     end, { desc = "Toggle term" })
  --
  --     vim.keymap.set({ "n", "t" }, "<F12>", function()
  --       go_prev_term()
  --     end, { desc = "Toggle term" })
  --   end,
  -- }
  -- {
  --   "boltlessengineer/bufterm.nvim",
  --   event = { "TermOpen" },
  --
  --   -- vim.keymap.set({ "n" }, "<M-o>", function()
  --   --   local active_buffer = vim.api.nvim_win_get_buf(0)
  --   --   print(active_buffer)
  --   -- end, {})
  --   -- vim.keymap.set({ "n" }, "<leader>fe", "<cmd>BufTermEnter<cr>", {})
  --   -- vim.keymap.set({ "n" }, "<leader>fj", "<cmd>BufTermNext<cr>", {})
  --   -- vim.keymap.set({ "n" }, "<leader>fk", "<cmd>BufTermNext<cr>", {})
  --   keys = {
  --     {
  --       mode = { "n" },
  --       "<leader>fp",
  --       function()
  --         if vim.bo.filetype == "BufTerm" or vim.bo.filetype == "terminal" then
  --           vim.cmd("close")
  --         else
  --           vim.cmd("BufTermEnter")
  --         end
  --       end,
  --     },
  --     { mode = { "n" }, "<leader>fe", "<cmd>BufTermEnter<cr>" },
  --     { mode = { "n" }, "<leader>fj", "<cmd>BufTermNext<cr>" },
  --     { mode = { "n" }, "<leader<fk", "<cmd>BufTermPrev<cr>" },
  --   },
  --   -- opts = {
  --   --   save_native_terms = true, -- integrate native terminals from `:terminal` command
  --   --   start_in_insert = false, -- start terminal in insert mode
  --   --   remember_mode = false, -- remember vi_mode of terminal buffer
  --   --   enable_ctrl_w = false, -- use <C-w> for window navigating in terminal mode (like vim8)
  --   --   terminal = {           -- default terminal settings
  --   --     buflisted = true,    -- whether to set 'buflisted' option
  --   --     termlisted = true,   -- list terminal in termlist (similar to buflisted)
  --   --     fallback_on_exit = true, -- prevent auto-closing window on terminal exit
  --   --     auto_close = true,   -- auto close buffer on terminal job ends
  --   --   },
  --   -- },
  --   config = function()
  --     require("bufterm").setup({
  --       save_native_terms = true, -- integrate native terminals from `:terminal` command
  --       start_in_insert = false, -- start terminal in insert mode
  --       remember_mode = false, -- remember vi_mode of terminal buffer
  --       enable_ctrl_w = false, -- use <C-w> for window navigating in terminal mode (like vim8)
  --       terminal = {          -- default terminal settings
  --         buflisted = true,   -- whether to set 'buflisted' option
  --         termlisted = true,  -- list terminal in termlist (similar to buflisted)
  --         fallback_on_exit = true, -- prevent auto-closing window on terminal exit
  --         auto_close = true,  -- auto close buffer on terminal job ends
  --       },
  --     })
  --   end,
  -- },
}
