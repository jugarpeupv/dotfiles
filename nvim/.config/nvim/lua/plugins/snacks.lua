return {
	"folke/snacks.nvim",
	priority = 800,
	enabled = true,
	event = { "LspAttach" },
	lazy = true,

	-- event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
	-- event = { "BufReadPost", "BufNewFile" },
	opts = {
		image = {
			doc = {
				enabled = false,
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
			enabled = true,
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
				icons = {
					confirm = function(picker, item)
						picker:close()
						if item then
							local icon = item.data or item.icon or item.text
							vim.fn.setreg("+", icon)
							-- Snacks.notify(("Copied `%s` to clipboard"):format(icon), { title = "Icons" })
						end
					end,
				},
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
						["<a-o>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
						["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
						["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
						["<C-l>"] = { "toggle_preview", mode = { "i", "n" } },
						["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
						["<c-a>"] = { "select_all", mode = { "n", "i" } },
						-- ["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<c-d>"] = false,
						["<c-u>"] = false,
						["<PageDown>"] = { "list_scroll_down", mode = { "i", "n" } },
						["<PageUp>"] = { "list_scroll_up", mode = { "i", "n" } },
						-- ["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
						--       ["<PageUp>"] = { "preview_scroll_up", mode = { "i", "n" } },
						-- ["<PageDown>"] = { "preview_scroll_down", mode = { "i", "n" } },
						-- ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
						["<c-space>"] = { "toggle_live", mode = { "i", "n" } },
						["<c-j>"] = { "list_down", mode = { "i", "n" } },
						["<c-k>"] = { "list_up", mode = { "i", "n" } },
						["<c-n>"] = { "list_down", mode = { "i", "n" } },
						["<c-p>"] = { "list_up", mode = { "i", "n" } },
						["<c-q>"] = { "qflist", mode = { "i", "n" } },
						["<c-s>"] = { "edit_split", mode = { "i", "n" } },
						["<c-t>"] = { "tab", mode = { "n", "i" } },
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
						{ win = "preview", title = "{preview}", width = 0.45, border = "left" },
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
		{
			"<leader>ms",
			function()
				local function run_email_sync(channel)
					vim.notify("Syncing email (" .. channel .. ")...", vim.log.levels.INFO)
					local stderr_lines = {}

					local function print_line(line)
						if line == "" then
							return
						end
						vim.api.nvim_echo({ { line, "Comment" } }, true, {})
					end

					vim.fn.jobstart({ "sh", "-c", "mbsync " .. channel .. " && notmuch new" }, {
						pty = true, -- force line-buffered output from mbsync
						on_stdout = function(_, data)
							vim.schedule(function()
								for _, line in ipairs(data) do
									print_line(line)
								end
							end)
						end,
						on_stderr = function(_, data)
							for _, line in ipairs(data) do
								if line ~= "" then
									table.insert(stderr_lines, line)
								end
							end
						end,
						on_exit = function(_, code)
							if code == 0 then
								vim.schedule(function()
									vim.notify("Email synced properly", vim.log.levels.INFO)
									local time = os.date("%H:%M")
									vim.fn.jobstart({
										"terminal-notifier",
										"-title",
										"Mail",
										"-message",
										time .. " Email synced properly",
									}, { detach = true })
								end)
							else
								vim.schedule(function()
									local reason = #stderr_lines > 0 and ("\n" .. table.concat(stderr_lines, "\n"))
										or ""
									vim.notify(
										"Email sync failed (exit code: " .. code .. ")" .. reason,
										vim.log.levels.ERROR
									)
								end)
							end
						end,
					})
				end

				local channels = { "izertis-channel", "gmail-personal-channel" }
				vim.ui.select(channels, {
					prompt = "Sync email channel:",
					format_item = function(item)
						return item
					end,
				}, function(choice)
					if not choice then
						vim.notify("Email sync cancelled", vim.log.levels.WARN)
						return
					end
					if choice ~= "izertis-channel" then
						run_email_sync(choice)
						return
					end
					-- izertis-channel: verify davmail oauth token before sync
					-- single source of truth: davmail/.davmail.properties:73 davmail.oauth.tokenFilePath
					local function get_davmail_token_path()
						local prop_files = {
							vim.fn.expand("~/.davmail.properties"),
							vim.fn.expand("~/dotfiles/davmail/.davmail.properties"),
							vim.fn.expand("~/.config/davmail/davmail.properties"),
						}
						for _, f in ipairs(prop_files) do
							if vim.fn.filereadable(f) == 1 then
								local v = vim.fn.system("grep -E '^davmail\\.oauth\\.tokenFilePath=' " .. vim.fn.shellescape(f) .. " | cut -d= -f2- | tr -d ' \\r\\n' | xargs"):gsub("%s+", "")
								if v ~= "" then
									v = v:gsub("^~", vim.fn.expand("~"))
									return v
								end
							end
						end
						-- return vim.fn.expand("~/.config/davmail/oauth_tokens.env")
					end
					local token_path = get_davmail_token_path()
					vim.notify("Davmail token_path resolved: " .. token_path, vim.log.levels.INFO)
					local function run_davmail_token(on_done)
						vim.notify("Running davmail-token (O365Interactive)...", vim.log.levels.WARN)
						vim.fn.jobstart({ "zsh", "-ic", "davmail-token" }, {
							pty = true,
							on_exit = function(_, code)
								vim.schedule(function()
									if code == 0 then
										vim.notify("davmail-token succeeded, syncing...", vim.log.levels.INFO)
										on_done()
									else
										vim.notify("davmail-token failed (exit " .. code .. ")", vim.log.levels.ERROR)
									end
								end)
							end,
						})
					end
					local function probe_token(email, cb)
						local cmd = string.format(
							[[timeout 7 python3 - << 'PY'
import imaplib,socket
socket.setdefaulttimeout(5)
try:
    m=imaplib.IMAP4('localhost',1143)
    m.login('%s','')
    m.logout()
    print('ok')
except Exception as e:
    print(e)
    exit(1)
PY
]],
							email:gsub("'", "'\\''")
						)
						vim.fn.jobstart({ "bash", "-c", cmd }, {
							on_exit = function(_, code)
								cb(code == 0)
							end,
						})
					end
					-- if file missing/empty -> need token immediately
					if vim.fn.filereadable(token_path) ~= 1 or vim.fn.getfsize(token_path) < 10 then
						run_davmail_token(function()
							run_email_sync(choice)
						end)
						return
					end
					-- file exists -> quick IMAP probe ( <7s, no heavy sync)
					vim.notify("Verifying davmail token...", vim.log.levels.INFO)
					local email = vim.fn.system("grep -v '^#' " .. vim.fn.shellescape(token_path) .. " | cut -d= -f1 | head -1 | tr -d ' \\n\\r'"):gsub("%s+", "")
					probe_token(email, function(ok)
						vim.schedule(function()
							if ok then
								run_email_sync(choice)
							else
								vim.notify("Davmail token invalid/expired, refreshing...", vim.log.levels.WARN)
								run_davmail_token(function()
									run_email_sync(choice)
								end)
							end
						end)
					end)
				end)
			end,
		},

		{
			"<C-R>",
			function()
				local cmd = vim.fn.getcmdline()
				local pos = vim.fn.getcmdpos()
				local ctype = vim.fn.getcmdtype()

				local function replace_cmdline(content)
					-- Re-enter the cmdline with the content inserted at the
					-- position where the cursor was when <C-R> was pressed.
					local head, tail = vim.fn.strpart(cmd, 0, pos - 1), vim.fn.strpart(cmd, pos - 1)
					vim.api.nvim_feedkeys(ctype .. head .. content .. tail, "nt", true)
					if #tail > 0 then
						vim.api.nvim_feedkeys(
							string.rep(
								vim.api.nvim_replace_termcodes("<Left>", true, true, true),
								vim.fn.strchars(tail)
							),
							"nt",
							true
						)
					end
				end

				local function open_picker()
					-- Telescope yank_history (yanky.nvim) picker
					local actions = require("telescope.actions")
					local action_state = require("telescope.actions.state")
					require("telescope").extensions.yank_history.yank_history({
						initial_mode = "insert",
						attach_mappings = function(_, _)
							actions.select_default:replace(function(bufnr)
								local selection = action_state.get_selected_entry()
								actions.close(bufnr)
								if selection then
									-- Strip tabs/newlines from linewise yanks: a trailing \n
									-- acts as <CR> and executes the re-entered cmdline, and
									-- leading \t mangles the text. We are also striping leading whitespace
									local content = (selection.value.regcontents or "")
										:gsub("[\t\n\r]", "")
										:gsub("\\n", "")
										:gsub("^%s+", "")

									-- Schedule so telescope fully closes first; otherwise the
									-- <cr> that confirmed the picker is still pending and would
									-- execute the re-entered cmdline immediately.
									vim.schedule(function()
										replace_cmdline(content)
									end)
								end
							end)
							return true
						end,
					})
				end

				-- Abort the in-progress command line, then open the picker on the
				-- next tick so the <esc> has fully processed and mode is back to
				-- normal. Opening the picker synchronously (or feeding <esc> with
				-- "x") leaves the cmdline active, so telescope's <ESC>A insert-mode
				-- key lands in the cmdline (":e A") and the prompt never gains focus.
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
				vim.schedule(open_picker)
			end,
			mode = "c",
			desc = "Insert register into command line",
		},
		{
			"<C-S>",
			function()
				local cmd = vim.fn.getcmdline()
				local pos = vim.fn.getcmdpos()
				local ctype = vim.fn.getcmdtype()

				local function replace_cmdline(content)
					-- Re-enter the cmdline with the content inserted at the
					-- position where the cursor was when <C-R> was pressed.
					local head, tail = vim.fn.strpart(cmd, 0, pos - 1), vim.fn.strpart(cmd, pos - 1)
					vim.api.nvim_feedkeys(ctype .. head .. content .. tail, "nt", true)
					if #tail > 0 then
						vim.api.nvim_feedkeys(
							string.rep(
								vim.api.nvim_replace_termcodes("<Left>", true, true, true),
								vim.fn.strchars(tail)
							),
							"nt",
							true
						)
					end
				end

				local function open_picker()
					require("snacks").picker.registers({
						actions = {
							confirm = function(picker, item)
								picker:close()
								local reg = vim.fn.getreg(item.reg)
								reg = (reg or ""):gsub("[\t\n\r]", ""):gsub("\\n", ""):gsub("^%s+", "")

								-- Schedule so telescope fully closes first; otherwise the
								-- <cr> that confirmed the picker is still pending and would
								-- execute the re-entered cmdline immediately.
								vim.schedule(function()
									replace_cmdline(reg)
								end)
							end,
						},
					})
				end

				-- Abort the in-progress command line, then open the picker on the
				-- next tick so the <esc> has fully processed and mode is back to
				-- normal. Opening the picker synchronously (or feeding <esc> with
				-- "x") leaves the cmdline active, so telescope's <ESC>A insert-mode
				-- key lands in the cmdline (":e A") and the prompt never gains focus.
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, true, true), "n", true)
				vim.schedule(open_picker)
			end,
			mode = "c",
			desc = "Insert register into command line",
		},
		-- Top Pickers & Explorer
		{
			"<leader>bi",
			function()
				Snacks.picker.buffers({ finder = "buffers", hidden = true, title = "< IBuffers >" })
			end,
		},
		{
			"gd",
			mode = { "n" },
			function()
				Snacks.picker.lsp_definitions()
			end,
		},
		-- {
		-- 	"gv",
		--     mode = { "n" },
		-- 	function()
		-- 		vim.cmd("vsp")
		-- 		Snacks.picker.lsp_definitions()
		-- 	end,
		-- },
		{
			"gs",
			mode = { "n" },
			function()
				vim.cmd("sp")
				Snacks.picker.lsp_definitions()
			end,
		},
		{
			mode = { "n" },
			"<leader>mp",
			function()
				-- require("telescope.builtin").man_pages({
				--   -- man_cmd = { "sh", "-c", "apropos . | sort | uniq" },
				--   man_cmd = { "cat", os.getenv("HOME") .. "/.cache/telescope_man_list.txt" },
				--   -- man_cmd = { "sh", "-c", "find /usr/share/man/man* -type f | sort | uniq" },
				--   sections = { "ALL" },
				-- })

				-- require("telescope.builtin").man_pages({ section = "1" })
				-- Snacks.picker.man({ section = { "1" } })
				-- Snacks.picker.man()

				local cache = os.getenv("HOME") .. "/.cache/telescope_man_list.txt"
				local items = {}
				local f = io.open(cache, "r")
				if f then
					for line in f:lines() do
						local prefix, desc = line:match("^(.-)%s+%-%s+(.*)$")
						if prefix then
							local name, section = prefix:match("^([^%(,]+)%((%w+)%)")
							if name then
								table.insert(items, {
									text = line,
									name = vim.trim(name),
									section = section,
									desc = desc,
								})
							end
						end
					end
					f:close()
				end

				if #items > 0 then
					Snacks.picker({
						title = "Man Pages",
						format = "text",
						layout = { preview = false },
						-- format = function(item, picker)
						-- 	local ret = {}
						-- 	-- name(section) - highlighted
						-- 	ret[#ret + 1] = { item.name, "NvimTreeExecFile" }
						-- 	ret[#ret + 1] = { "(", "Delimiter" }
						-- 	ret[#ret + 1] = { item.section, "Number" }
						-- 	ret[#ret + 1] = { ")", "Delimiter" }
						-- 	ret[#ret + 1] = { " - ", "Comment" }
						-- 	ret[#ret + 1] = { item.desc or "", "String" }
						-- 	return ret
						-- end,
						items = items,
						win = {
							input = {
								keys = {
									["<C-v>"] = { "vertical", mode = { "i", "n" } },
									["<C-x>"] = { "horizontal", mode = { "i", "n" } },
									["<C-t>"] = { "tab", mode = { "i", "n" } },
								},
							},
						},
						actions = {
							vertical = function(picker, item)
								picker:close()
								if item and item.name and item.section then
									vim.cmd("vert Man " .. item.section .. " " .. item.name)
								end
							end,
							horizontal = function(picker, item)
								picker:close()
								if item and item.name and item.section then
									vim.cmd("Man " .. item.section .. " " .. item.name)
								end
							end,
							tab = function(picker, item)
								picker:close()
								if item and item.name and item.section then
									vim.cmd("tab Man " .. item.section .. " " .. item.name)
								end
							end,
						},
						confirm = function(picker, item)
							picker:close()
							if item and item.name and item.section then
								vim.cmd("Man " .. item.section .. " " .. item.name)
							end
						end,
					})
				else
					Snacks.picker.man()
				end
			end,
			{ silent = true },
		},
		{
			"<leader>ch",
			function()
				Snacks.picker.command_history({ layout = { preview = false } })
				-- Snacks.picker.command_history({})
			end,
		},
		{
			"<leader>dS",
			function()
				Snacks.picker.lsp_symbols()
				-- require("telescope.builtin").oldfiles({ only_cwd = true })
			end,
		},
		{
			"<leader>jl",
			function()
				Snacks.picker.jumps()
				-- require("telescope.builtin").oldfiles({ only_cwd = true })
			end,
		},
		{
			"<leader>of",
			function()
				Snacks.picker.recent({ filter = { cwd = true } })
				-- require("telescope.builtin").oldfiles({ only_cwd = true })
			end,
		},
		{
			"<leader>ip",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			mode = { "c" },
			-- "<C-r><C-r>",
			"<C-c>",
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
			mode = { "n" },
			"<leader>fi",
			function()
				Snacks.picker.files()

				-- require("telescope.builtin").find_files({
				--   hidden = true,
				--   no_ignore = true,
				--   -- find_command = { "fd", ".", "--type", "f", "--exclude", ".git/*", "--exclude", "node_modules/*" },
				--   find_command = {
				--     "fd",
				--     ".",
				--     "--type",
				--     "f",
				--     "--exclude",
				--     ".git/*",
				--     "--exclude",
				--     "node_modules/*",
				--     "--exclude",
				--     "node_modules",
				--     "--exclude",
				--     "**/node_modules/**",
				--   },
				--   preview = {
				--     hide_on_startup = true,
				--   },
				-- })
			end,
		},

		{
			mode = { "n", "t" },
			"<M-p>",
			function()
				-- local ok = pcall(function()
				-- 	local git_root = Snacks.git.get_root()
				-- 	if not git_root then
				-- 		error("not in git repo")
				-- 	end
				-- 	Snacks.picker.git_files({ untracked = true })
				-- end)
				--
				-- if not ok then
				-- 	Snacks.picker.files({
				-- 		exclude = {
				-- 			".git",
				-- 			"*__template__*",
				-- 			"*DS_Store*",
				-- 		},
				-- 	})
				-- end

				Snacks.picker.files({
					-- cmd = "rg",
					hidden = true,
					exclude = {
						".git",
						-- "*__template__*",
						"*DS_Store*",
					},
				})

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
			"<leader>sr",
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
		-- {
		-- 	"<leader>,",
		-- 	function()
		-- 		Snacks.picker.buffers()
		-- 	end,
		-- 	desc = "Buffers",
		-- },
		{
			"<leader>/",
			function()
				Snacks.picker.grep({
					layout = {
						preview = false,
					},
					-- formatters = {
					-- 	file = {
					-- 		filename_first = true,
					-- 	},
					-- },
					win = {
						list = {
							treesitter = false, -- disable treesitter highlights
						},
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
			--    -- WORKING
			-- -- Copy and modify from https://github.com/folke/snacks.nvim/blob/main/lua/snacks/util/init.lua#L120-L154
			-- -- Example with `mini.icons`:
			-- -- return require("mini.icons").get(cat or "file", name)
			-- local basename = name
			-- local ext = cat
			-- if cat == "file" then
			-- 	basename = vim.fn.fnamemodify(name, ":t")
			-- 	-- ext = basename:match("%w%.(%w+)$")
			-- 	ext = basename:match("%.(.+)$") -- matches everything after the first dot
			-- end
			-- return require("nvim-web-devicons").get_icon(basename, ext, { default = true })
			-- -- return require("nvim-web-devicons").get_icon(name, cat or "file", opts)
			--    -- END WORKING

			local devicons = require("nvim-web-devicons")
			local basename = name
			local ext = cat
			if cat == "file" then
				basename = vim.fn.fnamemodify(name, ":t")
				-- ext = basename:match("%.([^.]+)$")
				ext = basename:match("%.([^.]+%.[^.]+)$") or basename:match("%.([^.]+)$")
			end
			local icon, hl = devicons.get_icon(basename, ext, { default = true })
			-- Check if we got a default icon by comparing with a known default
			local default_icon = devicons.get_icon("", "", { default = true })
			-- If icon is the default icon and we have an extension, try with just the extension
			if icon == default_icon and ext then
				local ext_icon, ext_hl = devicons.get_icon(ext, ext, { default = true })
				if ext_icon and ext_icon ~= default_icon then
					return ext_icon, ext_hl
				end
			end
			return icon, hl
		end
	end,
}
