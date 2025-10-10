local M = {}

-- git branch --set-upstream-to=origin/release release Selection:  {
--   authorname = "Garcia Perera, Julio",
--   committerdate = "2024/11/06 09:59:49",
--   display = <function 1>,
--   head = " ",
--   index = 24,
--   name = "origin/develop",
--   ordinal = "origin/develop",
--   upstream = "",
--   value = "origin/develop",
--   <metatable> = {
--     __index = <function 2>
--   }
-- }
-- Branch:  origin/develop
--
local function branch_name()
	local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
	if branch ~= "" then
		return branch
	else
		return ""
	end
end

M.set_upstream = function(prompt_bufnr)
	local actions = require("telescope.actions")
	local utils = require("telescope.utils")
	local action_state = require("telescope.actions.state")
	local cwd = action_state.get_current_picker(prompt_bufnr).cwd
	local selection = action_state.get_selected_entry()
	if selection == nil then
		utils.__warn_no_selection("actions.set_upstream")
		return
	end
	local active_branch = branch_name()
	actions.close(prompt_bufnr)
	local remote_branch = selection.value

	local upstream_string = "--set-upstream-to=" .. remote_branch
	local _, ret, stderr = utils.get_os_command_output({ "git", "branch", upstream_string, active_branch }, cwd)
	if ret == 0 then
		utils.notify("actions.set_upstream", {
			msg = string.format("Set branch '%s' upstream to: '%s'", active_branch, remote_branch),
			level = "INFO",
		})
	else
		utils.notify("actions.set_upstream", {
			msg = string.format(
				"Error when setting upstream to: %s. Git returned: '%s'",
				remote_branch,
				table.concat(stderr, " ")
			),
			level = "ERROR",
		})
	end
end

M.curr_buf = function(user_opts)
	local opts = {
		tiebreak = function(entry1, entry2, prompt)
			local start_pos1, _ = entry1.ordinal:find(prompt)
			if start_pos1 then
				local start_pos2, _ = entry2.ordinal:find(prompt)
				if start_pos2 then
					return start_pos1 < start_pos2
				end
			end
			return false
		end,
		additional_args = { "--ignore-case", "--pcre2" },
	}

	opts = vim.tbl_deep_extend("force", opts, user_opts or {})
	require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

M.normal_buffers = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	local function buf_in_cwd(bufname, cwd)
		local Path = require("plenary.path")
		if cwd:sub(-1) ~= Path.path.sep then
			cwd = cwd .. Path.path.sep
		end
		local bufname_prefix = bufname:sub(1, #cwd)
		return bufname_prefix == cwd
	end

	local function apply_cwd_only_aliases(opts2)
		local has_cwd_only = opts.cwd_only ~= nil
		local has_only_cwd = opts.only_cwd ~= nil

		if has_only_cwd and not has_cwd_only then
			-- Internally, use cwd_only
			opts2.cwd_only = opts2.only_cwd
			opts2.only_cwd = nil
		end

		return opts2
	end

	opts = apply_cwd_only_aliases(opts)

	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end
		-- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
		if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(bufnr) then
			return false
		end
		if opts.ignore_current_buffer and bufnr == vim.api.nvim_get_current_buf() then
			return false
		end

		local bufname = vim.api.nvim_buf_get_name(bufnr)

		-- local has_changes = require('gitsigns').get_hunks(bufname) ~= nil
		-- print("bufname: haschanges: ", bufname, has_changes)

		if string.match(bufname, "term://") then
			return false
		end

		if opts.cwd_only and not buf_in_cwd(bufname, vim.loop.cwd()) then
			return false
		end
		if not opts.cwd_only and opts.cwd and not buf_in_cwd(bufname, opts.cwd) then
			return false
		end
		return true
	end, vim.api.nvim_list_bufs())

	if not next(bufnrs) then
		local utils = require("telescope.utils")
		utils.notify("builtin.buffers", { msg = "No buffers found with the provided options", level = "INFO" })
		return
	end

	if opts.sort_mru then
		table.sort(bufnrs, function(a, b)
			return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
		end)
	end

	local buffers = {}
	local default_selection_idx = 1
	for _, bufnr in ipairs(bufnrs) do
		local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

		if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
			default_selection_idx = 2
		end

		local element = {
			bufnr = bufnr,
			flag = flag,
			info = vim.fn.getbufinfo(bufnr)[1],
		}

		if opts.sort_lastused and (flag == "#" or flag == "%") then
			local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
			table.insert(buffers, idx, element)
		else
			table.insert(buffers, element)
		end
	end

	if not opts.bufnr_width then
		local max_bufnr = math.max(unpack(bufnrs))
		opts.bufnr_width = #tostring(max_bufnr)
	end

	pickers
		.new(opts, {
			prompt_title = "Buffers",
			finder = finders.new_table({
				results = buffers,
				entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
			}),
			-- previewer = conf.grep_previewer(opts),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
			default_selection_index = default_selection_idx,
		})
		:find()
