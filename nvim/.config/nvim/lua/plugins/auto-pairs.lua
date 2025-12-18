return {
  {
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    -- dependencies = {
    --   {
    --     "hrsh7th/nvim-cmp",
    --   },
    -- },
    config = function()
      ---------------- AUTOPAIRS config
      local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")
      if not autopairs_setup then
        return
      end

      -- configure autopairs
      autopairs.setup({
        -- enable_check_bracket_line = false,
        -- ignored_next_char = "[%w%.]",
        -- ignored_next_char = "[%w%.%[%]%'%\"%`%$%{%}%(%)]", -- Add any characters you want to ignore
        -- ts_config = {
        --   lua = { "string" },                 -- don't add pairs in lua string treesitter nodes
        --   javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        --   -- java = false,                       -- don't check treesitter on java
        -- },
        disable_filetype = { "TelescopePrompt", "vim", "spectre_panel", 'snacks_picker_input' },
        disable_in_macro = true,   -- disable when recording or executing a macro
        disable_in_visualblock = true, -- disable when insert after visual block mode
        disable_in_replace_mode = true,
        -- ignored_next_char = "[%w%.%'%\"%`]",
        -- ignored_next_char = "[=[[%w%%%'%[%\"%.%`%$]]=]",
        -- ignored_next_char = "[%w%(%)%.%'%\"%[%]%$]",
        ignored_next_char = "[%w%.%'%\"%[%]%$]",
        -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = false,     -- add bracket pairs after quote
        -- enable_check_bracket_line = true, --- check bracket in same line
        enable_check_bracket_line = true, --- check bracket in same line
        enable_bracket_in_quote = true, --
        enable_abbr = false,          -- trigger abbreviation
        break_undo = true,            -- switch for basic rule break undo sequence
        -- check_ts = false,
        check_ts = true,              -- enable treesitter
        map_cr = false,
        map_bs = false,                -- map the <BS> key
        map_c_h = true,              -- Map the <C-h> key to delete a pair
        map_c_w = false,              -- map <c-w> to delete a pair if possible
      })

      -- require("nvim-autopairs.completion.cmp").setup({
      --   map_cr = false, --  map <CR> on insert mode
      --   map_complete = true, -- it will auto insert `(` after select function or method item
      --   auto_select = true -- automatically select the first item
      -- })

      -- -- setup cmp for autopairs
      -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      -- require("cmp").event:on('confirm_done', cmp_autopairs.on_confirm_done({
      --   map_char = {
      --     tex = '',
      --     javascript = '{'
      --   }
      -- }))

      -- Rules

      -- Add spaces between parentheses
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        -- Rule for a pair with left-side ' ' and right side ' '
        Rule(" ", " ")
        -- Pair will only occur if the conditional function returns true
            :with_pair(function(opts)
              -- We are checking if we are inserting a space in (), [], or {}
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                -- brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
        -- We only want to delete the pair of spaces when the cursor is as such: ( | )
            :with_del(
              function(opts)
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local context = opts.line:sub(col - 1, col + 2)
                return vim.tbl_contains({
                  brackets[1][1] .. "  " .. brackets[1][2],
                  brackets[2][1] .. "  " .. brackets[2][2],
                  brackets[3][1] .. "  " .. brackets[3][2],
                }, context)
              end
            ),
      })
      -- -- For each pair of brackets we will add another rule
      for _, bracket in pairs(brackets) do
        npairs.add_rules({
          -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
          Rule(bracket[1] .. " ", " " .. bracket[2])
              :with_pair(cond.none())
              :with_move(function(opts)
                return opts.char == bracket[2]
              end)
              :with_del(cond.none())
              :use_key(bracket[2])
          -- Removes the trailing whitespace that can occur without this
              :replace_map_cr(function(_)
                return "<C-c>2xi<CR><C-c>O"
              end),
        })
      end

      -- arrow key on javascript
      -- npairs.add_rules({
      --   Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
      --       :use_regex(true)
      --       :set_end_pair_length(2),
      -- })

      -- npairs.add_rules(require("nvim-autopairs.rules.endwise-lua"))
      -- npairs.add_rules(require("nvim-autopairs.rules.endwise-ruby"))

      autopairs.remove_rule("`")
      autopairs.remove_rule("\"")

      npairs.add_rules({
        Rule('"', '"')
          :with_pair(cond.not_after_regex("[^%s]"))  -- next char must be space
          :with_pair(cond.not_before_regex("[^%s]")) -- previous char must be space
      })
    end,
  },
  {
    "saghen/blink.pairs",
    enabled = false,
    version = "*", -- (recommended) only required with prebuilt binaries
    -- event = "BufReadPre",

    -- download prebuilt binaries from github releases
    dependencies = "saghen/blink.download",
    -- OR build from source, requires nightly:
    -- https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    --- @module 'blink.pairs'
    --- @type blink.pairs.Config
    opts = {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable()
        -- and require("blink.pairs.mappings").disable()
        -- to enable/disable mappings at runtime
        enabled = true,
        cmdline = true,
        -- or disable with `vim.g.pairs = false` (global) and `vim.b.pairs = false` (per-buffer)
        -- and/or with `vim.g.blink_pairs = false` and `vim.b.blink_pairs = false`
        disabled_filetypes = {},
        -- see the defaults:
        -- https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L14
        pairs = {},
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        cmdline = true,
        -- groups = {
        -- 	"BlinkPairsRed",
        -- 	"BlinkPairsYellow",
        -- 	"BlinkPairsBlue",
        -- 	"BlinkPairsOrange",
        -- 	"BlinkPairsGreen",
        -- 	"BlinkPairsPurple",
        -- 	"BlinkPairsCyan",
        -- },
        groups = {
          -- "BlinkPairsOrange",
          -- "BlinkPairsPurple",
          -- "BlinkPairsBlue",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
        },
        unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          cmdline = false,
          -- also include pairs not on top of the cursor, but surrounding the cursor
          include_surrounding = false,
          group = "BlinkPairsMatchParen",
          priority = 250,
        },
      },
      debug = false,
    },
  },
  -- { "rstacruz/vim-closer", event = { "InsertEnter" } },
  -- { "tpope/vim-endwise",   event = { "InsertEnter" } },
  -- {
  --   "m4xshen/autoclose.nvim",
  --   event = "InsertEnter",
  --   enabled = false,
  --   config = function()
  --     require("autoclose").setup()
  --   end,
  -- },
  -- { "cohama/lexima.vim", event = { "InsertEnter" }, enabled = false },
  --
  -- {
  --   "altermo/ultimate-autopair.nvim",
  --   enabled = false,
  --   event = { "InsertEnter" },
  --   branch = "v0.6", --recommended as each new version will have breaking changes
  --   opts = {
  --     --Config goes here
  --   },
  -- },
  -- { "tmsvg/pear-tree",   event = { "InsertEnter" }, enabled = false },
  -- { "jiangmiao/auto-pairs", event = { "InsertEnter" } },
}
