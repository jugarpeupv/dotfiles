-- return {}

function _G.FylerWinbarCwd()
	local ok, fyler = pcall(require, "fyler")
	if not ok or type(fyler.get_current_dir) ~= "function" then
		return (vim.loop.cwd() or ""):gsub("^" .. vim.env.HOME, "~")
	end
	local dir = fyler.get_current_dir() or vim.loop.cwd() or ""
	return dir:gsub("^" .. vim.env.HOME, "~")
end
--
-- -- return {}
return {
	{
		-- "A7Lavinraj/fyler.nvim",
		dir = "~/projects/fyler.nvim/wt-main",
		dev = true,
		enabled = true,
		lazy = true,
		cmd = { "Fyler" },
		-- event = { "VeryLazy" },
		-- branch = "stable",
		-- branch = "main",
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
				"<leader>EE",
				function()
					local fyler = require("fyler")
					local path = vim.fn.expand("%:p")
					fyler.open()
					fyler.navigate(path)
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
					confirm_simple = false,
					-- Replace netrw as default explorer
					default_explorer = false,
					-- Move deleted files/directories to the system trash
					delete_to_trash = true,
					columns = {
						permission = { enabled = false },
						size = { enabled = false },
						git = {
							enabled = true,
							position = "after_name",
							symbols = {
								Untracked = "?",
								Added = "+",
								Modified = "!",
								Deleted = "✗",
								Renamed = "󰕛 ",
								Copied = "~",
								Conflict = "",
								Ignored = " ",
							},
						},
						diagnostic = {
							enabled = true,
							position = "after_name",
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
						["gx"] = function(view)
							local entry = view:cursor_node_entry()
							local path = entry.path

							local home = os.getenv("HOME")
							if home then
								path = path:gsub("^" .. home, "~")
							end

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
						["<M-b>"] = function(view)
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
					},
					-- Current file tracking
					follow_current_file = false,
					-- File system watching(includes git status)
					watcher = {
						enabled = true,
					},
					-- Window configuration
					win = {
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
								width = "30%",
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
			vim.cmd("hi FylerDiagnosticWarn gui=none guifg=#F9E2AF")
			vim.cmd("hi FylerGitUntracked gui=none guifg=none")
			vim.cmd("hi FylerGitIconUntracked gui=none guifg=#89ddff")
			vim.cmd("hi FylerGitModified gui=none guifg=none")
			vim.cmd("hi FylerGitIconModified gui=none guifg=#F9E2AF")
			-- vim.api.nvim_set_hl(0, "FylerGitIconUntracked", { fg = "#ff0000", bold = true })
			-- vim.api.nvim_set_hl(0, "FylerGitIconModified", { fg = "#ff8800", bold = true })
			--
			-- -- Or make the filename dimmer while keeping the icon bright
			-- vim.api.nvim_set_hl(0, "FylerGitUntracked", { fg = "#888888" })
			-- -- FylerGitIconUntracked still links to the original cyan by default,
			-- -- but since the link target changed, you'd set it explicitly:
			-- vim.api.nvim_set_hl(0, "FylerGitIconUntracked", { fg = "#00cccc" })
		end,
	},
}