end

M.term_buffers = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	local function buf_in_cwd(bufname, cwd)
		local Path = require("plenary.path")
		if cwd:sub(-1) ~= Path.path.sep then
			cwd = cwd .. Path.path.sep
		end
		local bufname_prefix = bufname:sub(1, #cwd)
		return bufname_prefix == cwd
	end

	local function apply_cwd_only_aliases(opts2)
		local has_cwd_only = opts.cwd_only ~= nil
		local has_only_cwd = opts.only_cwd ~= nil

		if has_only_cwd and not has_cwd_only then
			-- Internally, use cwd_only
			opts2.cwd_only = opts2.only_cwd
			opts2.only_cwd = nil
		end

		return opts2
	end

	opts = apply_cwd_only_aliases(opts)

	local bufnrs = vim.tbl_filter(function(bufnr)
		if 1 ~= vim.fn.buflisted(bufnr) then
			return false
		end
		-- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
		if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(bufnr) then
			return false
		end
		if opts.ignore_current_buffer and bufnr == vim.api.nvim_get_current_buf() then
			return false
		end

		local bufname = vim.api.nvim_buf_get_name(bufnr)

		if not string.match(bufname, "term://") then
			return false
		end

		if opts.cwd_only and not buf_in_cwd(bufname, vim.loop.cwd()) then
			return false
		end
		if not opts.cwd_only and opts.cwd and not buf_in_cwd(bufname, opts.cwd) then
			return false
		end
		return true
	end, vim.api.nvim_list_bufs())

	if not next(bufnrs) then
		local utils = require("telescope.utils")
		utils.notify("builtin.buffers", { msg = "No buffers found with the provided options", level = "INFO" })
		return
	end

	if opts.sort_mru then
		table.sort(bufnrs, function(a, b)
			return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
		end)
	end

	local buffers = {}
	local default_selection_idx = 1
	for _, bufnr in ipairs(bufnrs) do
		local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

		if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
			default_selection_idx = 2
		end

		local element = {
			bufnr = bufnr,
			flag = flag,
			info = vim.fn.getbufinfo(bufnr)[1],
		}

		if opts.sort_lastused and (flag == "#" or flag == "%") then
			local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
			table.insert(buffers, idx, element)
		else
			table.insert(buffers, element)
		end
	end

	if not opts.bufnr_width then
		local max_bufnr = math.max(unpack(bufnrs))
		opts.bufnr_width = #tostring(max_bufnr)
	end

	local previewers = require("telescope.previewers")
	--   local bat_custom = previewers.new_termopen_previewer {
	--     get_command = function(entry)
	--       return { 'bat', entry.value }
	--     end
	-- }

	local term_buffer_previewer = previewers.new_buffer_previewer({
		define_preview = function(self, entry, _)
			local bufnr = entry.bufnr
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
			else
				vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "Buffer not loaded" })
			end
		end,
	})
	pickers
		.new(opts, {
			prompt_title = "Terminal Buffers",
			finder = finders.new_table({
				results = buffers,
				entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
				-- entry_maker = function(entry)
				-- 	return {
				-- 		value = entry,
				-- 		text = tostring(entry.bufnr),
				-- 		display = tostring(entry.name),
				-- 		ordinal = tostring(entry.bufnr),
				-- 	}
				-- end,
			}),
			previewer = {
				term_buffer_previewer,
				previewers.vim_buffer_vimgrep.new(opts),
			},
			-- previewer = previewers.qflist.new(opts),
			-- previewer = previewers.new_termopen_previewer(opts),
			-- previewer = previewers.new_buffer_previewer(opts),
			-- previewer = previewers.cat.new(opts),
			-- previewer = previewers.vim_buffer_cat.new(opts),
			-- previewer = conf.grep_previewer(opts),
			sorter = conf.generic_sorter(opts),
			default_selection_index = default_selection_idx,
		})
		:find()
