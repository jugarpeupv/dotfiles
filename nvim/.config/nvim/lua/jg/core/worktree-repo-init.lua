-- local function should_restore_session()
-- 	-- Returns true when nvim is opened without a specific readable file argument.
-- 	-- Mirrors the guard in utilities.lua persistence init.
-- 	local argc = vim.fn.argc()
-- 	local arg = argc == 1 and tostring(vim.fn.argv(0)) or ""
-- 	local is_file = arg ~= "" and vim.fn.isdirectory(arg) == 0 and vim.fn.filereadable(arg) == 1
-- 	return not is_file
-- end

local function should_restore_worktree()
	if vim.fn.argc() == 0 and vim.fn.line2byte("$") == -1 then
		return false
	end
	if vim.list_contains(vim.v.argv, "-R") then
		return false
	end

	if not vim.list_contains(vim.v.argv, ".") then
		return false
	end

	-- C-x C-e
	-- { "nvim", "--embed", "-c", "normal! 19go", "--", "/tmp/zshBXRabd.zsh" }
	if vim.list_contains(vim.v.argv, "--") then
		return false
	end

	local cwd = vim.loop.cwd()
	if not cwd or cwd == "" then
		return false
	end
	local has_wt_utils, wt_utils = pcall(require, "jg.custom.worktree-utils")
	if not has_wt_utils or not wt_utils.has_worktrees(cwd) then
		return false
	end
	return true
end

local function find_buffer_by_path(target_path)
	-- Normalize the target path
	local normalized = vim.fn.fnamemodify(target_path, ":p")

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		-- Only consider loaded/valid buffers
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if vim.fn.fnamemodify(bufname, ":p") == normalized then
				return bufnr
			end
		end
	end

	return nil
end

local function restore_last_worktree()
	local cwd = vim.loop.cwd()
	if not cwd then
		return
	end
	local has_file_utils, file_utils = pcall(require, "jg.custom.file-utils")
	if not has_file_utils then
		return
	end
	local key = vim.fn.fnamemodify(cwd, ":p")
	local bps_path = file_utils.get_bps_path(key)
	local data = file_utils.load_bps(bps_path)
	if not data or next(data) == nil or not data.last_active_wt then
		-- require("oil").open(cwd)
		print("No worktree data, opening cwd in fyler")

		require("fyler").open({ dir = cwd })

		local cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
		local win = vim.fn.bufwinid(cwd_buffer_nr)
		if win ~= -1 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
			vim.api.nvim_win_close(win, true)
		end
		-- Then wipe the buffer
		if not cwd_buffer_nr then
			return
		end
		pcall(vim.api.nvim_buf_delete, cwd_buffer_nr, { force = true })

		return
	end
	local last_active_wt = data.last_active_wt


  local cwd_buffer_nr = find_buffer_by_path(cwd:gsub("/$", ""))
  local win = vim.fn.bufwinid(cwd_buffer_nr)
  if win ~= -1 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.api.nvim_win_close(win, true)
  end
  -- Then wipe the buffer
  if not cwd_buffer_nr then
    return
  end
  pcall(vim.api.nvim_buf_delete, cwd_buffer_nr, { force = true })


	-- vim.cmd("bwipeout " .. cwd_buffer_nr)
	pcall(vim.cmd.cd, last_active_wt)

	-- Apply .sdkmanrc if present in the worktree
	local sdkmanrc = last_active_wt .. "/.sdkmanrc"
	if vim.fn.filereadable(sdkmanrc) == 1 then
		local sdkman_dir = vim.env.SDKMAN_DIR or (vim.env.HOME .. "/.sdkman")
		for line in io.lines(sdkmanrc) do
			local version = line:match("^java=(.+)$")
			if version then
				local java_home = sdkman_dir .. "/candidates/java/" .. version
				if vim.fn.isdirectory(java_home) == 1 then
					vim.env.JAVA_HOME = java_home
					vim.env.PATH = java_home .. "/bin:" .. (vim.env.PATH or "")
				end
			end
		end
	end

	-- require("oil").open(last_active_wt)
	require("fyler").open({ dir = last_active_wt, kind = "replace" })
	-- pcall(require("fyler").open, { dir = last_active_wt })
	cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
	if not cwd_buffer_nr then
		return
	end
	win = vim.fn.bufwinid(cwd_buffer_nr)
	if win ~= -1 and #vim.api.nvim_tabpage_list_wins(0) > 1 then
		vim.api.nvim_win_close(win, true)
	end
	-- Then wipe the buffer
	pcall(vim.api.nvim_buf_delete, cwd_buffer_nr, { force = true })
	-- pcall(vim.api.nvim_buf_delete, cwd_buffer_nr)
	-- vim.api.nvim_buf_delete(cwd_buffer_nr, { force = true })
end

-- if should_restore_worktree() then
-- 	restore_last_worktree()
-- end

-- Load the persistence session after any worktree cd has settled.
-- We schedule so that lazy.nvim has finished its setup and persistence is available.
-- if false and should_restore_session() then
-- 	vim.schedule(function()
-- 		require("persistence").load()
-- 	end)
-- end

if should_restore_worktree() then
	restore_last_worktree()
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "VeryLazy",
-- 	once = true,
-- 	callback = restore_last_worktree,
-- })
else
	vim.schedule(function()
		local path = vim.v.argv[3]
		if not path then
			return
		end

		if vim.fn.isdirectory(path) == 1 then
			local fyler = require("fyler")
			-- fyler.open({ dir = path, kind = "replace" })
			fyler.open({ dir = path })
			local cwd_buffer_nr = find_buffer_by_path(vim.loop.cwd():gsub("/$", ""))
			local win = vim.fn.bufwinid(cwd_buffer_nr)
			if win ~= -1 then
				vim.api.nvim_win_close(win, true)
			end
			-- Then wipe the buffer
			if not cwd_buffer_nr then
				return
			end
			vim.api.nvim_buf_delete(cwd_buffer_nr, { force = true })
		else
			return
		end
	end)
end
