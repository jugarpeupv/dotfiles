-- return {}
return {
  {
    "nvim-tree/nvim-tree.lua",
    -- lazy = true,
    -- cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    -- commit = "517e4fbb9ef3c0986da7047f44b4b91a2400f93c",
    -- event = "VeryLazy",
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        -- cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
        -- lazy = true,
        -- priority = 800,
        opts = {
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
            ["eslint.config.mjs"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintconfigmjs" },
            [".eslintrc.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintrcjson" },
            [".eslintrc.base.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintrcjson" },
            [".eslint-report.json"] = { icon = "󰱺", color = "#9CDCFE", name = "eslintreportjson" },
            ["commitlint.config.ts"] = { icon = "󰜘", color = "#CBA6F7", name = "commitlintconfig12" },
            [".prettierignore"] = { icon = "", color = "#7C7F93", name = "prettierignore" },
            [".prettierrc"] = { icon = "", color = "#73daca", name = "prettierrc" },
            ["project.json"] = { icon = "", color = "#9CDCFE", name = "ProjectJson" },
            ["tsconfig.federation.json"] = {
              icon = "󰛦",
              color = "#9CDCFE",
              name = "TSDeclarationfile23",
            },
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
        },
        -- config = function()
        --   local present, devicons = pcall(require, "nvim-web-devicons")
        --
        --   if not present then
        --     return
        --   end
        --
        --
        --   devicons.setup(options)
        -- end,
      },
    },

    priority = 500,
    config = function()
      local api_nvimtree = require("nvim-tree.api")
      local nvim_tree_jg_utils = require("jg.custom.nvim-tree-utils")

      vim.api.nvim_create_autocmd("filetype", {
        pattern = "NvimTree",
        desc = "Mappings for NvimTree",
        group = vim.api.nvim_create_augroup("NvimTreeBulkCommands", { clear = true }),
        callback = function()
          -- Yank marked files
          vim.keymap.set("n", "bgy", function()
            local marks = api_nvimtree.marks.list()
            if #marks == 0 then
              print("No items marked")
              return
            end
            local absolute_file_paths = ""
            for _, mark in ipairs(marks) do
              absolute_file_paths = absolute_file_paths .. mark.absolute_path .. "\n"
            end
            -- Using system registers for multi-instance support.
            vim.fn.setreg("+", absolute_file_paths)
            print("Yanked " .. #marks .. " items")
          end, { remap = true, buffer = true })

          -- Paste files
          vim.keymap.set("n", "bgp", function()
            local source_paths = {}
            for path in vim.fn.getreg("+"):gmatch("[^\n%s]+") do
              source_paths[#source_paths + 1] = path
            end
            local node = api_nvimtree.tree.get_node_under_cursor()
            local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
            local target_path = is_folder and node.absolute_path
                or vim.fn.fnamemodify(node.absolute_path, ":h")
            for _, source_path in ipairs(source_paths) do
              vim.fn.system({ "cp", "-R", source_path, target_path })
            end
            api_nvimtree.tree.reload()
            print("Pasted " .. #source_paths .. " items")
          end, { remap = true, buffer = true })
        end,
      })

      api_nvimtree.events.subscribe(api_nvimtree.events.Event.TreeOpen, function()
        vim.wo.statusline = " "
        vim.cmd("hi! NvimTreeStatusLine guifg=none guibg=none")
        vim.opt.laststatus = 3
        -- vim.cmd("hi! NvimTreeStatusLineNC guifg=none guibg=none")
      end)

      local status_ok, nvim_tree = pcall(require, "nvim-tree")
      if not status_ok then
        return
      end

      local function on_attach(bufnr)
        local opts = function(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- mark operation
        local mark_move_j = function()
          api_nvimtree.marks.toggle()
          vim.cmd("norm j")
        end
        local mark_move_k = function()
          api_nvimtree.marks.toggle()
          vim.cmd("norm k")
        end

        -- marked files operation
        local mark_trash = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          -- vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
          --   if input == "y" then
          --     for _, node in ipairs(marks) do
          --       api.fs.trash(node)
          --     end
          --     api.marks.clear()
          --     api.tree.reload()
          --   end
          -- end)

          for _, node in ipairs(marks) do
            api_nvimtree.fs.trash(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end
        local mark_remove = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          -- vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
          --   if input == "y" then
          --     for _, node in ipairs(marks) do
          --       api.fs.remove(node)
          --     end
          --     api.marks.clear()
          --     api.tree.reload()
          --   end
          -- end)

          for _, node in ipairs(marks) do
            api_nvimtree.fs.remove(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end

        local mark_copy = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api_nvimtree.fs.copy.node(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end
        local mark_cut = function()
          local marks = api_nvimtree.marks.list()
          if #marks == 0 then
            table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
          end
          for _, node in pairs(marks) do
            api_nvimtree.fs.cut(node)
          end
          api_nvimtree.marks.clear()
          api_nvimtree.tree.reload()
        end

        local lib = require("nvim-tree.lib")
        -- add custom key mapping to search in directory with grug-far
        vim.keymap.set("n", "S", function()
          local node = lib.get_node_at_cursor()
          local grugFar = require("grug-far")
          if node then
            -- get directory of current file if it's a file
            local path
            if node.type == "directory" then
              -- Keep the full path for directories
              path = node.absolute_path
            else
              -- Get the directory of the file
              path = vim.fn.fnamemodify(node.absolute_path, ":h")
            end

            -- escape all spaces in the path with "\ "
            path = path:gsub(" ", "\\ ")

            local prefills = {
              paths = path,
            }

            -- instance check
            if not grugFar.has_instance("tree") then
              grugFar.open({
                instanceName = "tree",
                prefills = prefills,
                staticTitle = "Find and Replace from Tree",
              })
            else
              grugFar.open_instance("tree")
              -- updating the prefills without clearing the search and other fields
              grugFar.update_instance_prefills("tree", prefills, false)
            end
          end
        end, opts("Search in directory"))

        vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))
        vim.keymap.set("n", "<down>", mark_move_j, opts("Toggle Bookmark Down"))
        vim.keymap.set("n", "<up>", mark_move_k, opts("Toggle Bookmark Up"))

        vim.keymap.set("n", "bx", mark_cut, opts("Cut File(s)"))
        vim.keymap.set("n", "bD", mark_trash, opts("Trash File(s)"))
        vim.keymap.set("n", "bd", mark_remove, opts("Remove File(s)"))
        vim.keymap.set("n", "by", mark_copy, opts("Copy File(s)"))

        vim.keymap.set("n", "bm", api_nvimtree.marks.bulk.move, opts("Move Bookmarked"))

        -- vim.keymap.set("n", "K", api_nvimtree.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "K", nvim_tree_jg_utils.custom_info_popup, opts("Info"))

        -- Default mappings. Feel free to modify or remove as you wish.
        --
        -- BEGIN_DEFAULT_ON_ATTACH
        vim.keymap.set("n", "<C-c>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "<BS>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        -- vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
        vim.keymap.set("n", "<C-r>", api_nvimtree.fs.rename_sub, opts("Rename: Omit Filename"))
        vim.keymap.set("n", "<C-t>", api_nvimtree.node.open.tab, opts("Open: New Tab"))
        vim.keymap.set("n", "<C-v>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
        vim.keymap.set("n", "<C-x>", api_nvimtree.node.open.horizontal, opts("Open: Horizontal Split"))
        -- vim.keymap.set("n", "<BS>", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "h", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "l", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<CR>", api_nvimtree.node.open.edit, opts("Open"))
        -- vim.keymap.set('n', '<CR>', toggle_replace, opts('Open: In Place'))
        -- vim.keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
        vim.keymap.set("n", "<Tab>", api_nvimtree.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", ">", api_nvimtree.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<", api_nvimtree.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", ".", api_nvimtree.node.run.cmd, opts("Run Command"))
        vim.keymap.set("n", "-", api_nvimtree.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "a", api_nvimtree.fs.create, opts("Create"))
        -- vim.keymap.set('n', '<leader>cr', change_root_to_global_cwd, opts('Change Root To Global CWD'))
        -- vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
        vim.keymap.set("n", "B", api_nvimtree.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
        vim.keymap.set("n", "yy", api_nvimtree.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "C", api_nvimtree.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
        vim.keymap.set("n", "[c", api_nvimtree.node.navigate.git.prev, opts("Prev Git"))
        vim.keymap.set("n", "]c", api_nvimtree.node.navigate.git.next, opts("Next Git"))
        vim.keymap.set("n", "d", api_nvimtree.fs.remove, opts("Delete"))
        vim.keymap.set("n", "D", api_nvimtree.fs.trash, opts("Trash"))
        -- vim.keymap.set("n", "E", api.tree.expand_all, opts("Expand All"))
        vim.keymap.set("n", "e", api_nvimtree.fs.rename_basename, opts("Rename: Basename"))
        vim.keymap.set("n", "]e", api_nvimtree.node.navigate.diagnostics.next, opts("Next Diagnostic"))
        vim.keymap.set("n", "[e", api_nvimtree.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
        vim.keymap.set("n", "F", api_nvimtree.live_filter.clear, opts("Clean Filter"))
        vim.keymap.set("n", "f", api_nvimtree.live_filter.start, opts("Filter"))
        vim.keymap.set("n", "g?", api_nvimtree.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "gy", api_nvimtree.fs.copy.absolute_path, opts("Copy Absolute Path"))
        vim.keymap.set("n", "H", api_nvimtree.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
        vim.keymap.set("n", "I", api_nvimtree.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
        -- vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
        -- vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
        vim.keymap.set("n", "M", api_nvimtree.marks.clear, opts("Clear marks"))
        vim.keymap.set("n", "m", api_nvimtree.marks.toggle, opts("Toggle Bookmark"))
        vim.keymap.set("n", "o", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "O", api_nvimtree.node.open.no_window_picker, opts("Open: No Window Picker"))
        vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))
        vim.keymap.set("n", "P", api_nvimtree.node.navigate.parent, opts("Parent Directory"))
        vim.keymap.set("n", "q", api_nvimtree.tree.close, opts("Close"))
        vim.keymap.set("n", "r", api_nvimtree.fs.rename, opts("Rename"))
        vim.keymap.set("n", "R", api_nvimtree.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "s", api_nvimtree.node.run.system, opts("Run System"))
        vim.keymap.set("n", "z", api_nvimtree.tree.search_node, opts("Search"))
        vim.keymap.set("n", "U", api_nvimtree.tree.toggle_custom_filter, opts("Toggle Hidden"))
        vim.keymap.set("n", "W", api_nvimtree.tree.collapse_all, opts("Collapse"))
        vim.keymap.set("n", "x", api_nvimtree.fs.cut, opts("Cut"))
        vim.keymap.set("n", "c", api_nvimtree.fs.copy.filename, opts("Copy Name"))
        vim.keymap.set("n", "Y", api_nvimtree.fs.copy.relative_path, opts("Copy Relative Path"))
        vim.keymap.set("n", "<2-LeftMouse>", api_nvimtree.node.open.edit, opts("Open"))
        vim.keymap.set("n", "<2-RightMouse>", api_nvimtree.tree.change_root_to_node, opts("CD"))
        -- -- END_DEFAULT_ON_ATTACH

        -- Mappings removed via:
        --   remove_keymaps
        --   OR
        --   view.mappings.list..action = ""
        --
        -- The dummy set before del is done for safety, in case a default mapping does not exist.
        --
        -- You might tidy things by removing these along with their default mapping.
        vim.keymap.set("n", "<C-e>", "", { buffer = bufnr })
        vim.keymap.del("n", "<C-e>", { buffer = bufnr })

        -- vim.keymap.set('n', '<C-k>', '', { buffer = bufnr })
        -- vim.keymap.del('n', '<C-k>', { buffer = bufnr })

        -- Mappings migrated from view.mappings.list
        --
        -- You will need to insert "your code goes here" for any mappings with a custom action_cb
        vim.keymap.set("n", "<C-Enter>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
        -- vim.keymap.set('n', '<C-p>', api.node.show_info_popup, opts('Info'))
      end

      local HEIGHT_RATIO = 0.8 -- You can change this
      local WIDTH_RATIO = 0.5 -- You can change this too

      -- setup with all defaults
      nvim_tree.setup({
        ui = {
          confirm = {
            trash = false,
            remove = true,
          },
        },
        -- BEGIN_DEFAULT_OPTS
        auto_reload_on_write = true,
        disable_netrw = true,
        -- disable_netrw = false,
        hijack_cursor = true,
        hijack_netrw = true,
        -- hijack_netrw = false,
        hijack_unnamed_buffer_when_opening = true,
        sort_by = "name",
        sync_root_with_cwd = true,
        -- prefer_startup_root = true,
        -- *nvim-tree.prefer_startup_root*
        -- Prefer startup root directory when updating root directory of the tree.
        -- Only relevant when `update_focused_file.update_root` is `true`
        -- Type: `boolean`, Default: `false`
        respect_buf_cwd = false,
        on_attach = on_attach,
        live_filter = {
          always_show_folders = false,
        },
        modified = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = false,
        },
        view = {
          -- width = 45,
          width = 50,
          -- height = 30,
          -- hide_root_folder = false,
          side = "left",
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          -- mappings = {
          -- 	custom_only = false,
          -- 	list = {
          -- 		-- user mappings go here
          -- 		{ key = "<C-e>", action = "" },
          -- 		{ key = "<C-Enter>", action = "vsplit" },
          -- 		{ key = "<C-k>", action = "" },
          -- 		{ key = "<C-p>", action = "toggle_file_info" },
          --       { key = "h", action = "parent_close," },
          -- 	},
          -- },
          -- float = {
          --   enable = true,
          --   open_win_config = function()
          --     local screen_w = vim.opt.columns:get()
          --     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
          --     local window_w = screen_w * WIDTH_RATIO
          --     local window_h = screen_h * HEIGHT_RATIO
          --     local window_w_int = math.floor(window_w)
          --     local window_h_int = math.floor(window_h)
          --     local center_x = (screen_w - window_w) / 2
          --     local center_y = ((vim.opt.lines:get() - window_h) / 2)
          --         - vim.opt.cmdheight:get()
          --     return {
          --       border = 'rounded',
          --       relative = 'editor',
          --       row = center_y,
          --       col = center_x,
          --       width = window_w_int,
          --       height = window_h_int,
          --     }
          --   end,
          -- },
          -- width = function()
          --   return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          -- end,
        },
        renderer = {
          indent_markers = {
            enable = true,
            icons = {
              -- corner = "└ ",
              corner = "│ ",
              edge = "│ ",
              none = "  ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "after",
            modified_placement = "after",
            diagnostics_placement = "after",
            bookmarks_placement = "signcolumn",
            padding = " ",
            symlink_arrow = " ➛ ",
            -- symlink_arrow = "  ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
              diagnostics = true,
              bookmarks = true,
            },
            glyphs = {
              -- default = circle,
              -- default = "〣",
              -- default = "",
              -- default = "",
              default = "",
              modified = "[!]",
              -- modified = "",
              -- default = "",
              -- default = "",
              -- default = "",
              -- default = "",
              -- default = "🀪",
              -- default = "🀀",
              -- default = "",
              -- default = "🀅",
              -- default = "📰",
              -- default = "",
              -- default = "🗃",
              symlink = "",
              folder = {
                arrow_closed = "",
                -- arrow_closed = "",
                -- arrow_open = "",
                -- arrow_closed = "",
                -- arrow_open = "",
                arrow_open = "",
                -- default = "",
                -- open = "",
                -- default = "",
                -- open = "",
                -- default = "",
                default = "",
                open = "",
                -- open = "",
                empty = "󱞞",
                empty_open = "󱞞",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                -- empty = "",
                -- empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                -- unstaged = "",
                -- unstaged = "",
                -- staged = "",

                -- unstaged = "",
                -- staged = "",
                -- unstaged = "M",
                -- unstaged = "",
                -- unstaged = "󱈸",
                -- unstaged = "󰐾 ",
                -- staged = "󰐾 ",
                -- staged = "",
                -- staged = ""
                -- staged = "",
                -- unstaged = "",
                staged = "+",
                unstaged = "!",
                -- unstaged = "󰀨 ",
                -- staged = "󰀨 ",
                -- staged = "󰐗 ",
                -- staged = "󱇭 ",
                -- staged = "   󰧞 󰺕 󰐾  󰻂           󰗖     "
                -- staged = "󱤧 ",
                -- unstaged = "!",
                -- staged = "+",
                -- unstaged = "!",
                -- staged = "+",
                -- unmerged = "",
                -- renamed = "➜",
                renamed = "󰕛 ",
                -- renamed = " ",
                -- unmerged = "",
                unmerged = " ",
                -- untracked = "★",
                -- untracked = "",
                untracked = "?",
                -- deleted = "",
                -- deleted = "✗",
                deleted = "󰧧",
                -- ignored = "◌",
                -- ignored = " "
                ignored = " ",
              },
            },
          },
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = false,
          update_root = { enable = false },
        },
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = true,
          show_on_dirs = false,
          show_on_open_dirs = false,
          debounce_delay = 30,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            -- hint = "",
            -- hint = "",
            hint = "󰠠 ",
            -- info = "",
            info = " ",
            warning = " ",
            error = " ",
          },
        },
        filters = {
          dotfiles = false,
          custom = {},
          exclude = {},
        },
        git = {
          ignore = false,
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = false,
          disable_for_dirs = {},
          timeout = 400,
          cygwin_support = false,
        },
        filesystem_watchers = {
          enable = false,
          debounce_delay = 30,
          ignore_dirs = { "node_modules" },
        },
        actions = {
          use_system_clipboard = true,
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "rounded",
              style = "minimal",
            },
          },
          change_dir = {
            enable = true,
            global = true,
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = false,
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            git = false,
            profile = false,
          },
        },
      }) -- END_DEFAULT_OPTS

      vim.cmd([[hi NvimTreeFolderIcon guifg=#89B4FA]])
      vim.cmd([[hi NvimTreeRootFolder gui=none]])
      vim.cmd([[highlight NvimTreeGitDirty guifg=#F9E2AF]])
      vim.cmd([[highlight NvimTreeGitStaged guifg=#8ee2cf]])
      vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F5C2E7]])
      -- vim.cmd([[highlight NvimTreeExecFile gui=none guifg=#F38BA8]])
      vim.cmd([[highlight NvimTreeModifiedFile gui=none guifg=#737aa2]])
      -- vim.cmd [[highlight NvimTreeModifiedFile gui=none guifg=#EFF1F5]]
      vim.cmd([[highlight NvimTreeGitNew guifg=#89ddff]])
      vim.cmd([[highlight NvimTreeCursorLine guibg=#3b4261]])
      vim.cmd([[highlight NvimTreeStatusLineNC guibg=none]])
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    opts = {
      default_component_configs = {
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = true,
        },
      },
    },
    -- config = function()
    --   -- If you want icons for diagnostic errors, you'll need to define them somewhere:
    --   vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    --   vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    --   vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    --   vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })
    --
    --   require("neo-tree").setup({
    --     close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    --     popup_border_style = "rounded",
    --     enable_git_status = true,
    --     enable_diagnostics = true,
    --     open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
    --     sort_case_insensitive = false,                                 -- used when sorting files and directories in the tree
    --     sort_function = nil,                                           -- use a custom function for sorting files and directories in the tree
    --     -- sort_function = function (a,b)
    --     --       if a.type == b.type then
    --     --           return a.path > b.path
    --     --       else
    --     --           return a.type > b.type
    --     --       end
    --     --   end , -- this sorts files and directories descendantly
    --     default_component_configs = {
    --       -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
    --       file_size = {
    --         enabled = true,
    --         required_width = 64, -- min width of window required to show this column
    --       },
    --       type = {
    --         enabled = true,
    --         required_width = 64, -- min width of window required to show this column
    --       },
    --       last_modified = {
    --         enabled = true,
    --         required_width = 64, -- min width of window required to show this column
    --       },
    --       created = {
    --         enabled = true,
    --         required_width = 64, -- min width of window required to show this column
    --       },
    --       symlink_target = {
    --         enabled = true
    --       },
    --     },
    --   })
    --
    --   vim.cmd([[nnoremap \ :Neotree current<cr>]])
    -- end,
  },
}
