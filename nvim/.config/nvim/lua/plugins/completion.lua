-- return {}
return {
  -- {
  --   'saghen/blink.cmp',
  --   lazy = false, -- lazy loading handled internally
  --   -- optional: provides snippets for the snippet source
  --   dependencies = 'rafamadriz/friendly-snippets',
  --
  --   -- use a release tag to download pre-built binaries
  --   version = 'v0.*',
  --   -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  --   -- build = 'cargo build --release',
  --   -- If you use nix, you can build from source using latest nightly rust with:
  --   -- build = 'nix run .#build-plugin',
  --
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     -- 'default' for mappings similar to built-in completion
  --     -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
  --     -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
  --     -- see the "default configuration" section below for full documentation on how to define
  --     -- your own keymap.
  --     keymap = { preset = 'default' },
  --
  --     appearance = {
  --       -- Sets the fallback highlight groups to nvim-cmp's highlight groups
  --       -- Useful for when your theme doesn't support blink.cmp
  --       -- will be removed in a future release
  --       use_nvim_cmp_as_default = true,
  --       -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
  --       -- Adjusts spacing to ensure icons are aligned
  --       nerd_font_variant = 'normal'
  --     },
  --
  --     -- default list of enabled providers defined so that you can extend it
  --     -- elsewhere in your config, without redefining it, via `opts_extend`
  --     sources = {
  --       default = { 'lsp', 'path', 'snippets', 'buffer' },
  --     },
  --
  --     -- experimental auto-brackets support
  --     -- completion = { accept = { auto_brackets = { enabled = true } } }
  --
  --     -- experimental signature help support
  --     -- signature = { enabled = true }
  --   },
  --   -- allows extending the providers array elsewhere in your config
  --   -- without having to redefine it
  --   opts_extend = { "sources.default" }
  -- },
  -- { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
  -- { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
  -- -- { "hrsh7th/cmp-buffer" },
  -- { "hrsh7th/cmp-cmdline" },
  -- { "hrsh7th/cmp-path",     event = "InsertEnter" },
  -- { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
  -- {
  --   "L3MON4D3/LuaSnip",
  --   event = "InsertEnter",
  --   -- dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
  -- },
  -- { "rafamadriz/friendly-snippets", event = "InsertEnter" },
  {
    event = "InsertEnter",
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "davidsierradz/cmp-conventionalcommits" },
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      },
      -- cmp sources plugins
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      -- "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local lspkind_comparator = function(conf)
        local lsp_types = require("cmp.types").lsp
        return function(entry1, entry2)
          if entry1.source.name ~= "nvim_lsp" then
            if entry2.source.name == "nvim_lsp" then
              return false
            else
              return nil
            end
          end
          local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
          local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]
          if kind1 == "Variable" and entry1:get_completion_item().label:match("%w*=") then
            kind1 = "Parameter"
          end
          if kind2 == "Variable" and entry2:get_completion_item().label:match("%w*=") then
            kind2 = "Parameter"
          end

          local priority1 = conf.kind_priority[kind1] or 0
          local priority2 = conf.kind_priority[kind2] or 0
          if priority1 == priority2 then
            return nil
          end
          return priority2 < priority1
        end
      end

      local label_comparator = function(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
      end

      local types = require("cmp.types")
      -- import nvim-cmp plugin safely
      local cmp_status, cmp = pcall(require, "cmp")
      if not cmp_status then
        return
      end

      -- import luasnip plugin safely
      local luasnip_status, luasnip = pcall(require, "luasnip")
      if not luasnip_status then
        return
      end

      -- import lspkind plugin safely
      local lspkind_status, lspkind = pcall(require, "lspkind")
      if not lspkind_status then
        return
      end

      luasnip.add_snippets("html", {
        luasnip.parser.parse_snippet("testtest", "worksworks"),
      })
      luasnip.filetype_extend("myangular", { "html" })
      -- load vs-code like snippets from plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      vim.opt.completeopt = "menu,menuone,noselect"

      cmp.setup.filetype({ "sagarename" }, {
        sources = {},
      })

      cmp.setup.filetype({ "copilot-chat" }, {
        sources = {},
      })

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- preslect = cmp.PreselectMode.Item,
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<Down>"), "m", true)
            end,
            i = function()
              vim.api.nvim_feedkeys(t("<Down>"), "m", true)
            end,
          }),
          ["<C-k>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<Up>"), "m", true)
            end,
            i = function()
              vim.api.nvim_feedkeys(t("<Up>"), "m", true)
            end,
          }),
          -- ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          -- ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping(function()
            local copilot = require("copilot.suggestion")
            if copilot.is_visible() then
              copilot.accept()
            elseif cmp.visible() then
              cmp.confirm({ select = true })
              return
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
            -- if luasnip.jumpable(-1) then
            --   luasnip.jump(-1)
            -- end
            -- if luasnip.expand_or_locally_jumpable() then
            --   luasnip.expand_or_jump()
            -- end
          end, { "i", "s" }),
          ["<C-x>"] = cmp.mapping(function()
            -- if luasnip.expand_or_jumpable() then
            --   luasnip.expand_or_jump()
            -- end
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(),   -- close completion window
          -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping(function(fallback)
            -- local copilot = require("copilot.suggestion")
            -- if copilot.is_visible() then
            --   copilot.accept()
            -- elseif cmp.visible() then
            local filetype = vim.bo.filetype
            if filetype == "" then
              vim.api.nvim_feedkeys(t("<CR>"), "n", true)
              return
            elseif cmp.visible() then
              cmp.confirm({ select = true })
              return
            else
              fallback()
              return
            end
          end, { "i", "s" }),
          ["<Right>"] = cmp.mapping(function(fallback)
            local copilot = require("copilot.suggestion")
            if copilot.is_visible() then
              copilot.accept()
            else
              fallback()
            end
          end, { "i", "s" }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Overload tab to accept Copilot suggestions.
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   -- local copilot = require("copilot.suggestion")
          --   -- if copilot.is_visible() then
          --   --   copilot.accept()
          --   -- elseif cmp.visible() then
          --
          --   if luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   else
          --     fallback()
          --   end
          --
          --   -- if cmp.visible() then
          --   --   cmp.confirm({ select = true })
          --   --   -- elseif luasnip.expand_or_locally_jumpable() then
          --   --   --   luasnip.expand_or_jump()
          --   -- else
          --   --   fallback()
          --   -- end
          -- end, { "i", "s" }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   -- local copilot = require("copilot.suggestion")
          --   -- if copilot.is_visible() then
          --   --   copilot.accept()
          --   -- else
          --   --   fallback()
          --   -- end
          --   -- if cmp.visible() then
          --   --   cmp.select_prev_item()
          --   -- elseif luasnip.expand_or_locally_jumpable(-1) then
          --   --   luasnip.jump(-1)
          --   -- else
          --   --   fallback()
          --   -- end
          --   if luasnip.expand_or_locally_jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s"}),
        }),
        -- window = {
        --   completion = cmp.config.window.bordered(),
        --   documentation = cmp.config.window.bordered(),
        -- },
        window = {
          completion = {
            -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            -- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
          },
        },
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "lazydev",         group_index = 0 },
          { name = "nvim_lua",        priority = 1100 },
          {
            name = "nvim_lsp",
            priority = 1000,
            -- entry_filter = function(entry, ctx)
            --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            -- end,
            -- entry_filter = function(entry, _)
            --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            -- end,
          },
          { name = "nvim_lsp:yamlls", priority = 999 },
          -- { name = 'nvim_lsp_signature_help', priority = 998 },
          { name = "ecolog",          priority = 901 },
          { name = "path",            priority = 900 }, -- file system paths
          -- { name = "nvim_lsp_signature_help" },
          { name = "render-markdown", priority = 850 },
          { name = "obsidian",        priority = 800 },
          { name = "obsidian_new",    priority = 800 },
          { name = "obsidian_tags",   priority = 800 },
          { name = "luasnip",         priority = 700 }, -- snippets
          -- { name = "nvim_lsp:marksman", priority = 600 },
          { name = "crates",          priority = 300 },
          { name = "buffer",          priority = 5, keyword_length = 3 },
        }),
        sorting = {
          -- comparators = {
          --   -- cmp.config.compare.offset,
          --   cmp.config.compare.order,
          --   cmp.config.compare.exact,
          --   cmp.config.compare.score,
          --   function(entry1, entry2)
          --     local kind1 = entry1:get_kind()
          --     kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
          --     local kind2 = entry2:get_kind()
          --     kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
          --     if kind1 ~= kind2 then
          --       if kind1 == types.lsp.CompletionItemKind.Snippet then
          --         return false
          --       end
          --       if kind2 == types.lsp.CompletionItemKind.Snippet then
          --         return true
          --       end
          --       local diff = kind1 - kind2
          --       if diff < 0 then
          --         return true
          --       elseif diff > 0 then
          --         return false
          --       end
          --     end
          --   end,
          --   cmp.config.compare.sort_text,
          --   cmp.config.compare.length,
          -- },

          comparators = {
            -- label_comparator,
            cmp.config.compare.score,
            lspkind_comparator({
              kind_priority = {
                Parameter = 14,
                Variable = 12,
                Field = 11,
                Property = 11,
                Constant = 10,
                Enum = 10,
                EnumMember = 10,
                Event = 10,
                Function = 10,
                Method = 10,
                Operator = 10,
                Reference = 10,
                Struct = 10,
                File = 8,
                Folder = 8,
                Class = 5,
                Color = 5,
                Module = 5,
                Keyword = 2,
                Constructor = 1,
                Interface = 1,
                Snippet = 0,
                Text = 0,
                TypeParameter = 1,
                Unit = 1,
                Value = 1,
              },
            }),
            -- cmp.config.compare.kind,
            cmp.config.compare.order,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            function(entry1, entry2)
              local kind1 = entry1:get_kind()
              kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
              local kind2 = entry2:get_kind()
              kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
              if kind1 ~= kind2 then
                if kind1 == types.lsp.CompletionItemKind.Snippet then
                  return false
                end
                if kind2 == types.lsp.CompletionItemKind.Snippet then
                  return true
                end
                local diff = kind1 - kind2
                if diff < 0 then
                  return true
                elseif diff > 0 then
                  return false
                end
              end
            end,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
          },
        },
        -- configure lspkind for vs-code like icons
        formatting = {
          -- format = require("tailwindcss-colorizer-cmp").formatter

          format = lspkind.cmp_format({
            maxwidth = 80,
            mode = "symbol_text",
            menu = {
              nvim_lsp = "[LSP]",
              ["nvim_lsp:yamlls"] = "[LSP-yamlls]",
              ["nvim_lsp:null-ls"] = "[LSP-nulls]",
              ["nvim_lsp:lua_ls"] = "[LSP-luals]",
              buffer = "[Buffer]",
              luasnip = "[LuaSnip]",
              obsidian = "[Obsidian]",
              obsidian_new = "[Obsidian]",
              obsidian_tags = "[Obsidian]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
              ["vim-dadbod-completion"] = "[DB]",
              crates = "[Crates]",
            },
            -- before = function(entry, vim_item)
            --   vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
            --   return vim_item
            -- end,
          }),
          -- format = function (entry, vim_item)
          --   vim_item.kind = lspkind.presets.default[vim_item.kind]
          --   vim_item.menu = ({
          --     nvim_lsp = "[LSP]",
          --     look = "[Dict]",
          --     buffer = "[Buffer]"
          --   })[entry.source.name]
          --
          --   vim_item.kind, vim_item.menu = vim_item.menu, vim_item.kind
          --   return vim_item
          -- end
          -- format = lspkind.cmp_format({
          --     -- mode = 'symbol',
          -- 	maxwidth = 50,
          -- 	ellipsis_char = "...",
          -- }),
        },
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        -- mapping = cmp.mapping.preset.cmdline({
        --   ["<C-j>"] = { c = cmp.mapping.select_next_item() },
        --   ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
        --   -- ["<Tab>"] = cmp.config.disable,
        --   ["<Tab>"] = cmp.mapping(function(fallback)
        --     -- local copilot = require("copilot.suggestion")
        --     -- if copilot.is_visible() then
        --     --   copilot.accept()
        --     -- elseif cmp.visible() then
        --     fallback()
        --   end),
        -- }),
        mapping = {
          ["<C-j>"] = { c = cmp.mapping.select_next_item() },
          ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
        },
        sources = {
          { name = "buffer" },
        },
      })
      -- -- `:` cmdline setup.
      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline({
      --     ["<C-j>"] = { c = cmp.mapping.select_next_item() },
      --     ["<C-k>"] = { c = cmp.mapping.select_prev_item() },
      --     ["<Tab>"] = cmp.mapping(function(fallback)
      --       -- local copilot = require("copilot.suggestion")
      --       -- if copilot.is_visible() then
      --       --   copilot.accept()
      --       -- elseif cmp.visible() then
      --       fallback()
      --     end),
      --   }),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     {
      --       name = "cmdline",
      --       option = {
      --         ignore_cmds = { "Man", "!", "read", "write" },
      --       },
      --     },
      --   }),
      -- })

      local autocomplete_group = vim.api.nvim_create_augroup("vimrc_autocompletion", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          cmp.setup.buffer({
            sources = {
              { name = "nvim_lsp" },
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
            },
          })
        end,
        group = autocomplete_group,
      })
    end,
  },
}
