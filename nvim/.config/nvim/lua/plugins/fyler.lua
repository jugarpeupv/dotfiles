-- return {}
function _G.FylerWinbarCwd()
	local ok, fyler = pcall(require, "fyler")
	local dir
	if not ok or type(fyler.get_current_dir) ~= "function" then
		dir = vim.loop.cwd() or ""
	else
		dir = fyler.get_current_dir() or vim.loop.cwd() or ""
	end
	-- Resolve relative paths (e.g. "." returned before full init) to absolute
	if dir ~= "" and not vim.startswith(dir, "/") then
		dir = vim.fn.fnamemodify(dir, ":p"):gsub("/$", "")
	end
	return dir:gsub("^" .. vim.env.HOME, "~")

end
return {
	{
		-- "A7Lavinraj/fyler.nvim",
    "jugarpeupv/fyler.nvim",
		dir = "~/projects/fyler.nvim/wt-main",
		dev = true,
		enabled = true,
		lazy = false,
		cmd = { "Fyler" },
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		keys = {
			{
				"<leader>fe",
				function()
					local fyler = require("fyler")
					fyler.open()
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
						if vim.bo[buf].filetype == "fyler" then
							vim.api.nvim_set_current_win(win)
							found = true
							break
						end
					end
					if not found then
						fyler.open()
					end
					fyler.navigate(path)
					-- vim.defer_fn(function ()
					--   vim.cmd("normal! zz")
					-- end, 50)
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
						if vim.bo[buf].filetype == "fyler" then
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
					local fyler = require("fyler")
					fyler.toggle()
				end,
				{ noremap = true, silent = true },
			},
			{
				mode = { "i", "t", "n" },
				"<D-j>",
				function()
					local fyler = require("fyler")
					fyler.toggle()
				end,
				{ noremap = true, silent = true },
			},
		},
		opts = {
			hooks = {
				-- function(path) end
				on_delete = nil,
				-- function(src_path, dst_path) end
				on_rename = nil,
				-- function(hl_groups, palette) end
				-- on_highlight = function(hl_groups)
				-- 	hl_groups.FylerDiagnosticWarn = {
				--         style = "none"
				-- 	}
				-- end,
			},
			integrations = {
				-- icon = "mini_icons",
				icon = "nvim_web_devicons",
				-- icon = "none",
				-- icon = function(item_type, path)
				--   if item_type == "directory" then
				--     return "", "FylerFSDirectoryIcon"
				--   else
				--     return "", "FylerFSDirectoryIcon"
				--   end
				-- end
			},
			views = {
				finder = {
					-- Close explorer when file is selected
					close_on_select = false,
					-- Auto-confirm simple file operations
					confirm_simple = true,
					-- Replace netrw as default explorer
					default_explorer = false,
					-- Move deleted files/directories to the system trash
					delete_to_trash = true,
					columns_order = { "git", "link", "permission" },
					columns = {
						permission = { enabled = false },
						size = { enabled = false },
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
								Ignored = " ",
								-- Untracked = "",
								-- Added = "",
								-- Modified = "",
								-- Deleted = "",
								-- Renamed = "",
								-- Copied = "",
								-- Conflict = "",
								-- Ignored = "",
							},
							-- symbols = {
							--   Untracked = "",
							--   Added = "",
							--   Modified = "",
							--   Deleted = "",
							--   Renamed = "",
							--   Copied = "",
							--   Conflict = "",
							--   Ignored = "",
							-- },
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
					-- Icons for directory states
					icon = {
						directory_collapsed = "",
						-- directory_empty = "󱞞",
						directory_expanded = "",
					},
					-- Indentation guides
					indentscope = {
						enabled = true,
						markers = {
							{ "│", "FylerIndentMarker" },
							{ "└", "FylerIndentMarker" },
						},
					},
					-- Key mappings
					mappings = {
						["gY"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
							local relative_path = vim.fn.fnamemodify(path, ":.")
							vim.notify("Copied path: " .. relative_path)
							vim.fn.setreg("+", relative_path)
						end,
						["gy"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
							vim.notify("Copied path: " .. path)
							vim.fn.setreg("+", path)
						end,
						["K"] = function(view)
							-- Check if we're already in a hover popup
							local current_win = vim.api.nvim_get_current_win()
							local current_buf = vim.api.nvim_win_get_buf(current_win)

							-- Check if current buffer has our hover popup marker
							local is_in_hover = vim.b[current_buf].fyler_hover_popup == true

							if is_in_hover then
								-- Close the popup if we press K again from inside it
								if vim.api.nvim_win_is_valid(current_win) then
									vim.api.nvim_win_close(current_win, true)
								end
								if vim.api.nvim_buf_is_valid(current_buf) then
									vim.api.nvim_buf_delete(current_buf, { force = true })
								end
								return
							end

							-- Check if there's already a hover popup open in another window
							local existing_popup_win = nil
							for _, win in ipairs(vim.api.nvim_list_wins()) do
								local buf = vim.api.nvim_win_get_buf(win)
								if vim.b[buf].fyler_hover_popup == true then
									existing_popup_win = win
									break
								end
							end

							if existing_popup_win and vim.api.nvim_win_is_valid(existing_popup_win) then
								-- Focus the existing popup window
								vim.api.nvim_set_current_win(existing_popup_win)
								return
							end

							local entry = view:cursor_node_entry()
							local path = entry.path

							-- Get file stats using vim.uv (luv)
							local stats = vim.uv.fs_stat(path)
							if not stats then
								vim.notify("Cannot retrieve file information for: " .. path, vim.log.levels.ERROR)
								return
							end

							local file_permissions = vim.fn.getfperm(path)

							-- Initialize lines with placeholder for size
							local lines = {
								" fullpath: " .. path,
								" permis:   " .. file_permissions,
								" size:     calculating...",
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
								width = math.max(max_width + 1, 50), -- Ensure minimum width for size updates
								height = #lines,
								noautocmd = true,
								zindex = 60,
							}

							local bufnr = vim.api.nvim_create_buf(false, true)
							local winnr = vim.api.nvim_open_win(bufnr, false, open_win_config)
							vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

							-- Mark this buffer as a hover popup
							vim.b[bufnr].fyler_hover_popup = true

							-- Highlight keys
							local function highlight_lines()
								for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
									local s, e = line:find(".-:")
									if s and e then
										vim.api.nvim_buf_add_highlight(bufnr, -1, "Type", i - 1, s - 1, e)
									end
								end
							end
							highlight_lines()

							-- Close popup on cursor move or 'q' key
							local close_popup = function()
								if vim.api.nvim_win_is_valid(winnr) then
									vim.api.nvim_win_close(winnr, true)
								end
								if vim.api.nvim_buf_is_valid(bufnr) then
									vim.api.nvim_buf_delete(bufnr, { force = true })
								end
							end

							vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
								noremap = true,
								silent = true,
								callback = close_popup,
							})

							vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "", {
								noremap = true,
								silent = true,
								callback = close_popup,
							})

							vim.api.nvim_create_autocmd("CursorMoved", {
								once = true,
								callback = function()
									if vim.api.nvim_get_current_win() ~= winnr then
										close_popup()
									end
								end,
							})

							-- Compute size asynchronously
							vim.system({ "du", "-sh", path }, {}, function(result)
								vim.schedule(function()
									-- Check if buffer and window are still valid
									if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winnr) then
										return
									end

									local improved_size = result.stdout and result.stdout:match("^[^\t]+") or "unknown"
									lines[3] = " size:     " .. improved_size

									-- Calculate new width if needed
									local new_max_width = vim.fn.max(vim.tbl_map(function(n)
										return #n
									end, lines))

									-- Update buffer content
									vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

									-- Update window width if size line is longer
									if new_max_width > open_win_config.width - 1 then
										open_win_config.width = new_max_width + 1
										vim.api.nvim_win_set_config(winnr, open_win_config)
									end

									-- Re-apply highlights
									vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)
									highlight_lines()
								end)
							end)
						end,
						["gx"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path

							---Copied from vim.ui.open in Neovim 0.10+
							---@param my_path string
							---@return nil|string[] cmd
							---@return nil|string error
							local function get_open_cmd(my_path)
								if vim.fn.has("mac") == 1 then
									return { "open", my_path }
								elseif vim.fn.has("win32") == 1 then
									if vim.fn.executable("rundll32") == 1 then
										return { "rundll32", "url.dll,FileProtocolHandler", my_path }
									else
										return nil, "rundll32 not found"
									end
								elseif vim.fn.executable("explorer.exe") == 1 then
									return { "explorer.exe", my_path }
								elseif vim.fn.executable("xdg-open") == 1 then
									return { "xdg-open", my_path }
								else
									return nil, "no handler found"
								end
							end

							local cmd, err = get_open_cmd(path)
							if not cmd then
								vim.notify(string.format("Could not open %s: %s", path, err), vim.log.levels.ERROR)
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
							-- local escaped_path = vim.fn.shellescape(path)

							-- local cmd_run = string.format(":Compile  %s", escaped_path)
              local cmd_run = string.format(":Compile  %s", path)
							local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
							vim.api.nvim_feedkeys(keys, "c", true)

							local hops =
								-- string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #escaped_path + 1)
                string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
							vim.api.nvim_feedkeys(hops, "n", true)
						end,
						["S"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
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
								preview = {
									hide_on_startup = true,
								},
								-- group_by = "filename",
								-- disable_devicons = true,
								vimgrep_arguments = {
									"rg",
									-- "--color=never",
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
									-- "--ignore-case",
									-- "--smart-case",
									-- "--word-regexp"
								},
							})
						end,
						["F"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
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
							})
						end,
						["go"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
							if vim.fn.isdirectory(path) == 0 then
								path = vim.fn.fnamemodify(path, ":h")
							end
							vim.cmd("vsplit")
							require("oil").open(path)
						end,
						["gl"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path
							local function check_and_modify_path(path_to)
								if vim.fn.isdirectory(path_to) == 1 then
									-- Path is a directory, do nothing
									return path_to
								else
									-- Path is a file, remove the last part
									local last_part = vim.fn.fnamemodify(path_to, ":h")
									return last_part
								end
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
								local term_title = vim.api.nvim_buf_get_var(term.buffer, "term_title")
								term.title = term_title
							end
							-- print("all_terms: ", vim.inspect(all_terms))

							local term_found

							modified_path = modified_path:gsub("^/Users/jgarcia", "~")
							print(modified_path)

							for _, term in pairs(all_terms or {}) do
								if term.title and string.find(term.title, modified_path, 1, true) then
									-- vim.api.nvim_set_current_buf(term.buffer)
									term_found = term
								end
							end

							if term_found then
								-- print("Found terminal: ", vim.inspect(term_found))
								vim.api.nvim_set_current_win(vim.api.nvim_open_win(term_found.buffer, true, {
									split = "below",
								}))
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
						["<CR>"] = "Select",
						["L"] = "Select",
						["<C-t>"] = "SelectTab",
						["<C-v>"] = "SelectVSplit",
						["<C-s>"] = "SelectSplit",
						["-"] = "GotoParent",
						["="] = "GotoCwd",
						["<BS>"] = "GotoNode",
						["#"] = "CollapseAll",
						-- ["<BS>"] = "CollapseNode",
						["H"] = "CollapseNode",
						-- ["gc"] = "SetCwdHere",
						-- ["gC"] = "SetCwdToParent",
						-- ["cd"] = "SetCwdToNode",
					},
					-- Current file tracking
					follow_current_file = false,
					-- File system watching(includes git status)
					watcher = {
						enabled = true,
					},
					-- Window configuration
					win = {
            min_width = 35,
						border = vim.o.winborder == "" and "single" or vim.o.winborder,
						buf_opts = {
							filetype = "fyler",
							syntax = "fyler",
							buflisted = false,
							buftype = "acwrite",
							expandtab = true,
							shiftwidth = 2,
						},
						-- kind = "split_right_most",
						-- kind = "replace",
						kind = "split_left_most",
						kinds = {
							float = {
								height = "70%",
								width = "70%",
								top = "10%",
								left = "15%",
							},
							replace = {},
							split_above = {
								height = "70%",
							},
							split_above_all = {
								height = "70%",
							},
							split_below = {
								height = "70%",
							},
							split_below_all = {
								height = "70%",
							},
							split_left = {
								width = "30%",
							},
							split_left_most = {
								width = "25%",
							},
							split_right = {
								width = "30%",
							},
							split_right_most = {
								width = "30%",
							},
						},
						win_opts = {
							-- winbar = "%#NvimTreeRootFolder#%{substitute(v:lua.vim.fn.getcwd(), '^' . $HOME, '~', '')}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							winbar = "%#NvimTreeRootFolder#%{v:lua.FylerWinbarCwd()}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							-- winbar = "%#NvimTreeRootFolder#%{substitute(v:lua.require('oil').get_current_dir(), '^' . $HOME, '~', '')}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
							concealcursor = "nvic",
							-- conceallevel = 3,
							foldcolumn = "1",
							cursorline = true,
							number = true,
							relativenumber = true,
							winhighlight = "Normal:FylerNormal",
							wrap = false,
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("fyler").setup(opts)
			vim.cmd("hi FylerGitStaged gui=none guifg=none")
			vim.cmd("hi FylerGitIconStaged gui=none guifg=#8ee2cf")
			vim.cmd("hi FylerGitUnstaged gui=none guifg=none")
			vim.cmd("hi FylerGitIconUnstaged gui=none guifg=#F5E0DC")
			vim.cmd("hi FylerGitUntracked gui=none guifg=none")
			vim.cmd("hi FylerGitIconUntracked gui=none guifg=#89ddff")
		end,
	},
}
