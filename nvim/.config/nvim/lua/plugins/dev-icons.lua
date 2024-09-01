return {
  -- {
  --   "rachartier/tiny-devicons-auto-colors.nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons"
  --   },
  --   event = "VeryLazy",
  --   config = function()
  --     require('tiny-devicons-auto-colors').setup()
  --   end
  -- },
  -- {
  --   "dgox16/devicon-colorscheme.nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("devicon-colorscheme").setup({
  --       colors = {
  --         blue = "#89b4fa",
  --         cyan = "#94e2d5",
  --         green = "#a6e3a1",
  --         magenta = "#f5c2e7",
  --         orange = "#eba0ac",
  --         purple = "#cba6f7",
  --         red = "#f38ba8",
  --         white = "#9399b2",
  --         yellow = "#f9e2af",
  --         bright_blue = "#89b4fa",
  --         bright_cyan = "#94e2d5",
  --         bright_green = "#a6e3a1",
  --         bright_magenta = "#f5c2e7",
  --         bright_orange = "#eba0ac",
  --         bright_purple = "#cba6f7",
  --         bright_red = "#f38ba8",
  --         bright_yellow = "#f9e2af",
  --       },
  --     })
  --   end,
  -- },
  {
    "nvim-tree/nvim-web-devicons",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    -- lazy = true,
    -- priority = 800,
    config = function()
      local present, devicons = pcall(require, "nvim-web-devicons")

      if not present then
        return
      end

      local options = {
        override = {
          html = {
            icon = "",
            name = "html",
            -- color = "#C24C38",
            color = "#F38BA8",
          },
          dockerfile = {
            icon = "",
            color = "#9CDCFE",
            name = "Dockerfile4",
          },
          groovy = {
            icon = "",
            name = "groovyfile",
          },
          [".npmrc"] = {
            icon = "",
            color = "#F38BA8",
            name = "npmrc1",
          },
          ["out"] = {
            icon = "",
            color = "#F38BA8",
            cterm_color = "124",
            name = "Out",
          },
          zsh = {
            icon = "",
            color = "#9CDCFE",
            cterm_color = "65",
            name = "Zsh",
          },
          ["scss"] = {
            icon = "󰟬",
            color = "#F38BA8",
            name = "scss1",
          },

          ["xlsx"] = {
            icon = "󰈛",
            color = "#73daca",
            name = "xlsx1",
          },
          ["csv"] = {
            icon = "",
            color = "#9CDCFE",
            name = "Csv",
          },
          ["md"] = {
            icon = "",
            color = "#9CDCFE",
            name = "Markdown2",
          },
          json = {
            icon = "󰘦",
            name = "json",
            color = "#9CDCFE",
          },
          js = {
            icon = "",
            name = "javascript",
            color = "#F9E2AF",
          },
          ["cjs"] = {
            icon = "",
            color = "#F9E2AF",
            name = "Cjs",
          },
          ["mjs"] = {
            icon = "",
            color = "#F9E2AF",
            name = "mjs1",
          },
          pdf = {
            icon = "",
            name = "pdf1",
            color = "#F38BA8",
          },
          txt = {
            icon = "󰈚",
            name = "txtname",
            color = "#8ee2cf",
          },
          toml = {
            icon = "",
            name = "toml",
            color = "#737aa2",
          },
          zip = {
            icon = "",
            name = "zipp",
            color = "#F9E2AF",
          },
          ["CODEOWNERS"] = { icon = "󱖨", color = "#73daca", name = "codeownersfile1" },
          ["d.ts"] = {
            -- icon = "",
            icon = "󰛦",
            -- color = "#F38BA8",
            -- color = "#CBA6F7",
            color = "#89B4FA",
            -- cterm_color = "172",
            name = "TypeScriptDeclaration",
          },
          default_icon = {
            -- icon = "󰙄",
            -- icon = "󰈤",
            -- icon = "🀄️",
            -- icon = "",
            -- icon = "🀀",
            -- icon = "",
            -- icon = "",
            icon = "",
            -- icon = "",
            -- icon = "📄",
            -- icon = "",
            -- color = "#73daca",
            -- color = "grey",
            color = "#7C7F93",
            name = "DefaultIcon",
          },
        },
        color_icons = true,
        default = false,
        strict = false,
        override_by_filename = {
          [".zshrc"] = {
            icon = "",
            color = "#7C7F93",
            name = "zshrc",
          },
          [".envrc"] = {
            icon = "",
            color = "#F2CDCD",
            name = "Envrc1",
          },

          ["tmux.conf"] = { icon = "", color = "#9CDCFE", name = "tmuxconf1" },
          ["docker-compose.yml"] = { icon = "󰡨", color = "#9CDCFE", name = "DockerComposeYml" },
          ["docker-compose.yaml"] = { icon = "󰡨", color = "#9CDCFE", name = "DockerComposeYml2" },
          [".dockerignore"] = { icon = "", color = "#9CDCFE", name = "DockerfileIgnore" },
          ["Dockerfile"] = { icon = "", color = "#9CDCFE", name = "Dockerfile2" },
          ["dockerfile"] = { icon = "", color = "#9CDCFE", name = "Dockerfile5" },
          ["app.routes.ts"] = { icon = "󰑪", color = "#73daca", name = "AngularRoutes" },
          ["webpack.config.js"] = { icon = "󰜫", color = "#9CDCFE", name = "WebpackConfig" },
          ["README.md"] = { icon = "", color = "#9CDCFE", name = "readmemd" },
          [".gitignore"] = { icon = "󰊢", color = "#CA9EE6", name = "gitignore" },
          ["readme.md"] = { icon = "", color = "#9CDCFE", name = "readmemd1" },
          ["webpack.prod.config.js"] = { icon = "󰜫", color = "#9CDCFE", name = "WebpackConfigProd" },
          ["webpack.config.ts"] = { icon = "󰜫", color = "#9CDCFE", name = "WebpackConfigTS" },
          ["webpack.prod.config.ts"] = { icon = "󰜫", color = "#9CDCFE", name = "WebpackConfigProdTS" },
          ["package.json"] = { icon = "", color = "#73daca", name = "PackageJson" },
          [".package.json"] = { icon = "", color = "#73daca", name = "PackageJson1" },
          ["*.package.json"] = { icon = "", color = "#73daca", name = "PackageJson2" },
          ["*package.json"] = { icon = "", color = "#73daca", name = "PackageJson3" },
          ["package-lock.json"] = { icon = "", color = "#73daca", name = "PackageLockJson" },
          ["pnpm-lock.yaml"] = { icon = "", color = "#F9E2AF", name = "pnpmLockYaml" },
          ["favicon.ico"] = { icon = "", color = "#F9E2AF", name = "faviconico" },
          ["codeowners"] = { icon = "󱖨", color = "#73daca", name = "codeownersfile2" },
          ["jenkinsfile"] = { icon = "", name = "Jenkins8", color = "#c0caf5" },
          ["jenkinsfileci"] = { icon = "", name = "Jenkins3", color = "#c0caf5" },
          ["jenkinsfilecd"] = { icon = "", name = "Jenkins4", color = "#c0caf5" },
          ["JenkinsfileCD"] = { icon = "", name = "Jenkins5", color = "#c0caf5" },
          ["JenkinsfileCI"] = { icon = "", name = "Jenkins7", color = "#c0caf5" },
          ["jest.config.ts"] = { icon = "󰙨", name = "jenkinsconfig1", color = "#f38bad" },
          ["jest.config.app.ts"] = { icon = "󰙨", name = "jenkinsconfigapp1", color = "#f38bad" },
          ["jest.config.js"] = { icon = "󰙨", name = "jenkinsconfig2", color = "#f38bad" },
          ["sonar-project.properties"] = { icon = "󰐷", color = "#CBA6F7", name = "sonarproperties" },
          ["nx.json"] = { icon = "󰰔", color = "#9CDCFE", name = "nxjson" },
          [".nxignore"] = { icon = "󰰔", color = "#7C7F93", name = "nxignore" },
          [".eslintignore"] = { icon = "󰱺", color = "#7C7F93", name = "eslintignore" },
          ["eslint.config.js"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintconfigjs" },
          ["eslint.config.ts"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintconfigts" },
          [".eslintrc.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintrcjson" },
          [".eslintrc.base.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintrcjson" },
          [".eslint-report.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintreportjson" },
          ["commitlint.config.ts"] = { icon = "󰜘", color = "#CBA6F7", name = "commitlintconfig12" },
          [".prettierignore"] = { icon = "", color = "#7C7F93", name = "prettierignore" },
          [".prettierrc"] = { icon = "", color = "#73daca", name = "prettierrc" },
          ["project.json"] = { icon = "", color = "#9CDCFE", name = "ProjectJson" },
          ["tsconfig.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile2" },
          ["tsconfig.editor.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile2" },
          ["tsconfig.base.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile2" },
          ["tsconfig.app.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile1" },
          ["tsconfig.lib.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile1" },
          ["tsconfig.spec.json"] = { icon = "󰛦", color = "#9CDCFE", name = "TSDeclarationfile1" },
        },
        override_by_extension = {
          [".env"] = {
            icon = "",
            color = "#F2CDCD",
            name = "Env2",
          },
          ["log"] = {
            icon = "",
            color = "#73daca",
            name = "Log",
          },
          ["module.ts"] = { icon = "", color = "#CBA6F7", name = "AngularModule1" },
          ["*.module.ts"] = { icon = "", color = "#CBA6F7", name = "AngularModule2" },
          [".module.ts"] = { icon = "", color = "#CBA6F7", name = "AngularModule" },
          ["service.ts"] = { icon = "", color = "#F9E2AF", name = "AngularService1" },
          [".service.ts"] = { icon = "", color = "#F9E2AF", name = "AngularService2" },

          ["component.ts"] = { icon = "󰚿", color = "#89b4fa", name = "AngularComponent1" },

          ["routes.ts"] = { icon = "󰑪", color = "#73daca", name = "AngularRoutesFile" },
          [".routes.ts"] = { icon = "󰑪", color = "#73daca", name = "AngularRoutesFile" },
          ["*.routes.ts"] = { icon = "󰑪", color = "#73daca", name = "AngularRoutesFile" },

          ["angular.json"] = { icon = "󰚿", color = "#f38ba8", name = "AngularJson" },
          ["*angular.json"] = { icon = "󰚿", color = "#f38ba8", name = "AngularJson" },
          ["*.angular.json"] = { icon = "󰚿", color = "#f38ba8", name = "AngularJson" },
          [".angular.json"] = { icon = "󰚿", color = "#f38ba8", name = "AngularJson" },
          ["directive.ts"] = { icon = "", color = "#6f32a8", name = "AngularDirective" },
          ["*.directive.ts"] = { icon = "", color = "#6f32a8", name = "AngularDirective" },
          [".directive.ts"] = { icon = "", color = "#6f32a8", name = "AngularDirective" },
          [".stories.ts"] = { icon = "", color = "#f55385", name = "Storie1" },
          ["stories.ts"] = { icon = "", color = "#f55385", name = "Storie2" },
          ["bun.lockb"] = { icon = "", color = "#F5C2E7", name = "bunlock" },
          ["codeowners"] = { icon = "󱖨", color = "#73daca", name = "codeownersfile3" },
          [".editorconfig"] = { icon = "", color = "#c0caf5", name = "Editorconfig" },
          ["drawio"] = { icon = "󰇟", color = "#F9E2AF", name = "drawio1" },
          ["spec.js"] = {
            icon = "",
            color = "#9CDCFE",
            name = "SpecJs",
          },
          ["spec.ts"] = {
            icon = "",
            color = "#9CDCFE",
            name = "SpecTs",
          },
          ["test.js"] = {
            icon = "",
            color = "#9CDCFE",
            name = "TestJs",
          },
          ["test.ts"] = {
            icon = "",
            color = "#9CDCFE",
            name = "SpecJs",
          },
        },
      }

      devicons.setup(options)
    end,
  },
}
