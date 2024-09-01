-- return {}

-- return { "griwes/telescope.nvim", branch = "group-by" }
--
return {
  {
    "dhruvmanila/browser-bookmarks.nvim",
    version = "*",
    cmd = { "Telescope" },
    -- event = "VeryLazy",
    -- dependencies = {
    --   "kkharji/sqlite.lua",
    --   "nvim-telescope/telescope.nvim",
    -- },
    config = function()
      require("browser_bookmarks").setup({
        selected_browser = "chrome",
      })
    end,
  },
  { "nvim-telescope/telescope-smart-history.nvim",  cmd = { "Telescope" } },
  -- { "nvim-telescope/telescope-harpoon.nvim",        cmd = { "Telescope" } },
  -- { "nvim-telescope/telescope-fzf-native.nvim",     cmd = { "Telescope" } },
  { "natecraddock/telescope-zf-native.nvim",        cmd = { "Telescope" } },
  -- { "nvim-telescope/telescope-fzf-native.nvim",     build = "make",            event = "VeryLazy" },
  { "nvim-telescope/telescope-live-grep-args.nvim", cmd = { "Telescope" } },
  { "nvim-telescope/telescope-ui-select.nvim",      cmd = { "Telescope" } },
  -- "griwes/telescope.nvim",
  -- branch = "group-by",
  -- commit = "6f6bb8065567b56c42e283b06e8a1c670c0092a1",
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    tag = "0.1.8",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    -- event = "VeryLazy",
    config = function()
      local open_with_trouble = require("trouble.sources.telescope").open
      -- local egrep_actions = require("telescope._extensions.egrepify.actions")

      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end

      local actions = require("telescope.actions")
      local actions_live_grep_args = require("telescope-live-grep-args.actions")

      telescope.setup({
        defaults = {

          -- prompt_prefix = " ",
          prompt_prefix = "> ",
          history = {
            path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
            limit = 50,
          },
          selection_caret = " ",
          initial_mode = "insert",
          cache_picker = { limit_entries = 100 },
          -- file_ignore_patterns = { "node_modules" },
          -- file_ignore_patterns = { "%__template__" },
          -- path_display = { "smart" },
          -- path_display = { "tail" },
          -- path_display = { shorten = { len = 5, exclude = { -1 } } },
          -- path_display = { shorten = { len = 3, exclude = { -1 } } },
          -- path_display = { "hidden" },
          path_display = { truncate = 5 },
          wrap_results = false,
          vimgrep_arguments = {
            "rg",
            -- "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          layout_strategy = "horizontal",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { width = 0.97, height = 0.9, preview_width = 0.45 },
            vertical = { width = 0.90, height = 0.99, preview_height = 0.35 },
            center = { width = 0.99, height = 0.99 },
            bottom_pane = { width = 0.99, height = 0.99 },
            prompt_position = "top",
          },

          -- preview = {
          --   mime_hook = function(filepath, bufnr, opts)
          --     local is_image = function(filepath)
          --       local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
          --       local split_path = vim.split(filepath:lower(), ".", { plain = true })
          --       local extension = split_path[#split_path]
          --       return vim.tbl_contains(image_extensions, extension)
          --     end
          --     if is_image(filepath) then
          --       local term = vim.api.nvim_open_term(bufnr, {})
          --       local function send_output(_, data, _)
          --         for _, d in ipairs(data) do
          --           vim.api.nvim_chan_send(term, d .. "\r\n")
          --         end
          --       end
          --       vim.fn.jobstart({
          --         "viu",
          --         filepath,
          --         }, {
          --           on_stdout = send_output,
          --           stdout_buffered = true,
          --       })
          --     else
          --       require("telescope.previewers.utils").set_preview_message(
          --         bufnr,
          --         opts.winid,
          --         "Binary cannot be previewed"
          --       )
          --     end
          --   end,
          -- },

          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-Enter>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- ["<C-t>"] = trouble.open_with_trouble,
              ["<C-e>"] = open_with_trouble,
              -- ["<C-t>"] = trouble.open_with_trouble,

              -- ["<C-u>"] = actions.preview_scrolling_up,
              -- ["<C-d>"] = actions.preview_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
              ["<C-a>"] = actions.git_create_branch,
            },

            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              -- ["<C-v>"] = actions.select_vertical,
              ["<C-Enter>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              -- ["<C-t>"] = trouble.open_with_trouble,
              ["<C-e>"] = open_with_trouble,

              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<BS>"] = "delete_buffer",

              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,

              -- ["<C-u>"] = actions.preview_scrolling_up,
              -- ["<C-d>"] = actions.preview_scrolling_down,

              -- ["<PageUp>"] = actions.results_scrolling_up,
              -- ["<PageDown>"] = actions.results_scrolling_down,

              ["<C-u>"] = actions.results_scrolling_up,
              ["<C-d>"] = actions.results_scrolling_down,

              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,

              ["?"] = actions.which_key,
            },
          },
        },
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
          -- find_files = {
          --   theme = "dropdown",
          -- }
          -- live_grep = {
          --   layout_strategy = "vertical",
          --   path_display = { 'hidden' }
          -- },
          git_branches = {
            layout_strategy = "vertical",
          },
        },
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
          ["zf-native"] = {
            -- options for sorting file-like items
            file = {
              -- override default telescope file sorter
              enable = true,

              -- highlight matching text in results
              highlight_results = true,

              -- enable zf filename match priority
              match_filename = true,
            },

            -- options for sorting all other items
            generic = {
              -- override default telescope generic item sorter
              enable = true,

              -- highlight matching text in results
              highlight_results = true,

              -- disable zf filename match priority
              match_filename = true,
            },
          },
          -- fzf = {
          --   fuzzy = true,              -- false will only do exact matching
          --   override_generic_sorter = true, -- override the generic sorter
          --   override_file_sorter = true, -- override the file sorter
          --   case_mode = "smart_case",  -- or "ignore_case" or "respect_case"
          --   -- the default case_mode is "smart_case"
          -- },
          egrepify = {
            -- intersect tokens in prompt ala "str1.*str2" that ONLY matches
            -- if str1 and str2 are consecutively in line with anything in between (wildcard)
            AND = true,             -- default
            permutations = false,   -- opt-in to imply AND & match all permutations of prompt tokens
            lnum = true,            -- default, not required
            lnum_hl = "EgrepifyLnum", -- default, not required, links to `Constant`
            col = false,            -- default, not required
            col_hl = "EgrepifyCol", -- default, not required, links to `Constant`
            title = true,           -- default, not required, show filename as title rather than inline
            filename_hl = "EgrepifyFile", -- default, not required, links to `Title`
            -- suffix = long line, see screenshot
            -- EXAMPLE ON HOW TO ADD PREFIX!
            prefixes = {
              -- ADDED ! to invert matches
              -- example prompt: ! sorter
              -- matches all lines that do not comprise sorter
              -- rg --invert-match -- sorter
              -- DEFAULTS
              -- filter for file suffixes
              -- example prompt: #lua,md $MY_PROMPT
              -- searches with ripgrep prompt $MY_PROMPT in files with extensions lua and md
              -- i.e. rg --glob="*.{lua,md}" -- $MY_PROMPT
              ["#"] = {
                -- #$REMAINDER
                -- # is caught prefix
                -- `input` becomes $REMAINDER
                -- in the above example #lua,md -> input: lua,md
                flag = "glob",
                cb = function(input)
                  return string.format([[*.{%s}]], input)
                end,
              },
              -- filter for (partial) folder names
              -- example prompt: >conf $MY_PROMPT
              -- searches with ripgrep prompt $MY_PROMPT in paths that have "conf" in folder
              -- i.e. rg --glob="**/conf*/**" -- $MY_PROMPT
              [">"] = {
                flag = "glob",
                cb = function(input)
                  return string.format([[**/**{%s}**/**]], input)
                end,
              },
              -- filter for (partial) file names
              -- example prompt: &egrep $MY_PROMPT
              -- searches with ripgrep prompt $MY_PROMPT in paths that have "egrep" in file name
              -- i.e. rg --glob="*egrep*" -- $MY_PROMPT
              ["&"] = {
                flag = "glob",
                cb = function(input)
                  return string.format([[*{%s}*]], input)
                end,
              },
              ["?"] = {
                flag = "no-ignore",
              },
              ["%"] = {
                flag = "word-regexp",
              },
              ["!"] = {
                flag = "invert-match",
              },
              -- HOW TO OPT OUT OF PREFIX
              -- ^ is not a default prefix and safe example
              ["^"] = false,
            },
            -- default mappings
            mappings = {
              i = {
                -- toggle prefixes, prefixes is default
                -- ["<C-z>"] = egrep_actions.toggle_prefixes,
                -- -- toggle AND, AND is default, AND matches tokens and any chars in between
                -- ["<C-a>"] = egrep_actions.toggle_and,
                -- -- toggle permutations, permutations of tokens is opt-in
                -- ["<C-r>"] = egrep_actions.toggle_permutations,
              },
            },
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              prompt_prefix = "> ",
              initial_mode = "normal",
            }),
          },
          live_grep_args = {
            path_display = { "smart" },
            -- layout_strategy = "vertical",
            -- theme = "dropdown",
            -- prompt_position = "bottom",
            -- layout_config = { horizontal = { width = 0.97, height = 0.9, preview_width = 0.40 } },

            -- theme = require("telescope.themes").get_dropdown({
            --   layout_config = { width = 0.90, height = 0.40 },
            --   prompt_prefix = "> ",
            --   prompt_position = "bottom",
            --   -- results_height = 40,
            -- }),
            -- theme = require("telescope.themes").get_dropdown({
            --   layout_config = { width = 0.90, height = 0.40 },
            --   prompt_prefix = "> ",
            --   prompt_position = "bottom"
            -- }),
            auto_quoting = false,
            mappings = {
              i = {
                ["<C-l>"] = actions_live_grep_args.quote_prompt(),
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-i>"] = actions_live_grep_args.quote_prompt({ postfix = " --iglob " }),
                ["<C-f>"] = actions_live_grep_args.quote_prompt({ postfix = " -t" }),
              },
            },
          },
          arecibo = {
            ["selected_engine"] = "google",
            ["url_open_command"] = "xdg-open",
            ["show_http_headers"] = false,
            ["show_domain_icons"] = false,
          },
          media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg", "pdf", "svg" },
            -- find command (defaults to `fd`)
            -- find_cmd = "rg"
          },
          -- fzy_native = {
          --   override_generic_sorter = true,
          --   override_file_sorter = true,
          -- },
          -- bookmarks = {
          --   -- Available: 'brave', 'buku', 'chrome', 'chrome_beta', 'edge', 'safari', 'firefox', 'vivaldi'
          --   selected_browser = "chrome",
          --   profile_name = "MAR",

          --   -- Either provide a shell command to open the URL
          --   url_open_command = "open",

          --   -- Or provide the plugin name which is already installed
          --   -- Available: 'vim_external', 'open_browser'
          --   url_open_plugin = nil,

          --   -- Show the full path to the bookmark instead of just the bookmark name
          --   full_path = true,

          --   -- Provide a custom profile name for Firefox
          --   firefox_profile_name = nil,
          -- },
        },
      })

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      -- telescope.load_extension("fzf")
      telescope.load_extension("harpoon")
      telescope.load_extension("zf-native")
      telescope.load_extension("ui-select")
      telescope.load_extension("bookmarks")
      telescope.load_extension("git_worktree")
      telescope.load_extension("yaml_schema")
      -- telescope.load_extension('media_files')
      -- telescope.load_extension("egrepify")
      -- telescope.load_extension('node_modules')
      -- telescope.load_extension('projects')
      -- telescope.load_extension('node_modules')
      -- telescope.load_extension('arecibo')
      -- require('telescope').load_extension('vim_bookmarks')
      -- require('telescope').load_extension('fzy_native')
      -- require('telescope').load_extension('gh')
      -- require("telescope").load_extension("media_files")
    end,
  },
}