end

M.telescope_image_preview = function()
	local supported_images = { "svg", "png", "jpg", "jpeg", "gif", "webp", "avif" }
	local from_entry = require("telescope.from_entry")
	local Path = require("plenary.path")
	local conf = require("telescope.config").values
	local Previewers = require("telescope.previewers")

	local previewers = require("telescope.previewers")
	local image_api = require("image")

	local is_image_preview = false
	local image = nil
	local last_file_path = ""

	local is_supported_image = function(filepath)
		local split_path = vim.split(filepath:lower(), ".", { plain = true })
		local extension = split_path[#split_path]
		return vim.tbl_contains(supported_images, extension)
	end

	local delete_image = function()
		if not image then
			return
		end

		image:clear()

		is_image_preview = false
	end

	local create_image = function(filepath, winid, bufnr)
    delete_image()
		-- image = image_api.hijack_buffer(filepath, winid, bufnr)
    vim.schedule(function()
      local winid_custom = vim.fn.bufwinid(bufnr)
      image = image_api.hijack_buffer(filepath, winid_custom, bufnr)
      -- image = image_api.from_file(filepath, { window = winid_custom, buffer = bufnr })
      if not image then
        print("not image")
        return
      end

      vim.schedule(function()
        image:render()
      end)

      is_image_preview = true
    end)
	end

	local function defaulter(f, default_opts)
		default_opts = default_opts or {}
		return {
			new = function(opts)
				if conf.preview == false and not opts.preview then
					return false
				end
				opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
				if type(conf.preview) == "table" then
					for k, v in pairs(conf.preview) do
						opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
					end
				end
				return f(opts)
			end,
			__call = function()
				local ok, err = pcall(f(default_opts))
				if not ok then
					error(debug.traceback(err))
				end
			end,
		}
	end

	-- NOTE: Add teardown to cat previewer to clear image when close Telescope
	local file_previewer = defaulter(function(opts)
		opts = opts or {}
		local cwd = opts.cwd or vim.loop.cwd()
		return Previewers.new_buffer_previewer({
			title = "File Preview",
			dyn_title = function(_, entry)
				return Path:new(from_entry.path(entry, true)):normalize(cwd)
			end,

			get_buffer_by_name = function(_, entry)
				return from_entry.path(entry, true)
			end,

			-- define_preview = function(self, entry, _)
			-- 	local p = from_entry.path(entry, true)
			-- 	if p == nil or p == "" then
			-- 		return
			-- 	end
			--
			-- 	conf.buffer_previewer_maker(p, self.state.bufnr, {
			-- 		bufname = self.state.bufname,
			-- 		winid = self.state.winid,
			-- 		preview = opts.preview,
			-- 	})
			-- end,

      define_preview = function(self, entry, _)
        local filepath = entry.value
        if is_supported_image(filepath) then
          create_image(filepath, self.state.winid, self.state.bufnr)
        else
          require("telescope.previewers").buffer_previewer_maker(filepath, self.state.bufnr, {
            bufname = self.state.bufname,
            winid = self.state.winid,
          })
        end
      end,

			teardown = function(_)
				if is_image_preview then
					delete_image()
				end
			end,
		})
	end, {})

	local buffer_previewer_maker = function(filepath, bufnr, opts)
		-- NOTE: Clear image when preview other file
		if is_image_preview and last_file_path ~= filepath then
			delete_image()
		end

		last_file_path = filepath

		if is_supported_image(filepath) then
			-- filepath = string.gsub(filepath, " ", "%%20"):gsub("\\", "")

      local winid = vim.fn.bufwinid(bufnr)
      -- print("winid, ", winid)
			create_image(filepath, winid, bufnr)
		-- create_image(filepath, winid, bufnr)
		else
			previewers.buffer_previewer_maker(filepath, bufnr, opts)
		end
	end

	return { buffer_previewer_maker = buffer_previewer_maker, file_previewer = file_previewer.new }
end

M.read_file = function(file_path)
	local file = io.open(file_path, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()

	return content
end

M.get_npm_scripts = function(package_json_path)
	if not package_json_path then
		package_json_path = "package.json"
	end
	local status, package_json_content = pcall(M.read_file, package_json_path)
	if not status then
		return
	end

	local status_decode, package_data = pcall(vim.json.decode, package_json_content)
	if not status_decode then
		print("Impossible to parse package.json")
		return {}
	end

	local scripts = package_data.scripts
	return scripts
end

M.get_project_json_targets = function()
	local project_json_path = "project.json"
	local status, project_json_content = pcall(M.read_file, project_json_path)
	if not status then
		return
	end

	local status_decode, project_data = pcall(vim.json.decode, project_json_content)
	if not status_decode then
		print("Impossible to parse package.json")
		return {}
	end

	local targets = project_data.targets
	return targets
end

M.compile_mode_on_npm_scripts = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local compile_mode = require("compile-mode")

	local scripts = M.get_npm_scripts() or {}

	local script_list = {}
	for key, value in pairs(scripts) do
		table.insert(script_list, { script_name = "npm run " .. key, script_value = value })
	end

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "Compile Mode on npm scripts",
				finder = finders.new_table({
					results = script_list,
					entry_maker = function(entry)
						return {
							value = entry,
							-- display = "npm run " .. entry.script_name .. "                      (" .. entry.script_value .. ")",
							display = entry.script_name,
							ordinal = entry.script_name,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						-- local command = selection[1]
						compile_mode.compile({ args = selection.value.script_name })
					end)
					return true
				end,
			})
			:find()
	end

	commands()
end

M.oil_fzf_files_builtin = function(path)
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		".",
		path,
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		"--max-depth",
		"4",
		"--hidden",
	}

	require("telescope.builtin").find_files({
		find_command,
		prompt_title = 'Open the directory of the selected file in Oil from "'
			.. path:gsub(os.getenv("HOME"), "~")
			.. '"',
		sorter = conf.generic_sorter(),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if vim.fn.isdirectory(selection.value) == 1 then
					require("oil").open(selection.value)
				else
					-- remove the last part of the path from selection.value
					local dir_path = selection.value:match("(.*/)")
					require("oil").open(dir_path)
				end
			end)
			return true
		end,
	})
