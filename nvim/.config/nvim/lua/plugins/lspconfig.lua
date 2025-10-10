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
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		enabled = function()
			local is_headless = #vim.api.nvim_list_uis() == 0
			if is_headless then
				return false
			end
			return true
		end,
		dependencies = { "JavaHello/spring-boot.nvim", "mfussenegger/nvim-dap" },
	},
	{
		"andreluisos/nvim-javagenie",
		enabled = false,
		ft = { "java" },
		dependencies = {
			"grapp-dev/nui-components.nvim",
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"jugarpeupv/springboot-nvim",
		-- dir = "~/projects/springboot-nvim",
		-- dev = true,
		ft = { "java" },
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
			springboot_nvim.setup()
		end,
	},
	{
		"JavaHello/java-deps.nvim",
		ft = { "java" },
		lazy = true,
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
		ft = { "java", "yaml", "jproperties" },
		dependencies = {
			"mfussenegger/nvim-jdtls",
		},
		opts = function()
			local home = os.getenv("HOME")
			-- mason for sonarlint-language path
			local mason_registery_status = pcall(require, "mason-registry")
			if not mason_registery_status then
				vim.notify("Mason registery not found", vim.log.levels.ERROR, { title = "Spring boot" })
				return
			end

			local opts = {}
			-- opts.ls_path = mason_registery.get_package("spring-boot-tools"):get_install_path()
			-- 	.. "/extension/language-server"

			-- /Users/jgarcia/.local/share/nvim/mason/packages/spring-boot-tools/extension/language-server/spring-boot-language-server-1.59.0-SNAPSHOT-exec.jar
			opts.ls_path = os.getenv("MASON")
				.. "/packages/spring-boot-tools/extension/language-server/spring-boot-language-server-1.59.0-SNAPSHOT-exec.jar"
			-- print("jdtls opts.ls_path: ", opts.ls_path)

			-- jdtls opts.ls_path:  /Users/jgarcia/.local/share/nvim/mason/packages/spring-boot-tools/extension/language-server
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
			{ "saghen/blink.cmp" },
			{ "nvim-telescope/telescope.nvim" },
			{
				"VidocqH/lsp-lens.nvim",
				enabled = false,
				config = function()
					require("lsp-lens").setup({})
				end,
			},
			{
				"hinell/lsp-timeout.nvim",
				enabled = false,
				dependencies = { "neovim/nvim-lspconfig" },
				-- init = function()
				-- 	vim.g.lspTimeoutConfig = {
				-- 		-- see config below
				-- 	}
				-- end,
			},
			{
				"zeioth/garbage-day.nvim",
				dependencies = "neovim/nvim-lspconfig",
				enabled = false,
				opts = {
					aggressive_mode = true,
					notifications = false,
					-- excluded_lsp_clients = {
					-- 	"copilot",
					-- },
					-- your options here
				},
			},
			{
				"b0o/schemastore.nvim",
				lazy = true,
			},
			{
				"j-hui/fidget.nvim",
				opts = {
					progress = {
						suppress_on_insert = true, -- Suppress new messages while in insert mode
						ignore_done_already = true, -- Ignore new tasks that are already complete
						ignore_empty_message = true,
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
			-- {
			--   "smjonas/inc-rename.nvim",
			--   lazy = true,
			--   config = function()
			--     require("inc_rename").setup()
			--   end,
			-- },
			{
				"rmagatti/goto-preview",
				enabled = false,
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
			-- { "folke/neodev.nvim", opts = {} },
			{
				-- "antosha417/nvim-lsp-file-operations",
				"igorlfs/nvim-lsp-file-operations",
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
			-- { "hrsh7th/nvim-cmp" },
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
				"jayp0521/mason-null-ls.nvim",
				enabled = false,
				-- enabled = function()
				-- 	local is_headless = #vim.api.nvim_list_uis() == 0
				-- 	if is_headless then
				-- 		return false
				-- 	end
				-- 	return true
				-- end,
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
			local on_attach = require("jg.custom.lsp-utils").attach_lsp_config
			local root_pattern = require("lspconfig.util").root_pattern

			-- used to enable autocompletion (assign to every lsp server config)
			-- local capabilities = cmp_nvim_lsp.default_capabilities()
			-- local capabilities = require("blink.cmp").get_lsp_capabilities()
			local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			vim.tbl_deep_extend("force", capabilities, blink_capabilities)
			-- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false -- https://github.com/neovim/neovim/issues/23291

			local config = {
				virtual_text = false,
				-- virtual_text = { spacing = 4, prefix = "●" },
				-- virtual_text = { spacing = 4, prefix = "" },
				-- virtual_text = { spacing = 4, prefix = " " },

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
					-- style = "minimal",
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

			-- ################### SERVER CONFIGURATIONS

			-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			-- 	wrap = true,
			-- 	border = "rounded", -- Optional: Add rounded borders to the hover window
			-- })

			-- configure html server
			vim.lsp.config("html", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "myangular", "html", "templ", "htmlangular" },
			})

			vim.lsp.enable("html")

			-- require('lspconfig').npmls = {
			--   default_config = {
			--     cmd = { "npm-workspaces-language-server", "--stdio" },
			--     filetypes = { "json", "packagejson" },
			--     root_dir = require('lspconfig.util').root_pattern("package.json", ".git"),
			--     -- single_file_support = false,
			--   }
			-- }
			--
			-- require('lspconfig').npmls.setup({})

			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							maxInlayHintLength = 30,
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						tsserver = {
							maxTsServerMemory = 8192,
						},
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

			vim.lsp.enable("vtsls")

			-- configure css server
			-- vim.lsp.config("cssls", {
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- })
			-- vim.lsp.enable("cssls")

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("pyright")

			-- configure tailwindcss server
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"htmlangular",
				},
				root_dir = root_pattern(
					"tailwind.config.js",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.ts"
				),
			})

			vim.lsp.enable("tailwindcss")

			-- local ok, mason_registry = pcall(require, "mason-registry")
			-- if not ok then
			-- 	vim.notify("mason-registry could not be loaded")
			-- 	return
			-- end

			-- local angularls_path = mason_registry.get_package("angular-language-server"):get_install_path()
			local angularls_path = os.getenv("MASON") .. "/packages/angular-language-server"
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

			vim.lsp.config("angularls", {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = angular_cmd,
				on_new_config = function(new_config, _)
					new_config.cmd = angular_cmd
				end,
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
				root_dir = root_pattern("angular.json", "project.json", "nx.json"),
			})
			vim.lsp.enable("angularls")

			vim.lsp.config("groovyls", {
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
			vim.lsp.enable("groovyls")

			local on_publish_diagnostics = vim.lsp.diagnostic.on_publish_diagnostics

			vim.lsp.config("bashls", {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "bash-language-server", "start" },
				filetypes = { "bash", "sh", "yaml.github" },
				handlers = {
					["textDocument/publishDiagnostics"] = function(err, res, ...)
						local file_name = vim.fn.fnamemodify(vim.uri_to_fname(res.uri), ":t")
						if string.match(file_name, "^%.env") == nil then
							return on_publish_diagnostics(err, res, ...)
						end
					end,
				},
			})
			vim.lsp.enable("bashls")

			local capabilities_json_ls = vim.lsp.protocol.make_client_capabilities()
			capabilities_json_ls.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.config("eslint", {
				cmd = { home .. "/.local/share/nvim/mason/bin/vscode-eslint-language-server", "--stdio" },
				on_attach = on_attach,
				-- handlers = {
				-- 	["eslint/noLibrary"] = function(err, params, ctx, config)
				-- 		print("[eslint] No ESLint library found for this project.")
				-- 		print(err)
				-- 		-- Do nothing else, suppress error
				-- 	end,
				-- 	["textDocument/diagnostic"] = function(err, result, ctx, config)
				-- 		if result and result.diagnostics then
				-- 			for _, diagnostic in ipairs(result.diagnostics) do
				-- 				if diagnostic.message:match("failed to load plugin") then
				-- 					diagnostic.severity = vim.diagnostic.severity.WARN
				-- 				end
				-- 			end
				-- 		end
				-- 		vim.lsp.handlers["textDocument/diagnostic"](err, result, ctx, config)
				-- 	end,
				-- },

				-- handlers = {
				--   ["eslint/noLibrary"] = function(err, params, ctx, config)
				--     print("[eslint] No ESLint library found for this project.")
				--     print(err)
				--     -- Do nothing else, suppress error
				--   end,
				-- },
				settings = {
					quiet = false,
					run = "onSave",
					-- experimental = {
					--   useFlatConfig = true
					-- },
				},
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

			vim.lsp.enable("eslint")

			-- defined in telescope yaml companion
			vim.lsp.config("yamlls", {
				filetypes = { "yaml", "yml" },
				cmd = { home .. "/.local/share/nvim/mason/bin/yaml-language-server", "--stdio" },
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
						validate = true,
						hover = true,
						-- schemaStore = {
						--   enable = true,
						--   url = "",
						-- },
						-- schemas = {}

						schemas = require("schemastore").json.schemas({}),
						-- schemas = {
						--   ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
						-- }
					},
				},
			})
			vim.lsp.enable("yamlls")

			vim.lsp.config("jsonls", {
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
			vim.lsp.enable("jsonls")

			vim.lsp.config("rust_analyzer", {
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
			vim.lsp.enable("rust_analyzer")

			vim.lsp.config("dockerls", {
				on_attach = on_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable("dockerls")

			vim.lsp.config("marksman", {
				on_attach = on_attach,
				capabilities = capabilities,
				root_markers = { ".marksman.toml", ".git", ".gitignore", ".obsidian.vimrc" },
				root_dir = root_pattern(
					".git",
					".marksman.toml",
					".obsidian",
					"README.md",
					".obsidian.vimrc",
					".gitignore"
				),
			})
			vim.lsp.enable("marksman")

			vim.lsp.config("emmet_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("emmet_ls")

			vim.lsp.config("sourcekit", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("sourcekit")

			-- configure lua server (with special settings)

			-- vim.lsp.config("emmylua_ls", {
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- })
			-- vim.lsp.enable("emmylua_ls")

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("lua_ls")

			-- lspconfig["lua_ls"].setup({
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- 	settings = { -- custom settings for lua
			-- 		Lua = {
			-- 			diagnostics = {
			-- 				globals = { "vim", "jit", "bit", "Config" },
			-- 			},
			--          workspace = {
			--              library = {
			--                  -- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--                  -- [vim.fn.stdpath("config") .. "/lua"] = true,
			--                },
			--              },
			-- 			-- workspace = {
			-- 			--   library = {
			-- 			--     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			-- 			--     [vim.fn.stdpath("config") .. "/lua"] = true,
			-- 			--   },
			-- 			-- },
			-- 		},
			-- 	},
			-- })

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("clangd")

			vim.filetype.add({
				pattern = {
					[".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
				},
			})

			local function get_init_options()
				local init_options = require("jg.custom.lsp-utils").get_gh_actions_init_options()
				return init_options
			end

			vim.lsp.config("gh_actions_ls", {
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					workspace = {
						didChangeWorkspaceFolders = {
							dynamicRegistration = true,
						},
					},
				}),
				handlers = {
					["actions/readFile"] = function(_, result)
						if type(result.path) ~= "string" then
							return nil, nil
						end
						local file_path = vim.uri_to_fname(result.path)
						if vim.fn.filereadable(file_path) == 1 then
							local content = vim.fn.readfile(file_path)
							local text = table.concat(content, "\n")
							return text, nil
						end
						return nil, nil
					end,
				},
				on_attach = on_attach,
				before_init = function(params)
					params.initializationOptions = get_init_options()
				end,
				init_options = get_init_options(),
				filetypes = { "yaml.github" },
				cmd = { home .. "/.local/share/nvim/mason/bin/gh-actions-language-server", "--stdio" },
				settings = {
					yaml = {
						format = {
							enable = true,
						},
						validate = {
							enable = true,
						},
					},
				},
			})
			vim.lsp.enable("gh_actions_ls")

			vim.lsp.config("ruby_lsp", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("ruby_lsp")

			vim.lsp.config("docker_compose_language_service", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("docker_compose_language_service")

			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("copilot_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("copilot_ls")

			vim.lsp.config("kulala_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("kulala_ls")

			vim.lsp.config("somesass_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
			})
			vim.lsp.enable("somesass_ls")

			-- vim.lsp.config("css_variables", {
			--   capabilities = capabilities,
			--   on_attach = on_attach,
			-- })
			-- vim.lsp.enable("css_variables")

			-- Set global defaults for all servers
			local lspconfig = require("lspconfig")
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
