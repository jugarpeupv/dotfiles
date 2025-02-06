return {
  {
    "tanvirtin/vgit.nvim",
    branch = "v1.0.x",
    enabled = true,
    keys = {
      {
        mode = { "n" },
        "<leader>vd",
        function()
          require("vgit").project_diff_preview()
        end,
      },
    },
    -- or               , tag = 'v1.0.2',
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = "BufReadPre",
    config = function()
      require("vgit").setup({
        keymaps = {
          ["n <C-p>"] = function()
            require("vgit").hunk_up()
          end,
          ["n <C-n>"] = function()
            require("vgit").hunk_down()
          end,
          ["n <leader>vs"] = function()
            -- require("vgit").buffer_hunk_stage()
            require("vgit").project_stash_preview()
          end,
          ["n <leader>vc"] = function()
            require("vgit").project_commit_preview()
          end,
          -- ["n <leader>vr"] = function()
          --   require("vgit").buffer_hunk_reset()
          -- end,
          -- ["n <leader>Ge"] = function()
          --   require("vgit").buffer_hunk_preview()
          -- end,
          -- ["n <leader>Gb"] = function()
          --   require("vgit").buffer_blame_preview()
          -- end,
          ["n <leader>vb"] = function()
            require("vgit").buffer_diff_preview()
          end,
          ["n <leader>vh"] = function()
            require("vgit").buffer_history_preview()
          end,
          -- ["n <leader>Gu"] = function()
          --   require("vgit").buffer_reset()
          -- end,
          ["n <leader>vd"] = function()
            require("vgit").project_diff_preview()
          end,
          -- ["n <leader>Gx"] = function()
          --   require("vgit").toggle_diff_preference()
          -- end,
        },
        settings = {
          -- You can either allow corresponding mapping for existing hl, or re-define them yourself entirely.
          hls = {
            GitCount = "Keyword",
            GitSymbol = "CursorLineNr",
            GitTitle = "Directory",
            GitSelected = "QuickfixLine",
            GitBackground = "Normal",
            GitAppBar = "Normal",
            GitHeader = "Normal",
            GitFooter = "Normal",
            GitBorder = "LineNr",
            GitLineNr = "LineNr",
            GitComment = "Comment",
            -- GitSignsAdd = {
            --   gui = nil,
            --   fg = "#d7ffaf",
            --   bg = nil,
            --   sp = nil,
            --   override = false,
            -- },
            -- GitSignsChange = {
            --   gui = nil,
            --   fg = "#7AA6DA",
            --   bg = nil,
            --   sp = nil,
            --   override = false,
            -- },
            -- GitSignsDelete = {
            --   gui = nil,
            --   fg = "#e95678",
            --   bg = nil,
            --   sp = nil,
            --   override = false,
            -- },
            -- GitSignsAddLn = "DiffAdd",
            -- GitSignsDeleteLn = "DiffDelete",
            -- GitWordAdd = {
            --   gui = nil,
            --   fg = nil,
            --   bg = "#5d7a22",
            --   sp = nil,
            --   override = false,
            -- },
            -- GitWordDelete = {
            --   gui = nil,
            --   fg = nil,
            --   bg = "#960f3d",
            --   sp = nil,
            --   override = false,
            -- },
            -- GitConflictCurrentMark = "DiffAdd",
            -- GitConflictAncestorMark = "Visual",
            -- GitConflictIncomingMark = "DiffChange",
            -- GitConflictCurrent = "DiffAdd",
            -- GitConflictAncestor = "Visual",
            -- GitConflictMiddle = "Visual",
            -- GitConflictIncoming = "DiffChange",
          },
          live_blame = {
            enabled = false,
            format = function(blame, git_config)
              local config_author = git_config["user.name"]
              local author = blame.author
              if config_author == author then
                author = "You"
              end
              local time = os.difftime(os.time(), blame.author_time) / (60 * 60 * 24 * 30 * 12)
              local time_divisions = {
                { 1,  "years" },
                { 12, "months" },
                { 30, "days" },
                { 24, "hours" },
                { 60, "minutes" },
                { 60, "seconds" },
              }
              local counter = 1
              local time_division = time_divisions[counter]
              local time_boundary = time_division[1]
              local time_postfix = time_division[2]
              while time < 1 and counter ~= #time_divisions do
                time_division = time_divisions[counter]
                time_boundary = time_division[1]
                time_postfix = time_division[2]
                time = time * time_boundary
                counter = counter + 1
              end
              local commit_message = blame.commit_message
              if not blame.committed then
                author = "You"
                commit_message = "Uncommitted changes"
                return string.format(" %s • %s", author, commit_message)
              end
              local max_commit_message_length = 255
              if #commit_message > max_commit_message_length then
                commit_message = commit_message:sub(1, max_commit_message_length) .. "..."
              end
              return string.format(
                " %s, %s • %s",
                author,
                string.format(
                  "%s %s ago",
                  time >= 0 and math.floor(time + 0.5) or math.ceil(time - 0.5),
                  time_postfix
                ),
                commit_message
              )
            end,
          },
          live_gutter = {
            enabled = true,
            edge_navigation = true, -- This allows users to navigate within a hunk
          },
          scene = {
            diff_preference = "unified", -- unified or split
            keymaps = {
              quit = "q",
            },
          },
          diff_preview = {
            keymaps = {
              reset = "r",
              buffer_stage = "S",
              buffer_unstage = "U",
              buffer_hunk_stage = "s",
              buffer_hunk_unstage = "u",
              toggle_view = "t",
            },
          },
          project_diff_preview = {
            keymaps = {
              commit = "C",
              buffer_stage = "s",
              buffer_unstage = "u",
              buffer_hunk_stage = "gs",
              buffer_hunk_unstage = "gu",
              buffer_reset = "r",
              stage_all = "S",
              unstage_all = "U",
              reset_all = "R",
            },
          },
          project_stash_preview = {
            keymaps = {
              add = "A",
              apply = "a",
              pop = "p",
              drop = "d",
              clear = "C",
            },
          },
          project_logs_preview = {
            keymaps = {
              previous = "-",
              next = "=",
            },
          },
          project_commit_preview = {
            keymaps = {
              save = "S",
            },
          },
          signs = {
            priority = 10,
            definitions = {
              -- The sign definitions you provide will automatically be instantiated for you.
              GitConflictCurrentMark = {
                linehl = "GitConflictCurrentMark",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictAncestorMark = {
                linehl = "GitConflictAncestorMark",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictIncomingMark = {
                linehl = "GitConflictIncomingMark",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictCurrent = {
                linehl = "GitConflictCurrent",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictAncestor = {
                linehl = "GitConflictAncestor",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictMiddle = {
                linehl = "GitConflictMiddle",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitConflictIncoming = {
                linehl = "GitConflictIncoming",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitSignsAddLn = {
                linehl = "GitSignsAddLn",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitSignsDeleteLn = {
                linehl = "GitSignsDeleteLn",
                texthl = nil,
                numhl = nil,
                icon = nil,
                text = "",
              },
              GitSignsAdd = {
                texthl = "GitSignsAdd",
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = "┃",
              },
              GitSignsDelete = {
                texthl = "GitSignsDelete",
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = "┃",
              },
              GitSignsChange = {
                texthl = "GitSignsChange",
                numhl = nil,
                icon = nil,
                linehl = nil,
                text = "┃",
              },
            },
            usage = {
              -- Please ensure these signs are defined.
              screen = {
                add = "GitSignsAddLn",
                remove = "GitSignsDeleteLn",
                conflict_current_mark = "GitConflictCurrentMark",
                conflict_current = "GitConflictCurrent",
                conflict_middle = "GitConflictMiddle",
                conflict_incoming_mark = "GitConflictIncomingMark",
                conflict_incoming = "GitConflictIncoming",
                conflict_ancestor_mark = "GitConflictAncestorMark",
                conflict_ancestor = "GitConflictAncestor",
              },
              main = {
                add = "GitSignsAdd",
                remove = "GitSignsDelete",
                change = "GitSignsChange",
              },
            },
          },
          symbols = {
            void = "⣿",
            open = "",
            close = "",
          },
        },
      })
    end,
  },

  {
    "NeogitOrg/neogit",
    cmd = { "Neogit" },
    keys = {
      {
        "<leader>ng",
        "<cmd>Neogit<cr>",
      },
    },
    dependencies = {
      "junegunn/fzf",
      "nvim-lua/plenary.nvim",      -- required
      "sindrets/diffview.nvim",     -- optional - Diff integration
      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",           -- optional
      -- "echasnovski/mini.pick",      -- optional
    },
    config = function()
      local neogit = require("neogit")

      neogit.setup({
        -- Hides the hints at the top of the status buffer
        disable_hint = false,
        -- Disables changing the buffer highlights based on where the cursor is.
        disable_context_highlighting = true,
        -- Disables signs for sections/items/hunks
        disable_signs = false,
        -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
        -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
        -- normal mode.
        disable_insert_on_commit = "auto",
        -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
        -- events.
        filewatcher = {
          interval = 1000,
          enabled = true,
        },
        -- "ascii"   is the graph the git CLI generates
        -- "unicode" is the graph like https://github.com/rbong/vim-flog
        -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
        graph_style = "kitty",
        -- Show relative date by default. When set, use `strftime` to display dates
        commit_date_format = nil,
        log_date_format = nil,
        -- Show message with spinning animation when a git command is running.
        process_spinner = false,
        -- Used to generate URL's for branch popup action "pull request".
        git_services = {
          ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
          ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
          ["gitlab.com"] =
          "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
          ["azure.com"] =
          "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
        },
        -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
        -- sorter instead. By default, this function returns `nil`.
        telescope_sorter = function()
          return require("telescope").extensions.fzf.native_fzf_sorter()
        end,
        -- Persist the values of switches/options within and across sessions
        remember_settings = true,
        -- Scope persisted settings on a per-project basis
        use_per_project_settings = true,
        -- Table of settings to never persist. Uses format "Filetype--cli-value"
        ignored_settings = {
          "NeogitPushPopup--force-with-lease",
          "NeogitPushPopup--force",
          "NeogitPullPopup--rebase",
          "NeogitCommitPopup--allow-empty",
          "NeogitRevertPopup--no-edit",
        },
        -- Configure highlight group features
        highlight = {
          italic = true,
          bold = true,
          underline = true,
        },
        -- Set to false if you want to be responsible for creating _ALL_ keymappings
        use_default_keymaps = true,
        -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
        -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
        auto_refresh = true,
        -- Value used for `--sort` option for `git branch` command
        -- By default, branches will be sorted by commit date descending
        -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
        -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
        sort_branches = "-committerdate",
        -- Default for new branch name prompts
        initial_branch_name = "",
        -- Change the default way of opening neogit
        kind = "tab",
        -- Disable line numbers
        disable_line_numbers = true,
        -- Disable relative line numbers
        disable_relative_line_numbers = true,
        -- The time after which an output console is shown for slow running commands
        console_timeout = 2000,
        -- Automatically show console if a command takes more than console_timeout milliseconds
        auto_show_console = true,
        -- Automatically close the console if the process exits with a 0 (success) status
        auto_close_console = true,
        notification_icon = "󰊢",
        status = {
          show_head_commit_hash = true,
          recent_commit_count = 10,
          HEAD_padding = 10,
          HEAD_folded = false,
          mode_padding = 3,
          mode_text = {
            M = "modified",
            N = "new file",
            A = "added",
            D = "deleted",
            C = "copied",
            U = "updated",
            R = "renamed",
            DD = "unmerged",
            AU = "unmerged",
            UD = "unmerged",
            UA = "unmerged",
            DU = "unmerged",
            AA = "unmerged",
            UU = "unmerged",
            ["?"] = "",
          },
        },
        commit_editor = {
          kind = "tab",
          show_staged_diff = true,
          -- Accepted values:
          -- "split" to show the staged diff below the commit editor
          -- "vsplit" to show it to the right
          -- "split_above" Like :top split
          -- "vsplit_left" like :vsplit, but open to the left
          -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
          staged_diff_split_kind = "split",
          spell_check = true,
        },
        commit_select_view = {
          kind = "tab",
        },
        commit_view = {
          kind = "vsplit",
          verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
        },
        log_view = {
          kind = "tab",
        },
        rebase_editor = {
          kind = "auto",
        },
        reflog_view = {
          kind = "tab",
        },
        merge_editor = {
          kind = "auto",
        },
        description_editor = {
          kind = "auto",
        },
        tag_editor = {
          kind = "auto",
        },
        preview_buffer = {
          kind = "floating_console",
        },
        popup = {
          kind = "split",
        },
        stash = {
          kind = "tab",
        },
        refs_view = {
          kind = "tab",
        },
        signs = {
          -- { CLOSED, OPENED }
          hunk = { "", "" },
          item = { ">", "v" },
          section = { ">", "v" },
        },
        -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
        integrations = {
          -- If enabled, use telescope for menu selection rather than vim.ui.select.
          -- Allows multi-select and some things that vim.ui.select doesn't.
          telescope = true,
          -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
          -- The diffview integration enables the diff popup.
          --
          -- Requires you to have `sindrets/diffview.nvim` installed.
          diffview = true,

          -- If enabled, uses fzf-lua for menu selection. If the telescope integration
          -- is also selected then telescope is used instead
          -- Requires you to have `ibhagwan/fzf-lua` installed.
          fzf_lua = nil,

          -- If enabled, uses mini.pick for menu selection. If the telescope integration
          -- is also selected then telescope is used instead
          -- Requires you to have `echasnovski/mini.pick` installed.
          mini_pick = nil,
        },
        sections = {
          -- Reverting/Cherry Picking
          sequencer = {
            folded = false,
            hidden = false,
          },
          untracked = {
            folded = false,
            hidden = false,
          },
          unstaged = {
            folded = false,
            hidden = false,
          },
          staged = {
            folded = false,
            hidden = false,
          },
          stashes = {
            folded = true,
            hidden = false,
          },
          unpulled_upstream = {
            folded = true,
            hidden = false,
          },
          unmerged_upstream = {
            folded = false,
            hidden = false,
          },
          unpulled_pushRemote = {
            folded = true,
            hidden = false,
          },
          unmerged_pushRemote = {
            folded = false,
            hidden = false,
          },
          recent = {
            folded = true,
            hidden = false,
          },
          rebase = {
            folded = true,
            hidden = false,
          },
        },
        mappings = {
          commit_editor = {
            ["q"] = "Close",
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
            ["<m-p>"] = "PrevMessage",
            ["<m-n>"] = "NextMessage",
            ["<m-r>"] = "ResetMessage",
          },
          commit_editor_I = {
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
          },
          rebase_editor = {
            ["p"] = "Pick",
            ["r"] = "Reword",
            ["e"] = "Edit",
            ["s"] = "Squash",
            ["f"] = "Fixup",
            ["x"] = "Execute",
            ["d"] = "Drop",
            ["b"] = "Break",
            ["q"] = "Close",
            ["<cr>"] = "OpenCommit",
            ["gk"] = "MoveUp",
            ["gj"] = "MoveDown",
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
            ["[c"] = "OpenOrScrollUp",
            ["]c"] = "OpenOrScrollDown",
          },
          rebase_editor_I = {
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
          },
          finder = {
            ["<cr>"] = "Select",
            ["<c-c>"] = "Close",
            ["<esc>"] = "Close",
            ["<c-n>"] = "Next",
            ["<c-p>"] = "Previous",
            ["<down>"] = "Next",
            ["<up>"] = "Previous",
            ["<tab>"] = "InsertCompletion",
            ["<space>"] = "MultiselectToggleNext",
            ["<s-space>"] = "MultiselectTogglePrevious",
            ["<c-j>"] = "NOP",
            ["<ScrollWheelDown>"] = "ScrollWheelDown",
            ["<ScrollWheelUp>"] = "ScrollWheelUp",
            ["<ScrollWheelLeft>"] = "NOP",
            ["<ScrollWheelRight>"] = "NOP",
            ["<LeftMouse>"] = "MouseClick",
            ["<2-LeftMouse>"] = "NOP",
          },
          -- Setting any of these to `false` will disable the mapping.
          popup = {
            ["?"] = "HelpPopup",
            ["A"] = "CherryPickPopup",
            ["d"] = "DiffPopup",
            ["M"] = "RemotePopup",
            ["P"] = "PushPopup",
            ["X"] = "ResetPopup",
            ["Z"] = "StashPopup",
            ["i"] = "IgnorePopup",
            ["t"] = "TagPopup",
            ["b"] = "BranchPopup",
            ["B"] = "BisectPopup",
            ["w"] = "WorktreePopup",
            ["c"] = "CommitPopup",
            ["f"] = "FetchPopup",
            ["l"] = "LogPopup",
            ["m"] = "MergePopup",
            ["p"] = "PullPopup",
            ["r"] = "RebasePopup",
            ["v"] = "RevertPopup",
          },
          status = {
            ["j"] = "MoveDown",
            ["k"] = "MoveUp",
            ["o"] = "OpenTree",
            ["q"] = "Close",
            ["I"] = "InitRepo",
            ["1"] = "Depth1",
            ["2"] = "Depth2",
            ["3"] = "Depth3",
            ["4"] = "Depth4",
            ["Q"] = "Command",
            ["<tab>"] = "Toggle",
            ["x"] = "Discard",
            ["s"] = "Stage",
            ["S"] = "StageUnstaged",
            ["<c-s>"] = "StageAll",
            ["u"] = "Unstage",
            ["K"] = "Untrack",
            ["U"] = "UnstageStaged",
            ["y"] = "ShowRefs",
            ["$"] = "CommandHistory",
            ["Y"] = "YankSelected",
            ["<c-r>"] = "RefreshBuffer",
            ["<cr>"] = "GoToFile",
            ["<s-cr>"] = "PeekFile",
            ["<c-v>"] = "VSplitOpen",
            ["<c-x>"] = "SplitOpen",
            ["<c-t>"] = "TabOpen",
            ["{"] = "GoToPreviousHunkHeader",
            ["}"] = "GoToNextHunkHeader",
            ["[c"] = "OpenOrScrollUp",
            ["]c"] = "OpenOrScrollDown",
            ["<c-k>"] = "PeekUp",
            ["<c-j>"] = "PeekDown",
            ["<c-n>"] = "NextSection",
            ["<c-p>"] = "PreviousSection",
          },
        },
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    -- event = "VeryLazy",
    -- cmd = { "DiffviewOpen" },
    -- event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "junegunn/fzf",
      "nvim-telescope/telescope.nvim",
      "akinsho/git-conflict.nvim",
    },
    keys = {
      { "<leader>gd", mode = "n",     "<cmd>DiffviewOpen<cr>" },
      { "<leader>cc", mode = "n",     "<cmd>DiffviewClose<cr>" },
      { "<leader>gv", mode = { "v" }, "<cmd>'<,'>DiffviewFileHistory<cr>" },
      { "<leader>gv", mode = { "n" }, "<cmd>DiffviewFileHistory %<cr>" },
      { "<leader>ll", mode = "n",     "<CMD>DiffviewFileHistory --range=HEAD<CR>" },
      { "<leader>l5", mode = "n",     "<CMD>DiffviewFileHistory --range=HEAD~50..HEAD<CR>" },
      { "<leader>l0", mode = "n",     "<CMD>DiffviewFileHistory --range=HEAD~10..HEAD<CR>" },
    },
    config = function()
      -- vim.cmd([[hi StatusLine guifg=#cdd6f5 guibg=#292e42]])
      -- Lua
      local actions = require("diffview.actions")

      require("diffview").setup({
        diff_binaries = false, -- Show diffs for binaries
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        git_cmd = { "git" }, -- The git executable followed by default args.
        use_icons = true,    -- Requires nvim-web-devicons
        watch_index = true,  -- Update views and index buffers when the git index changes.
        icons = {            -- Only applies when use_icons is true.
          folder_closed = "",
          folder_open = "",
        },
        signs = {
          -- fold_closed = "",
          -- fold_open = "",
          done = "✓",
          folder_closed = "",
          folder_open = "",
          -- folder_closed = "",
          -- folder_open = "",
        },
        view = {
          -- Configure the layout and behavior of different types of views.
          -- Available layouts:
          --  'diff1_plain'
          --    |'diff2_horizontal'
          --    |'diff2_vertical'
          --    |'diff3_horizontal'
          --    |'diff3_vertical'
          --    |'diff3_mixed'
          --    |'diff4_mixed'
          -- For more info, see ':h diffview-config-view.x.layout'.
          default = {
            -- Config for changed files, and staged files in diff views.
            layout = "diff2_horizontal",
          },
          merge_tool = {
            -- Config for conflicted files in diff views during a merge or rebase.
            -- layout = "diff3_mixed",
            -- layout = "diff3_horizontal",
            -- layout = "diff3_mixed",
            -- layout = "diff1_plain",
            layout = "diff1_plain",
            disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
          },
          file_history = {
            -- Config for changed files in file history views.
            layout = "diff2_horizontal",
          },
        },
        file_panel = {
          listing_style = "tree",      -- One of 'list' or 'tree'
          tree_options = {             -- Only applies when listing_style is 'tree'
            flatten_dirs = true,       -- Flatten dirs that only contain one single dir
            folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
          },
          -- win_config = {                      -- See ':h diffview-config-win_config'
          --   position = "left",
          --   width = 35,
          --   win_opts = {}
          -- },
          win_config = { -- See ':h diffview-config-win_config'
            position = "left",
            -- height = 7,
            win_opts = {},
          },
          -- win_config = function()
          --   local c = { type = "float" }
          --   local editor_width = vim.o.columns
          --   local editor_height = vim.o.lines
          --   c.width = math.min(100, editor_width)
          --   c.height = math.min(24, editor_height)
          --   c.col = math.floor(editor_width * 0.5 - c.width * 0.5)
          --   c.row = math.floor(editor_height * 0.5 - c.height * 0.5)
          --   return c
          -- end,
          -- win_config = function()
          --   return {
          --     type = "split",
          --     position = "bottom"
          --   }
          -- end
          -- win_config = {
          --   type = "split",
          --   position = "right",
          --   width = 40,
          -- }
        },
        file_history_panel = {
          -- log_options = {   -- See ':h diffview-config-log_options'
          --   single_file = {
          --     diff_merges = "combined",
          --   },
          --   multi_file = {
          --     diff_merges = "first-parent",
          --   },
          -- },
          win_config = { -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 16,
            win_opts = {},
          },
        },
        commit_log_panel = {
          win_config = { -- See ':h diffview-config-win_config'
            win_opts = {},
          },
        },
        default_args = { -- Default args prepended to the arg-list for the listed commands
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {
          diff_buf_win_enter = function(bufnr, winid, ctx)
            -- print("bufnr: ", bufnr)
            -- print("ctx: ", vim.inspect(ctx))
            -- print("winid: ", winid)
            -- if winid == 1004 or ctx.symbol == 'b' then
            --   vim.api.nvim_buf_set_option('wrap', true, { buf = bufnr})
            -- end

            vim.api.nvim_buf_set_option(bufnr, "wrap", false)

            -- vim.keymap.set({ "n" }, "<leader>sn", function()
            --   -- vim.wo.wrap = not vim.wo.wrap
            --   vim.cmd("windo set wrap!")
            -- end, { buffer = bufnr, noremap = true, silent = true })
          end,
          -- diff_buf_read = function(bufnr, win)
          --   print("win: ", vim.inspect(win))
          --   -- print('bufnr', bufnr)
          --   -- print('bufname', vim.api.nvim_buf_get_name(bufnr))
          --   -- vim.treesitter.stop(bufnr)
          --   -- local max_filesize = 900 * 1024 -- 100 KB
          --   -- local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          --   -- if ok and stats and stats.size > max_filesize then
          --   --   print('pasando por aqui')
          --   --   vim.cmd("set syntax=OFF")
          --   --   vim.treesitter.stop(bufnr)
          --   -- end
          --   -- vim.api.nvim_buf_set_option('wrap', true, { buf = bufnr})
          -- end,
          ---@param view StandardView
          view_opened = function(view)
            -- require("diffview.actions").toggle_files()
            local utils = require("jg.core.utils")
            require("barbecue.ui").toggle(false)

            -- vim.lsp.inlay_hint.enable(false)
            -- vim.cmd [[set nocursorline]]
            -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
            -- the right.
            local function post_layout()
              utils.tbl_ensure(view, "winopts.diff2.a")
              utils.tbl_ensure(view, "winopts.diff2.b")
              -- left
              view.winopts.diff2.a = utils.tbl_union_extend(view.winopts.diff2.a, {
                winhl = {
                  "DiffChange:DiffAddAsDelete",
                  "DiffText:DiffDeleteText",
                },
              })
              -- right
              view.winopts.diff2.b = utils.tbl_union_extend(view.winopts.diff2.b, {
                winhl = {
                  "DiffChange:DiffAdd",
                  "DiffText:DiffAddText",
                },
              })
            end
            vim.cmd("hi DiffviewDiffAddAsDelete guifg=none")
            view.emitter:on("post_layout", post_layout)
            post_layout()
          end,
          view_closed = function()
            require("barbecue.ui").toggle(true)
          end,
        },                    -- See ':h diffview-config-hooks'
        keymaps = {
          disable_defaults = true, -- Disable the default keymaps
          view = {
            -- The `view` bindings are active in the diff buffers, only when the current
            -- tabpage is a Diffview.
            ["<tab>"] = actions.select_next_entry,        -- Open the diff for the next file
            ["<s-tab>"] = actions.select_prev_entry,      -- Open the diff for the previous file
            ["gf"] = actions.goto_file,                   -- Open the file in a new split in the previous tabpage
            ["<C-w><C-f>"] = actions.goto_file_split,     -- Open the file in a new split
            ["<C-w>gf"] = actions.goto_file_tab,          -- Open the file in a new tabpage
            ["<M-k>"] = actions.focus_files,              -- Bring focus to the file panel
            ["<M-j>"] = actions.toggle_files,             -- Toggle the file panel.
            ["<BS>"] = actions.cycle_layout,
            ["[x"] = actions.prev_conflict,               -- In the merge_tool: jump to the previous conflict
            ["]x"] = actions.next_conflict,               -- In the merge_tool: jump to the next conflict
            ["X"] = actions.restore_entry,                -- Restore entry to the state on the left side.
            ["-"] = actions.toggle_stage_entry,           -- Stage / unstage the selected entry.
            ["<leader>ck"] = actions.prev_conflict,       -- In the merge_tool: jump to the previous conflict
            ["<leader>cj"] = actions.next_conflict,       -- In the merge_tool: jump to the next conflict
            ["<leader>co"] = actions.conflict_choose("ours"), -- Choose the OURS version of a conflict
            ["<leader>ct"] = actions.conflict_choose("theirs"), -- Choose the THEIRS version of a conflict
            ["<leader>cb"] = actions.conflict_choose("base"), -- Choose the BASE version of a conflict
            ["<leader>ca"] = actions.conflict_choose("all"), -- Choose all the versions of a conflict
            ["dx"] = actions.conflict_choose("none"),     -- Delete the conflict region
          },
          diff1 = { --[[ Mappings in single window diff layouts ]]
          },
          diff2 = { --[[ Mappings in 2-way diff layouts ]]
          },
          diff3 = {
            -- Mappings in 3-way diff layouts
            { { "n", "x" }, "2do", actions.diffget("ours") }, -- Obtain the diff hunk from the OURS version of the file
            { { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            { { "n", "x" }, "1do", actions.diffget("base") }, -- Obtain the diff hunk from the BASE version of the file
            { { "n", "x" }, "2do", actions.diffget("ours") }, -- Obtain the diff hunk from the OURS version of the file
            { { "n", "x" }, "3do", actions.diffget("theirs") }, -- Obtain the diff hunk from the THEIRS version of the file
          },
          file_panel = {
            ["j"] = actions.next_entry, -- Bring the cursor to the next file entry
            ["<down>"] = actions.next_entry,
            ["k"] = actions.prev_entry, -- Bring the cursor to the previous file entry.
            ["<up>"] = actions.prev_entry,
            ["h"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry, -- Open the diff for the selected entry.
            ["o"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["-"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ["T"] = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
            ["S"] = actions.stage_all,        -- Stage all entries.
            ["U"] = actions.unstage_all,      -- Unstage all entries.
            ["X"] = actions.restore_entry,    -- Restore entry to the state on the left side.
            ["L"] = actions.open_commit_log,  -- Open the commit log panel.
            ["<c-b>"] = actions.scroll_view(-0.25), -- Scroll the view up
            ["<c-f>"] = actions.scroll_view(0.25), -- Scroll the view down
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"] = actions.goto_file_tab,
            ["i"] = actions.listing_style, -- Toggle between 'list' and 'tree' views
            ["f"] = actions.toggle_flatten_dirs, -- Flatten empty subdirectories in tree listing style.
            ["R"] = actions.refresh_files, -- Update stats and entries in the file list.
            ["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
            ["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
            ["<BS>"] = actions.cycle_layout,
            ["[x"] = actions.prev_conflict,
            ["]x"] = actions.next_conflict,
          },
          file_history_panel = {
            ["g!"] = actions.options,         -- Open the option panel
            ["<C-A-d>"] = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
            ["y"] = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
            ["L"] = actions.open_commit_log,
            ["zR"] = actions.open_all_folds,
            ["zM"] = actions.close_all_folds,
            ["j"] = actions.next_entry,
            ["<down>"] = actions.next_entry,
            ["k"] = actions.prev_entry,
            ["<up>"] = actions.prev_entry,
            ["<cr>"] = actions.select_entry,
            ["o"] = actions.select_entry,
            ["<2-LeftMouse>"] = actions.select_entry,
            ["<c-b>"] = actions.scroll_view(-0.25),
            ["<c-f>"] = actions.scroll_view(0.25),
            ["<tab>"] = actions.select_next_entry,
            ["<s-tab>"] = actions.select_prev_entry,
            ["gf"] = actions.goto_file,
            ["<C-w><C-f>"] = actions.goto_file_split,
            ["<C-w>gf"] = actions.goto_file_tab,
            ["<M-k>"] = actions.focus_files, -- Bring focus to the file panel
            ["<M-j>"] = actions.toggle_files, -- Toggle the file panel.
            ["<BS>"] = actions.cycle_layout,
          },
          option_panel = {
            ["<tab>"] = actions.select_entry,
            ["q"] = actions.close,
          },
        },
      })

      -- -- Diffview
      -- local keymap = vim.api.nvim_set_keymap
      -- local opts = { noremap = true, silent = true }
      -- keymap("n", "<Leader>gd", "<cmd>DiffviewOpen<cr>", opts)
      -- keymap("n", "<Leader>cc", "<cmd>DiffviewClose<cr>", opts)
      -- keymap("v", "<Leader>gv", "<cmd>'<,'>DiffviewFileHistory<cr>", opts)
      -- keymap("n", "<Leader>gv", "<cmd>DiffviewFileHistory %<cr>", opts)
      -- -- Diffview
      -- vim.keymap.set("n", "<leader>ll", "<CMD>DiffviewFileHistory --range=HEAD<CR>")
      -- vim.keymap.set("n", "<leader>l5", "<CMD>DiffviewFileHistory --range=HEAD~50..HEAD<CR>")
      -- vim.keymap.set("n", "<leader>l0", "<CMD>DiffviewFileHistory --range=HEAD~10..HEAD<CR>")
    end,
  },
}