end

M.oil_fzf_files = function(path)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		".",
		path,
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		"--max-depth",
		"4",
		"--hidden",
	}

	-- Function to escape special characters in a string for use in a pattern
	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local escaped_path = escape_pattern(path)

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = 'Oil fzf files from "' .. path:gsub(os.getenv("HOME"), "~") .. '"',
				finder = finders.new_oneshot_job(find_command, {
					entry_maker = function(entry)
						local entry_substituted = entry:gsub(escaped_path, ""):gsub("^/", "")
						return {
							value = entry,
							display = entry_substituted,
							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if vim.fn.isdirectory(selection.value) == 1 then
							require("oil").open(selection.value)
						else
							-- remove the last part of the path from selection.value
							local dir_path = selection.value:match("(.*/)")
							require("oil").open(dir_path)
						end
					end)
					return true
				end,
			})
			:find()
	end

	commands()
end

M.telescope_file_picker_in_workspace = function(path, no_ignore)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		".",
		path,
		"--type",
		"d",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		-- "--one-file-system",
		"--max-depth",
		"4",
		"--hidden",
	}

	if no_ignore then
		table.insert(find_command, "--no-ignore")
	end

	-- Function to escape special characters in a string for use in a pattern
	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local escaped_path = escape_pattern(path)

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = 'Select a dir and open git files: "' .. path:gsub(os.getenv("HOME"), "~") .. '"',
				finder = finders.new_oneshot_job(find_command, {
					entry_maker = function(entry)
						local entry_substituted = entry:gsub(escaped_path, ""):gsub("^/", "")
						return {
							value = entry,
							-- display = "  ~/" .. entry_substituted,

							display = function()
								local display_string
								if string.find(path, os.getenv("HOME")) then
									display_string = "  ~/" .. entry_substituted
								else
									display_string = "  " .. entry_substituted
								end
								return display_string, { { { 0, 1 }, "Directory" } }
							end,
							-- { { {1, 3}, hl_group } }
							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						-- require("oil").open(selection.value)
						require("telescope.builtin").find_files({
							hidden = true,
							cwd = selection.value,
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
					end)

					return true
				end,
			})
			:find()
	end

	commands()
end

M.oil_fzf_dir = function(path, no_ignore)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		".",
		path,
		"--type",
		"d",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		-- "--one-file-system",
		"--max-depth",
		"4",
		"--hidden",
	}

	if no_ignore then
		table.insert(find_command, "--no-ignore")
	end

	-- Function to escape special characters in a string for use in a pattern
	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local escaped_path = escape_pattern(path)

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = 'Open a directory from "' .. path:gsub(os.getenv("HOME"), "~") .. '" in Oil',
				finder = finders.new_oneshot_job(find_command, {
					entry_maker = function(entry)
						local entry_substituted = entry:gsub(escaped_path, ""):gsub("^/", "")
						return {
							value = entry,
							-- display = "  ~/" .. entry_substituted,

							display = function()
								local display_string
								if string.find(path, os.getenv("HOME")) then
									display_string = "  ~/" .. entry_substituted
								else
									display_string = "  " .. entry_substituted
								end
								return display_string, { { { 0, 1 }, "Directory" } }
							end,
							-- { { {1, 3}, hl_group } }
							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						require("oil").open(selection.value)
					end)

					actions.select_vertical:replace(function()
						local selection = action_state.get_selected_entry()
						require("telescope.actions").close(prompt_bufnr)
						vim.cmd("vsplit")
						require("oil").open(selection.value)
					end)

          actions.select_horizontal:replace(function()
            local selection = action_state.get_selected_entry()
            require("telescope.actions").close(prompt_bufnr)
            vim.cmd("split")
            require("oil").open(selection.value)
          end)

					-- map("i", "<C-v>", function()
					--   require("telescope.actions").close(prompt_bufnr)
					--   vim.cmd("vsplit")
					--   require("oil").open(selection.value)
					-- end)

					return true
				end,
			})
			:find()
	end

	commands()
end

M.nvimtree_fzf_dir = function(path)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		".",
		path,
		"--type",
		"d",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		"--no-ignore",
		"--max-depth",
		"4",
		"--hidden",
	}

	-- Function to escape special characters in a string for use in a pattern
	local function escape_pattern(text)
		return text:gsub("([^%w])", "%%%1")
	end

	local escaped_path = escape_pattern(path)

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "Open directory in Nvimtree",
				finder = finders.new_oneshot_job(find_command, {
					entry_maker = function(entry)
						local entry_substituted = entry:gsub(escaped_path, ""):gsub("^/", "")
						return {
							value = entry,
							display = function()
								local display_string
								display_string = "  ~/" .. entry_substituted
								return display_string, { { { 0, 1 }, "Directory" } }
							end,

							ordinal = entry,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						local api = require("nvim-tree.api")
						-- api.tree.open({ update_root = true, path = selection.value })
						api.tree.change_root(selection.value)
						api.tree.find_file(selection.value)
					end)
					return true
				end,
			})
			:find()
	end

	commands()
