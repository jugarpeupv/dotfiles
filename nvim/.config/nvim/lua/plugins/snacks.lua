return {
	"folke/snacks.nvim",
	priority = 800,
	enabled = true,
	-- event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		image = {
			doc = {
				enabled = false
			},
			math = {
				enabled = false,
			},
		},
		-- input = {},
		-- indent = {
		--   animate = {
		--     enabled = false
		--   }
		-- },
		gh = {},
		layout = {},
		-- debug = {},
		-- scratch = {
		--   ft = function()
		--     if vim.bo.buftype == "" and vim.bo.filetype ~= "" then
		--       return vim.bo.filetype
		--     end
		--     return "lua"
		--   end,
		-- },
		bigfile = {
			notify = false, -- show notification when big file detected
			size = 0.7 * 1024 * 1024, -- 1.5MB
			line_length = 1000, -- average line length (useful for minified files)
			-- Enable or disable features when big file detected
			---@param ctx {buf: number, ft:string}
			setup = function(ctx)
				vim.b.matchparen_enabled = false
				vim.treesitter.stop(ctx.buf)

				vim.b.matchup_matchparen_enabled = 0
				vim.b.matchup_matchparen_fallback = 0

				-- Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0, number = false, relativenumber = false })
				Snacks.util.wo(0, {
					foldmethod = "manual",
					statuscolumn = "",
					conceallevel = 0,
					relativenumber = false,
					number = true,
				})
				vim.b.minianimate_disable = true
				vim.b.minihipatterns_disable = true
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(ctx.buf) then
						vim.bo[ctx.buf].syntax = ctx.ft
					end
				end)
			end,
		},
		picker = {
			ui_select = true,
			---@class snacks.picker.matcher.Config
			matcher = {
				fuzzy = true, -- use fuzzy matching
				smartcase = true, -- use smartcase
				ignorecase = true, -- use ignorecase
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = true, -- give bonus for matching files in the cwd
				frecency = true, -- frecency bonus
				history_bonus = true, -- give more weight to chronological order
			},
			sources = {
				gh_issue = {},
				gh_pr = {},
			},
			win = {
				-- input window
				input = {
					keys = {
						-- to close the picker on ESC instead of going to normal mode,
						-- add the following keymap to your config
						-- ["<Esc>"] = { "close", mode = { "n", "i" } },
						["/"] = "toggle_focus",
						["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
						["<C-Up>"] = { "history_back", mode = { "i", "n" } },
						["<C-c>"] = { "cancel", mode = "i" },
						["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
						["<CR>"] = { "confirm", mode = { "n", "i" } },
						["<Down>"] = { "list_down", mode = { "i", "n" } },
						["<Esc>"] = "cancel",
						["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
						["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
						["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
						["<Up>"] = { "list_up", mode = { "i", "n" } },
						["<a-d>"] = { "inspect", mode = { "n", "i" } },
						["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
						["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
						["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
						["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
						["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
						["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
						["<c-a>"] = { "select_all", mode = { "n", "i" } },
						-- ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<PageUp>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
						-- ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<PageDown>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
						["<c-j>"] = { "list_down", mode = { "i", "n" } },
						["<c-k>"] = { "list_up", mode = { "i", "n" } },
						["<c-n>"] = { "list_down", mode = { "i", "n" } },
						["<c-p>"] = { "list_up", mode = { "i", "n" } },
						["<c-q>"] = { "qflist", mode = { "i", "n" } },
						["<c-s>"] = { "edit_split", mode = { "i", "n" } },
						["<c-t>"] = { "tab", mode = { "n", "i" } },
						["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
						["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
						["<c-r>#"] = { "insert_alt", mode = "i" },
						["<c-r>%"] = { "insert_filename", mode = "i" },
						["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
						["<c-r><c-f>"] = { "insert_file", mode = "i" },
						["<c-r><c-l>"] = { "insert_line", mode = "i" },
						["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
						["<c-r><c-w>"] = { "insert_cword", mode = "i" },
						["<c-w>H"] = "layout_left",
						["<c-w>J"] = "layout_bottom",
						["<c-w>K"] = "layout_top",
						["<c-w>L"] = "layout_right",
						["?"] = "toggle_help_input",
						["G"] = "list_bottom",
						["gg"] = "list_top",
						["j"] = "list_down",
						["k"] = "list_up",
						["q"] = "cancel",
					},
					b = {
						minipairs_disable = true,
					},
				},
				-- result list window
				list = {
					keys = {
						["/"] = "toggle_focus",
						["<2-LeftMouse>"] = "confirm",
						["<CR>"] = "confirm",
						["<Down>"] = "list_down",
						["<Esc>"] = "cancel",
						["<S-CR>"] = { { "pick_win", "jump" } },
						["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
						["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
						["<Up>"] = "list_up",
						["<a-d>"] = "inspect",
						["<a-f>"] = "toggle_follow",
						["<a-h>"] = "toggle_hidden",
						["<a-i>"] = "toggle_ignored",
						["<a-m>"] = "toggle_maximize",
						["<a-p>"] = "toggle_preview",
						["<a-w>"] = "cycle_win",
						["<c-a>"] = "select_all",
						-- ["<c-b>"] = "preview_scroll_up",
						["<PageUp>"] = "preview_scroll_up",
						["<c-d>"] = "list_scroll_down",
						-- ["<c-f>"] = "preview_scroll_down",
						["<PageDown>"] = "preview_scroll_down",
						["<c-j>"] = "list_down",
						["<c-k>"] = "list_up",
						["<c-n>"] = "list_down",
						["<c-p>"] = "list_up",
						["<c-q>"] = "qflist",
						["<c-g>"] = "print_path",
						["<c-s>"] = "edit_split",
						["<c-t>"] = "tab",
						["<c-u>"] = "list_scroll_up",
						["<c-v>"] = "edit_vsplit",
						["<c-w>H"] = "layout_left",
						["<c-w>J"] = "layout_bottom",
						["<c-w>K"] = "layout_top",
						["<c-w>L"] = "layout_right",
						["?"] = "toggle_help_list",
						["G"] = "list_bottom",
						["gg"] = "list_top",
						["i"] = "focus_input",
						["j"] = "list_down",
						["k"] = "list_up",
						["q"] = "cancel",
						["zb"] = "list_scroll_bottom",
						["zt"] = "list_scroll_top",
						["zz"] = "list_scroll_center",
					},
					wo = {
						conceallevel = 2,
						concealcursor = "nvc",
					},
				},
				-- preview window
				preview = {
					keys = {
						["<Esc>"] = "cancel",
						["q"] = "cancel",
						["i"] = "focus_input",
						["<a-w>"] = "cycle_win",
					},
				},
			},
			layout = {
				layout = {
					box = "vertical",
					backdrop = false,
					row = -1,
					width = 0,
					height = 0.4,
					border = "top",
					title = " {title} {live} {flags}",
					title_pos = "center",
					{ win = "input", height = 1, border = "none" },
					{
						box = "horizontal",
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", width = 0.35, border = "left" },
					},
				},
			},

			-- layout = {
			-- 	preset = "ivy",
			-- 	preview = "main",
			-- 	layout = {
			-- 		box = "vertical",
			-- 		backdrop = false,
			-- 		width = 0,
			-- 		height = 0.4,
			-- 		position = "bottom",
			-- 		border = "top",
			-- 		title = " {title} {live} {flags}",
			-- 		title_pos = "left",
			-- 		{ win = "input", height = 1, border = "bottom" },
			-- 		{
			-- 			box = "horizontal",
			-- 			{ win = "list", border = "none" },
			-- 			{ win = "preview", title = "{preview}", width = 0.6, border = "left" },
			-- 		},
			-- 	},
			-- },
		},
	},
	keys = {
		-- Top Pickers & Explorer
		{
			"<leader>ip",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			mode = { "c" },
			"<C-r>",
			function()
				local cmd = vim.fn.getcmdline()
				if cmd == "" then
					vim.cmd("stopinsert")
					vim.schedule(function()
						Snacks.picker.command_history({ layout = { preview = false } })
					end)

					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
					-- vim.cmd("stopinsert")
					Snacks.picker.command_history({ layout = { preview = false }, pattern = cmd })
					-- vim.schedule(function()
					--   Snacks.picker.command_history({ layout = { preview = false }, pattern = cmd })
					--   -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
					-- end)

					-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
					-- Fallback to default <C-r> behavior
					-- return "<C-r>"
				end
			end,
			{ silent = true },
		},
		{
			mode = { "n", "t" },
			"<M-p>",
			function()
				Snacks.picker.git_files()
				-- require("telescope.builtin").find_files({
				--   cwd = vim.loop.cwd(),
				--   hidden = true,
				--   shorten_path = false,
				--   path_display = { "absolute" },
				--   find_command = {
				--     "rg",
				--     "--files",
				--     "--color",
				--     "never",
				--     "--glob=!.git",
				--     "--glob=!*__template__",
				--     "--glob=!*DS_Store",
				--   },
				-- })
			end,
			{ silent = true, noremap = true },
		},
		{ mode = { "n", "v" }, "<M-.>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { silent = true } },
		{
			mode = { "n", "v" },
			"<leader>ht",
			function()
				-- require("telescope.builtin").help_tags()
				Snacks.picker.help()
			end,
			{ silent = true },
		},
		{
			"<leader>au",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Smart Find Files",
		},
		{
			-- "<leader><space>",
			"<leader>rs",
			function()
				Snacks.picker.resume({
					-- layout = {
					-- 	preset = "ivy_split",
					-- },
				})
			end,
			desc = "Smart Find Files",
		},
		{
			"<M-P>",
			function()
				Snacks.picker.smart({
					-- layout = {
					-- 	preset = "ivy_split",
					-- },
				})
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep({
					layout = {
						preview = false,
					},
				})
			end,
			desc = "Grep",
		},
		-- -- find
		-- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		-- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		-- { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		-- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		-- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		-- { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- -- git
		-- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
		-- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
		-- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
		-- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
		-- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
		-- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		-- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		-- -- Grep
		-- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		-- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{
			"<leader>sb",
			function()
				Snacks.scratch()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.scratch.select()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sg",
			function()
				---@diagnostic disable-next-line: undefined-global
				Snacks.picker.grep({ preview = false })
			end,
			desc = "Grep",
		},
		-- {
		-- 	"<leader>sw",
		-- 	function()
		-- 		---@diagnostic disable-next-line: undefined-global
		-- 		Snacks.picker.grep_word()
		-- 	end,
		-- 	desc = "Visual selection or word",
		-- 	mode = { "n", "x" },
		-- },
		-- search
	},

	config = function(_, opts)
		require("snacks").setup(opts)
		Snacks.util.icon = function(name, cat, opts)
			-- Copy and modify from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/util/init.lua#L120-L154
			-- Example with `mini.icons`:
			-- return require("mini.icons").get(cat or "file", name)
      local basename = name
      local ext = cat
      if cat == "file" then
        basename = vim.fn.fnamemodify(name, ":t")
        -- ext = basename:match("%w%.(%w+)$")
        ext = basename:match("%.(.+)$") -- matches everything after the first dot
      end
      return require("nvim-web-devicons").get_icon(basename, ext, { default = true })
      -- return require("nvim-web-devicons").get_icon(name, cat or "file", opts)
		end
	end,
}
