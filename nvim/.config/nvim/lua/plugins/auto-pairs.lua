return {
  -- { "rstacruz/vim-closer", event = { "InsertEnter" } },
  -- { "tpope/vim-endwise", event = { "InsertEnter" } },
  -- { "jiangmiao/auto-pairs", event = { "InsertEnter" } },
  -- {
  --   "m4xshen/autoclose.nvim",
  --   event = "InsertEnter",
  --   config = function()
  --     require("autoclose").setup()
  --   end,
  -- },
  -- {
  --   "altermo/ultimate-autopair.nvim",
  --   event = { "InsertEnter" },
  --   branch = "v0.6", --recommended as each new version will have breaking changes
  --   opts = {
  --     --Config goes here
  --   },
  -- },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      -- import nvim-autopairs safely
      local autopairs_setup, autopairs = pcall(require, "nvim-autopairs")
      if not autopairs_setup then
        return
      end

      -- configure autopairs
      autopairs.setup({
        -- enable_check_bracket_line = false,
        check_ts = true, -- enable treesitter
        disable_filetype = { "TelescopePrompt", "vim" },
        fast_wrap = {},
        ts_config = {
          lua = { "string" },            -- don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
          java = false,                  -- don't check treesitter on java
        },
      })

      -- setup cmp for autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

      -- import nvim-autopairs completion functionality safely
      local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if not cmp_autopairs_setup then
        return
      end

      -- import nvim-cmp plugin safely (completions plugin)
      local cmp_setup, cmp = pcall(require, "cmp")
      if not cmp_setup then
        return
      end

      -- make autopairs and completion work together
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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
                brackets[2][1] .. brackets[2][2],
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
      npairs.add_rules({
        Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
            :use_regex(true)
            :set_end_pair_length(2),
      })

      -- auto addspace on =
      -- npairs.add_rules({
      --   Rule("=", "")
      --       :with_pair(cond.not_inside_quote())
      --       :with_pair(function(opts)
      --         local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
      --         if last_char:match("[%w%=%s]") then
      --           return true
      --         end
      --         return false
      --       end)
      --       :replace_endpair(function(opts)
      --         local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
      --         local next_char = opts.line:sub(opts.col, opts.col)
      --         next_char = next_char == " " and "" or " "
      --         if prev_2char:match("%w$") then
      --           return "<bs> =" .. next_char
      --         end
      --         if prev_2char:match("%=$") then
      --           return next_char
      --         end
      --         if prev_2char:match("=") then
      --           return "<bs><bs>=" .. next_char
      --         end
      --         return ""
      --       end)
      --       :set_end_pair_length(0)
      --       :with_move(cond.none())
      --       :with_del(cond.none()),
      -- })

      -- -- https://github.com/rstacruz/vim-closer/blob/master/autoload/closer.vim
      -- local get_closing_for_line = function(line)
      --   local i = -1
      --   local clo = ""

      --   while true do
      --     i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
      --     if i == nil then
      --       break
      --     end
      --     local ch = string.sub(line, i, i)
      --     local st = string.sub(clo, 1, 1)

      --     if ch == "{" then
      --       clo = "}" .. clo
      --     elseif ch == "}" then
      --       if st ~= "}" then
      --         return ""
      --       end
      --       clo = string.sub(clo, 2)
      --     elseif ch == "(" then
      --       clo = ")" .. clo
      --     elseif ch == ")" then
      --       if st ~= ")" then
      --         return ""
      --       end
      --       clo = string.sub(clo, 2)
      --     elseif ch == "[" then
      --       clo = "]" .. clo
      --     elseif ch == "]" then
      --       if st ~= "]" then
      --         return ""
      --       end
      --       clo = string.sub(clo, 2)
      --     end
      --   end

      --   return clo
      -- end

      -- autopairs.remove_rule("(")
      -- autopairs.remove_rule("{")
      -- autopairs.remove_rule("[")

      -- autopairs.add_rule(Rule("[%(%{%[]", "")
      --   :use_regex(true)
      --   :replace_endpair(function(opts)
      --     return get_closing_for_line(opts.line)
      --   end)
      --   :end_wise(function(opts)
      --     -- Do not endwise if there is no closing
      --     return get_closing_for_line(opts.line) ~= ""
      --   end))
    end,
  },
}
