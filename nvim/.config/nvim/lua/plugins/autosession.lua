return {
	-- Lua
	{
		"folke/persistence.nvim",
		enabled = true,
		lazy = true, -- loaded on demand from jg.core.worktree-repo-init
		event = { "BufReadPre" },
		opts = {
			-- Minimum number of named file buffers required before the session
			-- is written on VimLeavePre. The default (1) means: if you delete
			-- every buffer and quit, nothing is saved and the PREVIOUS session
			-- file survives, so the deleted buffers come back next launch.
			-- 0 = always save, i.e. the session reflects exactly what was open
			-- at exit.
			need = 0,
			-- One session per directory. Set to false if you want sessions
			-- scoped per git branch (the default in this fork).
			-- branch = false,
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "PersistenceLoadPost",
				callback = function()
					-- Restored buffers were created before the FileType handler in
					-- lua/plugins/treesitter.lua existed (lazy-loaded plugin), so
					-- start treesitter for them here. Guard against buffers with no
					-- filetype (scratch, terminal, prompts) or no installed parser,
					-- otherwise vim.treesitter.start() asserts.
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
							local ft = vim.bo[buf].filetype
							local lang = ft ~= "" and vim.treesitter.language.get_lang(ft) or nil
							-- local ok, loaded = lang and pcall(vim.treesitter.language.add, lang)
							pcall(vim.treesitter.start, buf, lang)
							-- if ok and loaded then
							-- 	pcall(vim.treesitter.start, buf, lang)
							-- end
						end
					end
				end,
			})
		end,
		config = function(_, opts)
			require("persistence").setup(opts)

			-- PersistenceSavePre: wipe buffers that :mksession cannot restore
			-- cleanly (neo-tree, opencode, mail, ...). Fyler is deliberately
			-- NOT wiped: the plugin restores its views from the fyler://
			-- placeholder written by :mksession (see lua/fyler/session.lua).
			vim.api.nvim_create_autocmd("User", {
				pattern = "PersistenceSavePre",
				callback = function()
					local excluded_ft = {
						"git",
						"neo-tree",
						"NvimTree",
						"mail",
						"notmuch-hello",
						"notmuch-threads",
						"opencode",
						"opencode_output",
					}
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						-- if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
						if vim.api.nvim_buf_is_valid(buf) then
							local ft = vim.bo[buf].filetype
							-- local bt = vim.bo[buf].buftype
							if vim.tbl_contains(excluded_ft, ft) then
								pcall(vim.api.nvim_buf_delete, buf, { force = true })
							end
						end
					end
				end,
			})
		end,
	},
	{
		"rmagatti/auto-session",
		enabled = false,
		-- event = "BufReadPost",
		lazy = false,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>Ws", "<cmd>AutoSession search<CR>", desc = "Session search" },
			{ "<leader>Wa", "<cmd>AutoSession save<CR>", desc = "Save session" },
		},
		---enables autocomplete for opts
		---@module "auto-session"
		---@diagnostic disable-next-line: undefined-doc-name
		---@type AutoSession.Config
		opts = {
			auto_save_enabled = true,
			auto_restore_enabled = true,
			auto_session_use_git_branch = true,
			-- close_unsupported_windows = {
			-- 	preserve_filetypes = { "fyler" },
			-- },
			-- cwd_change_handling = {
			-- 	post_cwd_changed_hook = function()
			-- 		require("lualine").refresh()
			-- 	end,
			-- },
		},
	},
}
