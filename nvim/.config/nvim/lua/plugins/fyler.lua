local M = {}

M.new_api_opts = {
  auto_confirm_simple_mutation = true,
  bound_cursor = true,
  follow_current_file = false,
  follow_root_dir = true,
  use_as_default_explorer = false,
  kind = "split_left_most",
  buf_opts = {
    filetype = "fyler_finder",
    syntax = "fyler_finder",
    shiftwidth = 2,
  },
  win_opts = {
    concealcursor = "nvic",
    conceallevel = 3,
    signcolumn = "yes",
    cursorline = true,
    number = true,
    relativenumber = true,
    winhighlight = "Normal:FylerNormal",
    wrap = false,
    foldcolumn = "1",
  },
  kind_presets = {
    split_left_most = {
      width = "25%",
      win_opts = {
        winfixwidth = true,
      },
    },
    replace = {
      mappings = {
        n = {
          ["<CR>"] = {
            action = "select",
            args = { close = true, pick = false },
          },
        },
      },
    },
  },
  extensions = {
    git = {
      enabled = true,
      icons = {
        ["??"] = { icon = "?", hl = "FylerGitUntracked" },
        [" M"] = { icon = "!", hl = "FylerGitModified" },
        ["MM"] = { icon = "!", hl = "FylerGitModified" },
        ["AM"] = { icon = "!", hl = "FylerGitModified" },
        ["M "] = { icon = "+", hl = "FylerGitStaged" },
        ["A "] = { icon = "+", hl = "FylerGitStaged" },
        [" D"] = { icon = "✗", hl = "FylerGitDeleted" },
        ["D "] = { icon = "✗", hl = "FylerGitDeleted" },
        ["R "] = { icon = "󰕛 ", hl = "FylerGitRenamed" },
        ["UU"] = { icon = "", hl = "FylerGitConflict" },
        ["!!"] = { icon = " ", hl = "FylerGitIgnored" },
      },
    },
    trash = { enabled = true },
    watcher = { enabled = true },
  },
  integrations = {
    icon = "nvim_web_devicons",
    icons = {
      directory_collapsed = "",
      directory_expanded = "",
    },
  },
  hooks = {
    on_delete = nil,
    on_rename = nil,
  },
  ui = {
    indent_guides = true,
    hidden_items = {
      switches = { "dotfiles" },
      patterns = {},
      always_visible = {},
      always_hidden = {},
    },
  },
  mappings = {
    n = {
      ["J"] = {
        action = function() end,
      },
      ["."] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          local cmd_run = string.format(":Compile  %s", path)
          local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
          vim.api.nvim_feedkeys(keys, "c", true)
          local hops = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
          vim.api.nvim_feedkeys(hops, "n", true)
        end,
      },
      ["C"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          local relative_path = vim.fn.fnamemodify(path, ":.")
          vim.notify("Copied path: " .. relative_path)
          vim.fn.setreg("+", relative_path)
        end,
      },
      ["gy"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          vim.notify("Copied path: " .. path)
          vim.fn.setreg("+", path)
        end,
      },
      ["K"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path

          local current_win = vim.api.nvim_get_current_win()
          local current_buf = vim.api.nvim_win_get_buf(current_win)
          local is_in_hover = vim.b[current_buf].fyler_hover_popup == true

          if is_in_hover then
            if vim.api.nvim_win_is_valid(current_win) then
              vim.api.nvim_win_close(current_win, true)
            end
            if vim.api.nvim_buf_is_valid(current_buf) then
              vim.api.nvim_buf_delete(current_buf, { force = true })
            end
            return
          end

          local existing_popup_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.b[buf].fyler_hover_popup == true then
              existing_popup_win = win
              break
            end
          end

          if existing_popup_win and vim.api.nvim_win_is_valid(existing_popup_win) then
            vim.api.nvim_set_current_win(existing_popup_win)
            return
          end

          local stats = vim.uv.fs_stat(path)
          if not stats then
            vim.notify("Cannot retrieve file information for: " .. path, vim.log.levels.ERROR)
            return
          end

          local file_permissions = vim.fn.getfperm(path)

          local lines = {
            " fullpath: " .. path,
            " permis:   " .. file_permissions,
            " size:     calculating...",
            " accessed: " .. os.date("%x %X", stats.atime.sec),
            " modified: " .. os.date("%x %X", stats.mtime.sec),
            " created:  " .. os.date("%x %X", stats.birthtime.sec),
          }

          local max_width = vim.fn.max(vim.tbl_map(function(n) return #n end, lines))

          local open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "rounded",
            style = "minimal",
            width = math.max(max_width + 1, 50),
            height = #lines,
            noautocmd = true,
            zindex = 60,
          }

          local bufnr = vim.api.nvim_create_buf(false, true)
          local winnr = vim.api.nvim_open_win(bufnr, false, open_win_config)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.b[bufnr].fyler_hover_popup = true

          local function highlight_lines()
            for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
              local s, e = line:find(".-:")
              if s and e then
                vim.api.nvim_buf_add_highlight(bufnr, -1, "Type", i - 1, s - 1, e)
              end
            end
          end
          highlight_lines()

          local close_popup = function()
            if vim.api.nvim_win_is_valid(winnr) then
              vim.api.nvim_win_close(winnr, true)
            end
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end
          end

          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
            noremap = true, silent = true, callback = close_popup,
          })
          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", {
            noremap = true, silent = true, callback = close_popup,
          })

          vim.api.nvim_create_autocmd("CursorMoved", {
            once = true,
            callback = function()
              if vim.api.nvim_get_current_win() ~= winnr then close_popup() end
            end,
          })

          vim.system({ "du", "-sh", path }, {}, function(result)
            vim.schedule(function()
              if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winnr) then return end

              local improved_size = result.stdout and result.stdout:match("^[^\t]+") or "unknown"
              lines[3] = " size:     " .. improved_size

              local new_max_width = vim.fn.max(vim.tbl_map(function(n) return #n end, lines))

              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

              if new_max_width > open_win_config.width - 1 then
                open_win_config.width = new_max_width + 1
                vim.api.nvim_win_set_config(winnr, open_win_config)
              end

              vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
              highlight_lines()
            end)
          end)
        end,
      },
      ["gx"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path

          local function get_open_cmd(my_path)
            if vim.fn.has("mac") == 1 then return { "open", my_path } end
            if vim.fn.has("win32") == 1 then
              if vim.fn.executable("rundll32") == 1 then
                return { "rundll32", "url.dll,FileProtocolHandler", my_path }
              end
              return nil, "rundll32 not found"
            end
            if vim.fn.executable("explorer.exe") == 1 then return { "explorer.exe", my_path } end
            if vim.fn.executable("xdg-open") == 1 then return { "xdg-open", my_path } end
            return nil, "no handler found"
          end

          local cmd, err = get_open_cmd(path)
          if not cmd then
            vim.notify(string.format("Could not open %s: %s", path, err), vim.log.levels.ERROR)
            return
          end
          local jid = vim.fn.jobstart(cmd, { detach = true })
          assert(jid > 0, "Failed to start job")
        end,
      },
      ["<leader>cr"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path

          local home = os.getenv("HOME")
          if home then path = path:gsub("^" .. home, "~") end

          local cmd_run = string.format(":Compile  %s", path)
          local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
          vim.api.nvim_feedkeys(keys, "c", true)

          local hops = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
          vim.api.nvim_feedkeys(hops, "n", true)
        end,
      },
      ["S"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end

          local home = os.getenv("HOME")
          if home then path = path:gsub("^" .. home, "~") end

          require("telescope").extensions.live_grep_args.live_grep_raw({
            cwd = path,
            disable_coordinates = true,
            path_display = { "absolute" },
            theme = "ivy",
            prompt_title = "Live grep in path: " .. path,
            layout_config = { height = 0.47 },
            preview = { hide_on_startup = true },
            vimgrep_arguments = {
              "rg", "--no-heading", "--with-filename", "--line-number", "--column",
              "--hidden", "--smart-case", "--no-ignore",
              "--glob=!icarSDK.js", "--glob=!package-lock.json",
              "--glob=!**/.git/**",
            },
          })
        end,
      },
      ["F"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end

          require("telescope.builtin").find_files({
            prompt_title = "Find files in: " .. path,
            cwd = path,
            hidden = true,
            find_command = {
              "rg", "--files", "--color", "never",
              "--glob=!.git", "--glob=!*__template__", "--glob=!*DS_Store",
            },
          })
        end,
      },
      ["go"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end
          vim.cmd("vsplit")
          require("oil").open(path)
        end,
      },
      ["gl"] = {
        action = function(instance)
          local entry = require("fyler.finder").parse_cursor_line(instance)
          if not entry then return end
          local path = entry.path

          local function check_and_modify_path(path_to)
            if vim.fn.isdirectory(path_to) == 1 then return path_to end
            return vim.fn.fnamemodify(path_to, ":h")
          end
          local modified_path = check_and_modify_path(path)

          local function get_all_terminals()
            local terminal_chans = {}
            for _, chan in pairs(vim.api.nvim_list_chans()) do
              if chan["mode"] == "terminal" and chan["pty"] ~= "" then
                table.insert(terminal_chans, chan)
              end
            end
            table.sort(terminal_chans, function(left, right)
              return left["buffer"] < right["buffer"]
            end)
            if #terminal_chans == 0 then return nil end
            return terminal_chans
          end

          local all_terms = get_all_terminals()
          for _, term in pairs(all_terms or {}) do
            term.title = vim.api.nvim_buf_get_var(term.buffer, "term_title")
          end

          local term_found
          modified_path = modified_path:gsub("^~", "~")
          modified_path = modified_path:gsub(" ", "\\ ")
          print(modified_path)

          for _, term in pairs(all_terms or {}) do
            if term.title and string.find(term.title, modified_path, 1, true) then
              term_found = term
            end
          end

          if term_found then
            vim.api.nvim_set_current_win(vim.api.nvim_open_win(term_found.buffer, true, {
              split = "below",
            }))
            return
          end

          local myterm = require("terminal").terminal:new({
            layout = { open_cmd = "botright new" },
            autoclose = false,
          })
          myterm:open()
          myterm:send("cd " .. modified_path)
        end,
      },
      ["q"] = { action = "close" },
      ["<CR>"] = { action = "select", args = { pick = true } },
      ["L"] = { action = "select", args = { pick = true } },
      ["<C-t>"] = { action = "select", args = { tabedit = true } },
      ["<C-v>"] = { action = "select", args = { vsplit = true } },
      ["<C-s>"] = { action = "select", args = { split = true } },
      ["-"] = { action = "visit", args = { parent = true } },
      ["="] = { action = "visit" },
      ["gw"] = {
        action = function(instance)
          local original_cwd = vim.fn.getcwd(-1, -1)
          instance:visit({ path = original_cwd })
        end,
      },
      ["<BS>"] = { action = "shrink", args = { parent = true } },
      ["H"] = { action = "shrink" },
      ["#"] = {
        action = function(instance)
          local st = instance.state
          st:walk(function(node, depth)
            if depth > 0 then
              local data = require("fyler.state").store[node.value]
              if data and data.type == "directory" then
                st:toggle(data.path, false)
              end
            end
          end, { skip_hidden = true })
          instance:refresh({ force = true, recursive = true })
        end,
      },
      ["<leader>cd"] = {
        action = function(instance)
          local dir = require("fyler").getcwd() or vim.fn.expand("%:p:h")
          if dir then
            vim.cmd("cd " .. vim.fn.fnameescape(dir))
            vim.notify("cwd: " .. dir)
          end
        end,
      },
    },
  },
}