end

M.run_nx_scripts = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local targets = M.get_project_json_targets() or {}

	local target_list = {}
	for key, _ in pairs(targets) do
		table.insert(target_list, { target_name = key, target_run = "npx nx run " .. key })
	end

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "Select nx target to run",
				finder = finders.new_table({
					results = target_list,
					entry_maker = function(entry)
						return {
							value = entry,
							-- display = "npm run " .. entry.script_name .. "                      (" .. entry.script_value .. ")",
							display = entry.target_name,
							ordinal = entry.target_name,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()

						-- local function toggle_terminal_with_command(command)
						--   -- Create a new terminal or get the existing one
						--   local Terminal = require('terminal')
						--   local term = Terminal:new({
						--     layout = 'horizontal',
						--     cmd = command,
						--     hidden = true,
						--   })
						--
						--   -- Toggle the terminal
						--   term:toggle()
						-- end
						--
						-- toggle_terminal_with_command(selection.value.script_name)
						local myterm = require("terminal").terminal:new({
							layout = { open_cmd = "botright new" },
							-- cmd = { selection.value.script_name },
							autoclose = false,
						})
						myterm:open()
						myterm:send(selection.value.target_run)
					end)
					return true
				end,
			})
			:find()
	end

	commands()
end

M.run_npm_scripts = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local scripts = M.get_npm_scripts() or {}

	local script_list = {}
	for key, value in pairs(scripts) do
		table.insert(script_list, { script_name = "npm run " .. key, script_value = value })
	end

	local commands = function(opts)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "Select npm script to run",
				finder = finders.new_table({
					results = script_list,
					entry_maker = function(entry)
						return {
							value = entry,
							-- display = "npm run " .. entry.script_name .. "                      (" .. entry.script_value .. ")",
							display = entry.script_name,
							ordinal = entry.script_name,
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()

						-- local function toggle_terminal_with_command(command)
						--   -- Create a new terminal or get the existing one
						--   local Terminal = require('terminal')
						--   local term = Terminal:new({
						--     layout = 'horizontal',
						--     cmd = command,
						--     hidden = true,
						--   })
						--
						--   -- Toggle the terminal
						--   term:toggle()
						-- end
						--
						-- toggle_terminal_with_command(selection.value.script_name)
						local myterm = require("terminal").terminal:new({
							layout = { open_cmd = "botright new" },
							-- cmd = { selection.value.script_name },
							autoclose = false,
						})
						myterm:open()
						myterm:send(selection.value.script_name)
					end)
					return true
				end,
			})
			:find()
	end

	commands()
