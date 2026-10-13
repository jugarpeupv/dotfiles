return {
	{
		"fredrikaverpil/godoc.nvim",
		version = "*",
		cmd = { "GoDoc" },
    dependencies = {
      "folke/snacks.nvim"
    },
		keys = {
			{ "<leader>gD", "<cmd>GoDoc<cr>" },
		},
		ft = { "go", "gomod" },
		-- dependencies = {
		-- 	{ "nvim-telescope/telescope.nvim" }, -- optional
		-- 	-- { "folke/snacks.nvim" }, -- optional
		-- 	-- { "echasnovski/mini.pick" }, -- optional
		-- 	-- { "ibhagwan/fzf-lua" }, -- optional
		-- },
		build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
		config = function()
			require("godoc").setup({
				adapters = {
					{
						name = "go",
						opts = {
							get_syntax_info = function()
								return {
									filetype = "godoc",
									language = "godoc",
								}
							end,
						},
					},
				},
				window = {
					-- fallback for :GoDoc via telescope/native pickers;
					-- snacks picker below bypasses this and uses <CR>/<C-v>/<C-s>
					type = "vsplit", -- split | vsplit
				},
				picker = {
					type = "snacks", -- native (vim.ui.select) | telescope | snacks | mini | fzf_lua

					-- per-picker options (see lua/godoc/pickers/<name>.lua for available fields)
					native = {},
					telescope = {},
					snacks = {},
					mini = {},
					fzf_lua = {},
				},
			})

			-- godoc snacks picker: <CR>=replace current buffer,
			-- <C-v>=vsplit, <C-s>=split (like telescope/snacks).
			-- Upstream hardcodes window.type (split|vsplit) in the
			-- callback, so we override the snacks picker to open
			-- the docs ourselves instead of going through open_window().
			do
				local snacks_picker = require("godoc.pickers.snacks")
				function snacks_picker.show(adapter, _config, _callback)
					local snacks = require("snacks")
					local godoc = require("godoc")

					-- Window that invoked :GoDoc (e.g. the godoc panel on
					-- follow-up lookups). snacks resolves its own "main"
					-- window by skipping non-file buffers (godoc doc buffers
					-- are scratch/nofile), so after close() focus would land
					-- in the previous code window and docs would replace the
					-- wrong buffer. Pin it ourselves instead.
					local src_win = vim.api.nvim_get_current_win()

					local function create_items()
						local items = {}
						for _, item_name in ipairs(adapter.get_items()) do
							table.insert(items, {
								text = item_name,
								item_name = item_name,
							})
						end
						return items
					end

					local syntax_info = adapter.get_syntax_info()

					local function open_with(how, picker, item, is_goto)
						if not item then
							return
						end
						snacks.picker.actions.close(picker)
						if vim.api.nvim_win_is_valid(src_win) then
							vim.api.nvim_set_current_win(src_win)
						end
						if how == "vsplit" then
							vim.cmd("vsplit")
						elseif how == "split" then
							vim.cmd("split")
						end
						if is_goto then
							godoc.goto_definition(adapter, item.item_name, snacks_picker.goto_definition)
						else
							godoc.show_documentation(adapter, item.item_name)
						end
					end

					snacks.picker.pick({
						finder = create_items,
						format = "text",
						title = "Select item",
						preview = function(ctx)
							if ctx.item then
								local content = adapter.get_content(ctx.item.item_name)
								ctx.preview:set_lines(content)
								ctx.preview:highlight({ ft = syntax_info.filetype })
							else
								ctx.preview:reset()
							end
						end or nil,
						win = {
							input = {
								keys = {
									["gd"] = { "godoc_goto", mode = { "n" } },
									["<C-v>"] = { "godoc_vsplit", mode = { "n", "i" } },
									["<C-s>"] = { "godoc_split", mode = { "n", "i" } },
								},
							},
						},
						actions = {
							confirm = function(picker, item)
								open_with("edit", picker, item, false)
							end,
							godoc_vsplit = function(picker, item)
								open_with("vsplit", picker, item, false)
							end,
							godoc_split = function(picker, item)
								open_with("split", picker, item, false)
							end,
							godoc_goto = function(picker, item)
								open_with("edit", picker, item, true)
							end,
						},
					})
				end
			end

			local godoc_parser = {
				install_info = {
					url = "https://github.com/fredrikaverpil/tree-sitter-godoc",
					files = { "src/parser.c" },
					version = "*",
				},
				filetype = "godoc",
			}

			require("nvim-treesitter.parsers").godoc = godoc_parser

			-- Map godoc filetype to the godoc parser
			vim.treesitter.language.register("godoc", "godoc")

			-- Re-register after :TSUpdate so the parser survives parser-list reloads
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").godoc = godoc_parser
				end,
			})

			-- Optional: also use the godoc filetype for `.godoc` files
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = "*.godoc",
				callback = function()
					vim.bo.filetype = "godoc"
				end,
			})

			vim.api.nvim_create_autocmd("PackChanged", {
				callback = function(ev)
					if
						ev.data.spec.name == "godoc.nvim"
						and (ev.data.kind == "install" or ev.data.kind == "update")
					then
						vim.system({
							"go",
							"install",
							"github.com/lotusirous/gostdsym/stdsym@latest",
						}):wait()
					end
				end,
			})
		end,
	},
	{
		"ray-x/go.nvim",
		enabled = true,
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			-- { "nvim-treesitter/nvim-treesitter", branch = 'main' } -- optional for master version
		},
		opts = function()
			--    local opts = {
			--      lsp_inlay_hints = {
			--        enable = false, -- this is the only field apply to neovim > 0.10
			--      },
			--    }
			-- require("go").setup(opts)
			-- local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			-- 	pattern = "*.go",
			-- 	callback = function()
			-- 		require("go.format").goimports()
			-- 	end,
			-- 	group = format_sync_grp,
			-- })
			return {
        lsp_inlay_hints = {
          enable = false, -- this is the only field apply to neovim > 0.10
        },
				-- lsp_keymaps = false,
				-- other options
			}
		end,
		-- event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	},
}
