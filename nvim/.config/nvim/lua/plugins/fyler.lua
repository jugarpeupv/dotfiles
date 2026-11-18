return {
	{
		"jugarpeupv/fyler.nvim",
		-- dir = "~/projects/fyler.nvim/wt-fyler-main/",
    enabled = true,
		lazy = false,
		cmd = { "Fyler" },
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "folke/snacks.nvim" },
		},
		keys = {
			{
				"<leader>fe",
				function()
					require("fyler").open()
				end,
				desc = "Fyler",
			},
			{
				mode = { "n", "t" },
				"<M-k>",
				function()
					local fyler = require("fyler")
					local path = vim.fn.expand("%:p")
					local found = false
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.bo[buf].filetype
						if ft == "fyler" or ft == "fyler_finder" then
							vim.api.nvim_set_current_win(win)
							found = true
							break
						end
					end
					if not found then
						fyler.open()
					end
					fyler.navigate(path)
				end,
				{ noremap = true, silent = true },
			},
			{
				mode = { "n", "t" },
				"<D-k>",
				function()
					local fyler = require("fyler")
					local path = vim.fn.expand("%:p")
					local found = false
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						local ft = vim.bo[buf].filetype
						if ft == "fyler" or ft == "fyler_finder" then
							vim.api.nvim_set_current_win(win)
							found = true
							break
						end
					end
					if not found then
						fyler.open()
					end
					fyler.navigate(path)
				end,
				{ noremap = true, silent = true },
			},
			{
				mode = { "i", "t", "n" },
				"<M-j>",
				function()
					require("fyler").toggle()
				end,
				{ noremap = true, silent = true },
			},
			{
				mode = { "i", "t", "n" },
				"<D-j>",
				function()
					require("fyler").toggle()
				end,
				{ noremap = true, silent = true },
			},
		},
		opts = function()
			-- if package.searchpath("fyler.finder", package.path) then return M.new_api_opts end
			return {
				hooks = {
					on_delete = nil,
					on_rename = nil,
				},
				integrations = {
					icon = "nvim_web_devicons",
					-- icon = "none",
					-- icon = "real_icons",
				},
				views = {
					finder = {
						close_on_select = false,
						confirm_simple = true,
						default_explorer = false,
						delete_to_trash = true,
						-- columns_order = { "git", "link", "permission", "size" },
						-- columns_order = { "git", "link", "permission", "size" },
						columns_order = { "git", "link", "size", "creation_time" },
						columns = {
							creation_time = { enabled = false },
							size = { enabled = true },
							permission = { enabled = true },
							git = {
								enabled = true,
								symbols = {
									Untracked = "?",
									Staged = "+",
									Unstaged = "!",
									Deleted = "✗",
									Renamed = "󰕛 ",
									Copied = "~",
									Conflict = "",
									Ignored = "",
								},
							},
							diagnostic = {
								enabled = false,
								symbols = {
									Error = " ",
									Warn = " ",
									Info = " ",
									Hint = "󰠠 ",
								},
							},
						},
						icon = {
							directory_collapsed = "",
							directory_expanded = "",
						},
						indentscope = {
							enabled = true,
							markers = {
								{ "│", "FylerIndentMarker" },
								{ "└", "FylerIndentMarker" },
							},
						},
						mappings = {
							["J"] = function() end,
							["gP"] = "PasteEntry",
							["gX"] = "VisualCutEntries",
							["gY"] = {
								n = function(view)
									local path
									if vim.api.nvim_win_get_cursor(0)[1] == 1 then
										-- Line 1 is fyler's editable path header, not an
										-- entry: copy the directory this instance shows.
										-- path = view:getcwd()
                    path = vim.fn.expand('%:p')
									else
										local entry = view:cursor_node_entry()
										if not entry then return end
										path = entry.path
									end
									vim.notify("Copied path: " .. path)
									vim.fn.setreg("+", path)
								end,
								x = "VisualYankEntries",
							},
							["gy"] = function(view)
								local entry = view:cursor_node_entry()
								local path = entry.path
								path = vim.fn.fnamemodify(path, ":~:.")
								vim.notify("Copied path: " .. path)
								vim.fn.setreg("+", path)
							end,
							["<leader>fI"] = "TogglePermissions",
							["<leader>fT"] = "ToggleCreationTime",
							["<leader>fS"] = "ToggleSize",
							["<leader>fP"] = "ToggleDetails",
							["<leader>fd"] = function(view)
								-- Picker rooted at THIS instance's cwd; selection
								-- opens in THIS instance (not the global one).
								require("jg.custom.telescope").find_directory_in_fyler_and_focus(view:getcwd(), view)
							end,
							["gs"] = "SortByCreationTime",
							["."] = function(view)
								local entry = view:cursor_node_entry()
								local path = entry.path
								local cmd_run = string.format(":Compile  %s", path)
								local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
								vim.api.nvim_feedkeys(keys, "c", true)
								local hops =
									string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
								vim.api.nvim_feedkeys(hops, "n", true)
							end,
							["C"] = function(view)
								local entry = view:cursor_node_entry()
								local path = entry.path
								local relative_path = vim.fn.fnamemodify(path, ":.")
								vim.notify("Copied path: " .. relative_path)
								vim.fn.setreg("+", relative_path)
							end,
							["K"] = function(view)
								local entry = view:cursor_node_entry()
								if not entry or not entry.path then
									vim.notify("No file under cursor", vim.log.levels.WARN)
									return
								end
								local path = entry.path

								local current_win = vim.api.nvim_get_current_win()
								local current_buf = vim.api.nvim_win_get_buf(current_win)
								local is_in_hover = vim.b[current_buf].fyler_hover_popup == true

								if is_in_hover then
									if vim.api.nvim_win_is_valid(current_win) then
										vim.api.nvim_win_close(current_win, true)
									end
									if vim.api.nvim_buf_is_valid(current_buf) then
										vim.api.nvim_buf_delete(current_buf, { force = true })
									end
									return
								end

								local existing_popup_win = nil
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									local buf = vim.api.nvim_win_get_buf(win)
									if vim.b[buf].fyler_hover_popup == true then
										existing_popup_win = win
										break
									end
								end

								if existing_popup_win and vim.api.nvim_win_is_valid(existing_popup_win) then
									vim.api.nvim_set_current_win(existing_popup_win)
									return
								end

								local stats = vim.uv.fs_stat(path)
								if not stats then
									vim.notify("Cannot retrieve file information for: " .. path, vim.log.levels.ERROR)
									return
								end

								local file_permissions = vim.fn.getfperm(path)

								local is_dir = stats.type == "directory" or vim.fn.isdirectory(path) == 1

								local function format_bytes(bytes)
									if bytes == nil then
										return "unknown"
									end
									if bytes < 1024 then
										return string.format("%dB", bytes)
									end
									local units = { "K", "M", "G", "T" }
									local size = bytes / 1024
									local unit = 1
									while size >= 1024 and unit < #units do
										size = size / 1024
										unit = unit + 1
									end
									return string.format("%.1f%s (%d bytes)", size, units[unit], bytes)
								end

								local lines = {
									" fullpath: " .. path,
									" permis:   " .. file_permissions,
									" size:     " .. (is_dir and "calculating..." or format_bytes(stats.size)),
									" accessed: " .. os.date("%x %X", stats.atime.sec),
									" modified: " .. os.date("%x %X", stats.mtime.sec),
									" created:  " .. os.date("%x %X", stats.birthtime.sec),
								}

								local max_width = vim.fn.max(vim.tbl_map(function(n)
									return #n
								end, lines))

								local open_win_config = {
									col = 1,
									row = 1,
									relative = "cursor",
									border = "rounded",
									style = "minimal",
									width = math.max(max_width + 1, 50),
									height = #lines,
									noautocmd = true,
									zindex = 60,
								}

								local bufnr = vim.api.nvim_create_buf(false, true)
								local winnr = vim.api.nvim_open_win(bufnr, false, open_win_config)
								vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
								vim.b[bufnr].fyler_hover_popup = true

								local function highlight_lines()
									for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
										local s, e = line:find(".-:")
										if s and e then
											vim.api.nvim_buf_add_highlight(bufnr, -1, "Type", i - 1, s - 1, e)
										end
									end
								end
								highlight_lines()

								local close_popup = function()
									if vim.api.nvim_win_is_valid(winnr) then
										vim.api.nvim_win_close(winnr, true)
									end
									if vim.api.nvim_buf_is_valid(bufnr) then
										vim.api.nvim_buf_delete(bufnr, { force = true })
									end
								end

								vim.api.nvim_buf_set_keymap(
									bufnr,
									"n",
									"q",
									"",
									{ noremap = true, silent = true, callback = close_popup }
								)
								vim.api.nvim_buf_set_keymap(
									bufnr,
									"n",
									"K",
									"",
									{ noremap = true, silent = true, callback = close_popup }
								)

								vim.api.nvim_create_autocmd("CursorMoved", {
									once = true,
									callback = function()
										if vim.api.nvim_get_current_win() ~= winnr then
											close_popup()
										end
									end,
								})

								-- Files already show exact size from stats; only du folders.
								if not is_dir then
									return
								end

								vim.system({ "du", "-sh", path }, {}, function(result)
									vim.schedule(function()
										if
											not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winnr)
										then
											return
										end

										local improved_size = result.stdout and result.stdout:match("^[^\t]+")
											or "unknown"
										lines[3] = " size:     " .. improved_size
										local new_max_width = vim.fn.max(vim.tbl_map(function(n)
											return #n
										end, lines))

										vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
										if new_max_width > open_win_config.width - 1 then
											open_win_config.width = new_max_width + 1
											vim.api.nvim_win_set_config(winnr, open_win_config)
										end
										vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
										highlight_lines()
									end)
								end)
							end,
							["gx"] = function(view)
								-- Get cursor row (1-indexed, line 1 = path header, line 2 = "../")
								local cursor_row = vim.api.nvim_win_get_cursor(view.win.winid)[1]
								local line = vim.api.nvim_get_current_line()

								local function get_open_cmd(my_path)
									if vim.fn.has("mac") == 1 then
										return { "open", my_path }
									end
									if vim.fn.has("win32") == 1 then
										if vim.fn.executable("rundll32") == 1 then
											return { "rundll32", "url.dll,FileProtocolHandler", my_path }
										end
										return nil, "rundll32 not found"
									end
									if vim.fn.executable("explorer.exe") == 1 then
										return { "explorer.exe", my_path }
									end
									if vim.fn.executable("xdg-open") == 1 then
										return { "xdg-open", my_path }
									end
									return nil, "no handler found"
								end

								local cwd

								-- Row 1: path header (e.g., "~/projects/fyler.nvim/wt-fyler-main")
								if cursor_row == 1 then
									cwd = vim.fn.fnamemodify(line, ":p")
								-- Second line or "../" entry: open parent directory
								elseif cursor_row == 2 then
									cwd = vim.fn.fnamemodify(view:getcwd(), ":h")
								else
									-- Other lines: cursor on a file/directory entry
									local entry = view:cursor_node_entry()
									if not entry then
										return
									end
									cwd = entry.path
								end

								local cmd, err = get_open_cmd(cwd)
								if not cmd then
									vim.notify(string.format("Could not open %s: %s", cwd, err), vim.log.levels.ERROR)
									return
								end
								local jid = vim.fn.jobstart(cmd, { detach = true })
								assert(jid > 0, "Failed to start job")
							end,
							["<leader>cr"] = function(view)
								local entry = view:cursor_node_entry()
								local path = entry.path
								local home = os.getenv("HOME")
								if home then
									path = path:gsub("^" .. home, "~")
								end
								local cmd_run = string.format(":Compile  %s", path)
								local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
								vim.api.nvim_feedkeys(keys, "c", true)
								local hops =
									string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
								vim.api.nvim_feedkeys(hops, "n", true)
							end,
							["S"] = function(view)
								local path
								local entry = view:cursor_node_entry()
								if entry and entry.path then
									path = entry.path
								else
									path = view:getcwd()
								end
								if vim.fn.isdirectory(path) == 0 then
									path = vim.fn.fnamemodify(path, ":h")
								end
								local home = os.getenv("HOME")
								if home then
									path = path:gsub("^" .. home, "~")
								end
								require("telescope").extensions.live_grep_args.live_grep_raw({
									cwd = path,
									disable_coordinates = true,
									path_display = { "absolute" },
									theme = "ivy",
									prompt_title = "Live grep in path: " .. path,
									layout_config = { height = 0.47 },
									preview = { hide_on_startup = true },
									vimgrep_arguments = {
										"rg",
										"--no-heading",
										"--with-filename",
										"--line-number",
										"--column",
										"--hidden",
										"--smart-case",
										"--no-ignore",
										"--glob=!icarSDK.js",
										"--glob=!package-lock.json",
										"--glob=!**/.git/**",
									},
								})
							end,
							["<M-p>"] = function(view)
								local path = view:getcwd()
								if vim.fn.isdirectory(path) == 0 then
									path = vim.fn.fnamemodify(path, ":h")
								end
								-- require("telescope.builtin").find_files({
								--   prompt_title = "Find files in: " .. path,
								--   cwd = path,
								--   hidden = true,
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
								Snacks.picker.files({
									-- cmd = "rg",
									title = "Find files in: " .. path,
									cwd = path,
									hidden = true,
									exclude = {
										".git",
										-- "*__template__*",
										"*DS_Store*",
									},
								})
							end,
							["<D-p>"] = function(view)
								local path = view:getcwd()
								if vim.fn.isdirectory(path) == 0 then
									path = vim.fn.fnamemodify(path, ":h")
								end
								Snacks.picker.files({
									title = "Find files in: " .. path,
									cwd = path,
									hidden = true,
									exclude = {
										".git",
										"*DS_Store*",
									},
								})
							end,
							["F"] = function(view)
								local actions = require("telescope.actions")
								local action_state = require("telescope.actions.state")
								local path
								local entry = view:cursor_node_entry()
								if entry and entry.path then
									path = entry.path
								else
									path = view:getcwd()
								end
								if vim.fn.isdirectory(path) == 0 then
									path = vim.fn.fnamemodify(path, ":h")
								end
								require("telescope.builtin").find_files({
									prompt_title = "Find files in: " .. path,
									cwd = path,
									hidden = true,
									find_command = {
										"rg",
										"--files",
										"--color",
										"never",
										"--glob=!.git",
										"--glob=!*__template__",
										"--glob=!*DS_Store",
									},
									attach_mappings = function(prompt_bufnr)
										actions.select_default:replace(function()
											actions.close(prompt_bufnr)
											local selection = action_state.get_selected_entry()
											if not selection then
												return
											end
											-- rg emits paths relative to cwd: absolutize.
											local file = selection.value
											if not file:match("^/") then
												file = path .. "/" .. file
											end
											file = vim.fs.normalize(file)
											-- Reveal in THIS instance (cursor on the file),
											-- not the global ORIG one module navigate()
											-- targets. Root untouched.
											if
												not (
													view.win
													and view.win.winid
													and vim.api.nvim_win_is_valid(view.win.winid)
												)
											then
												vim.notify("Fyler instance closed", vim.log.levels.WARN)
												return
											end
											view:reveal(file)
										end)
										return true
									end,
								})
							end,
							["go"] = function(view)
								-- Oil is lazy-loaded: force-load the plugin (which runs
								-- its setup) before touching its API. Reaching this
								-- keymap first would otherwise call oil.open() with oil
								-- never configured (E5108 on adapter_to_scheme).
								require("lazy").load({ plugins = { "oil.nvim" } })
								local entry = view:cursor_node_entry()
								if not entry then
									local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
									local path
									if cursor_line == 1 then
										path = vim.fn.expand(vim.api.nvim_get_current_line())
									else
										path = vim.uv.cwd()
									end
									vim.cmd("vsplit")
									require("oil").open(path)
									return
								end
								local path = entry.path
								if vim.fn.isdirectory(path) == 0 then
									path = vim.fn.fnamemodify(path, ":h")
								end
								vim.cmd("vsplit")
								require("oil").open(path)
							end,
							["gl"] = function(view)
								local path
								local entry = view:cursor_node_entry()
								if entry and entry.path then
									path = entry.path
								else
									path = view:getcwd()
								end

								local function check_and_modify_path(path_to)
									if vim.fn.isdirectory(path_to) == 1 then
										return path_to
									end
									return vim.fn.fnamemodify(path_to, ":h")
								end
								local modified_path = check_and_modify_path(path)

								local function get_all_terminals()
									local terminal_chans = {}
									for _, chan in pairs(vim.api.nvim_list_chans()) do
										if chan["mode"] == "terminal" and chan["pty"] ~= "" then
											table.insert(terminal_chans, chan)
										end
									end
									table.sort(terminal_chans, function(left, right)
										return left["buffer"] < right["buffer"]
									end)
									if #terminal_chans == 0 then
										return nil
									end
									return terminal_chans
								end

								local all_terms = get_all_terminals()
								for _, term in pairs(all_terms or {}) do
									term.title = vim.api.nvim_buf_get_var(term.buffer, "term_title")
								end

								local term_found
								modified_path = modified_path:gsub("^~", "~"):gsub(" ", "\\ ")
								print(modified_path)

								for _, term in pairs(all_terms or {}) do
									if term.title and string.find(term.title, modified_path, 1, true) then
										term_found = term
									end
								end

								if term_found then
									vim.api.nvim_set_current_win(
										vim.api.nvim_open_win(term_found.buffer, true, { split = "below" })
									)
									return
								end

								local myterm = require("terminal").terminal:new({
									layout = { open_cmd = "botright new" },
									autoclose = false,
								})
								myterm:open()
								myterm:send("cd " .. modified_path)
							end,
							["q"] = "CloseView",
							["<CR>"] = function(view)
								-- always open files in a window on the right side of
								-- fyler (never inside it): reuse the adjacent window,
								-- creating it if fyler is the only window open
								local entry = view:cursor_node_entry()
								if not entry or not entry.path then
									view:action_call("n_select")
									return
								end
								if vim.fn.isdirectory(entry.path) == 1 then
									view:action_call("n_select")
									return
								end
								local fyler_win = vim.api.nvim_get_current_win()
								local fpos = vim.api.nvim_win_get_position(fyler_win)
								local fheight = vim.api.nvim_win_get_height(fyler_win)
								local right_edge = fpos[2] + vim.api.nvim_win_get_width(fyler_win)
								local target = nil
								local best_col = nil
								local function is_usable_win(winid, fyler_win)
									return vim.api.nvim_win_is_valid(winid)
										and winid ~= fyler_win
										and vim.api.nvim_win_get_config(winid).relative == ""
										and not vim.wo[winid].winfixbuf
								end
								for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
									if is_usable_win(winid, fyler_win) then
										local wpos = vim.api.nvim_win_get_position(winid)
										local wheight = vim.api.nvim_win_get_height(winid)
										if wpos[1] < fpos[1] + fheight and fpos[1] < wpos[1] + wheight then
											if wpos[2] >= right_edge and (best_col == nil or wpos[2] < best_col) then
												target = winid
												best_col = wpos[2]
											end
										end
									end
								end
								local path = vim.fn.fnameescape(entry.path)
								if not target then
									-- fyler is the only window: open the file in a new
									-- vsplit taking 60% of the width, fyler keeps the rest
									local new_buf = vim.api.nvim_create_buf(false, true)
									target = vim.api.nvim_open_win(new_buf, true, {
										split = "right",
										win = fyler_win,
										width = math.floor(vim.o.columns * 0.8),
									})
								end
								vim.api.nvim_set_current_win(target)
								local ok, err = pcall(vim.cmd.edit, { args = { path }, mods = { keepalt = false } })
								if not ok then
									vim.notify("Could not open file: " .. tostring(err), vim.log.levels.ERROR)
								end
							end,
							-- ["L"] = "SelectIfDirectory",
							["L"] = "Select",
							["<C-t>"] = "SelectTab",
							["<C-v>"] = "SelectVSplit",
							-- ["<C-v>"] = function(view)
							-- 	-- vsplit that reuses an empty [No Name] buffer in the target
							-- 	-- window instead of splitting beside it, so no leftover
							-- 	-- empty window stays on the left
							-- 	local entry = view:cursor_node_entry()
							-- 	if not entry or not entry.path then
							-- 		-- "../" row or header: same as plain select
							-- 		view:action_call("n_select")
							-- 		return
							-- 	end
							-- 	if vim.fn.isdirectory(entry.path) == 1 then
							-- 		-- keep fyler's expand/collapse for directories
							-- 		view:action_call("n_select")
							-- 		return
							-- 	end
							-- 	-- target = window fyler was opened from, else first usable
							-- 	-- non-fyler window (mirrors the plugin, minus winpick)
							-- 	local fyler_win = vim.api.nvim_get_current_win()
							-- 	local target = nil
							-- 	local origin = view.win and view.win.origin_win or nil
							-- 	if origin and is_usable_win(origin, fyler_win) then
							-- 		target = origin
							-- 	else
							-- 		for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
							-- 			if is_usable_win(winid, fyler_win) then
							-- 				target = winid
							-- 				break
							-- 			end
							-- 		end
							-- 	end
							-- 	local path = vim.fn.fnameescape(entry.path)
							-- 	if target then
							-- 		edit_or_split(target, path, "vsplit")
							-- 	else
							-- 		vim.cmd.vsplit({ args = { path }, mods = { keepalt = false } })
							-- 	end
							-- end,
							["<C-s>"] = function(view)
								-- same empty-buffer reuse as <C-v>, horizontal split
								local entry = view:cursor_node_entry()
								if not entry or not entry.path then
									view:action_call("n_select")
									return
								end
								if vim.fn.isdirectory(entry.path) == 1 then
									view:action_call("n_select")
									return
								end
								local fyler_win = vim.api.nvim_get_current_win()
								local target = nil
								local origin = view.win and view.win.origin_win or nil
								local function is_usable_win(winid, fyler_win)
									return vim.api.nvim_win_is_valid(winid)
										and winid ~= fyler_win
										and vim.api.nvim_win_get_config(winid).relative == ""
										and not vim.wo[winid].winfixbuf
								end
								if origin and is_usable_win(origin, fyler_win) then
									target = origin
								else
									for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
										if is_usable_win(winid, fyler_win) then
											target = winid
											break
										end
									end
								end
								local path = vim.fn.fnameescape(entry.path)
								if target then
									local function edit_or_split(target, path, split_cmd)
										-- Reuse an empty [No Name] buffer in place instead of splitting beside
										-- it, so no leftover empty window stays next to the new buffer.
										local function is_empty_buffer(buf)
											return vim.api.nvim_buf_get_name(buf) == ""
												and vim.bo[buf].buftype == ""
												and not vim.bo[buf].modified
												and vim.api.nvim_buf_line_count(buf) == 1
												and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
										end
										vim.api.nvim_set_current_win(target)
										if is_empty_buffer(vim.api.nvim_win_get_buf(target)) then
											vim.cmd.edit({ args = { path }, mods = { keepalt = false } })
										else
											vim.cmd[split_cmd]({ args = { path }, mods = { keepalt = false } })
										end
									end
									edit_or_split(target, path, "split")
								else
									vim.cmd.split({ args = { path }, mods = { keepalt = false } })
								end
							end,
							["-"] = "GotoParent",
							["="] = "GotoCwd",
							["gw"] = "GotoCwdOriginal",
							["<BS>"] = "GotoNode",
							["#"] = "CollapseAll",
							["H"] = "CollapseNode",
							["<leader>cd"] = function()
								local ok, fyler = pcall(require, "fyler")
								local dir
								if ok and type(fyler.get_current_dir) == "function" then
									dir = fyler.get_current_dir()
								end
								if not dir or dir == "" then
									dir = vim.fn.expand("%:p:h")
								end
								vim.cmd("cd " .. vim.fn.fnameescape(dir))
								vim.notify("cwd: " .. dir)
							end,
						},
						follow_current_file = false,
						watcher = { enabled = true },
						win = {
							border = vim.o.winborder == "" and "single" or vim.o.winborder,
							buf_opts = {
								filetype = "fyler",
								syntax = "fyler",
								buftype = "acwrite",
								expandtab = true,
								shiftwidth = 2,
							},
							kind = "sidebar",
							kinds = {
								sidebar = { width = 40, win_opts = { winfixwidth = true } },
							},
							win_opts = {
								concealcursor = "nvic",
								cursorline = true,
								number = true,
								relativenumber = true,
								winhighlight = "Normal:FylerNormal",
								wrap = false,
								foldcolumn = "1",
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			-- ── <M-y> async command on fyler path (shared with oil/buffers) ──
			local async = require("jg.core.async-cmdline")

			local function fyler_get_path(view)
				local cursor_row = vim.api.nvim_win_get_cursor(view.win.winid)[1]
				local line = vim.api.nvim_get_current_line()
				if cursor_row == 1 then
					return vim.fn.fnamemodify(line, ":p")
				elseif cursor_row == 2 then
					return vim.fn.fnamemodify(view:getcwd(), ":h")
				else
					local entry = view:cursor_node_entry()
					if entry and entry.path then
						return entry.path
					end
					return view:getcwd()
				end
			end

			-- Shared entry point: arm the path and open the cmdline.
			local function _begin_async_cmdline(path)
				async.begin(path, { label = "Fyler" })
			end

			-- inject <M-y> into fyler's view mappings BEFORE setup so view:cursor_node_entry() works
			if opts.views and opts.views.finder and opts.views.finder.mappings then
				opts.views.finder.mappings["<M-y>"] = function(view)
					_begin_async_cmdline(fyler_get_path(view))
				end
				opts.views.finder.mappings["<D-y>"] = function(view)
					_begin_async_cmdline(fyler_get_path(view))
				end
			end

			require("fyler").setup(opts)

			local ok, fyler = pcall(require, "fyler")
			if not ok then
				return
			end

			if not fyler.set_current_dir then
				fyler.set_current_dir = function(path)
					fyler.open({ root_path = path, kind = "replace" })
				end
			end
			if fyler.getcwd then
				vim.cmd("hi FylerGitStaged gui=none guifg=none")
				vim.cmd("hi FylerGitModified gui=none guifg=none")
				vim.cmd("hi FylerGitUntracked gui=none guifg=none")
			else
				vim.cmd("hi FylerGitStaged gui=none guifg=none")
				vim.cmd("hi FylerGitIconStaged gui=none guifg=#8ee2cf")
				vim.cmd("hi FylerGitUnstaged gui=none guifg=none")
				vim.cmd("hi FylerGitIconUnstaged gui=none guifg=#F5E0DC")
				vim.cmd("hi FylerGitUntracked gui=none guifg=none")
				vim.cmd("hi FylerGitIconUntracked gui=none guifg=#89ddff")
			end

			-- keep equalalways=true but exclude fyler from the equalize
			-- fyler has winfixwidth=true (width=40) so it should stay fixed,
			-- but to avoid the 50/50 flash when the middle of [fyler][win2][win3]
			-- is closed, we re-assert fyler's width synchronously (no schedule)
			-- on WinClosed. This is flicker-free because it runs before redraw.
			-- vim.o.equalalways = true
			-- vim.o.splitkeep = "screen"
			-- vim.api.nvim_create_autocmd("WinClosed", {
			-- 	callback = function()
			-- 		-- no schedule → runs before redraw, no flash
			-- 		local wins = vim.api.nvim_tabpage_list_wins(0)
			-- 		local normal = {}
			-- 		for _, w in ipairs(wins) do
			-- 			if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_config(w).relative == "" then
			-- 				table.insert(normal, w)
			-- 			end
			-- 		end
			-- 		if #normal ~= 2 then
			-- 			return
			-- 		end
			-- 		local fyler_win, other = nil, nil
			-- 		for _, w in ipairs(normal) do
			-- 			local buf = vim.api.nvim_win_get_buf(w)
			-- 			if vim.bo[buf].filetype == "fyler" then
			-- 				fyler_win = w
			-- 			else
			-- 				other = w
			-- 			end
			-- 		end
			-- 		if not fyler_win or not other then
			-- 			return
			-- 		end
			-- 		-- enforce fixed width for fyler; other will fill the rest (80%)
			-- 		vim.api.nvim_win_set_width(fyler_win, 40)
			-- 	end,
			-- })
		end,
	},
}
