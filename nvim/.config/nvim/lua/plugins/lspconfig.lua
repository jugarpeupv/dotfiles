-- return {}
return {

  {
    "neovim/nvim-lspconfig",
    enabled = true,
    -- enabled = function()
    --   local is_headless = #vim.api.nvim_list_uis() == 0
    --   if is_headless then
    --     return false
    --   end
    --   return true
    -- end,
    event = { "VeryLazy" },
    -- lazy = true,
    -- event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "hinell/lsp-timeout.nvim",
        enabled = false,
        dependencies = { "neovim/nvim-lspconfig" },
      },
      {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        enabled = false,
        opts = {
          aggressive_mode = true,
          notifications = false,
        },
      },
      {
        "b0o/schemastore.nvim",
        enabled = true,
        lazy = true,
      },
    },
    config = function()
      -- local capabilities = vim.tbl_deep_extend(
      -- 	"force",
      -- 	vim.lsp.protocol.make_client_capabilities(),
      -- 	require("lsp-file-operations").default_capabilities()
      -- )
      local on_attach = require("jg.custom.lsp-utils").attach_lsp_config

      vim.lsp.config("*", {
        on_attach = on_attach,
        -- capabilities = capabilities,
      })

      local config = {
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰠠",
          },
        },
        update_in_insert = true,
        -- update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(config)

      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      -- To instead override globally
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      ---@diagnostic disable-next-line: duplicate-set-field
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      vim.lsp.enable("jdtls")
      vim.lsp.enable("html")
      vim.lsp.enable("vtsls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("angularls")
      vim.lsp.enable("groovyls")
      vim.lsp.enable("bashls")
      vim.lsp.enable("eslint")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("dockerls")
      vim.lsp.enable("marksman")
      vim.lsp.enable("emmet_ls")
      vim.lsp.enable("sourcekit")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("clangd")
      vim.lsp.enable("gh_actions_ls")
      vim.lsp.enable("ruby_lsp")
      vim.lsp.enable("docker_compose_language_service")
      vim.lsp.enable("gopls")
      vim.lsp.enable("copilot_ls")
      vim.lsp.enable("kulala_ls")
      vim.lsp.enable("somesass_ls")
    end,
  },
  {
    "igorlfs/nvim-lsp-file-operations",
    enabled = true,
    keys = { "<C-d>", "<C-u>" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "j-hui/fidget.nvim",
    enabled = true,
    -- event = { 'BufReadPost', "BufNewFile" },
    lazy = true,
    opts = {
      progress = {
        suppress_on_insert = false, -- Suppress new messages while in insert mode
        ignore_done_already = true, -- Ignore new tasks that are already complete
        ignore_empty_message = false,
        display = {
          -- done_style = "Operator",
          done_style = "String",
        },
      },
      -- Options related to integrating with other plugins
      integration = {
        ["nvim-tree"] = {
          enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
        },
      },
      -- Options related to notification subsystem
      notification = {

        window = {
          -- border = "rounded",
          winblend = 0, -- Background color opacity in the notification window
          zindex = 1,
        },
      },
    },
  },
	{
		"yioneko/nvim-vtsls",
		ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
		config = function()
			require("vtsls").config({
				refactor_auto_rename = true,
			})
		end,
	},
}
