return {
	{
		"nvim-tree/nvim-tree.lua",
		enabled = true,
		-- priority = 500,
		dependencies = {},
		-- event = { "VeryLazy" },
		lazy = true,
		keys = {
			{ mode = { "n", "t" }, "<M-k>", "<cmd>NvimTreeFindFile<cr>", { noremap = true, silent = true } },
			{ mode = { "n", "t" }, "<D-k>", "<cmd>NvimTreeFindFile<cr>", { noremap = true, silent = true } },
			{ mode = { "i", "t", "n" }, "<M-j>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true } },
			{ mode = { "i", "t", "n" }, "<D-j>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true } },
		},
		config = function()
			-- require("nvim-tree").setup({})
			local api_nvimtree = require("nvim-tree.api")

			local nvim_tree_jg_utils = require("jg.custom.nvim-tree-utils")

			-- local attach_git = function()
			-- 	local should_attach = true
			-- 	local git_dir = vim.fn.finddir(".git", vim.fn.expand("%:p:h"))
			-- 	-- print("git_dir: ", git_dir)
			--
			-- 	local git_file = vim.fn.findfile(".git", vim.fn.expand("%:p:h"))
			-- 	-- print("git_file: ", git_file)
			--
			-- 	local head_file = vim.fn.findfile("HEAD", vim.fn.expand("%:p:h"))
			-- 	-- print("head_file: ", head_file)
			--
			-- 	if git_dir == "" and head_file == "" and git_file == "" then
			-- 		should_attach = false
			-- 	end
			--
			-- 	return should_attach
			-- end

			-- local should_attach_git = attach_git()

			vim.keymap.set({ "n" }, "<leader>uR", function()
				api_nvimtree.tree.open({ find_file = true, update_root = true })
			end, { remap = true })

			vim.api.nvim_create_autocmd("filetype", {
				pattern = "NvimTree",
				desc = "Mappings for NvimTree",
				group = vim.api.nvim_create_augroup("NvimTreeBulkCommands", { clear = true }),
				callback = function()
					-- Yank marked files
					vim.keymap.set("n", "bgy", function()
						local marks = api_nvimtree.marks.list()
						if #marks == 0 then
							print("No items marked")
							return
						end
						local absolute_file_paths = ""
						for _, mark in ipairs(marks) do
							absolute_file_paths = absolute_file_paths .. mark.absolute_path .. "\n"
						end
						-- Using system registers for multi-instance support.
						vim.fn.setreg("+", absolute_file_paths)
						print("Yanked " .. #marks .. " items")
					end, { remap = true, buffer = true })

					-- Paste files
					vim.keymap.set("n", "bgp", function()
						local source_paths = {}
						for path in vim.fn.getreg("+"):gmatch("[^\n%s]+") do
							source_paths[#source_paths + 1] = path
						end
						local node = api_nvimtree.tree.get_node_under_cursor()
						local is_folder = node.fs_stat and node.fs_stat.type == "directory" or false
						local target_path = is_folder and node.absolute_path
							or vim.fn.fnamemodify(node.absolute_path, ":h")
						for _, source_path in ipairs(source_paths) do
							vim.fn.system({ "cp", "-R", source_path, target_path })
						end
						api_nvimtree.tree.reload()
						print("Pasted " .. #source_paths .. " items")
					end, { remap = true, buffer = true })
				end,
			})

			-- api_nvimtree.events.subscribe(api_nvimtree.events.Event.Ready, function()
			-- 	vim.wo.statusline = " "
			-- 	-- vim.cmd("hi! NvimTreeStatusLine guifg=none guibg=none")
			-- 	vim.opt.laststatus = 3
			-- 	-- local wt_utils = require("jg.custom.worktree-utils")
			-- 	-- local cwd = vim.loop.cwd()
			-- 	--
			-- 	-- local has_worktrees = wt_utils.has_worktrees(cwd)
			-- 	-- if has_worktrees then
			-- 	--   local file_utils = require("jg.custom.file-utils")
			-- 	--   local key = vim.fn.fnamemodify(cwd or "", ":p")
			-- 	--   local bps_path = file_utils.get_bps_path(key)
			-- 	--   local data = file_utils.load_bps(bps_path)
			-- 	--   if data == nil then
			-- 	--     return
			-- 	--   end
			-- 	--   if next(data) == nil or data.last_active_wt == nil then
			-- 	--     return
			-- 	--   end
			-- 	--   local last_active_wt = data.last_active_wt
			-- 	--
			-- 	--   api_nvimtree.tree.change_root(last_active_wt)
			-- 	--   -- vim.cmd("Explore " .. last_active_wt)  -- Open netrw browser
			-- 	--   -- vim.cmd("cd " .. last_active_wt)
			-- 	-- end
			-- 	-- vim.cmd("hi! NvimTreeStatusLineNC guifg=none guibg=none")
			-- end)

			local function on_attach(bufnr)
				local opts = function(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- mark operation
				local mark_move_j = function()
					api_nvimtree.marks.toggle()
					vim.cmd("norm j")
				end
				local mark_move_k = function()
					api_nvimtree.marks.toggle()
					vim.cmd("norm k")
				end

				-- marked files operation
				local mark_trash = function()
					local marks = api_nvimtree.marks.list()
					if #marks == 0 then
						table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
					end
					-- vim.ui.input({ prompt = string.format("Trash %s files? [y/n] ", #marks) }, function(input)
					--   if input == "y" then
					--     for _, node in ipairs(marks) do
					--       api.fs.trash(node)
					--     end
					--     api.marks.clear()
					--     api.tree.reload()
					--   end
					-- end)

					for _, node in ipairs(marks) do
						api_nvimtree.fs.trash(node)
					end
					api_nvimtree.marks.clear()
					api_nvimtree.tree.reload()
				end
				local mark_remove = function()
					local marks = api_nvimtree.marks.list()
					if #marks == 0 then
						table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
					end
					-- vim.ui.input({ prompt = string.format("Remove/Delete %s files? [y/n] ", #marks) }, function(input)
					--   if input == "y" then
					--     for _, node in ipairs(marks) do
					--       api.fs.remove(node)
					--     end
					--     api.marks.clear()
					--     api.tree.reload()
					--   end
					-- end)

					for _, node in ipairs(marks) do
						api_nvimtree.fs.remove(node)
					end
					api_nvimtree.marks.clear()
					api_nvimtree.tree.reload()
				end

				local mark_copy = function()
					local marks = api_nvimtree.marks.list()
					if #marks == 0 then
						table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
					end
					for _, node in pairs(marks) do
						api_nvimtree.fs.copy.node(node)
					end
					api_nvimtree.marks.clear()
					api_nvimtree.tree.reload()
				end

				local mark_cut = function()
					local marks = api_nvimtree.marks.list()
					if #marks == 0 then
						table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
					end
					for _, node in pairs(marks) do
						api_nvimtree.fs.cut(node)
					end
					api_nvimtree.marks.clear()
					api_nvimtree.tree.reload()
				end

				local mark_paste = function()
					local marks = api_nvimtree.marks.list()
					if #marks == 0 then
						table.insert(marks, api_nvimtree.tree.get_node_under_cursor())
					end
					for _, node in pairs(marks) do
						api_nvimtree.fs.paste(node)
					end
					api_nvimtree.marks.clear()
					api_nvimtree.tree.reload()
				end

				vim.keymap.set("n", "F", function()
					local node = api_nvimtree.tree.get_node_under_cursor()
					if node then
						-- get directory of current file if it's a file
						local path
						if node.type == "directory" then
							-- Keep the full path for directories
							path = node.absolute_path
						else
							-- Get the directory of the file
							path = vim.fn.fnamemodify(node.absolute_path, ":h")
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
					end
				end, opts("Search in directory"))

				-- vim.keymap.set("n", "U", function()
				-- 	api_nvimtree.marks.clear()
				-- end, opts("Delete marks"))

				vim.keymap.set("n", "<M-b>", function()
					local node = api_nvimtree.tree.get_node_under_cursor()
					if node then
						-- get directory of current file if it's a file
						local path = node.absolute_path

						local home = os.getenv("HOME")
						if home then
							path = path:gsub("^" .. home, "~")
						end

						local cmd_run = string.format(":Compile  %s", path)
						local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
						vim.api.nvim_feedkeys(keys, "c", true)

						local hops = string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
						vim.api.nvim_feedkeys(hops, "n", true)
					end
				end, opts("Search in directory"))

				vim.keymap.set("n", "S", function()
					local node = api_nvimtree.tree.get_node_under_cursor()
					if node then
						-- get directory of current file if it's a file
						local path
						if node.type == "directory" then
							-- Keep the full path for directories
							path = node.absolute_path
						else
							-- Get the directory of the file
							path = vim.fn.fnamemodify(node.absolute_path, ":h")
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
								"--color=never",
								"--no-heading",
								"--with-filename",
								"--line-number",
								"--column",
								"--hidden",
								"--smart-case",
								"--glob=!icarSDK.js",
								"--glob=!package-lock.json",
								"--glob=!**/.git/**",
								-- "--ignore-case",
								-- "--smart-case",
								-- "--word-regexp"
							},
						})
					end
				end, opts("Search in directory"))

				-- add custom key mapping to search in directory with grug-far
				-- vim.keymap.set("n", "S", function()
				--   local node = api_nvimtree.tree.get_node_under_cursor()
				--   local grugFar = require("grug-far")
				--   if node then
				--     -- get directory of current file if it's a file
				--     local path
				--     if node.type == "directory" then
				--       -- Keep the full path for directories
				--       path = node.absolute_path
				--     else
				--       -- Get the directory of the file
				--       path = vim.fn.fnamemodify(node.absolute_path, ":h")
				--     end
				--
				--     local prefills = {
				--       paths = path,
				--     }
				--
				--     if not grugFar.has_instance("tree") then
				--       grugFar.grug_far({
				--         instanceName = "tree",
				--         prefills = prefills,
				--         staticTitle = "Find and Replace from Tree",
				--       })
				--     else
				--       grugFar.open_instance("tree")
				--       -- updating the prefills without clearing the search
				--       grugFar.update_instance_prefills("tree", prefills, false)
				--     end
				--   end
				-- end, opts("Search in directory"))

				vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))

				-- START Preview functionality

				vim.keymap.set("n", "P", function()
					local preview = require("nvim-tree-preview")
					preview.watch()
				end, opts("Preview (Watch)"))
				vim.keymap.set("n", "<Esc>", function()
					local preview = require("nvim-tree-preview")
					preview.unwatch()
				end, opts("Close Preview/Unwatch"))
				vim.keymap.set("n", "<C-f>", function()
					local preview = require("nvim-tree-preview")
					return preview.scroll(4)
				end, opts("Scroll Down"))
				vim.keymap.set("n", "<C-b>", function()
					local preview = require("nvim-tree-preview")
					return preview.scroll(-4)
				end, opts("Scroll Up"))

				-- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
				-- vim.keymap.set("n", "<Tab>", function()
				-- 	local ok, node = pcall(api_nvimtree.tree.get_node_under_cursor)
				-- 	if ok and node then
				-- 		if node.type == "directory" then
				-- 			api_nvimtree.node.open.edit()
				-- 		else
				-- 			local preview = require("nvim-tree-preview")
				-- 			preview.node(node, { toggle_focus = true })
				-- 		end
				-- 	end
				-- end, opts("Preview"))

				-- Option B: Simple tab behavior: Always preview
				-- vim.keymap.set('n', '<Tab>', preview.node_under_cursor, opts 'Preview')

				-- END Preview functionality

				vim.keymap.set("n", "<down>", mark_move_j, opts("Toggle Bookmark Down"))
				vim.keymap.set("n", "<up>", mark_move_k, opts("Toggle Bookmark Up"))

				vim.keymap.set("n", "bx", mark_cut, opts("Cut File(s)"))
				vim.keymap.set("n", "bD", mark_trash, opts("Trash File(s)"))
				vim.keymap.set("n", "bd", mark_remove, opts("Remove File(s)"))
				vim.keymap.set("n", "by", mark_copy, opts("Copy File(s)"))
				vim.keymap.set("n", "bp", mark_paste, opts("Paste File(s)"))

				vim.keymap.set("n", "bm", api_nvimtree.marks.bulk.move, opts("Move Bookmarked"))

				-- vim.keymap.set("n", "K", api_nvimtree.node.show_info_popup, opts("Info"))
				vim.keymap.set("n", "K", nvim_tree_jg_utils.custom_info_popup, opts("Info"))

				-- Default mappings. Feel free to modify or remove as you wish.
				--
				-- BEGIN_DEFAULT_ON_ATTACH
				-- vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts("Info"))
				vim.keymap.set("n", "<C-r>", api_nvimtree.fs.rename_sub, opts("Rename: Omit Filename"))
				vim.keymap.set("n", "<C-t>", api_nvimtree.node.open.tab, opts("Open: New Tab"))
				vim.keymap.set("n", "<C-v>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
				-- vim.keymap.set("n", "<C-x>", api_nvimtree.node.open.horizontal, opts("Open: Horizontal Split"))
				vim.keymap.set("n", "<C-s>", api_nvimtree.node.open.horizontal, opts("Open: Horizontal Split"))
				-- vim.keymap.set("n", "<BS>", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
				-- vim.keymap.set("n", "h", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
				-- vim.keymap.set("n", "l", api_nvimtree.node.open.edit, opts("Open"))

				vim.keymap.set("n", "H", api_nvimtree.node.navigate.parent_close, opts("Close Directory"))
				vim.keymap.set("n", "L", api_nvimtree.node.open.edit, opts("Open"))

				vim.g.first_time_open = true
				-- vim.keymap.set("n", "<CR>", api_nvimtree.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<CR>", function(node)
					if vim.g.first_time_open == true then
						local get_terminal_bufs = function()
							return vim.tbl_filter(function()
								return vim.fn.getbufvar(bufnr, "&buftype") == "terminal"
									and vim.fn.getbufvar(bufnr, "&ft") == ""
							end, vim.api.nvim_list_bufs())
						end
						local terminals = get_terminal_bufs()
						local there_are_no_terminal_buffers = next(terminals) == nil
						if there_are_no_terminal_buffers then
							api_nvimtree.node.open.edit(node)
						else -- there are terminal buffers
							api_nvimtree.node.open.vertical(node)
							vim.g.first_time_open = false
						end
					else
						api_nvimtree.node.open.edit(node)
					end
				end, opts("Open"))
				-- vim.keymap.set('n', '<CR>', toggle_replace, opts('Open: In Place'))

				local function change_root_to_global_cwd()
					local api = require("nvim-tree.api")
					local global_cwd = vim.fn.getcwd(-1, -1)
					api.tree.change_root(global_cwd)
				end
				-- vim.keymap.set("n", "<Tab>", api_nvimtree.node.open.preview, opts("Open Preview"))
				vim.keymap.set("n", ">", api_nvimtree.node.navigate.sibling.next, opts("Next Sibling"))
				vim.keymap.set("n", "<", api_nvimtree.node.navigate.sibling.prev, opts("Previous Sibling"))
				vim.keymap.set("n", ".", api_nvimtree.node.run.cmd, opts("Run Command"))

				-- vim.keymap.set("n", "H", api_nvimtree.tree.change_root_to_parent, opts("Up"))
				-- vim.keymap.set("n", "<C-c>", api_nvimtree.tree.change_root_to_node, opts("CD"))
				vim.keymap.set("n", "<C-c>", change_root_to_global_cwd, opts("Change Root To Global CWD"))
				vim.keymap.set("n", "<BS>", api_nvimtree.tree.change_root_to_node, opts("CD"))

				-- vim.keymap.set("n", "O", api_nvimtree.node.open.no_window_picker, opts("Open: No Window Picker"))
				-- vim.keymap.set("n", "W", api_nvimtree.node.open.preview, opts("Open Preview"))
				vim.keymap.set("n", "-", function()
					vim.cmd("vsplit")
					require("oil").open(vim.loop.cwd())
				end, opts("Open Oil"))

				-- vim.keymap.set('n', "O", api_nvimtree.node.open.replace_tree_buffer, opts('Open: In Place'))
				vim.keymap.set("n", "O", function()
					vim.cmd("vsplit")
					-- get current path of nvimtree
					local path = api_nvimtree.tree.get_node_under_cursor().absolute_path
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
					require("oil").open(modified_path)
				end, opts("Open Oil"))

				vim.keymap.set("n", "gl", function()
					local path = api_nvimtree.tree.get_node_under_cursor().absolute_path
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

					-- all_terms:  { {
					--   argv = { "/bin/zsh" },
					--   buffer = 3,
					--   id = 3,
					--   mode = "terminal",
					--   pty = "/dev/ttys002",
					--   stream = "job"
					-- } }
				end, opts("Open Terminal in node"))

				vim.keymap.set("n", "E", function()
					local path = api_nvimtree.tree.get_node_under_cursor().absolute_path
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

					local myterm = require("terminal").terminal:new({
						layout = { open_cmd = "botright new" },
						autoclose = false,
					})
					myterm:open()
					myterm:send("cd " .. modified_path .. " && npx --yes live-server .")

					-- all_terms:  { {
					--   argv = { "/bin/zsh" },
					--   buffer = 3,
					--   id = 3,
					--   mode = "terminal",
					--   pty = "/dev/ttys002",
					--   stream = "job"
					-- } }
				end, opts("Live server in folder"))

				-- vim.keymap.set("n", "O", api_nvimtree.tree.change_root_to_parent, opts("Up"))

				-- vim.keymap.set("n", "-", function()
				--   vim.cmd("vsplit");
				--   require("oil").open(vim.loop.cwd())
				-- end, opts("Open Oil"))

				vim.keymap.set("n", "a", api_nvimtree.fs.create, opts("Create"))
				-- vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
				vim.keymap.set("n", "B", api_nvimtree.tree.toggle_no_buffer_filter, opts("Toggle No Buffer"))
				vim.keymap.set("n", "yy", api_nvimtree.fs.copy.node, opts("Copy"))
				vim.keymap.set("n", "C", api_nvimtree.tree.toggle_git_clean_filter, opts("Toggle Git Clean"))
				vim.keymap.set("n", "[c", api_nvimtree.node.navigate.git.prev, opts("Prev Git"))
				vim.keymap.set("n", "]c", api_nvimtree.node.navigate.git.next, opts("Next Git"))
				vim.keymap.set("n", "d", api_nvimtree.fs.remove, opts("Delete"))
				-- vim.keymap.set("n", "D", api_nvimtree.fs.trash, opts("Trash"))
				vim.keymap.set("n", "D", function(node)
					api_nvimtree.fs.trash(node)
					vim.defer_fn(function()
						api_nvimtree.tree.reload()
					end, 500)
				end, opts("Trash"))
				-- vim.keymap.set("n", "E", api_nvimtree.tree.expand_all, opts("Expand All"))
				vim.keymap.set("n", "e", api_nvimtree.fs.rename_basename, opts("Rename: Basename"))
				vim.keymap.set("n", "]e", api_nvimtree.node.navigate.diagnostics.next, opts("Next Diagnostic"))
				vim.keymap.set("n", "[e", api_nvimtree.node.navigate.diagnostics.prev, opts("Prev Diagnostic"))
				-- vim.keymap.set("n", "F", api_nvimtree.live_filter.clear, opts("Clean Filter"))
				-- vim.keymap.set("n", "f", api_nvimtree.live_filter.start, opts("Filter"))
				vim.keymap.set("n", "g?", api_nvimtree.tree.toggle_help, opts("Help"))
				vim.keymap.set("n", "gy", api_nvimtree.fs.copy.absolute_path, opts("Copy Absolute Path"))
				-- vim.keymap.set("n", "H", api_nvimtree.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))
				-- vim.keymap.set("n", "I", api_nvimtree.tree.toggle_gitignore_filter, opts("Toggle Git Ignore"))
				-- vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
				-- vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
				vim.keymap.set("n", "M", api_nvimtree.marks.clear, opts("Clear marks"))
				vim.keymap.set("n", "m", api_nvimtree.marks.toggle, opts("Toggle Bookmark"))
				-- vim.keymap.set("n", "o", api_nvimtree.node.open.edit, opts("Open"))

				-- vim.keymap.set('n', 'O', function()
				--   local node = api_nvimtree.tree.get_node_under_cursor()
				--   local path = node.absolute_path
				--
				--   if (path and vim.fn.isdirectory(path) == 0) then
				--     path = vim.fn.fnamemodify(path, ':h')
				--   end
				--   vim.cmd('vsplit')
				--   require("oil").open(path)
				-- end, opts("Open Oil"))
				vim.keymap.set("n", "p", api_nvimtree.fs.paste, opts("Paste"))
				vim.keymap.set("n", "A", api_nvimtree.node.navigate.parent, opts("Parent Directory"))
				vim.keymap.set("n", "q", api_nvimtree.tree.close, opts("Close"))
				vim.keymap.set("n", "r", api_nvimtree.fs.rename, opts("Rename"))
				vim.keymap.set("n", "R", api_nvimtree.tree.reload, opts("Refresh"))
				-- vim.keymap.set("n", "s", api_nvimtree.node.run.system, opts("Run System"))
				vim.keymap.set("n", "gx", api_nvimtree.node.run.system, opts("Run System"))
				-- vim.keymap.set("n", "z", api_nvimtree.tree.search_node, opts("Search"))
				-- vim.keymap.set("n", "U", api_nvimtree.tree.toggle_custom_filter, opts("Toggle Hidden"))
				vim.keymap.set("n", "W", api_nvimtree.tree.collapse_all, opts("Collapse"))
				vim.keymap.set("n", "x", api_nvimtree.fs.cut, opts("Cut"))
				vim.keymap.set("n", "c", api_nvimtree.fs.copy.filename, opts("Copy Name"))
				vim.keymap.set("n", "Y", api_nvimtree.fs.copy.relative_path, opts("Copy Relative Path"))
				vim.keymap.set("n", "<2-LeftMouse>", api_nvimtree.node.open.edit, opts("Open"))
				vim.keymap.set("n", "<2-RightMouse>", api_nvimtree.tree.change_root_to_node, opts("CD"))
				-- -- END_DEFAULT_ON_ATTACH

				-- Mappings removed via:
				--   remove_keymaps
				--   OR
				--   view.mappings.list..action = ""
				--
				-- The dummy set before del is done for safety, in case a default mapping does not exist.
				--
				-- You might tidy things by removing these along with their default mapping.
				vim.keymap.set("n", "<C-e>", "", { buffer = bufnr })
				vim.keymap.del("n", "<C-e>", { buffer = bufnr })

				vim.keymap.set("n", "<C-i>", "<C-i>", { buffer = bufnr })
				-- vim.keymap.del("n", "<C-i>", "", { buffer = bufnr })

				vim.keymap.set("n", "<C-o>", "<C-o>", { buffer = bufnr })
				-- vim.keymap.del("n", "<C-o>", { buffer = bufnr })

				-- vim.keymap.set('n', '<C-k>', '', { buffer = bufnr })
				-- vim.keymap.del('n', '<C-k>', { buffer = bufnr })

				-- Mappings migrated from view.mappings.list
				--
				-- You will need to insert "your code goes here" for any mappings with a custom action_cb
				vim.keymap.set("n", "<C-Enter>", api_nvimtree.node.open.vertical, opts("Open: Vertical Split"))
				-- vim.keymap.set('n', '<C-p>', api.node.show_info_popup, opts('Info'))
			end

			local status_ok, nvim_tree = pcall(require, "nvim-tree")
			if not status_ok then
				return
			end

			nvim_tree.setup({
				ui = {
					confirm = {
						trash = false,
						remove = true,
						default_yes = false,
					},
				},
				-- BEGIN_DEFAULT_OPTS
				auto_reload_on_write = true,
				disable_netrw = true,
				-- disable_netrw = false,
				hijack_cursor = true,
				hijack_netrw = true,
				-- hijack_netrw = false,
				hijack_unnamed_buffer_when_opening = true,
				-- sort_by = "name",
				-- sort = {
				--   sorter = "modification_time"
				-- },
				sync_root_with_cwd = true,
				-- prefer_startup_root = true,
				-- *nvim-tree.prefer_startup_root*
				-- Prefer startup root directory when updating root directory of the tree.
				-- Only relevant when `update_focused_file.update_root` is `true`
				-- Type: `boolean`, Default: `false`
				respect_buf_cwd = false,
				on_attach = on_attach,
				live_filter = {
					always_show_folders = false,
				},
				modified = {
					enable = false,
					show_on_dirs = false,
					show_on_open_dirs = false,
				},
				view = {
					-- width = 45,
					width = 50,
					-- height = 30,
					-- hide_root_folder = false,
					side = "left",
					-- side = "right",
					preserve_window_proportions = true,
					number = false,
					relativenumber = false,
					signcolumn = "yes",
					-- mappings = {
					-- 	custom_only = false,
					-- 	list = {
					-- 		-- user mappings go here
					-- 		{ key = "<C-e>", action = "" },
					-- 		{ key = "<C-Enter>", action = "vsplit" },
					-- 		{ key = "<C-k>", action = "" },
					-- 		{ key = "<C-p>", action = "toggle_file_info" },
					--       { key = "h", action = "parent_close," },
					-- 	},
					-- },
					-- float = {
					--   enable = true,
					--   open_win_config = function()
					--     local screen_w = vim.opt.columns:get()
					--     local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					--     local window_w = screen_w * WIDTH_RATIO
					--     local window_h = screen_h * HEIGHT_RATIO
					--     local window_w_int = math.floor(window_w)
					--     local window_h_int = math.floor(window_h)
					--     local center_x = (screen_w - window_w) / 2
					--     local center_y = ((vim.opt.lines:get() - window_h) / 2)
					--         - vim.opt.cmdheight:get()
					--     return {
					--       border = 'rounded',
					--       relative = 'editor',
					--       row = center_y,
					--       col = center_x,
					--       width = window_w_int,
					--       height = window_h_int,
					--     }
					--   end,
					-- },
					-- width = function()
					--   return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
					-- end,
				},
				renderer = {
					indent_markers = {
						enable = true,
						icons = {
							-- corner = "└ ",
							corner = "│ ",
							edge = "│ ",
							none = "  ",
						},
					},
					icons = {
						webdev_colors = true,
						git_placement = "after",
						modified_placement = "after",
						diagnostics_placement = "after",
						bookmarks_placement = "signcolumn",
						-- padding = " ",
						symlink_arrow = " ➛ ",
						-- symlink_arrow = "  ",
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
							modified = true,
							diagnostics = true,
							bookmarks = true,
						},
						glyphs = {
							-- default = circle,
							-- default = "〣",
							-- default = "",
							-- default = "",
							-- default = "",
							default = "",
							-- modified = "[!]",
							-- modified = "",
							modified = "⏺",
							-- modified = "",
							-- modified = ""
							-- modified = "",
							-- modified = "",
							-- default = "",
							-- default = "",
							-- default = "",
							-- default = "",
							-- default = "🀪",
							-- default = "🀀",
							-- default = "",
							-- default = "🀅",
							-- default = "📰",
							-- default = "",
							-- default = "🗃",
							symlink = "",
							folder = {
								arrow_closed = "",
								-- arrow_closed = "",
								-- arrow_open = "",
								-- arrow_closed = "",
								-- arrow_open = "",
								arrow_open = "",
								-- default = "",
								-- open = "",
								-- default = "",
								-- open = "",
								-- default = "",
								default = "",
								open = "",
								-- open = "",
								empty = "󱞞",
								empty_open = "󱞞",
								-- empty = "",
								-- empty_open = "",
								-- empty = "",
								-- empty_open = "",
								-- empty = "",
								-- empty_open = "",
								-- empty = "",
								-- empty_open = "",
								symlink = "",
								symlink_open = "",
							},
							git = {
								-- unstaged = "",
								-- unstaged = "",
								-- staged = "",

								-- unstaged = "",
								-- staged = "",
								-- unstaged = "M",
								-- unstaged = "",
								-- unstaged = "󱈸",
								-- unstaged = "󰐾 ",
								-- staged = "󰐾 ",
								-- staged = "",
								-- staged = ""
								-- staged = "",
								-- unstaged = "",
								staged = "+",
								unstaged = "!",
								-- unstaged = "󰀨 ",
								-- staged = "󰀨 ",
								-- staged = "󰐗 ",
								-- staged = "󱇭 ",
								-- staged = "   󰧞 󰺕 󰐾  󰻂           󰗖     "
								-- staged = "󱤧 ",
								-- unstaged = "!",
								-- staged = "+",
								-- unstaged = "!",
								-- staged = "+",
								-- unmerged = "",
								-- renamed = "➜",
								renamed = "󰕛 ",
								-- renamed = " ",
								-- unmerged = "",
								unmerged = " ",
								-- untracked = "★",
								-- untracked = "",
								untracked = "?",
								-- deleted = "",
								deleted = "✗",
								-- deleted = "󰧧",
								-- ignored = "◌",
								-- ignored = " "
								ignored = " ",
							},
						},
					},
				},
				hijack_directories = {
					enable = true,
					auto_open = true,
				},
				update_focused_file = {
					enable = false,
					update_root = { enable = false },
				},
				system_open = {
					cmd = "",
					args = {},
				},
				diagnostics = {
					enable = true,
					show_on_dirs = false,
					show_on_open_dirs = false,
					-- debounce_delay = 30,
					severity = {
						min = vim.diagnostic.severity.HINT,
						max = vim.diagnostic.severity.ERROR,
					},
					icons = {
						-- hint = "",
						-- hint = "",
						hint = "󰠠 ",
						-- info = "",
						info = " ",
						warning = " ",
						error = " ",
					},
				},
				filters = {
					dotfiles = false,
					custom = {},
					exclude = {},
				},
				git = {
					ignore = false,
					-- enable = should_attach_git,
					enable = true,
					show_on_dirs = true,
					show_on_open_dirs = false,
					disable_for_dirs = { "node_modules", "/node_modules", "/Users/jgarcia/", "/Users/jgarcia", "/dist" },
					-- timeout = 2000,
					-- timeout = 200,
					cygwin_support = false,
				},
				filesystem_watchers = {
					enable = true,
					-- enable = false,
					-- enable = should_attach_git,
					-- enable = false
					-- debounce_delay = 100,
					debounce_delay = 100,
					-- debounce_delay = 1000,
					-- ignore_dirs = { "/target", "/.ccls-cache" },
					ignore_dirs = {
						"node_modules",
						"/node_modules",
						"target",
						"/target",
						"tmp",
						"/tmp",
						"dist",
						"/dist",
						".angular",
						"/.angular",
						".nx",
						"/.nx",
						"/Users/jgarcia",
						"cdk.out",
						"/cdk.out",
						"coverage",
						"/coverage",
						"out-tsc",
						"/out-tsc",
						".DS_Store",
					},
				},
				actions = {
					use_system_clipboard = true,
					file_popup = {
						open_win_config = {
							col = 1,
							row = 1,
							relative = "cursor",
							border = "rounded",
							style = "minimal",
						},
					},
					change_dir = {
						enable = true,
						global = false,
					},
					open_file = {
						quit_on_open = false,
						resize_window = true,
						window_picker = {
							enable = false,
							chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
							exclude = {
								filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
								buftype = { "nofile", "terminal", "help" },
							},
						},
					},
				},
				log = {
					enable = false,
					truncate = false,
					types = {
						all = false,
						config = false,
						copy_paste = false,
						git = false,
						profile = false,
					},
				},
			})

			-- local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
			-- vim.api.nvim_create_autocmd("User", {
			--   pattern = "NvimTreeSetup",
			--   callback = function()
			--     local events = require("nvim-tree.api").events
			--     events.subscribe(events.Event.NodeRenamed, function(data)
			--       if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
			--         data = data
			--         Snacks.rename.on_rename_file(data.old_name, data.new_name)
			--       end
			--     end)
			--   end,
			-- })
		end,
	},
	{
		"b0o/nvim-tree-preview.lua",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"3rd/image.nvim", -- Optional, for previewing images
		},
		lazy = true,
		keys = {
			-- { "<Tab>", mode = "n" },
			{ "P", mode = "n" },
		},
		config = function()
			-- Default config:
			require("nvim-tree-preview").setup({
				-- Keymaps for the preview window (does not apply to the tree window).
				-- Keymaps can be a string (vimscript command), a function, or a table.
				--
				-- If a function is provided:
				--   When the keymap is invoked, the function is called.
				--   It will be passed a single argument, which is a table of the following form:
				--     {
				--       node: NvimTreeNode|NvimTreeRootNode, -- The tree node under the cursor
				--     }
				--   See the type definitions in `lua/nvim-tree-preview/types.lua` for a description
				--   of the fields in the table.
				--
				-- If a table, it must contain either an 'action' or 'open' key:
				--   Actions:
				--     { action = 'close', unwatch? = false, focus_tree? = true }
				--     { action = 'toggle_focus' }
				--     { action = 'select_node', target: 'next'|'prev' }
				--
				--   Open modes:
				--     { open = 'edit' }
				--     { open = 'tab' }
				--     { open = 'vertical' }
				--     { open = 'horizontal' }
				--
				-- To disable a default keymap, set it to false.
				-- All keymaps are set in normal mode. Other modes are not currently supported.
				keymaps = {
					["<Esc>"] = { action = "close", unwatch = true },
					-- ["<Tab>"] = { action = "toggle_focus" },
					["<CR>"] = { open = "edit" },
					["<C-t>"] = { open = "tab" },
					["<C-v>"] = { open = "vertical" },
					["<C-x>"] = { open = "horizontal" },
					["<C-n>"] = { action = "select_node", target = "next" },
					["<C-p>"] = { action = "select_node", target = "prev" },
				},
				min_width = 10,
				min_height = 5,
				max_width = 85,
				max_height = 25,
				wrap = false, -- Whether to wrap lines in the preview window
				border = "rounded", -- Border style for the preview window
				zindex = 100, -- Stacking order. Increase if the preview window is shown below other windows.
				show_title = true, -- Whether to show the file name as the title of the preview window
				title_pos = "top-left", -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
				title_format = " %s ",
				follow_links = true, -- Whether to follow symlinks when previewing files
				-- win_position: { row?: number|function, col?: number|function }
				-- Position of the preview window relative to the tree window.
				-- If not specified, the position is automatically calculated.
				-- Functions receive (tree_win, size) parameters and must return a number, where:
				--   tree_win: number - tree window handle
				--   size: {width: number, height: number} - dimensions of the preview window
				-- Example:
				--   win_position = {
				--    col = function(tree_win, size)
				--      local view_side = require('nvim-tree').config.view.side
				--      return view_side == 'left' and vim.fn.winwidth(tree_win) + 1 or -size.width - 3
				--    end,
				--   },
				win_position = {},
				image_preview = {
					enable = true, -- Whether to preview images (for more info see Previewing Images section in README)
					patterns = { -- List of Lua patterns matching image file names
						".*%.png$",
						".*%.jpg$",
						".*%.jpeg$",
						".*%.gif$",
						".*%.webp$",
						".*%.avif$",
						-- Additional patterns:
						-- '.*%.svg$',
						-- '.*%.bmp$',
						-- '.*%.pdf$', (known to have issues)
					},
				},
				on_open = nil, -- fun(win: number, buf: number) called when the preview window is opened
				on_close = nil, -- fun() called when the preview window is closed
				watch = {
					event = "CursorMoved", -- 'CursorMoved'|'CursorHold'. Event to use to update the preview in watch mode
				},
			})
		end,
	},
}
