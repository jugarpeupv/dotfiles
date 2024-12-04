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
    dir = "~/projects/springboot-nvim",
    dev = true,
    ft = "java",
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
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-jdtls",
    },
    opts = function()
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
      opts.exploded_ls_jar_data = true
      opts.jdtls_name = "jdtls"
      opts.log_file = "/Users/jgarcia/.local/state/nvim/spring-boot-ls.log"

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
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
            "gpd",
            function()
              require("goto-preview").goto_preview_definition()
            end,
          },

          {
            "gpr",
            function()
              require("goto-preview").goto_preview_references()
            end,
          },
        },
      },
      { "mfussenegger/nvim-jdtls", dependencies = { "JavaHello/spring-boot.nvim", "mfussenegger/nvim-dap" } },
      { "folke/neodev.nvim",       opts = {} },
      {
        "antosha417/nvim-lsp-file-operations",
        config = function()
          require("lsp-file-operations").setup()
        end,
      },
      { "hrsh7th/nvim-cmp" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "jayp0521/mason-null-ls.nvim" },
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
          local package_data = vim.json.decode(package_json_content)
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
              -- other preferences...
              importModuleSpecifier = "relative",
              importModuleSpecifierEnding = "minimal",
            },
            inlayHints = {

              --           includeInlayEnumMemberValueHints = false,
              --           includeInlayFunctionLikeReturnTypeHints = false,
              --           includeInlayFunctionParameterTypeHints = true,
              --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
              --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              --           includeInlayPropertyDeclarationTypeHints = false,
              --           includeInlayVariableTypeHints = false,
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

      -- require'lspconfig'.html.setup{
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- }

      -- configure typescript server with plugin
      -- typescript.setup({
      --   server = {
      --     capabilities = capabilities,
      --     on_attach = on_attach,
      --     -- root_dir = root_pattern("tsconfig.base.json", "package.json", "jsconfig.json", ".git", "tsconfig.json"),
      --     -- root_dir = root_pattern("tsconfig.base.json", "package.json", ".git"),
      --     -- root_dir = root_pattern("tsconfig.base.json", ".git"),
      --     -- root_dir = root_pattern("tsconfig.json","tsconfig.base.json", ".git"),
      --     root_dir = root_pattern("tsconfig.base.json", "package.json", "jsconfig.json", ".git"),
      --     settings = {
      --       javascript = {
      --         inlayHints = {
      --           includeInlayEnumMemberValueHints = true,
      --           includeInlayFunctionLikeReturnTypeHints = false,
      --           includeInlayFunctionParameterTypeHints = true,
      --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --           includeInlayPropertyDeclarationTypeHints = false,
      --           includeInlayVariableTypeHints = false,
      --         },
      --       },
      --       typescript = {
      --         inlayHints = {
      --           includeInlayEnumMemberValueHints = false,
      --           includeInlayFunctionLikeReturnTypeHints = false,
      --           includeInlayFunctionParameterTypeHints = true,
      --           includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --           includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --           includeInlayPropertyDeclarationTypeHints = false,
      --           includeInlayVariableTypeHints = false,
      --         },
      --       },
      --     },
      --   },
      -- })

      -- configure css server
      lspconfig["cssls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- lspconfig.sqlls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   filetypes = { 'sql' },
      --   root_dir = function(_)
      --     return vim.loop.cwd()
      --   end,
      -- })

      -- lspconfig.sqls.setup({
      --   capabilities = capabilities,

      --   on_attach = function(client, bufnr)
      --     require("sqls").on_attach(client, bufnr)
      --     require("jg.custom.lsp-utils").attach_lsp_config(client, bufnr)
      --   end,
      --   -- settings = {
      --   --   sqls = {
      --   --     connections = {
      --   --       {
      --   --         alias = "auth",
      --   --         driver = "mysql",
      --   --         -- mysql://root@localhost/auth
      --   --         -- dataSourceName = 'mysql://root@localhost/auth',
      --   --         -- dataSourceName = 'mysql://root@tcp(127.0.0.1:3306)/auth',
      --   --         -- dataSourceName = 'root:root@tcp(127.0.0.1:13306)/world',
      --   --         proto = "tcp",
      --   --         user = "root",
      --   --         passwd = "",
      --   --         host = "127.0.0.1",
      --   --         port = "3306",
      --   --         dbName = "auth",
      --   --       },
      --   --     },
      --   --   },
      --   -- },
      --   -- on_attach = on_attach,
      --   filetypes = { "sql", "mysql", "plsql" },
      --   root_dir = function(_)
      --     return vim.loop.cwd()
      --   end,
      -- })

      -- lspconfig.jedi_language_server.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      lspconfig["pyright"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        -- root_dir = function(fname)
        --   local root_files = {
        --     "pyproject.toml",
        --     "setup.py",
        --     "setup.cfg",
        --     "requirements.txt",
        --     "Pipfile",
        --     "pyrightconfig.json",
        --   }
        --   return root_pattern(unpack(root_files))(fname)
        -- end,
      })

      -- configure tailwindcss server
      lspconfig["tailwindcss"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
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
      }

      lspconfig["angularls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = angular_cmd,
        on_new_config = function(new_config, _)
          new_config.cmd = angular_cmd
        end,
        filetypes = { "typescript", "myangular", "html", "typescriptreact", "typescript.tsx" },
        -- root_dir = root_pattern("angular.json", "project.json"),
        -- root_dir = root_pattern("angular.json", "nx.json"),
        root_dir = calculate_angularls_root_dir(),
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
          "/Users/jgarcia/.config/groovy-language-server/build/libs/groovy-language-server-all.jar",
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
        -- root_dir = function(filename, bufnr)
        --   if string.find(filename, "node_modules/") then
        --     return nil
        --   end
        --   -- return require("lspconfig.server_configurations.eslint").default_config.root_dir(filename, bufnr)
        --   local root_dir = require("lspconfig.server_configurations.eslint").default_config.root_dir(filename)
        --   return root_dir
        -- end,
        -- root_dir = function(filename)
        --   if string.find(filename, "node_modules/") then
        --     return nil
        --   end
        --   return require("lspconfig.server_configurations.eslint").default_config.root_dir(filename)
        -- end,
        cmd = { "/Users/jgarcia/.local/share/nvim/mason/bin/vscode-eslint-language-server", "--stdio" },
        -- settings = {
        --   experimental = {
        --     useFlatConfig = true,
        --   },
        -- },
        on_attach = on_attach,
        capabilities = capabilities,
        -- filetypes = {
        --   "javascript",
        --   "html",
        --   "javascriptreact",
        --   "javascript.jsx",
        --   "typescript",
        --   "typescriptreact",
        --   "typescript.tsx",
        --   "vue",
        --   "svelte",
        --   "astro",
        -- },
      })

      -- local cfg = require("yaml-companion").setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })
      -- require("lspconfig")["yamlls"].setup(cfg)

      require("lspconfig").yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        -- settings = {
        --   -- yaml = {
        --   --   schemaStore = {
        --   --     enable = true,
        --   --     url = "",
        --   --   },
        --   --   schemas = require("schemastore").yaml.schemas(),
        --   -- },
        --   yaml = {
        --     -- validate = true,
        --     format = { enable = true },
        --     -- schemaDownload = { enable = true },
        --     -- schemaStore = {
        --     --   enable = true,
        --     --   url = "https://www.schemastore.org/api/json/catalog.json"
        --     -- },
        --     -- schemas = {
        --     --   ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        --     -- },
        --     -- schemas = require('schemastore').yaml.schemas(),
        --   },
        -- },
      })

      local default_schemas = nil
      local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
      if status_ok then
        default_schemas = jsonls_settings.get_default_schemas()
      else
        default_schemas = require("schemastore").json.schemas()
      end


      local schemas = {
        {
          description = "TypeScript compiler configuration file",
          fileMatch = {
            "tsconfig.json",
            "tsconfig.*.json",
          },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          description = "Lerna config",
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json",
        },
        {
          description = "Babel configuration",
          fileMatch = {
            ".babelrc.json",
            ".babelrc",
            "babel.config.json",
          },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          description = "ESLint config",
          fileMatch = {
            ".eslintrc.json",
            ".eslintrc",
          },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          description = "Bucklescript config",
          fileMatch = { "bsconfig.json" },
          url = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json",
        },
        {
          description = "Prettier config",
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json",
          },
          url = "https://json.schemastore.org/prettierrc",
        },
        {
          description = "Vercel Now config",
          fileMatch = { "now.json" },
          url = "https://json.schemastore.org/now",
        },
        {
          description = "Stylelint config",
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json",
          },
          url = "https://json.schemastore.org/stylelintrc",
        },
        {
          description = "A JSON schema for the ASP.NET LaunchSettings.json files",
          fileMatch = { "launchsettings.json" },
          url = "https://json.schemastore.org/launchsettings.json",
        },
        {
          description = "Schema for CMake Presets",
          fileMatch = {
            "CMakePresets.json",
            "CMakeUserPresets.json",
          },
          url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
        },
        {
          description = "Configuration file as an alternative for configuring your repository in the settings page.",
          fileMatch = {
            ".codeclimate.json",
          },
          url = "https://json.schemastore.org/codeclimate.json",
        },
        {
          description = "LLVM compilation database",
          fileMatch = {
            "compile_commands.json",
          },
          url = "https://json.schemastore.org/compile-commands.json",
        },
        {
          description = "Config file for Command Task Runner",
          fileMatch = {
            "commands.json",
          },
          url = "https://json.schemastore.org/commands.json",
        },
        {
          description =
          "AWS CloudFormation provides a common language for you to describe and provision all the infrastructure resources in your cloud environment.",
          fileMatch = {
            "*.cf.json",
            "cloudformation.json",
          },
          url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
        },
        {
          description =
          "The AWS Serverless Application Model (AWS SAM, previously known as Project Flourish) extends AWS CloudFormation to provide a simplified way of defining the Amazon API Gateway APIs, AWS Lambda functions, and Amazon DynamoDB tables needed by your serverless application.",
          fileMatch = {
            "serverless.template",
            "*.sam.json",
            "sam.json",
          },
          url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json",
        },
        {
          description = "Json schema for properties json file for a GitHub Workflow template",
          fileMatch = {
            ".github/workflow-templates/**.properties.json",
          },
          url = "https://json.schemastore.org/github-workflow-template-properties.json",
        },
        {
          description = "golangci-lint configuration file",
          fileMatch = {
            ".golangci.toml",
            ".golangci.json",
          },
          url = "https://json.schemastore.org/golangci-lint.json",
        },
        {
          description = "JSON schema for the JSON Feed format",
          fileMatch = {
            "feed.json",
          },
          url = "https://json.schemastore.org/feed.json",
          versions = {
            ["1"] = "https://json.schemastore.org/feed-1.json",
            ["1.1"] = "https://json.schemastore.org/feed.json",
          },
        },
        {
          description = "Packer template JSON configuration",
          fileMatch = {
            "packer.json",
          },
          url = "https://json.schemastore.org/packer.json",
        },
        {
          description = "NPM configuration file",
          fileMatch = {
            "package.json",
          },
          url = "https://json.schemastore.org/package.json",
        },
        {
          description = "JSON schema for Visual Studio component configuration files",
          fileMatch = {
            "*.vsconfig",
          },
          url = "https://json.schemastore.org/vsconfig.json",
        },
        {
          description = "Resume json",
          fileMatch = { "resume.json" },
          url = "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json",
        },
      }

      local function extend(tab1, tab2)
        for _, value in ipairs(tab2 or {}) do
          table.insert(tab1, value)
        end
        return tab1
      end

      local extended_schemas = extend(schemas, default_schemas)

      lspconfig["jsonls"].setup({
        filetypes = { "jsonc", "json", "json5" },
        on_attach = on_attach,
        capabilities = capabilities_json_ls,
        -- settings = {
        --   json = {
        --     shemas = extended_schemas,
        --   },
        -- },
        -- capabilities = capabilities,
        -- filetypes = { "json", "jsonc", "json5" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas({
              -- extra = {
              --   {
              --     description = 'My custom JSON schema',
              --     fileMatch = 'project.json',
              --     name = 'project.json',
              --     url = 'https://github.com/nrwl/nx/blob/master/packages/nx/schemas/project-schema.json',
              --   }
              -- }
              -- ignore = {
              --   -- 'catalog-info.yaml',
              --   -- 'mkdocs.yml'
              -- }
            }),
            -- validate = { enable = true },
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

      -- require("java").setup()

      -- lspconfig["jdtls"].setup({})
      -- lspconfig["jdtls"].setup({
      --   -- on_attach = on_attach,
      --   -- capabilities = capabilities,
      -- })

      lspconfig["dockerls"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require("lspconfig").docker_compose_language_service.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- require("lspconfig").cssmodules_ls.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })

      -- require'lspconfig'.markdown_oxide.setup{
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- }

      lspconfig["marksman"].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- require("lspconfig").nxls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      -- require("lspconfig").emmet_language_server.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- })

      -- require'lspconfig'.emmet_language_server.setup{}

      require("lspconfig").emmet_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- configure lua server (with special settings)
      lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { -- custom settings for lua
          Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
              globals = { "vim", "jit", "bit", "Config" },
            },
            workspace = {
              -- make language server aware of runtime files
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
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

      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })

      -- require("lspconfig").lua_ls.setup({
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      --   -- on_init = function(client)
      --   --   local path = client.workspace_folders[1].name
      --   --   if
      --   --       not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
      --   --   then
      --   --     client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
      --   --       Lua = {
      --   --
      --   --         diagnostics = {
      --   --           globals = { "vim", "jit", "bit", "Config" },
      --   --         },
      --   --         runtime = {
      --   --           -- Tell the language server which version of Lua you're using
      --   --           -- (most likely LuaJIT in the case of Neovim)
      --   --           version = "LuaJIT",
      --   --         },
      --   --         -- Make the server aware of Neovim runtime files
      --   --         workspace = {
      --   --           checkThirdParty = false,
      --   --           library = {
      --   --             vim.env.VIMRUNTIME,
      --   --             -- [vim.fn.stdpath("config") .. "/lua"] = true,
      --   --             -- "${3rd}/luv/library"
      --   --             -- "${3rd}/busted/library",
      --   --           },
      --   --           -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
      --   --           -- library = vim.api.nvim_get_runtime_file("", true)
      --   --         },
      --   --       },
      --   --     })
      --   --
      --   --     client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      --   --   end
      --   --   return true
      --   -- end,
      -- })

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
