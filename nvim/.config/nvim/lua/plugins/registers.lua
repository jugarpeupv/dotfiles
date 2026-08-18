return {
  {
    "https://codeberg.org/fosk/registers.nvim",
    cmd = "Registers",
    keys = {
      { '"',     mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    name = "registers",
    config = function()
      local registers = require("registers")
      registers.setup({
        -- Show these registers in the order of the string
        -- show = '+"0123456789*abcdefghijklmnopqrstuvwxyz:-/_=#%.',
        show = '+1234567890"*abcdefghi',
        -- Show a line at the bottom with registers that aren't filled
        show_empty = true,
        -- Expose the :Registers user command
        register_user_command = true,
        -- Always transfer all selected registers to the system clipboard
        system_clipboard = false,
        -- Don't show whitespace at the begin and end of the register's content
        trim_whitespace = true,
        -- Don't show registers which are exclusively filled with whitespace
        hide_only_whitespace = false,
        -- Show a character next to the register name indicating how the register will be applied
        show_register_types = true,
        bind_keys = {
          -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
          normal = registers.show_window({ mode = "motion" }),
          -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
          visual = registers.show_window({ mode = "motion" }),
          -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
          insert = registers.show_window({ mode = "insert" }),

          -- When pressing the key of a register, apply it with a very small delay, which will also highlight the selected register
          registers = registers.apply_register({ delay = 0.1 }),
          -- Immediately apply the selected register line when pressing the return key
          ["<CR>"] = registers.apply_register(),
          -- Close the registers window when pressing the Esc key
          ["<Esc>"] = registers.close_window(),

          -- Move the cursor in the registers window down when pressing <C-n>
          ["<C-n>"] = registers.move_cursor_down(),
          -- Move the cursor in the registers window up when pressing <C-p>
          ["<C-p>"] = registers.move_cursor_up(),
          -- Move the cursor in the registers window down when pressing <C-j>
          ["<C-j>"] = registers.move_cursor_down(),
          -- Move the cursor in the registers window up when pressing <C-k>
          ["<C-k>"] = registers.move_cursor_up(),
          -- Clear the register of the highlighted line when pressing <DeL>
          ["<Del>"] = registers.clear_highlighted_register(),
          -- Clear the register of the highlighted line when pressing <BS>
          ["<BS>"] = registers.clear_highlighted_register(),
        },
        events = {
          -- When a register line is highlighted, show a preview in the main buffer with how the register will be applied, but only if the register will be inserted or pasted
          on_register_highlighted = registers.preview_highlighted_register({
            if_mode = { "insert", "paste" },
          }),
        },
        symbols = {
          -- Show a special character for line breaks
          newline = "⏎",
          -- Show space characters without changes
          space = " ",
          -- Show a special character for tabs
          tab = ">",
          -- The character to show when a register will be applied in a char-wise fashion
          register_type_charwise = "ᶜ",
          -- The character to show when a register will be applied in a line-wise fashion
          register_type_linewise = "ˡ",
          -- The character to show when a register will be applied in a block-wise fashion
          register_type_blockwise = "ᵇ",
        },
        window = {
          -- The window can't be wider than 100 characters
          max_width = 100,
          -- Show a small highlight in the sign column for the line the cursor is on
          highlight_cursorline = true,
          -- Don't draw a border around the registers window
          border = "rounded",
          -- Apply a tiny bit of transparency to the the window, letting some characters behind it bleed through
          transparency = 0,
        },
        -- Highlight the sign registers as regular Neovim highlights
        sign_highlights = {
          cursorlinesign = "CursorLine",
          signcolumn = "SignColumn",
          cursorline = "Visual",
          selection = "Constant",
          default = "Function",
          unnamed = "Statement",
          read_only = "Type",
          expression = "Exception",
          black_hole = "Error",
          alternate_buffer = "Operator",
          last_search = "Tag",
          delete = "Special",
          yank = "Delimiter",
          history = "Number",
          named = "Todo",
        },
      })
    end,
  },
  {
    -- Ctrl-R in the command line has no preview by default (registers.nvim
    -- only supports the popup in normal/visual/insert). Replace the cmdline
    -- <C-R> with a snacks registers picker: abort the current cmdline, pick a
    -- register in a floating window, then re-enter the cmdline with the
    -- register content inserted at the original cursor position.
    "folke/snacks.nvim",
    keys = {
      {
        "<C-R>",
        function()
          local cmd = vim.fn.getcmdline()
          local pos = vim.fn.getcmdpos()
          local ctype = vim.fn.getcmdtype()

          local function replace_cmdline(content)
            -- Re-enter the cmdline with the content inserted at the
            -- position where the cursor was when <C-R> was pressed.
            local head, tail = vim.fn.strpart(cmd, 0, pos - 1), vim.fn.strpart(cmd, pos - 1)
            vim.api.nvim_feedkeys(ctype .. head .. content .. tail, "nt", true)
            if #tail > 0 then
              vim.api.nvim_feedkeys(
                string.rep(
                  vim.api.nvim_replace_termcodes("<Left>", true, true, true),
                  vim.fn.strchars(tail)
                ),
                "nt",
                true
              )
            end
          end

          local function open_picker()
            -- Telescope yank_history (yanky.nvim) picker
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            require("telescope").extensions.yank_history.yank_history({
              initial_mode = "insert",
              attach_mappings = function(_, _)
                actions.select_default:replace(function(bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(bufnr)
                  if selection then
                    -- Strip tabs/newlines from linewise yanks: a trailing \n
                    -- acts as <CR> and executes the re-entered cmdline, and
                    -- leading \t mangles the text. We are also striping leading whitespace
                    local content = (selection.value.regcontents or "")
                      :gsub("[\t\n\r]", "")
                      :gsub("\\n", "")
                      :gsub("^%s+", "")

                    -- Schedule so telescope fully closes first; otherwise the
                    -- <cr> that confirmed the picker is still pending and would
                    -- execute the re-entered cmdline immediately.
                    vim.schedule(function()
                      replace_cmdline(content)
                    end)
                  end
                end)
                return true
              end,
            })
          end

          -- Abort the in-progress command line, then open the picker on the
          -- next tick so the <esc> has fully processed and mode is back to
          -- normal. Opening the picker synchronously (or feeding <esc> with
          -- "x") leaves the cmdline active, so telescope's <ESC>A insert-mode
          -- key lands in the cmdline (":e A") and the prompt never gains focus.
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
          vim.schedule(open_picker)
        end,
        mode = "c",
        desc = "Insert register into command line",
      },
      {
        "<C-S>",
        function()
          local cmd = vim.fn.getcmdline()
          local pos = vim.fn.getcmdpos()
          local ctype = vim.fn.getcmdtype()

          local function replace_cmdline(content)
            -- Re-enter the cmdline with the content inserted at the
            -- position where the cursor was when <C-R> was pressed.
            local head, tail = vim.fn.strpart(cmd, 0, pos - 1), vim.fn.strpart(cmd, pos - 1)
            vim.api.nvim_feedkeys(ctype .. head .. content .. tail, "nt", true)
            if #tail > 0 then
              vim.api.nvim_feedkeys(
                string.rep(
                  vim.api.nvim_replace_termcodes("<Left>", true, true, true),
                  vim.fn.strchars(tail)
                ),
                "nt",
                true
              )
            end
          end

          local function open_picker()
            require("snacks").picker.registers({
              actions = {
                confirm = function(picker, item)
                  picker:close()
                  local reg = vim.fn.getreg(item.reg)
                  reg = (reg or "")
                    :gsub("[\t\n\r]", "")
                    :gsub("\\n", "")
                    :gsub("^%s+", "")

                  -- Schedule so telescope fully closes first; otherwise the
                  -- <cr> that confirmed the picker is still pending and would
                  -- execute the re-entered cmdline immediately.
                  vim.schedule(function()
                    replace_cmdline(reg)
                  end)
                end,
              },
            })
          end

          -- Abort the in-progress command line, then open the picker on the
          -- next tick so the <esc> has fully processed and mode is back to
          -- normal. Opening the picker synchronously (or feeding <esc> with
          -- "x") leaves the cmdline active, so telescope's <ESC>A insert-mode
          -- key lands in the cmdline (":e A") and the prompt never gains focus.
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
          vim.schedule(open_picker)
        end,
        mode = "c",
        desc = "Insert register into command line",
      },
    },
  },
}
