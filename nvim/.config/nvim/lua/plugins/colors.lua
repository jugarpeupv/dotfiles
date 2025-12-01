return {
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    ft = { "html", "htmlangular" },
    -- event = "InsertEnter",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig",      -- optional
    },
    opts = {
      -- server = {
      --   override = true,                     -- setup the server from the plugin if true
      --   settings = {},                       -- shortcut for `settings.tailwindCSS`
      --   on_attach = function(client, bufnr) end, -- callback triggered when the server attaches to a buffer
      -- },
      server = {
        override = false, -- setup the server from the plugin if true
        -- settings = {}, -- shortcut for `settings.tailwindCSS`
        -- on_attach = function(client, bufnr) end, -- callback triggered when the server attaches to a buffer
      },
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "󰝤 ", -- only used in inline mode
        debounce = 150, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = nil, -- only conceal classes exceeding the provided length
        symbol = "󱏿", -- only a single character is allowed
        highlight = { -- extmark highlight options, see :h 'highlight'
          fg = "#38BDF8",
        },
      },
      cmp = {
        highlight = "foreground", -- color preview style, "foreground" | "background"
      },
      -- telescope = {
      --   utilities = {
      --     callback = function(name, class) end, -- callback used when selecting an utility class in telescope
      --   },
      -- },
      -- see the extension section to learn more
      -- extension = {
      --   queries = {}, -- a list of filetypes having custom `class` queries
      --   patterns = { -- a map of filetypes to Lua pattern lists
      --     -- example:
      --     -- rust = { "class=[\"']([^\"']+)[\"']" },
      --     -- javascript = { "clsx%(([^)]+)%)" },
      --   },
      -- },
    },
  },

  -- {
  --   "roobert/tailwindcss-colorizer-cmp.nvim",
  --   -- optionally, override the default options:
  --   event = "InsertEnter",
  --   config = function()
  --     require("tailwindcss-colorizer-cmp").setup({
  --       color_square_width = 2,
  --     })
  --   end,
  -- },
  {
    "uga-rosa/ccc.nvim",
    -- opts = {
    --   highlighter = {
    --     auto_enable = true,
    --     lsp = true,
    --   },
    -- },
    -- event = { "BufReadPre" },
    keys = { { "<leader>CC", "<cmd>CccHighlighterToggle<cr>" } },
    cmd = { "CccPick", "CccHighlighterToggle", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable" },
    -- event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ColorInput = require("ccc.input")
      local convert = require("ccc.utils.convert")

      local RgbHslCmykInput = setmetatable({
        name = "RGB/HSL/CMYK",
        max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
        min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
        bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
      }, { __index = ColorInput })

      function RgbHslCmykInput.format(n, i)
        if i <= 3 then
          -- RGB
          n = n * 255
        elseif i == 5 or i == 6 then
          -- S or L of HSL
          n = n * 100
        elseif i >= 7 then
          -- CMYK
          return ("%5.1f%%"):format(math.floor(n * 200) / 2)
        end
        return ("%6d"):format(n)
      end

      function RgbHslCmykInput.from_rgb(RGB)
        local HSL = convert.rgb2hsl(RGB)
        local CMYK = convert.rgb2cmyk(RGB)
        local R, G, B = unpack(RGB)
        local H, S, L = unpack(HSL)
        local C, M, Y, K = unpack(CMYK)
        return { R, G, B, H, S, L, C, M, Y, K }
      end

      function RgbHslCmykInput.to_rgb(value)
        return { value[1], value[2], value[3] }
      end

      function RgbHslCmykInput:_set_rgb(RGB)
        self.value[1] = RGB[1]
        self.value[2] = RGB[2]
        self.value[3] = RGB[3]
      end

      function RgbHslCmykInput:_set_hsl(HSL)
        self.value[4] = HSL[1]
        self.value[5] = HSL[2]
        self.value[6] = HSL[3]
      end

      function RgbHslCmykInput:_set_cmyk(CMYK)
        self.value[7] = CMYK[1]
        self.value[8] = CMYK[2]
        self.value[9] = CMYK[3]
        self.value[10] = CMYK[4]
      end

      function RgbHslCmykInput:callback(index, new_value)
        self.value[index] = new_value
        local v = self.value
        if index <= 3 then
          local RGB = { v[1], v[2], v[3] }
          local HSL = convert.rgb2hsl(RGB)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_hsl(HSL)
          self:_set_cmyk(CMYK)
        elseif index <= 6 then
          local HSL = { v[4], v[5], v[6] }
          local RGB = convert.hsl2rgb(HSL)
          local CMYK = convert.rgb2cmyk(RGB)
          self:_set_rgb(RGB)
          self:_set_cmyk(CMYK)
        else
          local CMYK = { v[7], v[8], v[9], v[10] }
          local RGB = convert.cmyk2rgb(CMYK)
          local HSL = convert.rgb2hsl(RGB)
          self:_set_rgb(RGB)
          self:_set_hsl(HSL)
        end
      end

      local ccc = require("ccc")
      ccc.setup({
        highlighter = {
          excludes = { 'lazy' },
          auto_enable = true,
          lsp = false,
        },
        inputs = {
          RgbHslCmykInput,
        },
      })
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    enabled = false,
    -- event = "User FilePost",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup({
        yaml = { names = false },
        md = { names = false },
        markdown = { names = false },
        scss = { names = false },
        [".scss"] = { names = false },
        [".md"] = { names = false },
        ["*"] = { names = false },
      })
    end,
  },
}
