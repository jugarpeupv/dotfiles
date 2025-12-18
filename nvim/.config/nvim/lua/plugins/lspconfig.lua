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
			-- {
			-- 	"hinell/lsp-timeout.nvim",
			-- 	enabled = false,
			-- 	dependencies = { "neovim/nvim-lspconfig" },
			-- },
			-- {
			-- 	"zeioth/garbage-day.nvim",
			-- 	dependencies = "neovim/nvim-lspconfig",
			-- 	enabled = false,
			-- 	opts = {
			-- 		aggressive_mode = true,
			-- 		notifications = false,
			-- 	},
			-- },
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

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false -- https://github.com/neovim/neovim/issues/23291

			local on_attach = require("jg.custom.lsp-utils").attach_lsp_config

			vim.lsp.config("*", {
				on_attach = on_attach,
				capabilities = capabilities,
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

			-- local lsp_config = {
			-- 	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/gh-actions-language-server", "--stdio" },
			-- 	filetypes = { "yaml.github" },
			-- 	init_options = {
			-- 		sessionToken = os.getenv("GH_ACTIONS_PAT"),
			-- 		repos = {},
			-- 	},
			-- 	-- single_file_support = true,
			-- 	-- `root_dir` ensures that the LSP does not attach to all yaml files
			-- 	root_dir = function(bufnr, on_dir)
			-- 		local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
			-- 		if vim.endswith(parent, "/.github/workflows") then
			-- 			on_dir(parent)
			-- 		end
			-- 	end,
			-- 	-- root_dir = function(bufnr, on_dir)
			-- 	-- 	local parent = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
			-- 	--
			-- 	-- 	-- Check if we're in a workflow directory
			-- 	-- 	if
			-- 	-- 		vim.endswith(parent, "/.github/workflows")
			-- 	-- 		or vim.endswith(parent, "/.forgejo/workflows")
			-- 	-- 		or vim.endswith(parent, "/.gitea/workflows")
			-- 	-- 	then
			-- 	-- 		-- Find the git root of the current worktree
			-- 	-- 		local git_root = vim.fs.find(".git", {
			-- 	-- 			path = parent,
			-- 	-- 			upward = true,
			-- 	-- 			type = "directory",
			-- 	-- 		})[1]
			-- 	--
			-- 	-- 		if git_root then
			-- 	-- 			on_dir(vim.fs.dirname(git_root))
			-- 	-- 		else
			-- 	-- 			on_dir(parent)
			-- 	-- 		end
			-- 	-- 	end
			-- 	-- end,
			-- 	handlers = {
			-- 		["actions/readFile"] = function(_, result)
			-- 			if type(result.path) ~= "string" then
			-- 				return nil, { code = -32602, message = "Invalid path parameter" }
			-- 			end
			-- 			local file_path = vim.uri_to_fname(result.path)
			-- 			if vim.fn.filereadable(file_path) == 1 then
			-- 				local f = assert(io.open(file_path, "r"))
			-- 				local text = f:read("*a")
			-- 				f:close()
			-- 				return text, nil
			-- 			else
			-- 				return nil, { code = -32603, message = "File not found: " .. file_path }
			-- 			end
			-- 		end,
			-- 	},
			-- 	capabilities = {
			-- 		workspace = {
			-- 			didChangeWorkspaceFolders = {
			-- 				dynamicRegistration = true,
			-- 			},
			-- 		},
			-- 	},
			-- }
			--
			-- if vim.lsp.config then
			-- 	vim.lsp.config["gh_actions_ls"] = lsp_config
			-- 	vim.lsp.enable({ "gh_actions_ls" })
			-- 	-- Fetch repo info async and update running clients
			-- 	vim.schedule(function()
			-- 		local init_opts = require("jg.custom.lsp-utils").get_gh_actions_init_options()
			--
			-- 		-- Update the config for future clients
			-- 		lsp_config.init_options = init_opts
			--
			-- 		-- Notify any already-running clients with workspace/didChangeConfiguration
			-- 		for _, client in ipairs(vim.lsp.get_clients({ name = "gh_actions_ls" })) do
			-- 			client.config.init_options = init_opts
			-- 			---@diagnostic disable-next-line: param-type-mismatch
			-- 			client.notify("workspace/didChangeConfiguration", { settings = init_opts })
			-- 		end
			-- 	end)
			-- end

					local server_filetypes = {
				angularls = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx", "html" },
				bashls = { "sh", "bash", "zsh" },
				clangd = { "c", "cpp", "objc", "objcpp" },
				copilot_ls = { "lua", "python", "javascript", "typescript", "typescriptreact", "javascriptreact", "go", "ruby", "rust", "java" },
				docker_compose_language_service = { "yaml", "yml", "dockercompose" },
				dockerls = { "dockerfile" },
				emmet_ls = { "html", "css", "scss", "less", "javascriptreact", "typescriptreact" },
				eslint = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				gh_actions_ls = { "yaml", "yaml.github", "yml" },
				gopls = { "go", "gomod", "gowork" },
				groovyls = { "groovy" },
				html = { "html" },
				jdtls = { "java" },
				jsonls = { "json", "jsonc" },
				kulala_ls = { "http" },
				lua_ls = { "lua" },
				marksman = { "markdown" },
				pyright = { "python" },
				ruby_lsp = { "ruby" },
				rust_analyzer = { "rust" },
				somesass_ls = { "sass", "scss" },
				tailwindcss = { "html", "javascript", "typescript", "vue", "svelte", "php", "heex", "tsx", "jsx" },
				vtsls = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				yamlls = { "yaml", "yaml.github", "yml" },
			}

			local has_new_lsp_api = vim.fn.has("nvim-0.10") == 1 and vim.lsp.enable ~= nil
			if has_new_lsp_api then
				local group = vim.api.nvim_create_augroup("lazy_lsp_enable", { clear = true })
				for server, patterns in pairs(server_filetypes) do
					vim.api.nvim_create_autocmd("FileType", {
						group = group,
						pattern = patterns,
						once = false,
						callback = function(event)
							local clients = vim.lsp.get_clients({ bufnr = event.buf, name = server })
							-- if #clients > 0 then
							-- 	return
							-- end
							local ok, err = pcall(vim.lsp.enable, server, { bufnr = event.buf })
							if not ok then
								vim.notify(string.format("Failed to enable LSP '%s': %s", server, err), vim.log.levels.WARN)
							end
						end,
					})
				end
			else
				for server, _ in pairs(server_filetypes) do
					vim.lsp.enable(server)
				end
			end
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
