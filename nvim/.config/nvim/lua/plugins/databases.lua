return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{
				"https://github.com/tpope/vim-dotenv",
				cmd = { "Dotenv" },
				init = function()
					local group = vim.api.nvim_create_augroup("vim_dotenv_cwd", { clear = true })
					vim.api.nvim_create_autocmd("DirChanged", {
						group = group,
						callback = function()
							if vim.fn.filereadable(vim.fn.getcwd() .. "/.env") == 1 then
								require("lazy").load({ plugins = { "vim-dotenv" } })
							end
						end,
					})
				end,
			},
			{ "tpope/vim-dadbod", lazy = true },
			{
				"kristijanhusak/vim-dadbod-completion",
				ft = { "sql", "mysql", "plsql" },
				lazy = true,
			},
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>db", "<cmd>DBUIToggle<CR>", desc = "Toggle DBee" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_win_position = "right"
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_use_nvim_notify = 0
			vim.g.db_ui_disable_mappings = 1
			vim.g.db_ui_disable_mappings_dbui = 1
			vim.g.db_ui_disable_mappings_dbout = 1
			vim.g.db_ui_disable_mappings_sql = 1
			vim.g.db_ui_disable_mappings_javascript = 1
      vim.g.db_ui_execute_on_save = 0

			-- vim.g.dbs = {
			-- 	-- nomo = "sqlite:" .. vim.fn.expand("~/projects/nomo/wt-feature-rebrand/server/prisma/dev.db"),
			-- }
		end,
		config = function()
			local function map(buf, mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
			end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("dbui_custom_maps", { clear = true }),
				pattern = { "dbui", "sql", "javascript", "dbout" },
				callback = function(ev)
					local buf, ft = ev.buf, ev.match

					if ft == "dbui" then -- drawer
						map(buf, "n", "<CR>", "<Plug>(DBUI_SelectLine)", "DBUI: open/toggle")
						map(buf, "n", "o", "<Plug>(DBUI_SelectLine)", "DBUI: open/toggle")
						map(buf, "n", "<C-v>", "<Plug>(DBUI_SelectLineVsplit)", "DBUI: open vsplit")
						map(buf, "n", "D", "<Plug>(DBUI_DeleteLine)", "DBUI: delete")
						map(buf, "n", "r", "<Plug>(DBUI_RenameLine)", "DBUI: rename")
						map(buf, "n", "R", "<Plug>(DBUI_Redraw)", "DBUI: redraw")
						map(buf, "n", "A", "<Plug>(DBUI_AddConnection)", "DBUI: add connection")
						map(buf, "n", "H", "<Plug>(DBUI_ToggleDetails)", "DBUI: toggle details")
						map(buf, "n", "q", "<Plug>(DBUI_Quit)", "DBUI: quit")
					elseif ft == "sql" or ft == "javascript" then -- query buffers
						map(buf, { "n", "x" }, "<CR>", "<Plug>(DBUI_ExecuteQuery)", "DBUI: execute query")
						map(buf, "n", "<leader><leader>", "<Plug>(DBUI_SaveQuery)", "DBUI: save query")
						map(buf, "n", "<S-CR>", "<Plug>(DBUI_EditBindParameters)", "DBUI: bind params")
					elseif ft == "dbout" then -- result buffer
						map(buf, "n", "<leader><leader>", "<Plug>(DBUI_ToggleResultLayout)", "DBUI: toggle layout")
						map(buf, "n", "<CR>", "<Plug>(DBUI_JumpToForeignKey)", "DBUI: jump to FK")
					end
				end,
			})
		end,
	},
	{
		"kndndrj/nvim-dbee",
		dependencies = { "MunifTanjim/nui.nvim" },
		cmd = { "Dbee" },
		keys = {
			{ "<leader>dB", "<cmd>Dbee toggle<CR>", desc = "Toggle DBee" },
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup({
				sources = {
					require("dbee.sources").MemorySource:new({
						{
							name = "Nomo dev",
							type = "sqlite",
							url = vim.fn.expand("~/projects/nomo/wt-feature-rebrand/server/prisma/dev.db"),
						},
					}),
				},
			})
		end,
	},
}
