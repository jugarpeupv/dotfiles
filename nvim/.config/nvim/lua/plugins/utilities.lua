return {
  {
    "OXY2DEV/patterns.nvim",
    cmd = { "Patterns" }
  },
  {
    "andersevenrud/nvim_context_vt",
    -- event = { "BufReadPre", "BufNewFile" },
    opts = {
      enabled = false,
    },
    keys = { { "<leader>co", "<cmd>NvimContextVtToggle<cr>" } },
  },
  -- {
  --   "yuratomo/w3m.vim",
  -- },
  -- {
  --   "luckasRanarison/nvim-devdocs",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   opts = {},
  -- },
  {
    "ragnarok22/whereami.nvim",
    cmd = "Whereami",
  },
  {
    "vzze/calculator.nvim",
    -- cmd = { "Calculate" },
    event = { "BufReadPost" },
    config = function()
      vim.api.nvim_create_user_command(
        "Calculate",
        'lua require("calculator").calculate()',
        { ["range"] = 1, ["nargs"] = 0 }
      )
    end,
  },
  { "sam4llis/nvim-lua-gf", keys = { "gf" } },
  -- { "mrjones2014/tldr.nvim", cmd = { "Tldr", "Telescope" } ,dependencies = { "nvim-telescope/telescope.nvim" } },
  {
    "tldr-pages/tldr-neovim-extension",
    -- enabled = false,
    cmd = { "Tldr", "Telescope" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("tldr").setup()
    end,
  },
  -- {
  --   "matthewmturner/rfsee",
  --   opts = {},
  --   cmd = { "RFSeeIndex", "RFSee" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  -- },
  { "benelori/vim-rfc",     cmd = { "RFC" } },
  {
    "troydm/zoomwintab.vim",
    keys = { { mode = { "n" }, "<c-w>m", "<cmd>ZoomWinTabToggle<CR>" } },
  },
  -- { "dhruvasagar/vim-zoom" },
  {
    "fasterius/simple-zoom.nvim",
    enabled = false,
    config = true,
    opts = {
      hide_tabline = false,
    },
  },
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "json" },
    -- config = function (_, opts)
    --   require("package-info").setup(opts)
    -- end,

    opts = {
      -- colors = {
      --   up_to_date = "#94E2D5", -- Text color for up to date dependency virtual text
      --   outdated = "#313244", -- Text color for outdated dependency virtual text
      --   invalid = "#F38BA8", -- Text color for invalid dependency virtual text
      -- },
      icons = {
        enable = true, -- Whether to display icons
        style = {
          up_to_date = "|  ", -- Icon for up to date dependencies
          outdated = "| 󰃰 ", -- Icon for outdated dependencies
          invalid = "|  ", -- Icon for invalid dependencies
        },
      },
      autostart = false,          -- Whether to autostart when `package.json` is opened
      hide_up_to_date = false,    -- It hides up to date versions when displaying virtual text
      hide_unstable_versions = true, -- It hides unstable versions from version list e.g next-11.1.3-canary3
      -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
      -- The plugin will try to auto-detect the package manager based on
      -- `yarn.lock` or `package-lock.json`. If none are found it will use the
      -- provided one, if nothing is provided it will use `yarn`
      package_manager = "npm",
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      -- manually register them
      vim.cmd("highlight PackageInfoUpToDateVersion guifg=#94E2D5 guibg=#394b70")
      vim.cmd("highlight PackageInfoOutdatedVersion guifg=#747ebd guibg=#394b70")
      vim.cmd("highlight PackageInfoInvalidVersion guifg=#F38BA8 guibg=#394b70")

      -- Show dependency versions
      -- vim.keymap.set({ "n" }, "<leader>ns", require("package-info").show, { silent = true, noremap = true })
      -- vim.api.nvim_set_keymap(
      --   "n",
      --   "<leader>nr",
      --   "<cmd>lua require('package-info').show({ force = true })<cr>",
      --   { silent = true, noremap = true }
      -- )

      -- -- Hide dependency versions
      -- vim.keymap.set({ "n" }, "<leader>nh", require("package-info").hide, { silent = true, noremap = true })

      -- Toggle dependency versions
      vim.keymap.set({ "n" }, "<leader>nt", require("package-info").toggle, { silent = true, noremap = true })

      -- vim.api.nvim_set_keymap(
      --   "n",
      --   "<leader>nt",
      --   "<cmd>lua require('package-info').toggle({ force = true })<cr>",
      --   { silent = true, noremap = true }
      -- )

      -- Update dependency on the line
      vim.keymap.set({ "n" }, "<leader>nu", require("package-info").update, { silent = true, noremap = true })

      -- Delete dependency on the line
      vim.keymap.set({ "n" }, "<leader>nd", require("package-info").delete, { silent = true, noremap = true })

      -- Install a new dependency
      -- vim.keymap.set({ "n" }, "<leader>ni", require("package-info").install, { silent = true, noremap = true })

      -- Install a different dependency version
      vim.keymap.set(
        { "n" },
        "<leader>nc",
        require("package-info").change_version,
        { silent = true, noremap = true }
      )
    end,
  },
  {
    "philosofonusus/ecolog.nvim",
    enabled = true,
    -- dependencies = {
    --   -- "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
    --   "nvim-tree/nvim-tree.lua"
    -- },
    event = { "BufReadPre", "BufNewFile" },
    -- Optional: you can add some keybindings
    -- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
    keys = {
      { "<leader>eg", "<cmd>EcologGoto<cr>",            desc = "Go to env file" },
      { "<leader>ep", "<cmd>EcologPeek<cr>",            desc = "Ecolog peek variable" },
      { "<leader>es", "<cmd>EcologSelect<cr>",          desc = "Switch env file" },
      { "<leader>el", "<cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Shelter Line Peek" },
      { "<leader>et", "<cmd>EcologShelterToggle<cr>",   desc = "Ecolog Shelter Line Peek" },
    },
    lazy = true,
    opts = {
      integrations = {
        -- WARNING: for both cmp integrations see readme section below
        files = true,
        nvim_cmp = true, -- If you dont plan to use nvim_cmp set to false, enabled by default
        -- If you are planning to use blink cmp uncomment this line
        -- blink_cmp = true,
      },
      -- Enables shelter mode for sensitive values
      shelter = {
        configuration = {
          partial_mode = false,
        },
        modules = {
          cmp = true,            -- Mask values in completion
          peek = true,           -- Mask values in peek view
          telescope = true,      -- Mask values in telescope
          telescope_previewer = true, -- Mask values in telescope preview buffers
          files = {
            shelter_on_leave = true, -- Control automatic re-enabling of shelter when leaving buffer
            disable_cmp = true,  -- Disable completion in sheltered buffers (default: true)
            skip_comments = true, -- Skip masking comment lines in environment files (default: false)
          },
        },
      },
      -- true by default, enables built-in types (database_url, url, etc.)
      types = true,
      path = vim.fn.getcwd(),             -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
      env_file_pattern = {
        ".env",
        "^%.env%.%w+$",    -- Matches .env.development, .env.production, etc.
        "^config/env%.%w+$", -- Matches config/env.development, config/env.production, etc.
        "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
        ".+%.zsh$",
        ".+%.zshrc$",
        "^.config/zshrc/.+%.zshrc$",
        "/Users/jgarcia/.config/zshrc/.zshrc",
        "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
        "^.config/zshrc/^%.env%.%w+$", -- Matches config/env.development, config/env.production, etc.
      },
      -- Controls how environment variables are extracted from code and how cmp works
      provider_patterns = true, -- true by default, when false will not check provider patterns
    },

    -- opts = {
    --   integrations = {
    --     lsp = false,
    --     fzf = true,
    --   },
    --   -- Enables shelter mode for sensitive values
    --   shelter = {
    --     configuration = {
    --       partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
    --       mask_char = "*", -- Character used for masking
    --       -- patterns = {
    --       --   ["*_KEY"] = "full", -- Always fully mask API keys
    --       --   ["*_TOKEN"] = "full", -- Always fully mask API keys
    --       --   ["*_PAT"] = "full", -- Always fully mask API keys
    --       --   ["*_KEY_*"] = "full", -- Always fully mask API keys
    --       -- },
    --     },
    --     modules = {
    --       cmp = true,  -- Mask values in completion
    --       peek = false, -- Mask values in peek view
    --       files = true, -- Mask values in files
    --       telescope = true, -- Mask values in telescope
    --     },
    --   },
    --   -- true by default, enables built-in types (database_url, url, etc.)
    --   types = true,
    --   path = vim.fn.getcwd(), -- Path to search for .env files
    --   env_file_pattern = {
    --     "^%.env%.%w+$",       -- Matches .env.development, .env.production, etc.
    --     "^config/env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
    --     "^%.env%.local%.%w+$", -- Matches .env.local.development, .env.local.production, etc.
    --     ".+%.zsh$",
    --     ".+%.zshrc$",
    --     "^.config/zshrc/.+%.zshrc$",
    --     "/Users/jgarcia/.config/zshrc/.zshrc",
    --     "^%.config/zshrc/%.zshrc$", -- Matches .config/zshrc/.zshrc
    --     "^.config/zshrc/^%.env%.%w+$",  -- Matches config/env.development, config/env.production, etc.
    --   },
    --   preferred_environment = "development", -- Optional: prioritize specific env files
    -- },
  },

  { "heavenshell/vim-jsdoc", cmd = { "JsDoc" } },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    keys = { {
      "<leader>le",
      "<cmd>LiveServerToggle<CR>",
    } },
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    config = true,
  },
  -- {
  --   "alexxGmZ/Md2Pdf",
  --   cmd = "Md2Pdf"
  -- },

  -- {
  --   "andrewferrier/wrapping.nvim",
  --   config = function()
  --     require("wrapping").setup()
  --   end,
  -- },
  {
    "danymat/neogen",
    keys = {

      -- vim.keymap.set("n", "<leader>ns", vim.cmd.Neogen)
      {
        "<leader>nG",
        function()
          require("neogen").generate()
        end,
      },
    },
    config = function()
      require("neogen").setup({ enabled = true, snippet_engine = "luasnip" })
    end,

    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
  },
  -- {
  --   "chentoast/marks.nvim",
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  -- {
  --   "MattesGroeger/vim-bookmarks",
  --   config = function()
  --     vim.g.bookmark_save_per_working_dir = 1
  --     vim.g.bookmark_auto_save = 1
  --     vim.g.bookmark_sign = ''
  --     vim.cmd([[highlight BookmarkSign guifg=#89B4FA]])
  --     vim.cmd([[" Finds the Git super-project directory.
  --       function! g:BMWorkDirFileLocation()
  --           let filename = 'bookmarks'
  --           let location = ''
  --           if isdirectory('.git')
  --               " Current work dir is git's work tree
  --               let location = getcwd().'/.git'
  --           else
  --               " Look upwards (at parents) for a directory named '.git'
  --               let location = finddir('info', '.;')
  --           endif
  --           if len(location) > 0
  --               return location.'/'.filename
  --           else
  --               return getcwd().'/.'.filename
  --           endif
  --       endfunction]])
  --     vim.keymap.set("n", "<leader>mm", "<cmd>Telescope vim_bookmarks all<cr>", { noremap = true, silent = true })
  --   end,
  -- },
  {
    enabled = false,
    "jugarpeupv/recall.nvim",
    -- dir = "~/projects/recall.nvim",
    -- dev = true,
    version = "*",
    event = { "BufReadPost" },
    keys = {
      {
        mode = { "n" },
        -- "<leader>mm",
        "mm",
        "<cmd>lua require('recall').toggle()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mn",
        "mn",
        "<cmd>lua require('recall').goto_next()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mp",
        "mp",
        "<cmd>lua require('recall').goto_prev()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>mc",
        "<leader>mc",
        "<cmd>lua require('recall').clear()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>ml",
        "<leader>ml",
        "<cmd>Telescope recall<CR>",
        { noremap = true, silent = true },
      },
    },
    config = function()
      local recall = require("recall")
      recall.setup({
        sign = "",
        sign_highlight = "Function",

        telescope = {
          autoload = true,
          mappings = {
            unmark_selected_entry = {
              normal = "dd",
              -- insert = "<M-d>",
              insert = "<C-x>",
            },
          },
        },

        wshada = vim.fn.has("nvim-0.10") == 0,
      })
    end,
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>ot", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      -- Your setup opts here
    },
  },
  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
  },
  {
    "sontungexpt/url-open",
    -- event = "VeryLazy",
    keys = { { "gx", "<esc>:URLOpenUnderCursor<cr>" } },
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({
        highlight_url = {
          all_urls = {
            enabled = false,
            fg = "#21d5ff", -- "text" or "#rrggbb"
            -- fg = "text", -- text will set underline same color with text
            bg = nil, -- nil or "#rrggbb"
            underline = true,
          },
          cursor_move = {
            enabled = false,
            fg = "#199eff", -- "text" or "#rrggbb"
            -- fg = "text", -- text will set underline same color with text
            bg = nil, -- nil or "#rrggbb"
            underline = true,
          },
        },
      })
    end,
  },
  -- https://github.com/johmsalas/text-case.nvim
  -- { "VidocqH/data-viewer.nvim" },
  -- { "Djancyp/regex.nvim" },
  -- {"https://github.com/gabrielpoca/replacer.nvim"},
  -- { "Wansmer/sibling-swap.nvim" },
  -- { "nvim-spider" }
  -- { "airblade/vim-matchquote" },
  -- { "ton/vim-bufsurf" },
  { "taybart/b64.nvim",      cmd = { "B64Encode", "B64Decode" } },
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaWrite", "SudaRead" },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },

      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },

      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
    },
    opts = {
      skipInsignificantPunctuation = true,
      consistentOperatorPending = true, -- see "Consistent Operator-pending Mode" in the README
      subwordMovement = true,
      customPatterns = {},           -- check "Custom Movement Patterns" in the README for details
    },
  },
  -- { https://github.com/axieax/urlview.nvim }
  { "dstein64/vim-startuptime", cmd = { "StartupTime" } },
  -- { "dstein64/vim-startuptime", event = "VeryLazy" },
  {
    "b0o/schemastore.nvim",
    -- event = "VeryLazy",
    lazy = true,
  },
  {
    "christoomey/vim-tmux-navigator",
    -- event = "VeryLazy",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    config = function()
      vim.g.tmux_navigator_disable_when_zoomed = 1
      vim.g.tmux_navigator_preserve_zoom = 1
    end,
  },

  { "wellle/targets.vim",       event = { "BufReadPost", "BufNewFile" } },
  -- {
  --   "ibhagwan/fzf-lua",
  --   -- optional for icon support
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   event = { "BufReadPost" },
  --   config = function()
  --     -- calling `setup` is optional for customization
  --     require("fzf-lua").setup({})
  --   end,
  -- },
  {
    "junegunn/fzf",
    dependencies = { "junegunn/fzf.vim" },
    build = "./install --all",
    event = { "BufReadPost" },
    cmd = { "G" },
    keys = {

      { "<leader>jl", "<cmd>Jumps<CR>" },
      { "<leader>gt", "<cmd>GTags<CR>" },
      {
        mode = { "n" },
        "<leader>ga",
        "<cmd>Git add .<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gS",
        "<cmd>Git stash<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gO",
        "<cmd>Git! stash pop<cr>",
        { silent = true, noremap = true },
      },

      {
        mode = { "n" },
        "<Leader>gP",
        "<cmd>Git! push<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<leader>gf",
        "<cmd>Git! fetch --all -v<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gp",
        "<cmd>Git! pull<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gC",
        "<cmd>Git checkout . | Git clean -fd<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gl",
        "<cmd>Git log -20<cr>",
        { silent = true, noremap = true },
      },
    },
  },
  { "stsewd/fzf-checkout.vim", keys = { { "<leader>gt", "<cmd>GTags<CR>" } } },
  { "tpope/vim-repeat",        keys = { "." } },
  { "nvim-lua/plenary.nvim",   lazy = true },
  { "tpope/vim-surround",      event = { "BufReadPost", "BufNewFile" } },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "htmlangular" },
    -- opts = {
    --   aliases = {
    --     ["htmlangular"] = "html",
    --   },
    -- },
    config = function()
      require("nvim-ts-autotag").setup({
        aliases = {
          ["html"] = "html",
          ["htmlangular"] = "html",
        },
      })
    end,
  },
  { "tpope/vim-dispatch", lazy = true },
  { "kkharji/sqlite.lua", lazy = true },
  {
    "ckipp01/nvim-jenkinsfile-linter",
    keys = {
      {
        "<leader>va",
        function()
          require("jenkinsfile_linter").validate()
        end,
      },
    },
  },
}
