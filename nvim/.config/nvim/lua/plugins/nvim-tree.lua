-- return {}
return {
  {
    "nvim-tree/nvim-tree.lua",
    -- lazy = true,
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },

    priority = 500,
    config = function()
      local api_nvimtree = require("nvim-tree.api")
      local nvim_tree_jg_utils = require("jg.custom.nvim-tree-utils")

      api_nvimtree.events.subscribe(api_nvimtree.events.Event.TreeOpen, function()
        vim.wo.statusline = " "
        vim.cmd("hi! NvimTreeStatusLine guifg=none guibg=none")
        vim.opt.laststatus = 3
        -- vim.cmd("hi! NvimTreeStatusLineNC guifg=none guibg=none")
      end)

      local status_ok, nvim_tree = pcall(require, "nvim-tree")
      if not status_ok then
        return
      end

      local function on_attach(bufnr)
        local opts = function(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- mark operation
        local mark_move_j = function()
          api_nvimtree.marks.toggle()
          vim.cmd("norm j")
        end
        local mark_move_k = function()
          api_nvimtree.marks.toggle()
          vim.cmd("norm k")
        end

        -- marked files operation
        local mark_trash = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          -- vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
          --   if input == "y" then
          --     for _, node in ipairs(marks) do
          --       api.fs.trash(node)
          --     end
          --     api.marks.clear()
          --     api.tree.reload()
          --   end
          -- end)

          for _, node in ipairs(marks) do
            api_nvimtree.fs.trash(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end
        local mark_remove = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          -- vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
          --   if input == "y" then
          --     for _, node in ipairs(marks) do
          --       api.fs.remove(node)
          --     end
          --     api.marks.clear()
          --     api.tree.reload()
          --   end
          -- end)

          for _, node in ipairs(marks) do
            api_nvimtree.fs.remove(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end

        local mark_copy = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api_nvimtree.fs.copy.node(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end
        local mark_cut = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api_nvimtree.fs.cut(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end

        local lib = require("nvim-tree.lib")
        -- add custom key mapping to search in directory with grug-far
        vim.keymap.set("n", "S", function()
          local node = lib.get_node_at_cursor()
          local grugFar = require("grug-far")
          if node then
            -- get directory of current file if it's a file
            local path
            if node.type == "directory" then
              -- Keep the full path for directories
              path = node.absolute_path
            else
              -- Get the directory of the file
              path = vim.fn.fnamemodify(node.absolute_path, ":h")
            end

            -- escape all spaces in the path with "\ "
            path = path:gsub(" ", "\\ ")

            local prefills = {
              paths = path,
            }

            -- instance check
            if not grugFar.has_instance("tree") then
              grugFar.open({
                instanceName = "tree",
                prefills = prefills,
                staticTitle = "Find and Replace from Tree",
              })
            else
              grugFar.open_instance("tree")
              -- updating the prefills without clearing the search and other fields
              grugFar.update_instance_prefills("tree", prefills, false)
            end
          end
        end, opts("Search in directory"))

        vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))
        vim.keymap.set("n", "<down>", mark_move_j, opts("Toggle Bookmark Down"))
        vim.keymap.set("n", "<up>", mark_move_k, opts("Toggle Bookmark Up"))

        vim.keymap.set("n", "bx", mark_cut, opts("Cut File(s)"))
        vim.keymap.set("n", "bD", mark_trash, opts("Trash File(s)"))
        vim.keymap.set("n", "bd", mark_remove, opts("Remove File(s)"))
        vim.keymap.set("n", "by", mark_copy, opts("Copy File(s)"))

        vim.keymap.set("n", "bm", api_nvimtree.marks.bulk.move, opts("Move Bookmarked"))

        -- vim.keymap.set("n", "K", api_nvimtree.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "K", nvim_tree_jg_utils.custom_info_popup, opts("Info"))

        -- Default mappings. Feel free to modify or remove as you wish.
        --
        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-c>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<BS>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        -- vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api_nvimtree.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api_nvimtree.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api_nvimtree.node.open.horizontal, opts("Open: Horizontal Split"))
        -- vim.keymap.set("n", "<BS>", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "h", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "l", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api_nvimtree.node.open.edit, opts("Open"))
        -- vim.keymap.set('n', '<CR>', toggle_replace, opts('Open: In Place'))
        -- vim.keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set("n", "<Tab>", api_nvimtree.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api_nvimtree.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api_nvimtree.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api_nvimtree.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api_nvimtree.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api_nvimtree.fs.create, opts("Create"))
        -- vim.keymap.set('n', '<leader>cr', change_root_to_global_cwd, opts('Change Root To Global CWD'))
        -- vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
        vim.keymap.set("n", "B", api_nvimtree.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
        vim.keymap.set("n", "yy", api_nvimtree.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api_nvimtree.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
        vim.keymap.set("n", "[c", api_nvimtree.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api_nvimtree.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api_nvimtree.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api_nvimtree.fs.trash, opts("Trash"))
        -- vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api_nvimtree.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api_nvimtree.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api_nvimtree.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api_nvimtree.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api_nvimtree.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api_nvimtree.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api_nvimtree.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api_nvimtree.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api_nvimtree.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        -- vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
        -- vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
        vim.keymap.set("n", "m", api_nvimtree.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api_nvimtree.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api_nvimtree.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api_nvimtree.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api_nvimtree.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api_nvimtree.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api_nvimtree.node.run.system, opts("Run System"))
        vim.keymap.set("n", "z", api_nvimtree.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api_nvimtree.tree.toggle_custom_filter, opts("Toggle Hidden"))
        vim.keymap.set("n", "W", api_nvimtree.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api_nvimtree.fs.cut, opts("Cut"))
        vim.keymap.set("n", "c", api_nvimtree.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api_nvimtree.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        -- -- END_DEFAULT_ON_ATTACH

        -- Mappings removed via:
        --   remove_keymaps
        --   OR
        --   view.mappings.list..action = ""
        --
        -- The dummy set before del is done for safety, in case a default mapping does not exist.
        --
        -- You might tidy things by removing these along with their default mapping.
        vim.keymap.set("n", "<C-e>", "", { buffer = bufnr })
        vim.keymap.del("n", "<C-e>", { buffer = bufnr })

        -- vim.keymap.set('n', '<C-k>', '', { buffer = bufnr })
        -- vim.keymap.del('n', '<C-k>', { buffer = bufnr })

        -- Mappings migrated from view.mappings.list
        --
        -- You will need to insert "your code goes here" for any mappings with a custom action_cb
        vim.keymap.set("n", "<C-Enter>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
        -- vim.keymap.set('n', '<C-p>', api.node.show_info_popup, opts('Info'))
      end

      local HEIGHT_RATIO = 0.8 -- You can change this
      local WIDTH_RATIO = 0.5 -- You can change this too

      -- setup with all defaults
      nvim_tree.setup({
        ui = {
          confirm = {
            trash = false,
            remove = true,
          },
        },
        -- BEGIN_DEFAULT_OPTS
        auto_reload_on_write = true,
        disable_netrw = true,
        -- disable_netrw = false,
        hijack_cursor = true,
        hijack_netrw = true,
        -- hijack_netrw = false,
        hijack_unnamed_buffer_when_opening = true,
        sort_by = "name",
        sync_root_with_cwd = true,
        -- prefer_startup_root = true,
        -- *nvim-tree.prefer_startup_root*
        -- Prefer startup root directory when updating root directory of the tree.
        -- Only relevant when `update_focused_file.update_root` is `true`
        -- Type: `boolean`, Default: `false`
        respect_buf_cwd = false,
        on_attach = on_attach,
        live_filter = {
          always_show_folders = false,
        },
        modified = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = false,
        },
        view = {
          -- width = 45,
          width = 50,
          -- height = 30,
          -- hide_root_folder = false,
          side = "left",
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          -- mappings = {
          -- 	custom_only = false,
          -- 	list = {
          -- 		-- user mappings go here
          -- 		{ key = "<C-e>", action = "" },
          -- 		{ key = "<C-Enter>", action = "vsplit" },
          -- 		{ key = "<C-k>", action = "" },
          -- 		{ key = "<C-p>", action = "toggle_file_info" },
          --       { key = "h", action = "parent_close," },
          -- 	},
          -- },
          -- float = {
          --   enable = true,
          --   open_win_config = function()
          --     local screen_w = vim.opt.columns:get()
          --     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          --     local window_w = screen_w * WIDTH_RATIO
          --     local window_h = screen_h * HEIGHT_RATIO
          --     local window_w_int = math.floor(window_w)
          --     local window_h_int = math.floor(window_h)
          --     local center_x = (screen_w - window_w) / 2
          --     local center_y = ((vim.opt.lines:get() - window_h) / 2)
          --         - vim.opt.cmdheight:get()
          --     return {
          --       border = 'rounded',
          --       relative = 'editor',
          --       row = center_y,
          --       col = center_x,
          --       width = window_w_int,
          --       height = window_h_int,
          --     }
          --   end,
          -- },
          -- width = function()
          --   return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          -- end,
        },
        renderer = {
          indent_markers = {
            enable = true,
            icons = {
              -- corner = "└ ",
              corner = "│ ",
              edge = "│ ",
              none = "  ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "after",
            diagnostics_placement = "after",
            bookmarks_placement = "signcolumn",
            padding = " ",
            symlink_arrow = " ➛ ",
            -- symlink_arrow = "  ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
              diagnostics = true,
              bookmarks = true,
            },
            glyphs = {
              -- default = circle,
              -- default = "〣",
              -- default = "",
              -- default = "",
              default = "",
              modified = "[!]",
              -- modified = "",
              -- default = "",
              -- default = "",
              -- default = "",
              -- default = "",
              -- default = "🀪",
              -- default = "🀀",
              -- default = "",
              -- default = "🀅",
              -- default = "📰",
              -- default = "",
              -- default = "🗃",
              symlink = "",
              folder = {
                arrow_closed = "",
                -- arrow_closed = "",
                -- arrow_open = "",
                -- arrow_closed = "",
                -- arrow_open = "",
                arrow_open = "",
                -- default = "",
                -- open = "",
                -- default = "",
                -- open = "",
                -- default = "",
                default = "",
                open = "",
                -- open = "",
                empty = "󱞞",
                empty_open = "󱞞",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                -- unstaged = "",
                -- unstaged = "",
                -- staged = "",

                -- unstaged = "",
                -- staged = "",
                -- unstaged = "M",
                -- unstaged = "",
                -- unstaged = "󱈸",
                -- unstaged = "󰐾 ",
                -- staged = "󰐾 ",
                -- staged = "",
                -- staged = ""
                -- staged = "",
                -- unstaged = "",
                staged = "+",
                unstaged = "!",
                -- unstaged = "󰀨 ",
                -- staged = "󰀨 ",
                -- staged = "󰐗 ",
                -- staged = "󱇭 ",
                -- staged = "   󰧞 󰺕 󰐾  󰻂           󰗖     "
                -- staged = "󱤧 ",
                -- unstaged = "!",
                -- staged = "+",
                -- unstaged = "!",
                -- staged = "+",
                -- unmerged = "",
                -- renamed = "➜",
                renamed = "󰕛 ",
                -- renamed = " ",
                -- unmerged = "",
                unmerged = " ",
                -- untracked = "★",
                -- untracked = "",
                untracked = "?",
                -- deleted = "",
                -- deleted = "✗",
                deleted = "󰧧",
                -- ignored = "◌",
                -- ignored = " "
                ignored = " ",
              },
            },
          },
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = false,
          update_root = { enable = false },
        },
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = false,
          debounce_delay = 30,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            -- hint = "",
            -- hint = "",
            hint = "󰠠 ",
            -- info = "",
            info = " ",
            warning = " ",
            error = " ",
          },
        },
        filters = {
          dotfiles = false,
          custom = {},
          exclude = {},
        },
        git = {
          ignore = false,
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = false,
          disable_for_dirs = {},
          timeout = 4000,
          cygwin_support = false,
        },
        filesystem_watchers = {
          enable = false,
          debounce_delay = 30,
          ignore_dirs = { "node_modules" },
        },
        actions = {
          use_system_clipboard = true,
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "rounded",
              style = "minimal",
            },
          },
          change_dir = {
            enable = true,
            global = true,
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = false,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            git = false,
            profile = false,
          },
        },
      }) -- END_DEFAULT_OPTS

      vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
      vim.cmd([[hi NvimTreeRootFolder gui=none]])
      vim.cmd([[highlight NvimTreeGitDirty guifg=#F9E2AF]])
      vim.cmd([[highlight NvimTreeGitStaged guifg=#8ee2cf]])
      vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F5C2E7]])
      -- vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F38BA8]])
      vim.cmd([[highlight NvimTreeModifiedFile gui=none guifg=#737aa2]])
      -- vim.cmd [[highlight NvimTreeModifiedFile gui=none guifg=#EFF1F5]]
      vim.cmd([[highlight NvimTreeGitNew guifg=#89ddff]])
      vim.cmd([[highlight NvimTreeCursorLine guibg=#3b4261]])
      vim.cmd([[highlight NvimTreeStatusLineNC guibg=none]])
    end,
  },
}
