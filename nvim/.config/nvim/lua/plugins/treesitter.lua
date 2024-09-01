-- return {}
return {
  -- {
  --   "tzachar/local-highlight.nvim",
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     require("local-highlight").setup({
  --       file_types = { 'rs', 'rust', 'python', 'typescript', 'javascript' },
  --       hlgroup = "Search",
  --       -- cw_hlgroup = "Error",
  --     })
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    dependencies = { 'nvim-treesitter/nvim-treesitter-refactor' },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      -- import nvim-treesitter plugin safely
      local status, treesitter = pcall(require, "nvim-treesitter.configs")
      if not status then
        return
      end

      -- configure treesitter
      treesitter.setup({
        refactor = {
          highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
          },
        },

        -- enable syntax highlighting
        -- refactor = {
        -- 	navigation = { enable = false },
        -- 	highlight_current_scope = { enable = false },
        -- 	smart_rename = {
        -- 		enable = false,
        -- 		-- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
        -- 		keymaps = {
        -- 			smart_rename = "grr",
        -- 		},
        -- 	},
        -- 	highlight_definitions = {
        -- 		enable = true,
        -- 		-- Set to false if you have an `updatetime` of ~100.
        -- 		clear_on_cursor_move = false,
        -- 	},
        -- },
        highlight = {
          enable = true,
          disable = function(lang, bufnr) -- Disable in large .json files like in package-lock.json
            -- if lang == "yaml" or lang == "yml" then
            --   return true
            -- end

            return lang == "json" and vim.api.nvim_buf_line_count(bufnr) > 10000
          end,
          additional_vim_regex_highlighting = true,
        },
        sync_install = true,
        -- ignore_install = { "yaml" },
        ignore_install = {},
        modules = {},
        -- enable indentation
        indent = { enable = true },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = { enable = true },
        -- ensure these language parsers are installed
        ensure_installed = {
          "json",
          "jsonc",
          "json5",
          "angular",
          "gitignore",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "vimdoc",
          "luadoc",
          "vim",
          "lua",
          "markdown",
          "javascript",
          "xml",
          "http",
          "java",
          "jq",
          "jsdoc",
          "groovy",
          "typescript",
          "tsx",
          "yaml",
          "html",
          "css",
          -- "sql",
          "markdown",
          "markdown_inline",
          -- "svelte",
          "graphql",
          "bash",
          "lua",
          "luadoc",
          "vim",
          "dockerfile",
          "rust",
          "cpp",
          -- "dap_repl",
          "regex",
        },
        -- auto install above language parsers
        auto_install = true,
        rainbow = {
          enable = true,
          disable = { "html" },
          -- query = 'rainbow-parens',
          -- strategy = require('ts-rainbow').strategy.global
          -- extended_mode = true,
          -- max_file_lines = nil,
          colors = {
            -- vscode
            -- "#DCDCAA",
            -- "#569CD6",
            -- "#9CDCFE",

            -- catpuccin
            "#C6A0F6",
            "#8AADF4",
            "#F0C6C6",

            -- tokyo
            -- "#7aa2f7",
            -- "#2ac3de",
            -- "#9d7cd8",
          }, -- table of hex strings
          -- termcolors = {} -- table of colour name strings
        },
        matchup = {
          enable = true,
          disable_virtual_text = false,
        },
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true of false
            include_surrounding_whitespace = false,
          },
        },
      })
    end,
  },
  {
    cmd = { "TSPlaygroundToggle" },
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    affects = "nvim-treesitter",
    -- event = "VeryLazy",
    config = function()
      require("treesitter-context").setup({
        enable = true,     -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 4,     -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        zindex = 20, -- The Z-index of the context window
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        -- on_attach = function(bufnr)
        --   return vim.bo[bufnr].filetype ~= 'DiffviewFiles'
        -- end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    -- event = "VeryLazy",
    after = "nvim-treesitter/nvim-treesitter",
    -- dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