end

M.run_npm_scripts_improved = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local find_command = {
		"fd",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
		"--hidden",
		"--glob",
		"package.json",
	}

	local function count_package_json_files()
		local handle = io.popen("fd --exclude .git --exclude node_modules --hidden --glob package.json | wc -l")
		if not handle then
			return 0
		end
		local result = handle:read("*a")
		handle:close()
		return tonumber(result)
	end

	local commands = function(opts)
		opts = opts or {}
		local package_json_count = count_package_json_files()
		print(package_json_count)

		if package_json_count == 0 then
			print("No package.json files found")
			return
		end

		if package_json_count == 1 then
			M.run_npm_scripts()
		else
			pickers
				.new(opts, {
					prompt_title = "Select package.json",
					finder = finders.new_oneshot_job(find_command, {
						entry_maker = function(entry)
							local entry_substituted = entry:gsub("^/", ""):gsub("^./", "")
							return {
								value = entry,
								display = function()
									local display_string = "  " .. entry_substituted
									return display_string, { { { 0, 1 }, "DiagnosticOk" } }
								end,
								ordinal = entry,
							}
						end,
					}),
					sorter = conf.generic_sorter(opts),
					attach_mappings = function(prompt_bufnr)
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							local scripts = M.get_npm_scripts(selection.value) or {}

							local script_list = {}
							for key, value in pairs(scripts) do
								table.insert(script_list, { script_name = "npm run " .. key, script_value = value })
							end

							local directory = vim.fn.fnamemodify(selection.value, ":h")

							pickers
								.new(opts, {
									prompt_title = "Select npm script to run",
									finder = finders.new_table({
										results = script_list,
										entry_maker = function(entry)
											return {
												value = entry,
												-- display = "npm run " .. entry.script_name .. "                      (" .. entry.script_value .. ")",
												display = entry.script_name,
												ordinal = entry.script_name,
											}
										end,
									}),
									sorter = conf.generic_sorter(opts),
									attach_mappings = function(prompt_bufnr2)
										actions.select_default:replace(function()
											actions.close(prompt_bufnr2)
											local selection2 = action_state.get_selected_entry()

											local myterm = require("terminal").terminal:new({
												layout = { open_cmd = "botright new" },
												-- cmd = { selection.value.script_name },
												cwd = directory,
												autoclose = false,
											})
											myterm:open()
											myterm:send(selection2.value.script_name)
										end)
										return true
									end,
								})
								:find()
						end)
						return true
					end,
				})
				:find()
		end
	end

	commands()
end

return M
