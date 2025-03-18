
-- return {}
return {
  -- {
  --   enabled = true,
  --   "cskeeters/javadoc.nvim",
  --   ft = "java", -- Lazy load this plugin as soon as we open a file with java filetype
  --   init = function()
  --     vim.g.javadoc_path = "/path/to/java_doc/api"
  --   end,
  --   keys = {
  --     { "gh", "<Plug>JavadocOpen", buffer = true, ft = "java", desc = "Open javadoc api to work under cursor" },
  --   },
  -- },
  {
    "andreluisos/nvim-javagenie",
    enabled = false,
    dependencies = {
      "grapp-dev/nui-components.nvim",
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "jugarpeupv/springboot-nvim",
    -- dir = "~/projects/springboot-nvim",
    -- dev = true,
    ft = "java",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
      "rebelot/terminal.nvim",
    },
    keys = {
      {
        mode = { "n" },
        "<leader>Jr",
        "<cmd>lua require('springboot-nvim').new_boot_run()<CR>",
        { noremap = true, silent = true, desc = "Spring Boot Run Project" },
      },
      {
        mode = { "n" },
        "<leader>Jc",
        "<cmd>lua require('springboot-nvim').generate_class()<CR>",
        { noremap = true, silent = true, desc = "Java Create Class" },
      },
      {
        mode = { "n" },
        "<leader>Ji",
        "<cmd>lua require('springboot-nvim').generate_interface()<CR>",
        { noremap = true, silent = true, desc = "Java Create Interface" },
      },
      {
        mode = { "n" },
        "<leader>Je",
        "<cmd>lua require('springboot-nvim').generate_enum()<CR>",
        { noremap = true, silent = true, desc = "Java Create Enum" },
      },
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      springboot_nvim.setup({})
    end,
  },
  {
    "JavaHello/java-deps.nvim",
    lazy = true,
    ft = "java",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    dependencies = {
      { "mfussenegger/nvim-jdtls" },
      {
        "simrat39/symbols-outline.nvim",
        config = function()
          require("symbols-outline").setup()
        end,
      },
    },
    config = function()
      require("java-deps").setup({})
    end,
  },
  {
    "JavaHello/spring-boot.nvim", --"eslam-allam/spring-boot.nvim"
    version = "*",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    opts = function()
      local home = os.getenv("HOME")
      -- mason for sonarlint-language path
      local mason_registery_status, mason_registery = pcall(require, "mason-registry")
      if not mason_registery_status then
        vim.notify("Mason registery not found", vim.log.levels.ERROR, { title = "Spring boot" })
        return
      end

      local opts = {}
      opts.ls_path = mason_registery.get_package("spring-boot-tools"):get_install_path()
          .. "/extension/language-server"
      -- opts.ls_path = "/home/sangram/.vscode/extensions/vmware.vscode-spring-boot-1.55.1"
      -- vim.notify("spring boot ls path : " .. opts.ls_path, vim.log.levels.INFO, {title = "Spring boot"})
      opts.java_cmd = "java"
      -- opts.exploded_ls_jar_data = true
      opts.jdtls_name = "jdtls"
      opts.log_file = home .. "/.local/state/nvim/spring-boot-ls.log"
      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- commit = "1f941b36",
    enabled = function()
      local is_headless = #vim.api.nvim_list_uis() == 0
      if is_headless then
        return false
      end
      return true
    end,
    -- event = { "InsertEnter" },
    dependencies = {
      {
        "b0o/schemastore.nvim",
        lazy = true,
      },
      {
        "j-hui/fidget.nvim",
        opts = {
          progress = {
            display = {
              -- done_style = "Operator",
              done_style = "String",
            },
          },
          -- Options related to notification subsystem
          notification = {

            window = {
              -- border = "single",
              winblend = 0, -- Background color opacity in the notification window
            },
          },
        },
      },
      -- {
      --   "smjonas/inc-rename.nvim",
      --   lazy = true,
      --   config = function()
      --     require("inc_rename").setup()
      --   end,
      -- },
      {
        "rmagatti/goto-preview",
        lazy = true,
        config = true, -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
        keys = {
          {
            "<leader>pd",
            function()
              require("goto-preview").goto_preview_definition()
            end,
          },

          {
            "<leader>pr",
            function()
              require("goto-preview").goto_preview_references()
            end,
          },
        },
      },
      {
        "mfussenegger/nvim-jdtls",
        enabled = function()
          local is_headless = #vim.api.nvim_list_uis() == 0
          if is_headless then
            return false
          end
          return true
        end,
        dependencies = { "JavaHello/spring-boot.nvim", "mfussenegger/nvim-dap" },
      },
      -- { "folke/neodev.nvim", opts = {} },
      {
        "antosha417/nvim-lsp-file-operations",
        config = function()
          require("lsp-file-operations").setup()
        end,
      },
      { "hrsh7th/nvim-cmp" },
      {
        "williamboman/mason.nvim",

        enabled = function()
          local is_headless = #vim.api.nvim_list_uis() == 0
          if is_headless then
            return false
          end
          return true
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        enabled = function()
          local is_headless = #vim.api.nvim_list_uis() == 0
          if is_headless then
            return false
          end
          return true
        end,
      },
      {
        "jayp0521/mason-null-ls.nvim",
        enabled = function()
          local is_headless = #vim.api.nvim_list_uis() == 0
          if is_headless then
            return false
          end
          return true
        end,
      },
      -- { "nanotee/sqls.nvim" },
      {
        "yioneko/nvim-vtsls",
        config = function()
          require("vtsls").config({
            refactor_auto_rename = true,
          })
        end,
      },
    },
    config = function()
      local home = os.getenv("HOME")
      -- import lspconfig plugin safely
      local on_attach = require("jg.custom.lsp-utils").attach_lsp_config
      local lspconfig_status, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_status then
        return
      end

      -- import cmp-nvim-lsp plugin safely
      local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not cmp_nvim_lsp_status then
        print("cmp_nvim_lsp could not be loaded")
        return
      end

      -- import typescript plugin safely
      -- local typescript_setup, typescript = pcall(require, "typescript")
      -- if not typescript_setup then
      --   return
      -- end

      local root_pattern = require("lspconfig.util").root_pattern

      local calculate_angularls_root_dir = function()
        local function read_file(file_path)
          local file = io.open(file_path, "r")
          if not file then
            return nil
          end

          local content = file:read("*a")
          file:close()

          return content
        end

        -- Function to check if a specific dependency is present in the package.json file
        local function has_dependency(package_json_content, dependency_name)
          local status_decode, package_data = pcall(vim.json.decode, package_json_content)
          if not status_decode then
            return false
          end
          local dependencies = package_data.dependencies

          return dependencies and dependencies[dependency_name] ~= nil
        end

        -- Example usage
        local package_json_path = "package.json"
        if pcall(read_file, package_json_path) then
          local package_json_content = read_file(package_json_path)

          if package_json_content then
            local dependency_name = "@angular/core"
            local hasAngularCore = has_dependency(package_json_content, dependency_name)
            print("hasAngularCore: ", hasAngularCore)

            if hasAngularCore then
              return root_pattern("angular.json", "nx.json", "project.json")
            else
              return root_pattern("inventado")
            end
          else
            return root_pattern("inventado")
          end
        else
          return root_pattern("inventado")
        end
      end

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()
      -- local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- capabilities.textDocument.foldingRange = {
      --   dynamicRegistration = false,
      --   lineFoldingOnly = true,
      -- }

      -- Change the Diagnostic symbols in the sign column (gutter)
      -- (not in youtube nvim video)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

      -- local signs = { Error = "", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      local signs_diag = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        -- { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignHint", text = "󰠠" },
        -- { name = "DiagnosticSignInfo", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      local config = {
        virtual_text = false,
        -- virtual_text = { spacing = 4, prefix = "●" },
        -- virtual_text = { spacing = 4, prefix = "" },
        -- virtual_text = { spacing = 4, prefix = " " },

        signs = {
          active = signs_diag,
        },
        update_in_insert = true,
        -- update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = true,
          -- style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      }

      vim.diagnostic.config(config)

      -- vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=#394b70]])
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
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      -- ################### SERVER CONFIGURATIONS

      -- configure html server
      lspconfig["html"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "myangular", "html", "templ" },
      })

      require("lspconfig").vtsls.setup({
        settings = {
          typescript = {
            preferences = {
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
            },
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = false },
              enumMemberValues = { enabled = true },
            },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure css server
      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig["pyright"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure tailwindcss server
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "htmlangular" },
        root_dir = root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.ts"
        ),
      })

      local ok, mason_registry = pcall(require, "mason-registry")
      if not ok then
        vim.notify("mason-registry could not be loaded")
        return
      end

      local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()

      -- local function get_angular_core_version(root_dir)
      --   local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])
      --   local default_version = '17.3.9'
      --
      --   if not project_root then
      --     return default_version
      --   end
      --
      --   local package_json = project_root .. '/package.json'
      --   if not vim.loop.fs_stat(package_json) then
      --     return default_version
      --   end
      --
      --   local contents = io.open(package_json):read '*a'
      --   local json = vim.json.decode(contents)
      --   if not json.dependencies then
      --     return default_version
      --   end
      --
      --   local angular_core_version = json.dependencies['@angular/core']
      --
      --   return angular_core_version
      -- end

      -- local default_angular_core_version = get_angular_core_version(vim.fn.getcwd())

      local angular_cmd = {
        "ngserver",
        "--stdio",
        "--tsProbeLocations",
        table.concat({
          angularls_path,
          vim.uv.cwd(),
        }, ","),
        "--ngProbeLocations",
        table.concat({
          angularls_path .. "/node_modules/@angular/language-server",
          vim.uv.cwd(),
        }, ","),
        -- '--angularCoreVersion',
        -- default_angular_core_version,
      }

      lspconfig["angularls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = angular_cmd,
        on_new_config = function(new_config, _)
          new_config.cmd = angular_cmd
        end,
        -- filetypes = { "typescript", "myangular", "html", "typescriptreact", "typescript.tsx" },
        filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx', 'htmlangular' },
        root_dir = root_pattern("angular.json", "project.json", "nx.json"),
        -- root_dir = angular_root_path
        -- root_dir = root_pattern("angular.json", "nx.json"),
        -- root_dir = calculate_angularls_root_dir(),
      })

      lspconfig["groovyls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
          ["textDocument/publishDiagnostics"] = function() end,
        },
        cmd = {
          "java",
          "-jar",
          home .. "/.config/groovy-language-server/build/libs/groovy-language-server-all.jar",
          -- "~/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
        },
      })

      lspconfig["bashls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      local capabilities_json_ls = vim.lsp.protocol.make_client_capabilities()
      capabilities_json_ls.textDocument.completion.completionItem.snippetSupport = true

      lspconfig["eslint"].setup({
        cmd = { home .. "/.local/share/nvim/mason/bin/vscode-eslint-language-server", "--stdio" },
        on_attach = on_attach,
        -- filetypes = {
        --   'javascript',
        --   'javascriptreact',
        --   'javascript.jsx',
        --   'typescript',
        --   'typescriptreact',
        --   'typescript.tsx',
        --   'vue',
        --   'svelte',
        --   'astro',
        --   'json',
        --   'jsonc'
        -- },
        capabilities = capabilities,
      })

      require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        editor = {
          formatOnType = false,
        },
        format = {
          enable = true,
        },
        settings = {
          yaml = {
            validate = false,
            hover = false,
            -- schemaStore = {
            --   enable = true,
            --   url = "",
            -- },
            -- schemas = {}
          },
        },
      })

      lspconfig["jsonls"].setup({
        filetypes = { "jsonc", "json", "json5" },
        on_attach = on_attach,
        capabilities = capabilities_json_ls,
        -- init_options = {
        --   provideFormatter = true,
        -- },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas({}),
            format = {
              enable = true,
            },
            validate = {
              enable = true,
            },
          },
        },
      })

      lspconfig["rust_analyzer"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enable = true,
            },
          },
        },
      })

      lspconfig["dockerls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").docker_compose_language_service.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lspconfig["marksman"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      require'lspconfig'.sourcekit.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { -- custom settings for lua
          Lua = {
            diagnostics = {
              globals = { "vim", "jit", "bit", "Config" },
            },
            -- workspace = {
            --   library = {
            --     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            --     [vim.fn.stdpath("config") .. "/lua"] = true,
            --   },
            -- },
          },
        },
      })

      require("lspconfig").clangd.setup({
        on_attach = on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(),
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })

      require("lspconfig").clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      require'lspconfig'.ruby_lsp.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Set global defaults for all servers
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          -- returns configured operations if setup() was already called
          -- or default operations if not
          require("lsp-file-operations").default_capabilities()
        ),
      })
    end,
  },
}
