return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		keys = {
      {
        mode = "n",
        "H",
        function()
          local target
          local buffer = vim.api.nvim_get_current_buf()

          if not buffer then
            return nil
          end
          local path = vim.api.nvim_buf_get_name(buffer)
          if path == "" then
            target = vim.loop.cwd()
          end
          target = vim.fn.fnamemodify(path, ":p:h")
          require("oil").open(target)
        end,
        desc = "Oil: parent directory",
      },
			{
				"-",
				function()
					local target
					local buffer = vim.api.nvim_get_current_buf()

					if not buffer then
						return nil
					end
					local path = vim.api.nvim_buf_get_name(buffer)
					if path == "" then
						target = vim.loop.cwd()
					end
					target = vim.fn.fnamemodify(path, ":p:h")
					require("oil").open(target)
				end,
				desc = "Oil: parent directory",
				mode = "n",
			},
			{
				"<leader>ou",
				function()
					local home = vim.loop.os_homedir()
					if home then
						if not home then
							local buffer = vim.api.nvim_get_current_buf()
							if not buffer then
								return nil
							end
							local path = vim.api.nvim_buf_get_name(buffer)
							if path == "" then
								home = vim.loop.cwd()
							end
							home = vim.fn.fnamemodify(path, ":p:h")
						end
						if not home then
							return
						end
						require("oil").open(home)
					end
				end,
				desc = "Oil: home directory",
				mode = "n",
			},
		},
		config = function()
      _G.oil_winbar_label = function()
        local oil = require("oil")
        local dir = oil.get_current_dir()

        if dir and dir ~= "" then
          local home = vim.loop.os_homedir()
          if home and home ~= "" then
            dir = dir:gsub("^" .. vim.pesc(home), "~")
          end
          return dir
        end

        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then
          return "[No Name]"
        end

        return bufname
      end

			require("oil").setup({
				-- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
				-- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
				default_file_explorer = true,
				-- Id is automatically added at the beginning, and name at the end
				-- See :help oil-columns
				columns = {
					{ "icon", directory = "", default_file = "" },
					"permissions",
					"size",
					"mtime",
				},
				-- Buffer-local options to use for oil buffers
				buf_options = {
					buflisted = true,
					bufhidden = "hide",
				},
				-- Window-local options to use for oil buffers
				win_options = {
					winbar = "%#NvimTreeRootFolder#%{v:lua.oil_winbar_label()}  %#ModeMsg#%{%&modified ? '⏺' : ''%}",
					-- winbar = "%#@attribute.builtin#%{v:lua.get_winbar()} %#ModeMsg#%{%&modified ? '⏺' : ''%}",
					-- wrap = false,
					-- signcolumn = "no",
					-- cursorcolumn = false,
					-- foldcolumn = "0",
					-- spell = false,
					-- list = false,
					-- conceallevel = 0,
					-- concealcursor = "nvic",
				},
				-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
				delete_to_trash = false,
				-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
				skip_confirm_for_simple_edits = true,
				-- Selecting a new/moved/renamed file or directory will prompt you to save changes first
				-- (:help prompt_save_on_select_new_entry)
				-- prompt_save_on_select_new_entry = true,
				prompt_save_on_select_new_entry = false,
				-- Oil will automatically delete hidden buffers after this delay
				-- You can set the delay to false to disable cleanup entirely
				-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
				cleanup_delay_ms = false,
				-- cleanup_delay_ms = false,
				lsp_file_methods = {
					enabled = true,
					-- Time to wait for LSP file operations to complete before skipping
					timeout_ms = 1000,
					-- Set to true to autosave buffers that are updated with LSP willRenameFiles
					-- Set to "unmodified" to only save unmodified buffers
					-- autosave_changes = true,
					autosave_changes = true,
				},
				-- Constrain the cursor to the editable parts of the oil buffer
				-- Set to `false` to disable, or "name" to keep it on the file names
				-- constrain_cursor = "editable",
				constrain_cursor = "editable",
				-- Set to true to watch the filesystem for changes and reload oil
				watch_for_changes = true,
				-- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
				-- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
				-- Additionally, if it is a string that matches "actions.<name>",
				-- it will use the mapping at require("oil.actions").<name>
				-- Set to `false` to remove a keymap
				-- See :help oil-actions for a list of all available actions
				keymaps = {
					["g?"] = { "actions.show_help", mode = "n" },
					-- ["gp"] = {
					--   callback = function()
					--     require("image_preview").PreviewImageOil()
					--   end,
					--   mode = "n",
					-- },
					-- ["<leader>pi"] = function()
					--   local oil = require("oil")
					--   local filename = oil.get_cursor_entry().name
					--   local dir = oil.get_current_dir()
					--   print("Pasting image: ", dir .. filename)
					--   local img_clip = require("img-clip")
					--   img_clip.paste_image({}, dir .. filename)
					-- end,
					["<CR>"] = "actions.select",
					["<C-v>"] = { "actions.select", opts = { vertical = true } },
					["<C-s>"] = { "actions.select", opts = { horizontal = true } },
					["<C-t>"] = { "actions.select", opts = { tab = true } },
					["<C-p>"] = "actions.preview",
					["<C-c>"] = { "actions.close", mode = "n" },
					-- ["<C-l>"] = "actions.refresh",
					-- ["<C-h>"] = "",
					-- ["<C-l>"] = "",
					["R"] = "actions.refresh",
					["-"] = { "actions.parent", mode = "n" },
					["_"] = { "actions.open_cwd", mode = "n" },
					-- ["<BS>"] = { "actions.cd", mode = "n" },
					["L"] = { "actions.select", mode = "n" },
					["H"] = { "actions.parent", mode = "n" },
					["<BS>"] = { "actions.select", mode = "n" },
					["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
					["gs"] = { "actions.change_sort", mode = "n" },

					["su"] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end
							local home = vim.fn.expand("$HOME")

							require("jg.custom.telescope").oil_fzf_dir(home)

							-- oil.open(path)
						end,
						mode = "n",
					},
					["sd"] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end
							-- local root_dir = vim.fs.dirname(vim.fs.find({ ".git" })[1])
							--
							-- if not root_dir then
							--   root_dir = dir
							-- end

							require("jg.custom.telescope").oil_fzf_dir(dir)
						end,
						mode = "n",
					},
					["sf"] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end
							-- local root_dir = vim.fs.dirname(vim.fs.find({ ".git" })[1])
							--
							-- if not root_dir then
							--   root_dir = dir
							-- end

							-- require("jg.custom.telescope").oil_fzf_dir(root_dir)
							require("jg.custom.telescope").oil_fzf_files_builtin(dir)
						end,
						mode = "n",
					},
					["<M-b>"] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end

							entry.name = entry.name:gsub(" ", "\\ ")
							local path = dir .. entry.name

							local cmd_run = string.format(":Compile  %s", path)
							local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
							vim.api.nvim_feedkeys(keys, "c", true)

							local hops =
								string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
							vim.api.nvim_feedkeys(hops, "n", true)

							-- vim.ui.input({ prompt = "Command to run on " .. entry.name .. ": " }, function(cmd)
							-- 	if not cmd or cmd == "" then
							-- 		return
							-- 	end
							-- 	-- local myterm = require("terminal").terminal:new({
							-- 	-- 	layout = { open_cmd = "botright new" },
							-- 	-- 	cwd = dir,
							-- 	--           cmd = { cmd, path },
							-- 	--           autoclose = false
							-- 	-- })
							-- 	-- myterm:open()
							--
							-- 	local cmd_run = string.format(":Bufferize !" .. cmd .. " " .. path)
							-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd_run, true, false, true), "c", true)
							-- end)
						end,
						mode = "n",
					},
					["."] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end

							entry.name = entry.name:gsub(" ", "\\ ")
							local path = dir .. entry.name

							local cmd_run = string.format(":Bufferize ! %s", path)
							local keys = vim.api.nvim_replace_termcodes(cmd_run, true, false, true)
							vim.api.nvim_feedkeys(keys, "c", true)

							local hops =
								string.rep(vim.api.nvim_replace_termcodes("<Left>", true, false, true), #path + 1)
							vim.api.nvim_feedkeys(hops, "n", true)

							-- vim.ui.input({ prompt = "Command to run on " .. entry.name .. ": " }, function(cmd)
							-- 	if not cmd or cmd == "" then
							-- 		return
							-- 	end
							-- 	-- local myterm = require("terminal").terminal:new({
							-- 	-- 	layout = { open_cmd = "botright new" },
							-- 	-- 	cwd = dir,
							-- 	--           cmd = { cmd, path },
							-- 	--           autoclose = false
							-- 	-- })
							-- 	-- myterm:open()
							--
							-- 	local cmd_run = string.format(":Bufferize !" .. cmd .. " " .. path)
							-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd_run, true, false, true), "c", true)
							-- end)
						end,
						mode = "n",
					},
					-- ["."] = {
					-- 	callback = function()
					-- 		local oil = require("oil")
					-- 		local dir = oil.get_current_dir()
					-- 		if not dir then
					-- 			return
					-- 		end
					-- 		-- Ensure trailing slash
					-- 		if not dir:match("/$") then
					-- 			dir = dir .. "/"
					-- 		end
					-- 		local cmd = string.format(":!wget -P %s ", vim.fn.shellescape(dir))
					-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "c", true)
					-- 	end,
					-- 	mode = "n",
					-- },
					["go"] = {
						callback = function()
							local oil = require("oil")
							local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()

							if not entry or not dir then
								return
							end

							entry.name = entry.name:gsub(" ", "\\ ")
							local path = dir .. entry.name

							local zaread = require("terminal").terminal:new({
								layout = { open_cmd = "botright new" },
								cwd = dir,
								cmd = "zaread " .. path,
							})
							zaread:open()
						end,
					},
					["gy"] = {
						callback = function()
							local oil = require("oil")
							local dir = oil.get_current_dir()
							local entry = oil.get_cursor_entry()

							if not dir or not entry then
								return
							end

							local path = vim.fn.fnamemodify(dir .. entry.name, ":p")

							vim.fn.setreg("+", path)
							vim.fn.setreg('"', path)
							vim.notify("Copied path: " .. path, vim.log.levels.INFO)
						end,
					},
					["gt"] = {
						callback = function()
							local oil = require("oil")
							-- local entry = oil.get_cursor_entry()
							local dir = oil.get_current_dir()
							-- local term_map = require("terminal.mappings")
							-- term_map.toggle(nil, { cwd = dir })
							local myterm = require("terminal").terminal:new({
								layout = { open_cmd = "botright new" },
								cwd = dir,
							})
							myterm:open()
						end,
					},
					["gx"] = "actions.open_external",
					-- ["gz"] = {
					--   callback = function()
					--     local oil = require("oil")
					--     local entry = oil.get_cursor_entry()
					--     local dir = oil.get_current_dir()
					--     if not entry or not dir then
					--       return
					--     end
					--     local path = dir .. entry.name
					--
					--
					--     local cmd, err = { "zathura", path }, nil
					--     if not cmd then
					--       vim.notify(string.format("Could not open %s: %s", path, err), vim.log.levels.ERROR)
					--       return
					--     end
					--     local jid = vim.fn.jobstart(cmd, { detach = true })
					--     assert(jid > 0, "Failed to start job")
					--   end,
					--   mode = "n"
					-- },
					["g."] = { "actions.toggle_hidden", mode = "n" },
					["g\\"] = { "actions.toggle_trash", mode = "n" },
				},
				-- Set to false to disable all of the above keymaps
				use_default_keymaps = false,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
					-- This function defines what is considered a "hidden" file
					-- is_hidden_file = function(name, bufnr)
					--   return vim.startswith(name, ".")
					-- end,
					-- -- This function defines what will never be shown, even when `show_hidden` is set
					-- is_always_hidden = function(name, bufnr)
					--   return false
					-- end,
					-- Sort file names in a more intuitive order for humans. Is less performant,
					-- so you may want to set to false if you work with large directories.
					natural_order = true,
					-- Sort file and directory names case insensitive
					case_insensitive = false,
					sort = {
						-- sort order can be "asc" or "desc"
						-- see :help oil-columns to see which columns are sortable
						{ "type", "asc" },
						{ "birthtime", "desc" },
						{ "name", "asc" },
					},
				},
				-- Extra arguments to pass to SCP when moving/copying files over SSH
				extra_scp_args = {},
        extra_s3_args = { "--profile=mar-dev" },
				-- EXPERIMENTAL support for performing file operations with git
				-- git = {
				--   -- Return true to automatically git add/mv/rm files
				--   add = function(path)
				--     return false
				--   end,
				--   mv = function(src_path, dest_path)
				--     return false
				--   end,
				--   rm = function(path)
				--     return false
				--   end,
				-- },
				-- Configuration for the floating window in oil.open_float
				float = {
					-- Padding around the floating window
					padding = 2,
					max_width = 0,
					max_height = 0,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- preview_split: Split direction: "auto", "left", "right", "above", "below".
					preview_split = "auto",
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					-- override = function(conf)
					--   return conf
					-- end,
				},
				-- Configuration for the actions floating preview window
				preview = {
					-- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- min_width and max_width can be a single value or a list of mixed integer/float types.
					-- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
					max_width = 0.9,
					-- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
					min_width = { 40, 0.4 },
					-- optionally define an integer/float for the exact width of the preview window
					width = nil,
					-- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- min_height and max_height can be a single value or a list of mixed integer/float types.
					-- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
					max_height = 0.9,
					-- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
					min_height = { 5, 0.1 },
					-- optionally define an integer/float for the exact height of the preview window
					height = nil,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
					-- Whether the preview window is automatically updated when the cursor is moved
					update_on_cursor_moved = true,
				},
				-- Configuration for the floating progress window
				progress = {
					max_width = 0.9,
					min_width = { 40, 0.4 },
					width = nil,
					max_height = { 10, 0.9 },
					min_height = { 5, 0.1 },
					height = nil,
					border = "rounded",
					minimized_border = "none",
					win_options = {
						winblend = 0,
					},
				},
				-- Configuration for the floating SSH window
				ssh = {
					border = "rounded",
				},
				-- Configuration for the floating keymaps help window
				keymaps_help = {
					border = "rounded",
				},
			})
		end,
	},
}
