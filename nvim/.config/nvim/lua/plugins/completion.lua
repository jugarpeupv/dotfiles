-- return {}
return {
  -- { "hrsh7th/cmp-nvim-lua", event = "InsertEnter" },
  -- { "hrsh7th/cmp-nvim-lsp", event = "InsertEnter" },
  -- -- { "hrsh7th/cmp-buffer" },
  -- -- { "hrsh7th/cmp-cmdline" },
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
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      },
      -- cmp sources plugins
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    config = function()
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

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- preslect = cmp.PreselectMode.Item,
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
          ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- ["<C-y>"] = cmp.mapping(function()
          --   if luasnip.jumpable(-1) then
          --     luasnip.jump(-1)
          --   end
          -- end, { "i", "s" }),
          -- ["<C-i>"] = cmp.mapping(function()
          --   if luasnip.expand_or_jumpable() then
          --     luasnip.expand_or_jump()
          --   end
          -- end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
          ["<C-e>"] = cmp.mapping.abort(),   -- close completion window
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Overload tab to accept Copilot suggestions.
          -- ["<Tab>"] = cmp.mapping(function(fallback)
          --   local copilot = require("copilot.suggestion")
          --   if cmp.visible() then
          --     -- cmp.mapping.confirm({ select = false })
          --     cmp.confirm({ select = true  })
          --     -- cmp.
          --     -- cmp.select_next_item()
          --     -- cmp.select_next_item()
          --   elseif copilot.is_visible() then
          --     copilot.accept()
          --   elseif luasnip.expand_or_locally_jumpable() then
          --     luasnip.expand_or_jump()
          --   else
          --     fallback()
          --   end
          -- end, { "i", "s" }),
          -- ["<S-Tab>"] = cmp.mapping(function(fallback)
          --   local copilot = require("copilot.suggestion")
          --   if copilot.is_visible() then
          --     copilot.accept()
          --   else
          --     fallback()
          --   end
          --   -- if cmp.visible() then
          --   --   cmp.select_prev_item()
          --   -- elseif luasnip.expand_or_locally_jumpable(-1) then
          --   --   luasnip.jump(-1)
          --   -- else
          --   --   fallback()
          --   -- end
          -- end, { "i", "s" }),
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
          { name = "lazydev", group_index = 0 },
          {
            name = "nvim_lsp",
            -- entry_filter = function(entry, ctx)
            --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            -- end,
            -- entry_filter = function(entry, _)
            --   return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            -- end,
          },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp:marksman" },
          { name = "marksman" },
          { name = "buffer" },
          { name = "luasnip" }, -- snippets
          { name = "path" }, -- file system paths
          { name = "crates" },
          -- { name = "buffer", keyword_length = 5, max_item_count = 5 },
          -- { name = "buffer" },
          -- { name = 'markdown-link' },
          -- { name = 'markdown' },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.exact,
            -- cmp.config.compare.offset,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            -- require("cmp-under-comparator").under,
            -- function(entry1, entry2)
            --   local _, entry1_under = entry1.completion_item.label:find("^_+")
            --   local _, entry2_under = entry2.completion_item.label:find("^_+")
            --   entry1_under = entry1_under or 0
            --   entry2_under = entry2_under or 0
            --   if entry1_under > entry2_under then
            --     return false
            --   elseif entry1_under < entry2_under then
            --     return true
            --   end
            -- end,
            cmp.config.compare.kind,
            -- cmp.config.compare.offset,
            -- cmp.config.compare.exact,
            -- cmp.config.compare.score,
            -- -- cmp.config.compare.kind,
            -- -- cmp.config.compare.sort_text,
            -- -- cmp.config.compare.length,
            -- -- cmp.config.compare.order,

            -- -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
            -- -- -- copied from cmp-under, but I don't think I need the plugin for this.
            -- -- -- I might add some more of my own.
            -- function(entry1, entry2)
            --   local _, entry1_under = entry1.completion_item.label:find("^_+")
            --   local _, entry2_under = entry2.completion_item.label:find("^_+")
            --   entry1_under = entry1_under or 0
            --   entry2_under = entry2_under or 0
            --   if entry1_under > entry2_under then
            --     return false
            --   elseif entry1_under < entry2_under then
            --     return true
            --   end
            -- end,

            -- cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            -- cmp.config.compare.length,
            -- cmp.config.compare.order,
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
              -- buffer = "[Buffer]",
              luasnip = "[LuaSnip]",
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
      -- cmp.setup.cmdline("/", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     { name = "buffer" },
      --   },
      -- })
      -- `:` cmdline setup.
      -- cmp.setup.cmdline(":", {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources({
      --     { name = "path" },
      --   }, {
      --     {
      --       name = "cmdline",
      --       option = {
      --         ignore_cmds = { "Man", "!" },
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
