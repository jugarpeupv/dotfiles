return {
  { "sam4llis/nvim-lua-gf",  keys = { "gf" } },
  -- {
  --   "matthewmturner/rfsee",
  --   opts = {},
  --   cmd = { "RFSeeIndex", "RFSee" },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  -- },
  { "benelori/vim-rfc",         cmd = { "RFC" } },
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
      vim.api.nvim_set_keymap(
        "n",
        "<leader>nr",
        "<cmd>lua require('package-info').show({ force = true })<cr>",
        { silent = true, noremap = true }
      )

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
      vim.keymap.set({ "n" }, "<leader>ni", require("package-info").install, { silent = true, noremap = true })

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
    dependencies = {
      "hrsh7th/nvim-cmp", -- Optional: for autocompletion support (recommended)
    },
    -- Optional: you can add some keybindings
    -- (I personally use lspsaga so check out lspsaga integration or lsp integration for a smoother experience without separate keybindings)
    keys = {
      { "<leader>eg", "<cmd>EcologGoto<cr>",   desc = "Go to env file" },
      { "<leader>ep", "<cmd>EcologPeek<cr>",   desc = "Ecolog peek variable" },
      { "<leader>es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
    },
    lazy = true,
    opts = {
      integrations = {
        lsp = false,
      },
      -- Enables shelter mode for sensitive values
      shelter = {
        configuration = {
          partial_mode = false, -- false by default, disables partial mode, for more control check out shelter partial mode
          mask_char = "*", -- Character used for masking
        },
        modules = {
          cmp = true,   -- Mask values in completion
          peek = false, -- Mask values in peek view
          files = false, -- Mask values in files
          telescope = false, -- Mask values in telescope
        },
      },
      -- true by default, enables built-in types (database_url, url, etc.)
      types = true,
      path = vim.fn.getcwd(),             -- Path to search for .env files
      preferred_environment = "development", -- Optional: prioritize specific env files
    },
  },

  { "heavenshell/vim-jsdoc", cmd = { "JsDoc" } },
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
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
        "<leader>ng",
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
    "jugarpeupv/recall.nvim",
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
        "mc",
        "<cmd>lua require('recall').clear()<CR>",
        { noremap = true, silent = true },
      },
      {
        mode = { "n" },
        -- "<leader>ml",
        "ml",
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
  { "taybart/b64.nvim",         cmd = { "B64Encode", "B64Decode" } },
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
    "chrisgrieser/nvim-various-textobjs",
    -- event = "VeryLazy",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { mode = { "o", "x" }, "as", "<cmd>lua require('various-textobjs').subword('outer')<CR>" },
      { mode = { "o", "x" }, "is", "<cmd>lua require('various-textobjs').subword('inner')<CR>" },
    },
    opts = {
      keymaps = {
        useDefaults = true,
      },
    },
    -- config = function(_, opts)
    --   require("various-textobjs").setup(opts)
    --   -- example: `as` for outer subword, `is` for inner subword
    --   vim.keymap.set({ "o", "x" }, "as", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
    --   vim.keymap.set({ "o", "x" }, "is", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
    -- end,
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

  { "wellle/targets.vim",      event = { "BufReadPost", "BufNewFile" } },
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

      { "<leader>jp", "<cmd>Jumps<CR>" },
      { "<leader>gt", "<cmd>GTags<CR>" },
      {
        mode = { "n" },
        "<leader>ga",
        "<cmd>G add .<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gS",
        "<cmd>G stash<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gO",
        "<cmd>G stash pop<cr>",
        { silent = true, noremap = true },
      },

      {
        mode = { "n" },
        "<Leader>gP",
        "<cmd>G! push<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<leader>gf",
        "<cmd>G! fetch --all -v<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gp",
        "<cmd>G! pull<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gC",
        "<cmd>G checkout . | G clean -fd<cr>",
        { silent = true, noremap = true },
      },
      {
        mode = { "n" },
        "<Leader>gl",
        "<cmd>G log -20<cr>",
        { silent = true, noremap = true },
      },
    },
  },
  { "stsewd/fzf-checkout.vim", keys = { { "<leader>gt", "<cmd>GTags<CR>" } } },
  { "tpope/vim-repeat",        keys = { "." } },
  { "nvim-lua/plenary.nvim",   lazy = true },
  { "tpope/vim-surround",      event = { "BufReadPost", "BufNewFile" } },
  { "windwp/nvim-ts-autotag",  ft = "html" },
  { "tpope/vim-dispatch",      lazy = true },
  { "kkharji/sqlite.lua",      lazy = true },
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