M.old_api_opts = {
  hooks = {
    on_delete = nil,
    on_rename = nil,
  },
  integrations = {
    icon = "nvim_web_devicons",
  },
  views = {
    finder = {
      close_on_select = false,
      confirm_simple = true,
      default_explorer = false,
      delete_to_trash = true,
      columns_order = { "git", "link", "permission", "creation_time" },
      columns = {
        creation_time = { enabled = false },
        permission = { enabled = false },
        size = { enabled = false },
        git = {
          enabled = true,
          symbols = {
            Untracked = "?",
            Staged = "+",
            Unstaged = "!",
            Deleted = "✗",
            Renamed = "󰕛 ",
            Copied = "~",
            Conflict = "",
            Ignored = " ",
          },
        },
        diagnostic = {
          enabled = false,
          symbols = {
            Error = " ",
            Warn = " ",
            Info = " ",
            Hint = "󰠠 ",
          },
        },
      },
      icon = {
        directory_collapsed = "",
        directory_expanded = "",
      },
      indentscope = {
        enabled = true,
        markers = {
          { "│", "FylerIndentMarker" },
          { "└", "FylerIndentMarker" },
        },
      },
      mappings = {
        ["J"] = function() end,
        ["gP"] = "PasteEntry",
        ["gX"] = "VisualCutEntries",
        ["gY"] = {
          n = function(view)
            local entry = view:cursor_node_entry()
            local path = entry.path
            vim.notify("Copied path: " .. path)
            vim.fn.setreg("+", path)
          end,
          x = "VisualYankEntries",
        },
        ["gy"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          path = vim.fn.fnamemodify(path, ":~:.")
          vim.notify("Copied path: " .. path)
          vim.fn.setreg("+", path)
        end,
        ["<leader>fp"] = "TogglePermissions",
        ["."] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          local cmd_run = string.format(":Compile  %s", path)
          local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
          vim.api.nvim_feedkeys(keys, "c", true)
          local hops = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
          vim.api.nvim_feedkeys(hops, "n", true)
        end,
        ["C"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          local relative_path = vim.fn.fnamemodify(path, ":.")
          vim.notify("Copied path: " .. relative_path)
          vim.fn.setreg("+", relative_path)
        end,
        ["K"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path

          local current_win = vim.api.nvim_get_current_win()
          local current_buf = vim.api.nvim_win_get_buf(current_win)
          local is_in_hover = vim.b[current_buf].fyler_hover_popup == true

          if is_in_hover then
            if vim.api.nvim_win_is_valid(current_win) then vim.api.nvim_win_close(current_win, true) end
            if vim.api.nvim_buf_is_valid(current_buf) then vim.api.nvim_buf_delete(current_buf, { force = true }) end
            return
          end

          local existing_popup_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.b[buf].fyler_hover_popup == true then
              existing_popup_win = win
              break
            end
          end

          if existing_popup_win and vim.api.nvim_win_is_valid(existing_popup_win) then
            vim.api.nvim_set_current_win(existing_popup_win)
            return
          end

          local stats = vim.uv.fs_stat(path)
          if not stats then
            vim.notify("Cannot retrieve file information for: " .. path, vim.log.levels.ERROR)
            return
          end

          local file_permissions = vim.fn.getfperm(path)

          local lines = {
            " fullpath: " .. path,
            " permis:   " .. file_permissions,
            " size:     calculating...",
            " accessed: " .. os.date("%x %X", stats.atime.sec),
            " modified: " .. os.date("%x %X", stats.mtime.sec),
            " created:  " .. os.date("%x %X", stats.birthtime.sec),
          }

          local max_width = vim.fn.max(vim.tbl_map(function(n) return #n end, lines))

          local open_win_config = {
            col = 1, row = 1, relative = "cursor", border = "rounded",
            style = "minimal", width = math.max(max_width + 1, 50),
            height = #lines, noautocmd = true, zindex = 60,
          }

          local bufnr = vim.api.nvim_create_buf(false, true)
          local winnr = vim.api.nvim_open_win(bufnr, false, open_win_config)
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
          vim.b[bufnr].fyler_hover_popup = true

          local function highlight_lines()
            for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
              local s, e = line:find(".-:")
              if s and e then vim.api.nvim_buf_add_highlight(bufnr, -1, "Type", i - 1, s - 1, e) end
            end
          end
          highlight_lines()

          local close_popup = function()
            if vim.api.nvim_win_is_valid(winnr) then vim.api.nvim_win_close(winnr, true) end
            if vim.api.nvim_buf_is_valid(bufnr) then vim.api.nvim_buf_delete(bufnr, { force = true }) end
          end

          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", { noremap = true, silent = true, callback = close_popup })
          vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", { noremap = true, silent = true, callback = close_popup })

          vim.api.nvim_create_autocmd("CursorMoved", {
            once = true,
            callback = function()
              if vim.api.nvim_get_current_win() ~= winnr then close_popup() end
            end,
          })

          vim.system({ "du", "-sh", path }, {}, function(result)
            vim.schedule(function()
              if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winnr) then return end

              local improved_size = result.stdout and result.stdout:match("^[^\t]+") or "unknown"
              lines[3] = " size:     " .. improved_size
              local new_max_width = vim.fn.max(vim.tbl_map(function(n) return #n end, lines))

              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
              if new_max_width > open_win_config.width - 1 then
                open_win_config.width = new_max_width + 1
                vim.api.nvim_win_set_config(winnr, open_win_config)
              end
              vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
              highlight_lines()
            end)
          end)
        end,
        ["gx"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path

          local function get_open_cmd(my_path)
            if vim.fn.has("mac") == 1 then return { "open", my_path } end
            if vim.fn.has("win32") == 1 then
              if vim.fn.executable("rundll32") == 1 then return { "rundll32", "url.dll,FileProtocolHandler", my_path } end
              return nil, "rundll32 not found"
            end
            if vim.fn.executable("explorer.exe") == 1 then return { "explorer.exe", my_path } end
            if vim.fn.executable("xdg-open") == 1 then return { "xdg-open", my_path } end
            return nil, "no handler found"
          end

          local cmd, err = get_open_cmd(path)
          if not cmd then
            vim.notify(string.format("Could not open %s: %s", path, err), vim.log.levels.ERROR)
            return
          end
          local jid = vim.fn.jobstart(cmd, { detach = true })
          assert(jid > 0, "Failed to start job")
        end,
        ["<leader>cr"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          local home = os.getenv("HOME")
          if home then path = path:gsub("^" .. home, "~") end
          local cmd_run = string.format(":Compile  %s", path)
          local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
          vim.api.nvim_feedkeys(keys, "c", true)
          local hops = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
          vim.api.nvim_feedkeys(hops, "n", true)
        end,
        ["S"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end
          local home = os.getenv("HOME")
          if home then path = path:gsub("^" .. home, "~") end
          require("telescope").extensions.live_grep_args.live_grep_raw({
            cwd = path, disable_coordinates = true, path_display = { "absolute" },
            theme = "ivy", prompt_title = "Live grep in path: " .. path,
            layout_config = { height = 0.47 }, preview = { hide_on_startup = true },
            vimgrep_arguments = {
              "rg", "--no-heading", "--with-filename", "--line-number", "--column",
              "--hidden", "--smart-case", "--no-ignore", "--glob=!icarSDK.js",
              "--glob=!package-lock.json", "--glob=!**/.git/**",
            },
          })
        end,
        ["F"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end
          require("telescope.builtin").find_files({
            prompt_title = "Find files in: " .. path, cwd = path, hidden = true,
            find_command = { "rg", "--files", "--color", "never", "--glob=!.git", "--glob=!*__template__", "--glob=!*DS_Store" },
          })
        end,
        ["go"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path
          if vim.fn.isdirectory(path) == 0 then path = vim.fn.fnamemodify(path, ":h") end
          vim.cmd("vsplit")
          require("oil").open(path)
        end,
        ["gl"] = function(view)
          local entry = view:cursor_node_entry()
          local path = entry.path

          local function check_and_modify_path(path_to)
            if vim.fn.isdirectory(path_to) == 1 then return path_to end
            return vim.fn.fnamemodify(path_to, ":h")
          end
          local modified_path = check_and_modify_path(path)

          local function get_all_terminals()
            local terminal_chans = {}
            for _, chan in pairs(vim.api.nvim_list_chans()) do
              if chan["mode"] == "terminal" and chan["pty"] ~= "" then table.insert(terminal_chans, chan) end
            end
            table.sort(terminal_chans, function(left, right) return left["buffer"] < right["buffer"] end)
            if #terminal_chans == 0 then return nil end
            return terminal_chans
          end

          local all_terms = get_all_terminals()
          for _, term in pairs(all_terms or {}) do term.title = vim.api.nvim_buf_get_var(term.buffer, "term_title") end

          local term_found
          modified_path = modified_path:gsub("^~", "~"):gsub(" ", "\\ ")
          print(modified_path)

          for _, term in pairs(all_terms or {}) do
            if term.title and string.find(term.title, modified_path, 1, true) then term_found = term end
          end

          if term_found then
            vim.api.nvim_set_current_win(vim.api.nvim_open_win(term_found.buffer, true, { split = "below" }))
            return
          end

          local myterm = require("terminal").terminal:new({
            layout = { open_cmd = "botright new" }, autoclose = false,
          })
          myterm:open()
          myterm:send("cd " .. modified_path)
        end,
        ["q"] = "CloseView",
        ["<CR>"] = "Select",
        ["L"] = "Select",
        ["<C-t>"] = "SelectTab",
        ["<C-v>"] = "SelectVSplit",
        ["<C-s>"] = "SelectSplit",
        ["-"] = "GotoParent",
        ["="] = "GotoCwd",
        ["gw"] = "GotoCwdOriginal",
        ["<BS>"] = "GotoNode",
        ["#"] = "CollapseAll",
        ["H"] = "CollapseNode",
        ["<leader>cd"] = function()
          local ok, fyler = pcall(require, "fyler")
          local dir
          if ok and type(fyler.get_current_dir) == "function" then dir = fyler.get_current_dir() end
          if not dir or dir == "" then dir = vim.fn.expand("%:p:h") end
          vim.cmd("cd " .. vim.fn.fnameescape(dir))
          vim.notify("cwd: " .. dir)
        end,
      },
      follow_current_file = false,
      watcher = { enabled = true },
      win = {
        border = vim.o.winborder == "" and "single" or vim.o.winborder,
        buf_opts = {
          filetype = "fyler", syntax = "fyler",
          buftype = "acwrite", expandtab = true, shiftwidth = 2,
        },
        kind = "sidebar",
        kinds = {
          sidebar = { width = 40, win_opts = { winfixwidth = true } },
        },
        win_opts = {
          concealcursor = "nvic", cursorline = true, number = true,
          relativenumber = true, winhighlight = "Normal:FylerNormal", wrap = false,
          foldcolumn = "1",
        },
      },
    },
  },
}

return {
  {
    "jugarpeupv/fyler.nvim",
    -- branch = "main",
    -- dev = true,
    -- dir = "~/projects/fyler.nvim/wt-fyler-main/",
    -- dir = "~/projects/fyler.nvim/wt-fyler-origin-main/",
    enabled = true,
    lazy = false,
    cmd = { "Fyler" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("fyler").open()
        end,
        desc = "Fyler",
      },
      {
        mode = { "n", "t" },
        "<M-k>",
        function()
          local fyler = require("fyler")
          local path = vim.fn.expand("%:p")
          local found = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "fyler" or ft == "fyler_finder" then
              vim.api.nvim_set_current_win(win)
              found = true
              break
            end
          end
          if not found then fyler.open() end
          fyler.navigate(path)
        end,
        { noremap = true, silent = true },
      },
      {
        mode = { "n", "t" },
        "<D-k>",
        function()
          local fyler = require("fyler")
          local path = vim.fn.expand("%:p")
          local found = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == "fyler" or ft == "fyler_finder" then
              vim.api.nvim_set_current_win(win)
              found = true
              break
            end
          end
          if not found then fyler.open() end
          fyler.navigate(path)
        end,
        { noremap = true, silent = true },
      },
      {
        mode = { "i", "t", "n" },
        "<M-j>",
        function()
          require("fyler").toggle()
        end,
        { noremap = true, silent = true },
      },
      {
        mode = { "i", "t", "n" },
        "<D-j>",
        function()
          require("fyler").toggle()
        end,
        { noremap = true, silent = true },
      },
    },
    opts = function()
      if package.searchpath("fyler.finder", package.path) then return M.new_api_opts end
      return M.old_api_opts
    end,
    config = function(_, opts)
      require("fyler").setup(opts)

      local ok, fyler = pcall(require, "fyler")
      if not ok then return end

      if not fyler.set_current_dir then
        fyler.set_current_dir = function(path)
          fyler.open({ root_path = path, kind = "replace" })
        end
      end
      if fyler.getcwd then
        vim.cmd("hi FylerGitStaged gui=none guifg=none")
        vim.cmd("hi FylerGitModified gui=none guifg=none")
        vim.cmd("hi FylerGitUntracked gui=none guifg=none")
      else
        vim.cmd("hi FylerGitStaged gui=none guifg=none")
        vim.cmd("hi FylerGitIconStaged gui=none guifg=#8ee2cf")
        vim.cmd("hi FylerGitUnstaged gui=none guifg=none")
        vim.cmd("hi FylerGitIconUnstaged gui=none guifg=#F5E0DC")
        vim.cmd("hi FylerGitUntracked gui=none guifg=none")
        vim.cmd("hi FylerGitIconUntracked gui=none guifg=#89ddff")
      end
    end,
  },
}
